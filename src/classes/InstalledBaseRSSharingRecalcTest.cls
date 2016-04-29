@isTest
private class InstalledBaseRSSharingRecalcTest {
    private static final Integer NUMBER_TO_CREATE_ACCOUNT = 1;
    private static final Integer NUMBER_TO_CREATE_CONTACT = 1;
    private static final Integer NUMBER_TO_CREATE_INSTALLEDBASERS = 2;
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

    private static InstalledBaseRSSharingRecalc testBatch;

    static {
        profileId = [SELECT Id
                     FROM Profile
                     WHERE Name =: USER_PROFILE_NAME LIMIT 1][0].Id;
    }

    private static void prepareDataForTest(){
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
                contact.LastName = 'Contact Name' + String.valueOf(contactNamePreffix++);
                Contact.AccountId = account.Id;
                testContactList.add(contact);
            }
        }
        insert testContactList;

        testUserList = TestUtils.createUsers(testContactList, profileId, USER_NAME_PREFIX, true);

        testInstalledBaseRSList = new List<InstalledBaseRS__c>();
        Integer installedBaseRSNamePreffix = 1;
        for (Integer i = 0; i < NUMBER_TO_CREATE_INSTALLEDBASERS; i++){
            InstalledBaseRS__c item = UtilityTestMethod.getInstalledBaseRS();
            item.Name               = item.Name + String.valueOf(installedBaseRSNamePreffix++);
            item.Account__c         = testAccountList[0].Id;
            item.FleetMaintainer__c = testFleetMaintainerAccountList[0].Id;
            item.OperatorName__c    = testOperatorNameAccountList[0].Id;
            testInstalledBaseRSList.add(item);
        }
        insert testInstalledBaseRSList;
    }

    private static testMethod void initBatchClass(){
        Test.startTest();
            testBatch = new InstalledBaseRSSharingRecalc();
        Test.stopTest();

        System.assert(testBatch != null,  'InstalledBaseRSSharingRecalc should be created');
    }

    private static testMethod void executeBatchClass(){
        prepareDataForTest();

        List<InstalledBaseRS__Share> checkShareList = [SELECT Id FROM InstalledBaseRS__Share];

        testBatch = new InstalledBaseRSSharingRecalc();

        Test.startTest();
            Database.executeBatch( testBatch );
        Test.stopTest();

        checkShareList = [SELECT Id FROM InstalledBaseRS__Share WHERE Id IN : checkShareList];
        System.assert(checkShareList.isEmpty(), 'InstalledBaseRS__Share record should be created');

        List<InstalledBaseRS__Share> resultShareList = [SELECT Id FROM InstalledBaseRS__Share];
        System.assert(!resultShareList.isEmpty(), 'New InstalledBaseRS__Share record should be created');
    }
}