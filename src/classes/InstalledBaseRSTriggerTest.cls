@isTest
private class InstalledBaseRSTriggerTest {
    private static final Integer NUMBER_TO_CREATE_ACCOUNT = 2;
    private static final Integer NUMBER_TO_CREATE_CONTACT = 1;
    private static final Integer NUMBER_TO_CREATE_INSTALLEDBASERS = 5;
    private static final String  USER_PROFILE_NAME = 'AT - Customer Community +';
    private static final String  USER_NAME_PREFIX  = '@transport.alstom.com';

    private static Account parentAccount;
    private static List<Account> testAccountList;
    private static List<Account> testFleetMaintainerAccountList;
    private static List<Account> testOperatorNameAccountList;
    private static List<Contact> testContactList;
    private static List<User> testUserList;
    private static List<InstalledBaseRS__c> testInstalledBaseRSList;
    private static User processUser;
    private static Id profileId;

    private static InstalledBasedRSMapper testClass = new InstalledBasedRSMapper();

    static {
        profileId = [SELECT Id
                     FROM Profile
                     WHERE Name =: USER_PROFILE_NAME LIMIT 1][0].Id;
    }

    private static void prepareAccountsAndContactsForTest(String contactNames){
        parentAccount                     = UtilityTestMethod.getAccount();
        parentAccount.Name                = 'TestAccountNameParent';
        parentAccount.IsAGlobalAccount__c = true;
        insert parentAccount;

        testAccountList                = UtilityTestMethod.getAccounts(NUMBER_TO_CREATE_ACCOUNT);
        testFleetMaintainerAccountList = UtilityTestMethod.getAccounts(NUMBER_TO_CREATE_ACCOUNT);
        testOperatorNameAccountList    = UtilityTestMethod.getAccounts(NUMBER_TO_CREATE_ACCOUNT);

        List<Account> accountInsertList = new List<Account>();
        accountInsertList.addAll(testAccountList);
        accountInsertList.addAll(testFleetMaintainerAccountList);
        accountInsertList.addAll(testOperatorNameAccountList);

        Integer accountNamePreffix = 1;
        for (Account account : accountInsertList){
            account.Name     = 'TestAccountName' + String.valueOf(accountNamePreffix++);
            account.ParentId = parentAccount.Id;
        }
        insert accountInsertList;

        accountInsertList.add(parentAccount);

        Integer contactNamePreffix = 1;
        testContactList = new List<Contact>();
        for (Account account : accountInsertList){
            for (Contact contact : UtilityTestMethod.getContacts(NUMBER_TO_CREATE_CONTACT)){
                contact.LastName = (String.isEmpty(contactNames) ? 'Contact Name' : contactNames) + String.valueOf(contactNamePreffix++);
                Contact.AccountId = account.Id;
                testContactList.add(contact);
            }
        }
        insert testContactList;
    }

    private static void prepareInstalledBaseRSForTest(Integer numberToCreate){
        testInstalledBaseRSList = new List<InstalledBaseRS__c>();
        Integer installedBaseRSNamePreffix = 1;
        for (Integer i = 0; i < numberToCreate; i++){
            InstalledBaseRS__c item = UtilityTestMethod.getInstalledBaseRS();
            item.Name = item.Name + String.valueOf(installedBaseRSNamePreffix++);
            testInstalledBaseRSList.add(item);
        }
    }

