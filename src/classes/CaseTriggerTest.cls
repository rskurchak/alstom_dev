@isTest
private class CaseTriggerTest {
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

    private static testMethod void insertCaseRecords(){
        prepareAccountsAndContactsForTest('Contact Name');
        testUserList = TestUtils.createUsers(testContactList, profileId, USER_NAME_PREFIX, true);

        prepareCasesForTest(NUMBER_TO_CREATE_CASE);

        for (Case item : testCaseList){
            item.AccountId = testAccountList[0].Id;
        }

        Test.startTest();

                insert testCaseList;

        Test.stopTest();

        if (!PAD.canTrigger('BW01')) return;

        Map<Id, Group> gr = new Map<Id, Group>([SELECT Id, RelatedId
                                                FROM Group
                                                WHERE RelatedId IN : [Select PortalAccountId
                                                                      From UserRole
                                                                      Where PortalAccountId = : testAccountList[0].Id OR
                                                                            PortalAccountId = : parentAccount.Id]]);

        List<CaseShare> shareResultList = [SELECT Id, CaseId, UserOrGroupId, CaseAccessLevel, RowCause
                                           FROM CaseShare
                                           WHERE CaseId IN : testCaseList AND
                                                    RowCause <> 'Owner' AND
                                                    RowCause <> 'RelatedPortalUser' AND
                                                    UserOrGroupId IN : gr.keySet()];

        System.assert (!shareResultList.isEmpty(), 'CaseShare records should be created');

        Map<Id, Set<String>> sharedRecordsIdWithFieldNames = new Map<Id, Set<String>>();
        for (CaseShare item : shareResultList){
            if (!sharedRecordsIdWithFieldNames.containsKey(item.CaseId)){
                sharedRecordsIdWithFieldNames.put(item.CaseId, new Set<String>{item.RowCause});
            } else {
                sharedRecordsIdWithFieldNames.get(item.CaseId).add(item.RowCause);
            }
        }

        //check If all share records are created
        System.assertEquals(sharedRecordsIdWithFieldNames.keySet(), new Map<Id, Case>(testCaseList).keySet(), 'Not all share records are created');
    }

    private static testMethod void updateCaseRecords(){
        prepareAccountsAndContactsForTest('Contact Name');
        testUserList = TestUtils.createUsers(testContactList, profileId, USER_NAME_PREFIX, true);

        prepareCasesForTest(NUMBER_TO_CREATE_CASE);

        for (Case item : testCaseList){
            item.AccountId         = testAccountList[0].Id;
        }
        insert testCaseList;

        List<CaseShare> shareResultList = [SELECT Id, CaseId, UserOrGroupId, CaseAccessLevel, RowCause
                                           FROM CaseShare
                                           WHERE CaseId IN : testCaseList AND
                                                    RowCause <> 'Owner' AND
                                                    RowCause <> 'RelatedPortalUser'];

        for (Case item : testCaseList){
            item.AccountId = testAccountList[1].Id;
        }

        Test.startTest();

            update testCaseList;

        Test.stopTest();

        //check if previously created share records have been removed from the System
        shareResultList = [SELECT Id, CaseId, UserOrGroupId, CaseAccessLevel, RowCause
                           FROM CaseShare
                           WHERE Id IN : shareResultList];
        System.assert (shareResultList.isEmpty(), 'CaseShare records that where created on the insert should be deleted');

        if (!PAD.canTrigger('BW01')) return;

        Map<Id, Group> gr = new Map<Id, Group>([SELECT Id, RelatedId
                                                FROM Group
                                                WHERE RelatedId IN : [Select PortalAccountId
                                                                      From UserRole
                                                                      Where PortalAccountId = : testAccountList[1].Id OR
                                                                            PortalAccountId = : parentAccount.Id]]);

        shareResultList = [SELECT Id, CaseId, UserOrGroupId, CaseAccessLevel, RowCause
                           FROM CaseShare
                           WHERE CaseId IN : testCaseList AND
                                    RowCause <> 'Owner' AND
                                    RowCause <> 'RelatedPortalUser' AND
                                    UserOrGroupId IN : gr.keySet()];

        System.assert (!shareResultList.isEmpty(), 'CaseShare records should be created');

        Map<Id, Set<String>> sharedRecordsIdWithFieldNames = new Map<Id, Set<String>>();
        for (CaseShare item : shareResultList){
            if (!sharedRecordsIdWithFieldNames.containsKey(item.CaseId)){
                sharedRecordsIdWithFieldNames.put(item.CaseId, new Set<String>{item.RowCause});
            } else {
                sharedRecordsIdWithFieldNames.get(item.CaseId).add(item.RowCause);
            }
        }

        //check If all share records are created
        System.assertEquals(sharedRecordsIdWithFieldNames.keySet(), new Map<Id, Case>(testCaseList).keySet(), 'Not all share records are created');
    }

