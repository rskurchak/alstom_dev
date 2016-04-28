@isTest
private class TileServiceTest {
    private final static String  PROFILE_COMMUNITY_NAME = 'AT - Customer Community +';
    private final static String  PERMISSION_SET_NAME = 'API Only User';
    private final static String  EMAIL_PREFIX = '@transport.alstom.com';
    private final static Integer COUNT_TILES = 4;

    private static User          userWithRole;
    private static Profile       profile;
    private static List<Account> portalAccounts;
    private static List<Contact> portalContacts;
    private static List<User>    portalUsers;
    private static List<Tile__c> tiles;

    static {
        AP69User.avoidFutureMethodExecutionForTestNeeds = true;
    }

    private static void setupData(){
        List<User> users = [SELECT Id FROM User WHERE UserRoleId != null AND isActive = true AND Profile.Name = 'System Administrator'];
        System.assert(!users.isEmpty(), 'Please set user a role');
        userWithRole = users[0];
        profile = [SELECT Id FROM Profile WHERE Name = :PROFILE_COMMUNITY_NAME LIMIT 1];    
        System.runAs(userWithRole){
            //create a portal accounts
            portalAccounts = TestUtils.createAccount(2, null, true);
            //create a portal contacts
            portalContacts = TestUtils.createContacts(portalAccounts, true);
            //create a portal users
            portalUsers = TestUtils.createUsers(portalContacts, profile.Id, EMAIL_PREFIX, true);
            //create a tiles
            tiles = TestUtils.createTiles(COUNT_TILES, PERMISSION_SET_NAME, true);
        }
    }

    private static String TILEASSIGNMENTSJSON = '[{"PermissionSet__c":"{ps}","Account__c":"{a0}","Tile__c":"{t0}"},{"PermissionSet__c":"{ps}","Account__c":"{a1}","Tile__c":"{t1}"}]';
    @isTest static void testAssignForOneAccount() {
        List<TileAssignment__c> tileAssignments;
        setupData();
        tileAssignments = (List<TileAssignment__c>)JSON.deserialize(TILEASSIGNMENTSJSON.replace('{ps}', PERMISSION_SET_NAME).replace('{a0}', portalAccounts[0].Id).replace('{a1}', portalAccounts[0].Id), List<TileAssignment__c>.class);
        TileService service = new TileService();

        Test.startTest();
            System.runAs(userWithRole){
                //create a tile assignments
                service.assign(tileAssignments);    
            }
        Test.stopTest();

        List<PermissionSetAssignment> assigments = [SELECT Id, AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Label = :PERMISSION_SET_NAME AND AssigneeId IN :portalUsers];
        System.assertEquals(1, assigments.size(), 'Method should create only one record');
    }

    @isTest static void testAssignForTwoAccount() {
        List<TileAssignment__c> tileAssignments;
        setupData();
        tileAssignments = (List<TileAssignment__c>)JSON.deserialize(TILEASSIGNMENTSJSON.replace('{ps}', PERMISSION_SET_NAME).replace('{a0}', portalAccounts[0].Id).replace('{a1}', portalAccounts[1].Id), List<TileAssignment__c>.class);
        TileService service = new TileService();

        Test.startTest();
            System.runAs(userWithRole){
                //create a tile assignments
                service.assign(tileAssignments);
            }
        Test.stopTest();

        List<PermissionSetAssignment> assigments = [SELECT Id, AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Label = :PERMISSION_SET_NAME AND AssigneeId IN :portalUsers];
        System.assertEquals(2, assigments.size(), 'Method should create two records');
    }

    @isTest static void testAssignForTwoAccountWithOneAssignedExisting() {
        List<TileAssignment__c> tileAssignments;
        setupData();
        System.runAs(userWithRole){
            PermissionSet ps = [SELECT Id, Label, Name FROM PermissionSet WHERE Label = :PERMISSION_SET_NAME LIMIT 1];
            TestUtils.createPermissionSetAssignment(ps.Id, portalUsers[0].Id, true);
            tileAssignments = (List<TileAssignment__c>)JSON.deserialize(TILEASSIGNMENTSJSON.replace('{ps}', PERMISSION_SET_NAME).replace('{a0}', portalAccounts[0].Id).replace('{a1}', portalAccounts[1].Id), List<TileAssignment__c>.class);
        }
        TileService service = new TileService();

        Test.startTest();
            System.runAs(userWithRole){
                //create a tile assignments
                service.assign(tileAssignments);
            }
        Test.stopTest();

        List<PermissionSetAssignment> assigments = [SELECT Id, AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Label = :PERMISSION_SET_NAME AND AssigneeId IN :portalUsers];
        System.assertEquals(2, assigments.size(), 'Method should create one record and one existing');
    }