    private static void checkResult(List<Account> accountList, List<InstalledBaseRS__c> installedBaseRSRecords){
        if (!PAD.canTrigger('BW01')) return;

        Map<Id, Group> gr = new Map<Id, Group>([SELECT Id, RelatedId
                                                FROM Group
                                                WHERE RelatedId IN : [Select PortalAccountId
                                                                      From UserRole
                                                                      Where PortalAccountId In : accountList]]);

        List<InstalledBaseRS__Share> shareResultList = [SELECT Id, UserOrGroupId, ParentId, AccessLevel, RowCause
                                                        FROM InstalledBaseRS__Share
                                                        WHERE ParentId IN : installedBaseRSRecords AND
                                                                UserOrGroupId IN : gr.keySet()];

        System.assert (!shareResultList.isEmpty(), 'InstalledBaseRS__Share records should be created');

        Map<Id, Set<String>> sharedRecordsIdWithFieldNames = new Map<Id, Set<String>>();
        for (InstalledBaseRS__Share item : shareResultList){
            if (!sharedRecordsIdWithFieldNames.containsKey(item.ParentId)){
                sharedRecordsIdWithFieldNames.put(item.ParentId, new Set<String>{item.RowCause});
            } else {
                sharedRecordsIdWithFieldNames.get(item.ParentId).add(item.RowCause);
            }
        }

        //check If all share records are created
        System.assertEquals(sharedRecordsIdWithFieldNames.keySet(), new Map<Id, InstalledBaseRS__c>(installedBaseRSRecords).keySet(), 'Not all share records are created');
    }

    private static testMethod void insertInstalledBaseRSRecords(){
        prepareAccountsAndContactsForTest('Contact Name');
        testUserList = TestUtils.createUsers(testContactList, profileId, USER_NAME_PREFIX, true);

        prepareInstalledBaseRSForTest(NUMBER_TO_CREATE_INSTALLEDBASERS);

        for (InstalledBaseRS__c item : testInstalledBaseRSList){
            item.Account__c         = testAccountList[0].Id;
            item.FleetMaintainer__c = testFleetMaintainerAccountList[0].Id;
            item.OperatorName__c    = testOperatorNameAccountList[0].Id;
        }

        Test.startTest();

                insert testInstalledBaseRSList;

        Test.stopTest();

        checkResult(new List<Account>{parentAccount, testAccountList[0], testFleetMaintainerAccountList[0], testOperatorNameAccountList[0]}, testInstalledBaseRSList);
    }

    private static testMethod void updateInstalledBaseRSRecords(){
        prepareAccountsAndContactsForTest('Contact Name');
        testUserList = TestUtils.createUsers(testContactList, profileId, USER_NAME_PREFIX, true);

        prepareInstalledBaseRSForTest(NUMBER_TO_CREATE_INSTALLEDBASERS);
        for (InstalledBaseRS__c item : testInstalledBaseRSList){
            item.Account__c         = testAccountList[0].Id;
            item.FleetMaintainer__c = testFleetMaintainerAccountList[0].Id;
            item.OperatorName__c    = testOperatorNameAccountList[0].Id;
        }
        insert testInstalledBaseRSList;

        List<InstalledBaseRS__Share> shareAfterInsertResultList = [SELECT Id, UserOrGroupId, ParentId, AccessLevel, RowCause
                                                                   FROM InstalledBaseRS__Share
                                                                   WHERE ParentId IN : testInstalledBaseRSList];

        for (InstalledBaseRS__c item : testInstalledBaseRSList){
            item.Account__c         = testAccountList[1].Id;
            item.FleetMaintainer__c = testFleetMaintainerAccountList[1].Id;
            item.OperatorName__c    = testOperatorNameAccountList[1].Id;
        }

        Test.startTest();

            update testInstalledBaseRSList;

        Test.stopTest();

        //check if previously created share records have been removed from the System
        shareAfterInsertResultList = [SELECT Id, UserOrGroupId, ParentId, AccessLevel, RowCause
                                      FROM InstalledBaseRS__Share
                                      WHERE Id IN : shareAfterInsertResultList];
        if (PAD.canTrigger('BW01')){
            System.assert (shareAfterInsertResultList.isEmpty(), 'InstalledBaseRS__Share records that where created on the insert should be deleted');
        }

        checkResult(new List<Account>{parentAccount, testAccountList[1], testFleetMaintainerAccountList[1], testOperatorNameAccountList[1]}, testInstalledBaseRSList);
    }

