public class TestUtils {

    public static ProgramAllocation__c programAllocation(String name, Program__c program, String fiscalYear) {
        ProgramAllocation__c allocation = new ProgramAllocation__c(Name = name, Program__c = program.Id, FiscalYear__c = fiscalYear);
        insert allocation;
        return allocation;
    }
    
    public static Program__c program(String name) {
        Program__c program = new Program__c(Name = name, Cluster__c = cluster('Test').Id);
        insert program;
        return program;
    }
    
    public static Cluster__c cluster(String name) {
        Cluster__c cluster = new Cluster__c(Name = name);
        insert cluster;
        return cluster;
    }

    public static List<Account> createAccount(Integer count, Id parentId, Boolean doCreate){
        List<Account> accounts = new List<Account>();
        for(Integer i=0; i<count; i++){
            accounts.add(new Account( Name = 'TestAccount'+i, ParentId = parentId));
        }

        if(doCreate){
            insert accounts;
        }
        return accounts;
    }

    public static List<Contact> createContacts(List<Account> accounts, Boolean doCreate){
        List<Contact> contacts = new List<Contact>();
        Integer i = 0;
        for(Account acc: accounts){
            contacts.add(
                new Contact( 
                    LastName = 'TestContact'+i,
                    AccountId = acc.Id
                    )
                );
            i++;
        }

        if(doCreate){
            insert contacts;
        }
        return contacts;
    }

    public static User createUser(String userNamePreffix, String userEmailPrefix, Id profileId, Id roleId, Boolean doCreate){
        User user = new User( FirstName         = userNamePreffix,
                              LastName          = userNamePreffix,
                              Profileid         = profileId,
                              UserRoleId        = roleId,
                              Email             = userNamePreffix + userEmailPrefix,
                              UserName          = userNamePreffix + userEmailPrefix,
                              Alias             = 'GDS',
                              TimeZoneSidKey    = 'America/New_York',
                              EmailEncodingKey  = 'ISO-8859-1',
                              LocaleSidKey      = 'en_US', 
                              LanguageLocaleKey = 'en_US' );

        if(doCreate){
            insert user;
        }
        return user;
    }

    public static List<User> createUsers(List<Contact> contacts, Id profileId, String namePrefix, Boolean doCreate){
        List<User> users = new List<User>();
        Integer userNamePreffix = 0;
        for(Contact contact: contacts){
            users.add( new User( FirstName         = 'User' + String.valueOf(userNamePreffix),
                                 LastName          = contact.LastName.replace(' ', '_') + 'Test',
                                 Profileid         = profileId,
                                 Email             = 'User' + String.valueOf(userNamePreffix) + namePrefix,
                                 UserName          = contact.LastName.replace(' ', '_') + String.valueOf(userNamePreffix) + namePrefix,
                                 Alias             = 'GDS',
                                 TimeZoneSidKey    = 'America/New_York',
                                 EmailEncodingKey  = 'ISO-8859-1',
                                 LocaleSidKey      = 'en_US', 
                                 LanguageLocaleKey = 'en_US',
                                 ContactId         = contact.Id,
                                 PortalRole        = 'Manager' ) );
            userNamePreffix++;
        }

        if(doCreate){
            insert users;
        }
        return users;
    }

    public static List<Tile__c> createTiles(Integer count, String permisionName, Boolean doCreate){
        List<Tile__c> tiles = new List<Tile__c>();
        for(Integer i=0; i<count; i++){
            tiles.add(
                new Tile__c( 
                    Name = 'TestTile'+i,
                    Url__c = 'TestUrl'+i, 
                    Image__c = 'TestImage'+i, 
                    PermissionSet__c = permisionName,
                    Order__c = i
                    )
                );
        }

        if(doCreate){
            insert tiles;
        }
        return tiles;
    }

    public static List<TileAssignment__c> createTileAssignments(List<Tile__c> tiles, List<Account> accounts, Boolean doCreate){
        List<TileAssignment__c> tileAssignments = new List<TileAssignment__c>();
        if(tiles.size() != accounts.size()){
            return tileAssignments;
        }

        Integer i = 0;
        for(Account acc: accounts){
            tileAssignments.add(
                new TileAssignment__c( 
                    Account__c = acc.Id,
                    Tile__c = tiles[i].Id
                    )
                );
            i++;
        }

        if(doCreate){
            insert tileAssignments;
        }
        return tileAssignments;
    }

