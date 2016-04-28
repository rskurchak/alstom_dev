@isTest
private class SharingServiceTest {
    private static final Integer NUM_ACCOUNT = 1;
    private static final Integer NUM_CONTACT = 1;
    private static final Integer NUM_CASE = 1;
    private static final Integer NUM_BULLETIN = 1;
    private static final Integer NUM_INSTALLEDBASERS = 2;
    private static final String  USER_PROFILE_NAME = 'AT - Customer Community +';
    private static final String  USER_NAME_PREFIX  = '@transport.alstom.com';
    private static Account parentAccount;
    private static Contact parentContact;
    private static List<Account> accounts;
    private static List<Contact> contacts;
    private static List<Case> cases;
    private static List<Bulletin__c> bulletins;
    private static List<InstalledBaseRS__c> installedBaseRSs;
    private static List<User> createdUserList;

    private static SharingService testClass;
    //different classes that implement MapperInterface interface
    private static MockMapper             testMockMapperClass             = new MockMapper();
    private static CaseMapper             testCaseMapperClass             = new CaseMapper();
    private static BulletinMapper         testBulletinMapperClass         = new BulletinMapper();
    private static InstalledBasedRSMapper testInstalledBasedRSMapperClass = new InstalledBasedRSMapper();

    private static void prepareDataForTest(){
        parentAccount                     = UtilityTestMethod.getAccount();
        parentAccount.Name                = 'TestAccountNameParent';
        parentAccount.IsAGlobalAccount__c = true;
        insert parentAccount;

        parentContact = UtilityTestMethod.getContacts(1)[0];
        parentContact.LastName = 'Parent Contact';
        parentContact.AccountId = parentAccount.Id;
        insert parentContact;

        accounts = UtilityTestMethod.getAccounts(NUM_ACCOUNT);
        for (Account item : accounts){
            item.ParentId = parentAccount.Id;
        }
        insert accounts;

        Integer contactNamePreffix = 1;
        contacts = new List<Contact>();
        for (Account accountItem : accounts){
            for (Contact contact : UtilityTestMethod.getContacts(NUM_CONTACT)){
                contact.LastName = 'Contact Name' + String.valueOf(contactNamePreffix++);
                contact.AccountId = accountItem.Id;
                contacts.add(contact);
            }
        }
        insert contacts;

        cases = UtilityTestMethod.getCaseList( NUM_CASE, 'Test status' );
        insert cases;

        bulletins = UtilityTestMethod.getBulletinList(NUM_BULLETIN, 'TestType', null);
        insert bulletins;

        installedBaseRSs = new List<InstalledBaseRS__c>();
        Integer installedBaseRSNamePreffix = 1;
        for (Integer i = 0; i < NUM_INSTALLEDBASERS; i++){
            InstalledBaseRS__c item = UtilityTestMethod.getInstalledBaseRS();
            item.Name = item.Name + String.valueOf(installedBaseRSNamePreffix++);
            installedBaseRSs.add(item);
        }
        insert installedBaseRSs;
    }

    private static testMethod void initSharingServiceClass(){

        Test.startTest();
            testClass = new SharingService(testMockMapperClass);
        Test.stopTest();

        System.assert(testClass != null, 'Class should be created');
    }

    private static testMethod void filterMethod(){
        prepareDataForTest();

        testClass = new SharingService(testMockMapperClass);

        List<sObject> result;

        Test.startTest();

            result = testClass.filter(accounts, null);

        Test.stopTest();

        System.assert(result != null, 'MockMapper class filter method returns null');
        System.assertEquals(accounts.size(), result.size(), 'MockMapper class filter method should return all records passed to the method');
        System.assertEquals(new Map<Id, Account>(accounts).keySet(), new Map<Id, Account>( (List<Account>)result ).keySet(), 'MockMapper class filter method does not return all Accounts passed to the method');
    }

    private static testMethod void filterChangeAccountIdMethod(){
        prepareDataForTest();

        Map<Id, Account> accountsMapOld = new Map<Id, Account>(accounts.deepclone(true, false, true));

        for (Account accountItem : accounts){
            accountItem.ParentId = accounts[0].Id;
        }

        testClass = new SharingService(testMockMapperClass);

        List<sObject> result;

        Test.startTest();

            result = testClass.filter(accounts, accountsMapOld);

        Test.stopTest();

        System.assert(result != null, 'MockMapper class filter method returns null');
        System.assertEquals(accounts.size(), result.size(), 'MockMapper class filter method should return all records passed to the method');
        System.assertEquals(new Map<Id, Account>(accounts).keySet(), new Map<Id, Account>( (List<Account>)result ).keySet(), 'MockMapper class filter method does not return all Accounts passed to the method');
    }

