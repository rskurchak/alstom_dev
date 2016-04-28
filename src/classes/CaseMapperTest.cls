@isTest
private class CaseMapperTest {
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

    private static Set<String> availableRawCause;

    private static CaseMapper testClass = new CaseMapper();

    static {
        profileId = [SELECT Id
                     FROM Profile
                     WHERE Name =: USER_PROFILE_NAME LIMIT 1][0].Id;

        availableRawCause = new Set<String>();

        for( SharingFieldOptionsMetadata__mdt csItem : [ Select DeveloperName, RowCause__c, AccessLevel__c, MasterLabel 
                                                         From SharingFieldOptionsMetadata__mdt 
                                                         Where ObjectName__c = 'Case' ] ){
            availableRawCause.add( csItem.RowCause__c );
        }
    }

    private static void prepareAccountsAndContactsForTest(){
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
                contact.LastName = 'Contact Name' + String.valueOf(contactNamePreffix++);
                Contact.AccountId = account.Id;
                testContactList.add(contact);
            }
        }
        insert testContactList;
    }

    private static void prepareCasesForTest(Integer numberToCreate){
        testCaseList = UtilityTestMethod.getCaseList(NUMBER_TO_CREATE_CASE, 'Test status');
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
        prepareCasesForTest(NUMBER_TO_CREATE_CASE);
        for (Case item : testCaseList){
            item.AccountId = testContactList[0].AccountId;
        }
        insert testCaseList;

        List<UserRole> ur = [SELECT Id, PortalAccountId
                             FROM UserRole
                             WHERE PortalAccountId = : testContactList[0].AccountId];
        System.assert(!ur.isEmpty(), 'UserRole must be created');

        List<Group> gr = [SELECT Id, RelatedId
                          FROM Group
                          WHERE RelatedId = : ur];
        System.assert(!gr.isEmpty(), 'UserGroup must be created');
        Set<Id> userGroupIds = new Map<Id, Group>(gr).keySet();

        List<CaseShare> share = [SELECT Id, CaseId, UserOrGroupId, CaseAccessLevel, RowCause
                                 FROM CaseShare
                                 WHERE (NOT RowCause IN : availableRawCause)];
        System.assert(!share.isEmpty(), '');

        CaseShare shareRecordForTest = new CaseShare( UserOrGroupId = gr[0].Id,
                                                      CaseId = testCaseList[0].Id,
                                                      CaseAccessLevel = 'Read' );
        insert shareRecordForTest;

        Set<Share> result;

        Test.startTest();

            result = testClass.getExistingShares(new List<Id>{testCaseList[0].Id});

        Test.stopTest();

        System.assert(!result.isEmpty());

        List<CaseShare> existingShareRecords = [SELECT Id, CaseId, UserOrGroupId, CaseAccessLevel, RowCause
                                                FROM CaseShare
                                                WHERE CaseId = : testCaseList[0].Id AND
                                                    RowCause IN : availableRawCause];

        System.assertEquals(existingShareRecords.size(), result.size(), 'Incorrect result records number');

        Set<Id> checkResultIds = new Set<Id>();
        for (Share item : result){
            checkResultIds.add(item.getShareId());
        }

        System.assertEquals(new Map<Id, CaseShare>(existingShareRecords).keySet(), checkResultIds, 'Incorrect existing CaseShare records in the result');
    }

    private static testMethod void getExistingSharesWithoutShares(){
        prepareAccountsAndContactsForTest();

        testUserList = TestUtils.createUsers(testContactList, profileId, USER_NAME_PREFIX, true);

        prepareCasesForTest(NUMBER_TO_CREATE_CASE);
        for (Case item : testCaseList){
            item.AccountId = testContactList[0].AccountId;
        }
        insert testCaseList;

        List<CaseShare> existingShareRecords = [SELECT Id, CaseId, UserOrGroupId, CaseAccessLevel, RowCause
                                                FROM CaseShare
                                                WHERE CaseId = : testCaseList[0].Id AND
                                                    RowCause IN : availableRawCause];
        delete existingShareRecords;

        Set<Share> result;

        Test.startTest();

            result = testClass.getExistingShares(new List<Id>{testCaseList[0].Id});

        Test.stopTest();

        System.assert(result.isEmpty(), 'Result should be empty');
    }
}