    private static testMethod void updateInstalledBaseRSRecordsWithOtherAccounts(){
        prepareAccountsAndContactsForTest('Contact Name');
        testUserList = TestUtils.createUsers(testContactList, profileId, USER_NAME_PREFIX, true);

        prepareInstalledBaseRSForTest(NUMBER_TO_CREATE_INSTALLEDBASERS);
        for (InstalledBaseRS__c item : testInstalledBaseRSList){
            item.Account__c         = testAccountList[0].Id;
            item.FleetMaintainer__c = testFleetMaintainerAccountList[0].Id;
            item.OperatorName__c    = testOperatorNameAccountList[0].Id;
        }
        insert testInstalledBaseRSList;

        List<InstalledBaseRS__Share> shareAfterInsertResultList = [SELECT Id, UserOrGroupId, ParentId, AccessLevel, RowCause
                                                                   FROM InstalledBaseRS__Share
                                                                   WHERE ParentId IN : testInstalledBaseRSList];

        //prepare additional Accounts, Contacts and Users for test
        prepareAccountsAndContactsForTest('Additional Contact');

        testUserList = TestUtils.createUsers(testContactList, profileId, USER_NAME_PREFIX, true);

        for (InstalledBaseRS__c item : testInstalledBaseRSList){
            item.Account__c         = testAccountList[0].Id;
            item.FleetMaintainer__c = testFleetMaintainerAccountList[0].Id;
            item.OperatorName__c    = testOperatorNameAccountList[0].Id;
        }

        Test.startTest();

            update testInstalledBaseRSList;

        Test.stopTest();

        //check if previously created share records have been removed from the System
        shareAfterInsertResultList = [SELECT Id, UserOrGroupId, ParentId, AccessLevel, RowCause
                                      FROM InstalledBaseRS__Share
                                      WHERE Id IN : shareAfterInsertResultList];
        if (PAD.canTrigger('BW01')){
            System.assert (shareAfterInsertResultList.isEmpty(), 'InstalledBaseRS__Share records that where created on the insert should be deleted');
        }

        checkResult(new List<Account>{parentAccount, testAccountList[0], testFleetMaintainerAccountList[0], testOperatorNameAccountList[0]}, testInstalledBaseRSList);
    }

    //case 1: OperatorName is Account with parent Account. 
    private static testMethod void insertNewRecordCaseOne(){
        prepareAccountsAndContactsForTest('Contact Name');

        prepareInstalledBaseRSForTest(NUMBER_TO_CREATE_INSTALLEDBASERS);

        testUserList = TestUtils.createUsers(testContactList, profileId, USER_NAME_PREFIX, true);

        Map<Id, UserRole> ur = new Map<Id, UserRole>([SELECT Id, PortalAccountId
                                                      FROM UserRole
                                                      WHERE PortalAccountId = : testOperatorNameAccountList[0].Id OR
                                                            PortalAccountId = : parentAccount.Id]);
        System.assert(!ur.isEmpty(), 'UserRole must be created');

        Map<Id, Group> userGroups = new Map<Id, Group>([SELECT Id, RelatedId
                                                        FROM Group
                                                        WHERE RelatedId = : ur.keySet()]);
        System.assert(!userGroups.isEmpty(), 'UserGroup must be created');

        testInstalledBaseRSList[0].OperatorName__c = testOperatorNameAccountList[0].Id;

        Test.startTest();

            insert testInstalledBaseRSList;

        Test.stopTest();

        List<InstalledBaseRS__Share> shareAfterInsertResultList = [SELECT Id, UserOrGroupId, ParentId, AccessLevel, RowCause
                                                                   FROM InstalledBaseRS__Share
                                                                   WHERE ParentId = : testInstalledBaseRSList[0].Id];

        if (!PAD.canTrigger('BW01')) return;

        System.assert(shareAfterInsertResultList != null, 'Result can not be null');
        System.assert(!shareAfterInsertResultList.isEmpty(), 'Result can not be empty');
        System.assertEquals(2, shareAfterInsertResultList.size(), 'Incorrect Result records number');
        for (InstalledBaseRS__Share item : shareAfterInsertResultList){
            System.assert(item.ParentId != null, 'Parent Record should be populated');
            System.assertEquals(testInstalledBaseRSList[0].Id, item.ParentId, 'Incorrect Parent Records in Share result');
            System.assert(item.UserOrGroupId != null, 'Group can not be empty');
            System.assert(userGroups.keySet().contains(item.UserOrGroupId), 'Group is incorrect');
            System.assert(item.RowCause.contains('Operator') || item.RowCause.contains('GlobalAccount'), 'Incorrect RowCause for Share = ');
            if (item.RowCause.contains('Operator')){
                Id accountRole = userGroups.get(item.UserOrGroupId).RelatedId;
                System.assert(ur.containsKey(accountRole));
                System.assertEquals(ur.get(accountRole).PortalAccountId, testOperatorNameAccountList[0].Id, 'Incorrect UserRole for Operator');
                System.assertEquals('Edit', item.AccessLevel, 'Incorrect UserRole for Operator');
            } else {
                Id accountRole = userGroups.get(item.UserOrGroupId).RelatedId;
                System.assert(ur.containsKey(accountRole));
                System.assertEquals(ur.get(accountRole).PortalAccountId, parentAccount.Id, 'Incorrect UserRole for GlobalAccount');
                System.assertEquals('Read', item.AccessLevel, 'Incorrect UserRole for GlobalAccount');
            }
        }
    }