    @isTest static void testRevokeForTwoAccount() {
        List<TileAssignment__c> tileAssignments;
        setupData();
        System.runAs(userWithRole){     
            PermissionSet ps = [SELECT Id, Label, Name FROM PermissionSet WHERE Label = :PERMISSION_SET_NAME LIMIT 1];
            List<PermissionSetAssignment> psAssignments = new List<PermissionSetAssignment>();
            psAssignments.add(TestUtils.createPermissionSetAssignment(ps.Id, portalUsers[0].Id, false));
            psAssignments.add(TestUtils.createPermissionSetAssignment(ps.Id, portalUsers[1].Id, false));
            insert psAssignments;
            tileAssignments = TestUtils.createTileAssignments(new List<Tile__c>{tiles[0],tiles[1]}, portalAccounts, true);  
            tileAssignments = (List<TileAssignment__c>)JSON.deserialize(TILEASSIGNMENTSJSON.replace('{ps}', PERMISSION_SET_NAME).replace('{a0}', portalAccounts[0].Id).replace('{a1}', portalAccounts[1].Id), List<TileAssignment__c>.class);
        }
        TileService service = new TileService();

        Test.startTest();
            System.runAs(userWithRole){
                //create a tile assignments
                service.revoke(tileAssignments);    
            }
        Test.stopTest();

        List<PermissionSetAssignment> assigments = [SELECT Id, AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Label = :PERMISSION_SET_NAME AND AssigneeId IN :portalUsers];
        System.assertEquals(0, assigments.size(), 'Method should remove two records');
    }

    private static String TILEASSIGNMENTSJSONONE = '[{"PermissionSet__c":"{ps}","Account__c":"{a0}","Tile__c":"{t0}"}]';
    @isTest static void testRevokeForOneAccount() {
        List<TileAssignment__c> tileAssignments;
        setupData();
        System.runAs(userWithRole){     
            PermissionSet ps = [SELECT Id, Label, Name FROM PermissionSet WHERE Label = :PERMISSION_SET_NAME LIMIT 1];
            List<PermissionSetAssignment> psAssignments = new List<PermissionSetAssignment>();
            psAssignments.add(TestUtils.createPermissionSetAssignment(ps.Id, portalUsers[0].Id, false));
            psAssignments.add(TestUtils.createPermissionSetAssignment(ps.Id, portalUsers[1].Id, false));
            insert psAssignments;
            tileAssignments = TestUtils.createTileAssignments(new List<Tile__c>{tiles[0],tiles[1]}, portalAccounts, true);  
            tileAssignments = (List<TileAssignment__c>)JSON.deserialize(TILEASSIGNMENTSJSONONE.replace('{ps}', PERMISSION_SET_NAME).replace('{a0}', portalAccounts[0].Id), List<TileAssignment__c>.class);
        }
        TileService service = new TileService();

        Test.startTest();
            System.runAs(userWithRole){
                //create a tile assignments
                service.revoke(tileAssignments);    
            }
        Test.stopTest();

        List<PermissionSetAssignment> assigments = [SELECT Id, AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Label = :PERMISSION_SET_NAME AND AssigneeId IN :portalUsers];
        System.assertEquals(1, assigments.size(), 'Method should remove one record');
    }   

    @isTest static void testGetTiles() {
        List<TileAssignment__c> tileAssignments;
        setupData();        
        System.runAs(userWithRole){
            tileAssignments = TestUtils.createTileAssignments(new List<Tile__c>{tiles[0]}, new List<Account>{portalAccounts[0]}, true);
        }

        Test.startTest();
            List<Tile__c> tilesForUser = TileService.getTiles([SELECT Id, Contact.AccountId FROM USER WHERE Id = :portalUsers[0].Id]);
        Test.stopTest();

        System.assertEquals(1, tilesForUser.size(), 'User should have one tile.');
    }

    @isTest static void testGetTilesByUserId() {
        List<TileAssignment__c> tileAssignments;
        setupData();        
        System.runAs(userWithRole){
            tileAssignments = TestUtils.createTileAssignments(new List<Tile__c>{tiles[0]}, new List<Account>{portalAccounts[0]}, true);
        }

        Test.startTest();
            List<Tile__c> tilesForUser = TileService.getTilesByUserId(portalUsers[0].Id);
        Test.stopTest();

        System.assertEquals(1, tilesForUser.size(), 'User should have one tile.');
    }

    @isTest static void testProcessPermissionSetAssignmentsOnInsert(){
        setupData();
        PermissionSet permSet = [SELECT Id FROM PermissionSet WHERE Label = :PERMISSION_SET_NAME];
        PermissionSetAssignment assigment = TestUtils.createPermissionSetAssignment(permSet.Id, portalUsers[0].Id, false);

        Test.startTest();
            TileService.processPermissionSetAssignments( JSON.serialize(new List<PermissionSetAssignment>{assigment}), true);
        Test.stopTest();

        List<PermissionSetAssignment> assigments = [SELECT Id, AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Label = :PERMISSION_SET_NAME AND AssigneeId = :portalUsers[0].Id];
        System.assertEquals(1, assigments.size(), 'Method must create one record');     
    }