    private static testMethod void getAccountIdToGroupIdMap(){
        if (UserInfo.getUserRoleId() == null){
            UserRole ur = [SELECT Id FROM UserRole LIMIT 1];
            System.runAs(new User(Id = UserInfo.getUserId())){
                //assign User to Role
                update new User(Id = UserInfo.getUserId(), UserRoleId = ur.Id);
            }
        }

        prepareDataForTest();

        List<Profile> profile = [SELECT Id
                                 FROM Profile
                                 WHERE Name =: USER_PROFILE_NAME LIMIT 1];
        Id profileId = profile[0].Id;
        createdUserList = TestUtils.createUsers(new List<Contact>{contacts[0]}, profileId, USER_NAME_PREFIX, true);

        //get UserGroups Ids for processing Account Record
        Set<Id> userGroupsForProccesingAccount = new Map<Id, Group>([SELECT Id, RelatedId
                                                                     FROM Group
                                                                     WHERE RelatedId IN : [Select Id, PortalAccountId From UserRole Where PortalAccountId = : contacts[0].AccountId]]).keySet();

        testClass = new SharingService(testMockMapperClass);
        testClass.filter(accounts, null);

        Map<Id, Id> result;

        Test.startTest();

            result = testClass.getAccountIdToGroupIdMap(new Map<Id, Account>(accounts).keySet());


        Test.stopTest();

        System.assert(result != null, 'This method returns null');
        System.assertEquals(accounts.size(), result.size(), 'Method should return all records passed to the method');
        System.assertEquals(new Map<Id, Account>(accounts).keySet(), result.keySet(), ' method does not return all Accounts Ids passed to the method');
    }

    //this method covered try/catch statsment
    private static testMethod void shareForMockMapperClass(){
        if (UserInfo.getUserRoleId() == null){
            UserRole ur = [SELECT Id FROM UserRole LIMIT 1];
            System.runAs(new User(Id = UserInfo.getUserId())){
                //assign User to Role
                update new User(Id = UserInfo.getUserId(), UserRoleId = ur.Id);
            }
        }

        prepareDataForTest();

        List<Profile> profile = [SELECT Id
                                 FROM Profile
                                 WHERE Name =: USER_PROFILE_NAME LIMIT 1];
        Id profileId = profile[0].Id;
        createdUserList = TestUtils.createUsers(new List<Contact>{contacts[0]}, profileId, USER_NAME_PREFIX, true);

        //get UserGroups Ids for processing Account Record
        Set<Id> userGroupsForProccesingAccount = new Map<Id, Group>([SELECT Id, RelatedId
                                                                     FROM Group
                                                                     WHERE RelatedId IN : [Select Id, PortalAccountId From UserRole Where PortalAccountId = : contacts[0].AccountId]]).keySet();

        testClass = new SharingService(testMockMapperClass);
        testClass.filter(accounts, null);

        String errorString;

        Test.startTest();

        try{
            testClass.share(accounts);
        } catch (Exception ex){
            errorString = ex.getMessage();
        }

        Test.stopTest();
    }

    private static testMethod void getShares(){
        if (UserInfo.getUserRoleId() == null){
            UserRole ur = [SELECT Id FROM UserRole LIMIT 1];
            System.runAs(new User(Id = UserInfo.getUserId())){
                //assign User to Role
                update new User(Id = UserInfo.getUserId(), UserRoleId = ur.Id);
            }
        }

        prepareDataForTest();

        List<Profile> profile = [SELECT Id
                                 FROM Profile
                                 WHERE Name =: USER_PROFILE_NAME LIMIT 1];
        Id profileId = profile[0].Id;
        createdUserList = TestUtils.createUsers(new List<Contact>{contacts[0]}, profileId, USER_NAME_PREFIX, true);

        //get UserGroups Ids for processing Account Record
        List<Group> userGroupForAccount = [ SELECT Id, RelatedId
                                            FROM Group
                                            WHERE RelatedId IN : [Select Id, PortalAccountId From UserRole Where PortalAccountId = : contacts[0].AccountId] ];

        CaseShare caseShareForTest = new CaseShare( UserOrGroupId   = userGroupForAccount[0].Id,
                                                    CaseId          = cases[0].Id,
                                                    CaseAccessLevel = 'Edit');
        insert caseShareForTest;

        for (Case caseItem : cases){
            caseItem.AccountId = contacts[0].AccountId;
        }

        testClass = new SharingService(testCaseMapperClass);
        //the filter() method only populates fieldOptions property for test needes
        testClass.filter(new List<sObject>(), null);

        Set<Share> result;

        Test.startTest();

            result = testClass.getShares(cases, SharingFieldOptionsServices.getFieldOptionsForObject('Case'));

        Test.stopTest();

        System.assert (!result.isEmpty(), 'Result should return records:' + result);
        System.assertEquals (cases.size() + 1, result.size(), 'The only two records should returns: ' + result);
        for (Share shareItem : result){
            if ( shareItem.isCreated() ){
                System.assertEquals(caseShareForTest.Id, shareItem.getShareId(), 'Incorrect CaseShare record');
            }
        }
    }