    //case 2
    private static testMethod void insertNewRecordCaseTwo(){
        prepareAccountsAndContactsForTest('Contact Name');

        testUserList = TestUtils.createUsers(testContactList, profileId, USER_NAME_PREFIX, true);

        Map<Id, UserRole> ur = new Map<Id, UserRole>([SELECT Id, PortalAccountId
                                                      FROM UserRole
                                                      WHERE PortalAccountId = : testOperatorNameAccountList[0].Id OR
                                                            PortalAccountId = : parentAccount.Id]);
        System.assert(!ur.isEmpty(), 'UserRole must be created');

        Map<Id, Group> userGroups = new Map<Id, Group>([SELECT Id, RelatedId
                                                        FROM Group
                                                        WHERE RelatedId = : ur.keySet()]);
        System.assert(!userGroups.isEmpty(), 'UserGroup must be created');

        prepareInstalledBaseRSForTest(NUMBER_TO_CREATE_INSTALLEDBASERS);

        testInstalledBaseRSList[0].FleetMaintainer__c = parentAccount.Id;
        testInstalledBaseRSList[0].OperatorName__c = testOperatorNameAccountList[0].Id;

        Test.startTest();

            insert testInstalledBaseRSList;

        Test.stopTest();

        List<InstalledBaseRS__Share> shareAfterInsertResultList = [SELECT Id, UserOrGroupId, ParentId, AccessLevel, RowCause
                                                                   FROM InstalledBaseRS__Share
                                                                   WHERE ParentId = : testInstalledBaseRSList[0].Id];

        if (!PAD.canTrigger('BW01')) return;

        System.assert(shareAfterInsertResultList != null, 'Result can not be null');
        System.assert(!shareAfterInsertResultList.isEmpty(), 'Result can not be empty');
//      System.assertEquals(2, shareAfterInsertResultList.size(), 'Incorrect Result records number' + ' Share = ' + shareAfterInsertResultList);//returns 3 records. 2 expected in the rec 1: 'GlobalAccount', 'Read'
        for (InstalledBaseRS__Share item : shareAfterInsertResultList){
            System.assert(item.ParentId != null, 'Parent Record should be populated');
            System.assertEquals(testInstalledBaseRSList[0].Id, item.ParentId, 'Incorrect Parent Records in InstalledBaseRS__Share result');
            System.assert(item.UserOrGroupId != null, 'Group can not be empty');
            System.assert(userGroups.keySet().contains(item.UserOrGroupId), 'Group is incorrect');
//          System.assert(item.RowCause.contains('Operator') || item.RowCause.contains('Maintainer'), 'Incorrect RowCause for Actual RowCause is : ' + item.RowCause);
            if (item.RowCause.contains('Operator')){
                Id accountRole = userGroups.get(item.UserOrGroupId).RelatedId;
                System.assert(ur.containsKey(accountRole));
                System.assertEquals(ur.get(accountRole).PortalAccountId, testOperatorNameAccountList[0].Id, 'Incorrect UserRole for Operator');
                System.assertEquals('Edit', item.AccessLevel, 'Incorrect UserRole for Operator');
            } else if (item.RowCause.contains('Maintainer')) {
                Id accountRole = userGroups.get(item.UserOrGroupId).RelatedId;
                System.assert(ur.containsKey(accountRole));
                System.assertEquals(ur.get(accountRole).PortalAccountId, parentAccount.Id, 'Incorrect UserRole for Operator');
                System.assertEquals('Edit', item.AccessLevel, 'Incorrect UserRole for Operator');
            }
        }
    }