    public static PermissionSetAssignment createPermissionSetAssignment(Id perSetId, Id userId, Boolean doCreate){
        PermissionSetAssignment assignment = new PermissionSetAssignment(
                PermissionSetId = perSetId,
                AssigneeId = userId
            );
        if(doCreate){
            insert assignment;
        }
        return assignment;
    }

    public static ReadReceipt__c createReadReceipt(Id bulletinId, Id userId, Boolean doCreate){
        ReadReceipt__c receipt = new ReadReceipt__c(
            Bulletin__c = bulletinId,
            User__c = userId,
            EquipmentConfiguration__c = 'Configuration',
            EquipmentModification__c = 'Modification',
            EquipmentNumber__c = 0,
            EquipmentReliability__c = 'Reliability',
            EquipmentScrapRate__c = 'ScrapRate',
            EquipmentStock__c = 1,
            ReadDate__c = Date.today(),
            ReplacementDate__c = Date.today(),
            SpecificInformation__c = 'Information'
            );
        
        if(doCreate){
            insert receipt;
        }
        return receipt;
    }

    public static Bulletin__c createBulletin(String name, String type, String accountId, Boolean doCreate){   
        Bulletin__c bulletin = new Bulletin__c(
            Name        = name, 
            Account__c  = AccountId, 
            Language__c = 'EN', 
            Status__c   = 'Published', 
            Type__c     = type, 
            Text__c     = 'test text'
            );

        if(doCreate){
            insert bulletin;
        }
        return bulletin;
    }

    public static List<Bulletin__c> createBulletins(Integer count, String name, String type, String accountId, Boolean doCreate){   
        List<Bulletin__c> bulletins = new List<Bulletin__c>();
        for(Integer i=0; i<count; i++){
            bulletins.add( new Bulletin__c(
                Name        = name+i, 
                Account__c  = AccountId, 
                Language__c = 'English (en)', 
                Status__c   = 'Published', 
                Type__c     = type, 
                Text__c     = 'test text'
                )
            );
        }

        if(doCreate){
            insert bulletins;
        }
        return bulletins;
    }

    public static List<Bulletin_Sent_Notification__c> createBulletinSentNotifications(List<Bulletin__c> buletins, Id accountId, Boolean doCreate){   
        List<Bulletin_Sent_Notification__c> bulletinSentNotifications = new List<Bulletin_Sent_Notification__c>();

        for (Bulletin__c bulletin : buletins){
            bulletinSentNotifications.add(new Bulletin_Sent_Notification__c( Bulletin__c = bulletin.Id,
                                                                             Account__c  = accountId));
        }

        if(doCreate){
            insert bulletinSentNotifications;
        }
        return bulletinSentNotifications;
    }

    public static List<InstalledBaseRS__c> createInstalledBaseRSs(Integer count, Id accountId, Boolean doCreate){
        List<InstalledBaseRS__c> installedBaseList = new List<InstalledBaseRS__c>();
        for(Integer i=0; i<count; i++){
            installedBaseList.add(
                new InstalledBaseRS__c(
                    Name='IBRS'+i, 
                    Country__c = 'France', 
                    Account__c = AccountId
                    )
                );
        }

        if(doCreate){
            insert installedBaseList;
        }
        return installedBaseList;
    }      

    public static List<RMA__c> createRMAs(Integer count, Id accountId, Boolean doCreate){
        List<RMA__c> rmaList = new List<RMA__c>();

        for(Integer i=0; i<count; i++){
            rmaList.add( new RMA__c( Same_as_Return_Billto__c = true,
                                     Same_as_Return_ultimateconsignee__c = true,
                                     RequestorAccount__c = accountId ) );
        }

        if(doCreate){
            insert rmaList;
        }

        return rmaList;
    }

    public static List<Item__c> createRMAItemss(Integer count, Id rmaId, Boolean doCreate){
        List<Item__c> rmaItemList = new List<Item__c>();

        for(Integer i=0; i<count; i++){
            rmaItemList.add( new Item__c(RMA__c = rmaId) );
        }

        if(doCreate){
            insert rmaItemList;
        }

        return rmaItemList;
    }
}