    private static testMethod void updateCaseWithOtherAccounts(){
        prepareAccountsAndContactsForTest('Contact Name');
        testUserList = TestUtils.createUsers(testContactList, profileId, USER_NAME_PREFIX, true);

        prepareCasesForTest(NUMBER_TO_CREATE_CASE);

        for (Case item : testCaseList){
            item.AccountId         = testAccountList[0].Id;
        }
        insert testCaseList;

        List<CaseShare> shareResultList = [SELECT Id, CaseId, UserOrGroupId, CaseAccessLevel, RowCause
                                           FROM CaseShare
                                           WHERE CaseId IN : testCaseList AND
                                                    RowCause <> 'Owner' AND
                                                    RowCause <> 'RelatedPortalUser'];

        //prepare additional Accounts, Contacts and Users for test
        prepareAccountsAndContactsForTest('Additional Contact');
        testUserList = null;
        testUserList = TestUtils.createUsers(testContactList, profileId, USER_NAME_PREFIX, true);

        for (Case item : testCaseList){
            item.AccountId         = testAccountList[0].Id;
        }

        Test.startTest();

            update testCaseList;

        Test.stopTest();


        //check if previously created share records have been removed from the System
        shareResultList = [SELECT Id, CaseId, UserOrGroupId, CaseAccessLevel, RowCause
                           FROM CaseShare
                           WHERE Id IN : shareResultList];
        System.assert (shareResultList.isEmpty(), 'CaseShare records that where created on the insert should be deleted');

        if (!PAD.canTrigger('BW01')) return;

        Map<Id, Group> gr = new Map<Id, Group>([SELECT Id, RelatedId
                                                FROM Group
                                                WHERE RelatedId IN : [Select PortalAccountId
                                                                      From UserRole
                                                                      Where PortalAccountId = : testAccountList[0].Id OR
                                                                            PortalAccountId = : parentAccount.Id]]);

        shareResultList = [SELECT Id, CaseId, UserOrGroupId, CaseAccessLevel, RowCause
                           FROM CaseShare
                           WHERE CaseId IN : testCaseList AND
                                    RowCause <> 'Owner' AND
                                    RowCause <> 'RelatedPortalUser' AND
                                    UserOrGroupId IN : gr.keySet()];

        System.assert (!shareResultList.isEmpty(), 'CaseShare records should be created');

        Map<Id, Set<String>> sharedRecordsIdWithFieldNames = new Map<Id, Set<String>>();
        for (CaseShare item : shareResultList){
            if (!sharedRecordsIdWithFieldNames.containsKey(item.CaseId)){
                sharedRecordsIdWithFieldNames.put(item.CaseId, new Set<String>{item.RowCause});
            } else {
                sharedRecordsIdWithFieldNames.get(item.CaseId).add(item.RowCause);
            }
        }

        //check If all share records are created
        System.assertEquals(sharedRecordsIdWithFieldNames.keySet(), new Map<Id, Case>(testCaseList).keySet(), 'Not all share records are created');
    }
}