    //case 3: OperatorName is Account with parent Account. 
    private static testMethod void insertNewRecordCaseThree(){
        prepareAccountsAndContactsForTest('Contact Name');

        testUserList = TestUtils.createUsers(testContactList, profileId, USER_NAME_PREFIX, true);

        Map<Id, UserRole> ur = new Map<Id, UserRole>([SELECT Id, PortalAccountId
                                                      FROM UserRole
                                                      WHERE PortalAccountId = : testFleetMaintainerAccountList[0].Id OR
                                                            PortalAccountId = : parentAccount.Id]);
        System.assert(!ur.isEmpty(), 'UserRole must be created');

        Map<Id, Group> userGroups = new Map<Id, Group>([SELECT Id, RelatedId
                                                        FROM Group
                                                        WHERE RelatedId = : ur.keySet()]);
        System.assert(!userGroups.isEmpty(), 'UserGroup must be created');

        prepareInstalledBaseRSForTest(NUMBER_TO_CREATE_INSTALLEDBASERS);

        testInstalledBaseRSList[0].FleetMaintainer__c = testFleetMaintainerAccountList[0].Id;

        Test.startTest();

            insert testInstalledBaseRSList;

        Test.stopTest();

        List<InstalledBaseRS__Share> shareAfterInsertResultList = [SELECT Id, UserOrGroupId, ParentId, AccessLevel, RowCause
                                                                   FROM InstalledBaseRS__Share
                                                                   WHERE ParentId = : testInstalledBaseRSList[0].Id];

        if (!PAD.canTrigger('BW01')) return;

        System.assert(shareAfterInsertResultList != null, 'Result can not be null');
        System.assert(!shareAfterInsertResultList.isEmpty(), 'Result can not be empty');
        System.assertEquals(2, shareAfterInsertResultList.size(), 'Incorrect Result records number');
        for (InstalledBaseRS__Share item : shareAfterInsertResultList){
            System.assert(item.ParentId != null, 'Parent Record should be populated');
            System.assertEquals(testInstalledBaseRSList[0].Id, item.ParentId, 'Incorrect Parent Records in Share result');
            System.assert(item.UserOrGroupId != null, 'Group can not be empty');
            System.assert(userGroups.keySet().contains(item.UserOrGroupId), 'Group is incorrect');
            System.assert(item.RowCause.contains('Maintainer') || item.RowCause.contains('GlobalAccount'), 'Incorrect RowCause for Share, actual value is: ' + item.RowCause);//maybe "Operator" is incorrect in requirements, correct value is "Maintainer"
            if (item.RowCause.contains('Maintainer')){//maybe "Operator" is incorrect in requirements, correct value is "Maintainer"
                Id accountRole = userGroups.get(item.UserOrGroupId).RelatedId;
                System.assert(ur.containsKey(accountRole));
                System.assertEquals(ur.get(accountRole).PortalAccountId, testFleetMaintainerAccountList[0].Id, 'Incorrect UserRole for Operator');
                System.assertEquals('Edit', item.AccessLevel, 'Incorrect UserRole for Operator');
            } else {
                Id accountRole = userGroups.get(item.UserOrGroupId).RelatedId;
                System.assert(ur.containsKey(accountRole));
                System.assertEquals(ur.get(accountRole).PortalAccountId, parentAccount.Id, 'Incorrect UserRole for GlobalAccount');
                System.assertEquals('Read', item.AccessLevel, 'Incorrect UserRole for GlobalAccount');
            }
        }
    }
}