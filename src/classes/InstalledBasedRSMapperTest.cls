@isTest
private class InstalledBasedRSMapperTest {
    private static final Integer NUMBER_TO_CREATE_ACCOUNT = 1;
    private static final Integer NUMBER_TO_CREATE_CONTACT = 1;
    private static final Integer NUMBER_TO_CREATE_INSTALLEDBASERS = 10;
    private static final String  USER_PROFILE_NAME = 'AT - Customer Community +';
    private static final String  USER_NAME_PREFIX  = '@transport.alstom.com';

    private static Account parentAccount;
    private static Account accountWithoutParentAccount;
    private static List<Account> testAccountList;
    private static List<Account> testFleetMaintainerAccountList;
    private static List<Account> testOperatorNameAccountList;
    private static List<Contact> testContactList;
    private static List<User> testUserList;
    private static List<InstalledBaseRS__c> testInstalledBaseRSList;
    private static Id profileId;

    private static InstalledBasedRSMapper testClass = new InstalledBasedRSMapper();

    static {
        profileId = [SELECT Id
                     FROM Profile
                     WHERE Name =: USER_PROFILE_NAME LIMIT 1][0].Id;
    }

    private static void prepareAccountsAndContactsForTest(){
        parentAccount                     = UtilityTestMethod.getAccount();
        parentAccount.Name                = 'TestAccountNameParent';
        parentAccount.IsAGlobalAccount__c = true;
        insert parentAccount;

        accountWithoutParentAccount   = UtilityTestMethod.getAccounts(1)[0];
        testAccountList                = UtilityTestMethod.getAccounts(NUMBER_TO_CREATE_ACCOUNT);
        testFleetMaintainerAccountList = UtilityTestMethod.getAccounts(NUMBER_TO_CREATE_ACCOUNT);
        testOperatorNameAccountList    = UtilityTestMethod.getAccounts(NUMBER_TO_CREATE_ACCOUNT);

        List<Account> accountForTestList = new List<Account>();
        accountForTestList.addAll(testAccountList);
        accountForTestList.addAll(testFleetMaintainerAccountList);
        accountForTestList.addAll(testOperatorNameAccountList);

        Integer accountNamePreffix = 1;
        for (Account account : accountForTestList){
            account.Name     = 'TestAccountName' + String.valueOf(accountNamePreffix++);
            account.ParentId = parentAccount.Id;
        }
        accountForTestList.add(accountWithoutParentAccount);
        insert accountForTestList;

        accountForTestList.add(parentAccount);

        Integer contactNamePreffix = 1;
        testContactList = new List<Contact>();
        for (Account account : accountForTestList){
            for (Contact contact : UtilityTestMethod.getContacts(NUMBER_TO_CREATE_CONTACT)){
                contact.LastName = 'Contact Name' + String.valueOf(contactNamePreffix++);
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

    private static testMethod void getFieldOptions(){
        Map<String, Map<String, String>> result;

        Test.startTest();

            result = testClass.getFieldOptions();

        Test.stopTest();

        List<SharingFieldOptionsMetadata__mdt> checkResultList = [ SELECT DeveloperName, RowCause__c, AccessLevel__c, MasterLabel
                                                                   FROM SharingFieldOptionsMetadata__mdt
                                                                   WHERE ObjectName__c = 'InstalledBaseRS__c' ];

        System.assertEquals(checkResultList.isEmpty(), result.isEmpty(), 'Result should depend from existing SharingFieldOptionsMetadata__mdt records');
    }

    private static testMethod void getSObjectsFromShare(){
        List<SObject> result;

        Test.startTest();

            result = testClass.getSObjectsFromShare(new List<Share>());

        Test.stopTest();
    }

    private static testMethod void getExistingShares(){
        prepareAccountsAndContactsForTest();

        testUserList = TestUtils.createUsers(testContactList, profileId, USER_NAME_PREFIX, true);

        prepareInstalledBaseRSForTest(NUMBER_TO_CREATE_INSTALLEDBASERS);
        testInstalledBaseRSList[0].Account__c = testContactList[0].AccountId;
        insert testInstalledBaseRSList;

        List<UserRole> ur = [SELECT Id, PortalAccountId
                             FROM UserRole
                             WHERE PortalAccountId = : testContactList[0].AccountId];
        System.assert(!ur.isEmpty(), 'UserRole must be created');

        List<Group> gr = [SELECT Id, RelatedId
                          FROM Group
                          WHERE RelatedId = : ur];
        System.assert(!gr.isEmpty(), 'UserGroup must be created');
        Set<Id> userGroupIds = new Map<Id, Group>(gr).keySet();

        List<InstalledBaseRS__Share> share = [SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause
                                              FROM InstalledBaseRS__Share];
        System.assert(!share.isEmpty(), '');

        InstalledBaseRS__Share shareRecordForTest = new InstalledBaseRS__Share( UserOrGroupId = gr[0].Id,
                                                                                ParentId = testInstalledBaseRSList[0].Id,
                                                                                AccessLevel = 'Read',
                                                                                RowCause = 'Account__c' );
        insert shareRecordForTest;

        Set<Share> result;

        Test.startTest();

            result = testClass.getExistingShares(new List<Id>{testInstalledBaseRSList[0].Id});

        Test.stopTest();

        System.assert(!result.isEmpty());

        List<InstalledBaseRS__Share> existingShareRecords = [SELECT Id, UserOrGroupId, AccessLevel, RowCause
                                                             FROM InstalledBaseRS__Share
                                                             WHERE ParentId = : testInstalledBaseRSList[0].Id];

        System.assertEquals(existingShareRecords.size(), result.size(), 'Incorrect result records number');

        Set<Id> checkResultIds = new Set<Id>();
        for (Share item : result){
            checkResultIds.add(item.getShareId());
        }

        System.assertEquals(new Map<Id, InstalledBaseRS__Share>(existingShareRecords).keySet(), checkResultIds, 'Incorrect existing InstalledBaseRS__Share records in the result');
    }

    private static testMethod void getExistingSharesWithoutShares(){
        prepareAccountsAndContactsForTest();

        testUserList = TestUtils.createUsers(testContactList, profileId, USER_NAME_PREFIX, true);

        prepareInstalledBaseRSForTest(NUMBER_TO_CREATE_INSTALLEDBASERS);
        testInstalledBaseRSList[0].Account__c = testContactList[0].AccountId;
        insert testInstalledBaseRSList;

        List<InstalledBaseRS__Share> existingShareRecords = [SELECT Id, UserOrGroupId, AccessLevel, RowCause
                                                           FROM InstalledBaseRS__Share
                                                           WHERE ParentId = : testInstalledBaseRSList[0].Id];
        delete existingShareRecords;

        Set<Share> result;

        Test.startTest();

            result = testClass.getExistingShares(new List<Id>{testInstalledBaseRSList[0].Id});

        Test.stopTest();

        System.assert(result.isEmpty(), 'Result should be empty');
    }
}