    private static testMethod void shareForCase(){
        if (UserInfo.getUserRoleId() == null){
            UserRole ur = [SELECT Id FROM UserRole LIMIT 1];
            System.runAs(new User(Id = UserInfo.getUserId())){
                //assign User to Role
                update new User(Id = UserInfo.getUserId(), UserRoleId = ur.Id);
            }
        }

        prepareDataForTest();

        List<Profile> profile = [SELECT Id
                                 FROM Profile
                                 WHERE Name =: USER_PROFILE_NAME LIMIT 1];
        Id profileId = profile[0].Id;
        createdUserList = TestUtils.createUsers(new List<Contact>{contacts[0]}, profileId, USER_NAME_PREFIX, true);

        //get UserGroups Ids for processing Account Record
        List<Group> userGroupForAccount = [ SELECT Id, RelatedId
                                            FROM Group
                                            WHERE RelatedId IN : [Select Id, PortalAccountId From UserRole Where PortalAccountId = : contacts[0].AccountId] ];

        CaseShare caseShareForTest = new CaseShare( UserOrGroupId   = userGroupForAccount[0].Id,
                                                    CaseId          = cases[0].Id,
                                                    CaseAccessLevel = 'Edit');
        insert caseShareForTest;

        for (Case caseItem : cases){
            caseItem.AccountId = contacts[0].AccountId;
        }

        testClass = new SharingService(testCaseMapperClass);
        //the filter() method only populates fieldOptions property for test needes
        testClass.filter(new List<sObject>(), null);

        Test.startTest();

            testClass.share(cases);

        Test.stopTest();

        List<CaseShare> caseShareDeletedCheckList = [SELECT Id
                                                     FROM CaseShare
                                                     WHERE Id = : caseShareForTest.id];

        System.assert(caseShareDeletedCheckList.isEmpty(), 'The existing CaseShare must be deleted');

        List<CaseShare> caseShareCreatedCheckList = [SELECT Id, CaseId, UserOrGroupId, CaseAccessLevel
                                                     FROM CaseShare
                                                     WHERE RowCause <> 'Owner' AND
                                                            CaseId IN : cases];

        System.assert(!caseShareCreatedCheckList.isEmpty(), 'New CaseShare records should be created for processing Cases');
        System.assertEquals(cases.size(), caseShareCreatedCheckList.size(), 'New CaseShare records should be created for processing Cases' + caseShareCreatedCheckList);
        Set<Id> caseIdsInTheCreatedCaseSharesCheckSet = new Set<Id>();
        for (CaseShare item : caseShareCreatedCheckList){
            caseIdsInTheCreatedCaseSharesCheckSet.add(item.CaseId);
        }
        System.assertEquals(new Map<Id, Case>(cases).keySet(), caseIdsInTheCreatedCaseSharesCheckSet, 'Result is incorrect, not all processing Cases get CaseShare records');
    }

