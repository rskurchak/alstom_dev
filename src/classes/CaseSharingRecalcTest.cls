@isTest
private class CaseSharingRecalcTest {
    private static final Integer NUMBER_TO_CREATE_ACCOUNT = 2;
    private static final Integer NUMBER_TO_CREATE_CONTACT = 2;
    private static final Integer NUMBER_TO_CREATE_CASE = 5;
    private static final String  USER_PROFILE_NAME = 'AT - Customer Community +';
    private static final String  USER_NAME_PREFIX  = '@transport.alstom.com';

    private static Account parentAccount;
    private static List<Account> testAccountList;
    private static List<Contact> testContactList;
    private static List<User> testUserList;
    private static List<Case> testCaseList;
    private static Id profileId;
    private static List<String> caseRowCauseList;

    private static CaseSharingRecalc testBatch;

    static {
        profileId = [SELECT Id
                     FROM Profile
                     WHERE Name =: USER_PROFILE_NAME LIMIT 1][0].Id;

        caseRowCauseList = new List<String>();
		for( SharingFieldOptionsMetadata__mdt csItem : [ Select DeveloperName, RowCause__c, AccessLevel__c, MasterLabel 
													  	 From SharingFieldOptionsMetadata__mdt 
													  	 Where ObjectName__c = 'Case' ] ){
			caseRowCauseList.add(csItem.RowCause__c);
		}
    }

    private static void prepareAccountsAndContactsForTest(String contactNames){
        parentAccount                     = UtilityTestMethod.getAccount();
        parentAccount.Name                = 'TestAccountNameParent';
        parentAccount.IsAGlobalAccount__c = true;
        insert parentAccount;

        testAccountList                   = UtilityTestMethod.getAccounts(NUMBER_TO_CREATE_ACCOUNT);

        List<Account> accountForTestList = new List<Account>();
        accountForTestList.addAll(testAccountList);

        Integer accountNamePreffix = 1;
        for (Account account : accountForTestList){
            account.Name     = 'TestAccountName' + String.valueOf(accountNamePreffix++);
            account.ParentId = parentAccount.Id;
        }
        insert accountForTestList;

        accountForTestList.add(parentAccount);

        Integer contactNamePreffix = 1;
        testContactList = new List<Contact>();
        for (Account account : accountForTestList){
            for (Contact contact : UtilityTestMethod.getContacts(NUMBER_TO_CREATE_CONTACT)){
                contact.LastName = (String.isEmpty(contactNames) ? 'Contact Name' : contactNames) + String.valueOf(contactNamePreffix++);
                Contact.AccountId = account.Id;
                testContactList.add(contact);
            }
        }
        insert testContactList;
    }

    private static void prepareCasesForTest(Integer numberToCreate){
        testCaseList = UtilityTestMethod.getCaseList(NUMBER_TO_CREATE_CASE, 'Test status');
    }

    private static testMethod void initBatchClass(){
        Test.startTest();
            testBatch = new CaseSharingRecalc();
        Test.stopTest();

        System.assert(testBatch != null, 'CaseSharingRecalc should be created');
    }

    private static testMethod void executeBatchClass(){
        prepareAccountsAndContactsForTest('Contact Name');
        testUserList = TestUtils.createUsers(testContactList, profileId, USER_NAME_PREFIX, true);

        prepareCasesForTest(NUMBER_TO_CREATE_CASE);

        for (Case item : testCaseList){
            item.AccountId = testAccountList[0].Id;
        }

        insert testCaseList;

        List<CaseShare> checkCaseShareList = [SELECT Id FROM CaseShare WHERE RowCause IN : caseRowCauseList];

        testBatch = new CaseSharingRecalc();

        Test.startTest();
            Database.executeBatch(testBatch);
        Test.stopTest();

        checkCaseShareList = [SELECT Id FROM CaseShare WHERE Id IN : checkCaseShareList];
        System.assert(checkCaseShareList.isEmpty(), 'CaseShare record should be created');

        List<CaseShare> resultCaseShareList = [SELECT Id FROM CaseShare WHERE RowCause IN : caseRowCauseList];
        System.assert(!resultCaseShareList.isEmpty(), 'New CaseShare record should be created');
    }
}