    @isTest static void testProcessPermissionSetAssignmentsOnInsertWithError(){
        setupData();
        PermissionSet permSet = [SELECT Id FROM PermissionSet WHERE Label = :PERMISSION_SET_NAME];
        PermissionSetAssignment assigment = TestUtils.createPermissionSetAssignment(permSet.Id, 'a144E0000004DuT', false);

        Test.startTest();
            TileService.processPermissionSetAssignments( JSON.serialize(new List<PermissionSetAssignment>{assigment}), true);
        Test.stopTest();

        List<PermissionSetAssignment> assigments = [SELECT Id, AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Label = :PERMISSION_SET_NAME AND AssigneeId = :portalUsers[0].Id];
        System.assertEquals(0, assigments.size(), 'Method doesn`t should create record');
    }

    @isTest static void testProcessPermissionSetAssignmentsOnDelete(){
        setupData();
        PermissionSet permSet = [SELECT Id FROM PermissionSet WHERE Label = :PERMISSION_SET_NAME];
        PermissionSetAssignment assigment = TestUtils.createPermissionSetAssignment(permSet.Id, portalUsers[0].Id, true);

        Test.startTest();
            TileService.processPermissionSetAssignments( JSON.serialize(new List<PermissionSetAssignment>{assigment}), false);
        Test.stopTest();

        List<PermissionSetAssignment> assigments = [SELECT Id, AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Label = :PERMISSION_SET_NAME AND AssigneeId = :portalUsers[0].Id];
        System.assertEquals(0, assigments.size(), 'Method should delete one record');       
    }

    @isTest static void testProcessPermissionSetAssignmentsOnDeleteWithError(){
        setupData();
        PermissionSet permSet = [SELECT Id FROM PermissionSet WHERE Label = :PERMISSION_SET_NAME];
        PermissionSetAssignment assigment = TestUtils.createPermissionSetAssignment(permSet.Id, portalUsers[0].Id, true);
        delete assigment;

        Test.startTest();
            TileService.processPermissionSetAssignments( JSON.serialize(new List<PermissionSetAssignment>{assigment}), false);
        Test.stopTest();

        List<PermissionSetAssignment> assigments = [SELECT Id, AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Label = :PERMISSION_SET_NAME AND AssigneeId = :portalUsers[0].Id];
        System.assertEquals(0, assigments.size(), 'Method should delete record');
    }   

    @isTest static void testSendEmailErrors(){
        PermissionSet permSet = [SELECT Id FROM PermissionSet WHERE Label = :PERMISSION_SET_NAME];
        List<PermissionSetAssignment> assigments = new List<PermissionSetAssignment>();
        assigments.add(TestUtils.createPermissionSetAssignment(permSet.Id, 'a144E0000004DuT', false));
        List<String> errorList = new List<String>();
        for (PermissionSetAssignment assigment: assigments){
            errorList.add('Test Error');
        }

        Test.startTest();
            TileService.sendEmailErrors(assigments, errorList);
            Integer sendedEmail = Limits.getEmailInvocations();
        Test.stopTest();

        System.assertEquals(1, sendedEmail, 'One email should be send');            
    }

    @isTest static void testReassignOrders(){
        setupData();
        tiles[2].Order__c = 8;
        tiles[3].Order__c = 9;
        update tiles;
        tiles[2].Order__c = 1;
        TileService service = new TileService();

        Test.startTest();
            service.reassignOrders(new List<Tile__c>{tiles[2]});
        Test.stopTest();

        List<Tile__c> tilesSelected = [SELECT Id, Name, Order__c FROM Tile__c WHERE Id = :tiles[1].Id];
        System.assertEquals(2, tilesSelected[0].Order__c, 'Second tile should be moved on third position.');    
    }

    @isTest static void testAssignPermissionSets(){
        User newUser;
        setupData();
        System.runAs(userWithRole){     
            PermissionSet ps = [SELECT Id, Label, Name FROM PermissionSet WHERE Label = :PERMISSION_SET_NAME LIMIT 1];
            List<PermissionSetAssignment> psAssignments = new List<PermissionSetAssignment>();
            psAssignments.add(TestUtils.createPermissionSetAssignment(ps.Id, portalUsers[0].Id, false));
            psAssignments.add(TestUtils.createPermissionSetAssignment(ps.Id, portalUsers[1].Id, false));
            insert psAssignments;
            List<TileAssignment__c> tileAssignments = TestUtils.createTileAssignments(new List<Tile__c>{tiles[0],tiles[1]}, portalAccounts, true);
            Contact newContact = TestUtils.createContacts(new List<Account>{portalAccounts[0]}, false)[0];
            newContact.LastName = 'UserNew';
            insert newContact;
            newUser = TestUtils.createUsers(new List<Contact>{newContact}, profile.Id, EMAIL_PREFIX, true)[0];
        }
        TileService service = new TileService();

        Test.startTest();
            System.runAs(userWithRole){
                //create a tile assignments
                service.assignPermissionSets(new List<User>{newUser});  
            }
        Test.stopTest();

        List<PermissionSetAssignment> assigments = [SELECT Id, AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Label = :PERMISSION_SET_NAME AND AssigneeId = :newUser.Id];
        System.assertEquals(1, assigments.size(), 'Method should create one record');       
    }

}