    private static testMethod void getSharesForBulletin(){
        if (UserInfo.getUserRoleId() == null){
            UserRole ur = [SELECT Id FROM UserRole LIMIT 1];
            System.runAs(new User(Id = UserInfo.getUserId())){
                //assign User to Role
                update new User(Id = UserInfo.getUserId(), UserRoleId = ur.Id);
            }
        }

        prepareDataForTest();

        List<Profile> profile = [SELECT Id
                                 FROM Profile
                                 WHERE Name =: USER_PROFILE_NAME LIMIT 1];
        Id profileId = profile[0].Id;
        createdUserList = TestUtils.createUsers(new List<Contact>{parentContact, contacts[0]}, profileId, USER_NAME_PREFIX, true);

        //get UserGroups Ids for processing Account Record
        List<Group> userGroupForAccount = [ SELECT Id, RelatedId
                                            FROM Group
                                            WHERE RelatedId IN : [Select Id, PortalAccountId From UserRole Where PortalAccountId = : contacts[0].AccountId] ];

        //get UserGroups Ids for parent Account Record
        Map<Id, Group> userGroupForParentAccount = new Map<Id, Group>([ SELECT Id, RelatedId
                                                                        FROM Group
                                                                        WHERE RelatedId IN : [Select Id, PortalAccountId From UserRole Where PortalAccountId = : parentAccount.Id] ]);

        List<Bulletin__Share> bs = new List<Bulletin__Share>();
        for (Group ug : userGroupForAccount){
            Bulletin__Share bulletinShareForTest = new Bulletin__Share( UserOrGroupId = userGroupForAccount[0].Id,
                                                                        ParentId      = bulletins[0].Id,
                                                                        AccessLevel   = 'Edit',
                                                                        RowCause      = 'Account__c');
            bs.add(bulletinShareForTest);
        }
        insert bs;

        testClass = new SharingService(testBulletinMapperClass);

        Set<Share> result;

        Test.startTest();

            result = testClass.getSharesForBulletin(bulletins[0].Id);

        Test.stopTest();

        System.assert (!result.isEmpty());

        for (Share item : result){
            System.assertEquals(bulletins[0].Id, item.getRecordId(), 'Parent record for Share is incorrent');
            System.assert(userGroupForParentAccount.containsKey(item.getUserId()), 'User Group is for Share is incorrent');
        }

    }

    private static testMethod void shareForBulletin(){
        if (UserInfo.getUserRoleId() == null){
            UserRole ur = [SELECT Id FROM UserRole LIMIT 1];
            System.runAs(new User(Id = UserInfo.getUserId())){
                //assign User to Role
                update new User(Id = UserInfo.getUserId(), UserRoleId = ur.Id);
            }
        }

        prepareDataForTest();

        List<Profile> profile = [SELECT Id
                                 FROM Profile
                                 WHERE Name =: USER_PROFILE_NAME LIMIT 1];
        Id profileId = profile[0].Id;
        createdUserList = TestUtils.createUsers(new List<Contact>{parentContact, contacts[0]}, profileId, USER_NAME_PREFIX, true);

        //get UserGroups Ids for processing Account Record
        List<Group> userGroupForAccount = [ SELECT Id, RelatedId
                                            FROM Group
                                            WHERE RelatedId IN : [Select Id, PortalAccountId From UserRole Where PortalAccountId = : contacts[0].AccountId] ];

        //get UserGroups Ids for parent Account Record
        Map<Id, Group> userGroupForParentAccount = new Map<Id, Group>([ SELECT Id, RelatedId
                                                                        FROM Group
                                                                        WHERE RelatedId IN : [Select Id, PortalAccountId From UserRole Where PortalAccountId = : parentAccount.Id] ]);

        List<Bulletin__Share> createdBulletinShareList = new List<Bulletin__Share>();
        for (Group ug : userGroupForAccount){
            Bulletin__Share bulletinShareForTest = new Bulletin__Share( UserOrGroupId = userGroupForAccount[0].Id,
                                                                        ParentId      = bulletins[0].Id,
                                                                        AccessLevel   = 'Edit',
                                                                        RowCause      = 'Account__c');
            createdBulletinShareList.add(bulletinShareForTest);
        }
        insert createdBulletinShareList;

        testClass = new SharingService(testBulletinMapperClass);

        Test.startTest();

            testClass.shareBulletin(bulletins[0].Id);

        Test.stopTest();

        List<Bulletin__Share> checkResult = [SELECT Id, UserOrGroupId, ParentId, AccessLevel, RowCause
                                             FROM Bulletin__Share
                                             WHERE (NOT Id IN : createdBulletinShareList) AND
                                                    ParentId = : bulletins[0].Id];

        System.assert(!checkResult.isEmpty(), 'shareBulletin method should create Bulletin__Share records');
    }

    private static testMethod void getAccountsForBulletinToSendNotification(){
        if (UserInfo.getUserRoleId() == null){
            UserRole ur = [SELECT Id FROM UserRole LIMIT 1];
            System.runAs(new User(Id = UserInfo.getUserId())){
                //assign User to Role
                update new User(Id = UserInfo.getUserId(), UserRoleId = ur.Id);
            }
        }

        prepareDataForTest();

        List<Profile> profile = [SELECT Id
                                 FROM Profile
                                 WHERE Name =: USER_PROFILE_NAME LIMIT 1];
        Id profileId = profile[0].Id;
        createdUserList = TestUtils.createUsers(new List<Contact>{parentContact, contacts[0]}, profileId, USER_NAME_PREFIX, true);

        //get UserGroups Ids for processing Account Record
        List<Group> userGroupForAccount = [ SELECT Id, RelatedId
                                            FROM Group
                                            WHERE RelatedId IN : [Select Id, PortalAccountId From UserRole Where PortalAccountId = : contacts[0].AccountId] ];

        //get UserGroups Ids for parent Account Record
        Map<Id, Group> userGroupForParentAccount = new Map<Id, Group>([ SELECT Id, RelatedId
                                                                        FROM Group
                                                                        WHERE RelatedId IN : [Select Id, PortalAccountId From UserRole Where PortalAccountId = : parentAccount.Id] ]);

        List<Bulletin__Share> createdBulletinShareList = new List<Bulletin__Share>();
        for (Group ug : userGroupForAccount){
            Bulletin__Share bulletinShareForTest = new Bulletin__Share( UserOrGroupId = userGroupForAccount[0].Id,
                                                                        ParentId      = bulletins[0].Id,
                                                                        AccessLevel   = 'Edit',
                                                                        RowCause      = 'Account__c');
            createdBulletinShareList.add(bulletinShareForTest);
        }
        insert createdBulletinShareList;

        //prepare allAccounts list for test needs
        testBulletinMapperClass.getParentAccountIdsForGroups( new Map<Id, Group>(userGroupForAccount).keySet() );

        //create test class
        testClass = new SharingService(testBulletinMapperClass);

        Set<Id> result;

        Test.startTest();

            result = testClass.getAccountsForBulletinToSendNotification(bulletins[0].Id);

        Test.stopTest();

        System.assertEquals (testBulletinMapperClass.getAllAccounts(), result);
    }

    private static testMethod void getAccountsForBulletinToSendNotificationWithSentNotificationRecords(){
        if (UserInfo.getUserRoleId() == null){
            UserRole ur = [SELECT Id FROM UserRole LIMIT 1];
            System.runAs(new User(Id = UserInfo.getUserId())){
                //assign User to Role
                update new User(Id = UserInfo.getUserId(), UserRoleId = ur.Id);
            }
        }

        prepareDataForTest();

        List<Profile> profile = [SELECT Id
                                 FROM Profile
                                 WHERE Name =: USER_PROFILE_NAME LIMIT 1];
        Id profileId = profile[0].Id;
        createdUserList = TestUtils.createUsers(new List<Contact>{parentContact, contacts[0]}, profileId, USER_NAME_PREFIX, true);

        //get UserGroups Ids for processing Account Record
        List<Group> userGroupForAccount = [ SELECT Id, RelatedId
                                            FROM Group
                                            WHERE RelatedId IN : [Select Id, PortalAccountId From UserRole Where PortalAccountId = : contacts[0].AccountId] ];

        //get UserGroups Ids for parent Account Record
        Map<Id, Group> userGroupForParentAccount = new Map<Id, Group>([ SELECT Id, RelatedId
                                                                        FROM Group
                                                                        WHERE RelatedId IN : [Select Id, PortalAccountId From UserRole Where PortalAccountId = : parentAccount.Id] ]);

        List<Bulletin__Share> createdBulletinShareList = new List<Bulletin__Share>();
        for (Group ug : userGroupForAccount){
            Bulletin__Share bulletinShareForTest = new Bulletin__Share( UserOrGroupId = userGroupForAccount[0].Id,
                                                                        ParentId      = bulletins[0].Id,
                                                                        AccessLevel   = 'Edit',
                                                                        RowCause      = 'Account__c');
            createdBulletinShareList.add(bulletinShareForTest);
        }
        insert createdBulletinShareList;

        //prepare allAccounts list for test needs
        testBulletinMapperClass.getParentAccountIdsForGroups( new Map<Id, Group>(userGroupForAccount).keySet() );

        //This Account Id will not be processed
        Id accountIdForNotification;
        for (Id accountId : testBulletinMapperClass.getAllAccounts()){
            accountIdForNotification = accountId;
            break;
        }

        Set<Id> thisWillBeExpectedResultSet = new Set<Id>();
        thisWillBeExpectedResultSet.addAll(testBulletinMapperClass.getAllAccounts());
        thisWillBeExpectedResultSet.remove(accountIdForNotification);

        //prepare Bulletin_Sent_Notification__c record for test needs.
        TestUtils.createBulletinSentNotifications(new List<Bulletin__c>{bulletins[0]}, accountIdForNotification, true);

        //create test class
        testClass = new SharingService(testBulletinMapperClass);

        Set<Id> result;

        Test.startTest();

            result = testClass.getAccountsForBulletinToSendNotification(bulletins[0].Id);

        Test.stopTest();

        System.assertEquals (thisWillBeExpectedResultSet, result, 'Result is inccorrect');
    }
}