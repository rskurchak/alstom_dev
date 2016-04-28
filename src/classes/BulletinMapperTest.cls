@isTest
private class BulletinMapperTest {
    private static final Integer NUMBER_TO_CREATE_ACCOUNT = 2;
    private static final Integer NUMBER_TO_CREATE_CONTACT = 1;
    private static final Integer NUMBER_TO_CREATE_BULLETIN = 5;
    private static final String  USER_PROFILE_NAME = 'AT - Customer Community +';
    private static final String  USER_NAME_PREFIX  = '@transport.alstom.com';

    private static Account parentAccount;
    private static Account accountWithoutParentAccount;
    private static List<Account> testAccountList;
    private static List<Contact> testContactList;
    private static List<User> testUserList;
    private static List<Bulletin__c> testBulletinList;
    private static Id profileId;

    private static BulletinMapper testClass = new BulletinMapper();

    static {
        profileId = [SELECT Id
                     FROM Profile
                     WHERE Name =: USER_PROFILE_NAME LIMIT 1][0].Id;
    }

    private static void prepareAccountsAndContactsForTest(String contactNames){
        parentAccount                     = TestUtils.createAccount(1, null, false)[0];
        parentAccount.Name                = 'TestAccountNameParent';
        parentAccount.IsAGlobalAccount__c = true;

        accountWithoutParentAccount       = TestUtils.createAccount(1, null, false)[0];
        accountWithoutParentAccount.Name  = 'TestAccountWithoutParent';
        insert new List<Account>{parentAccount, accountWithoutParentAccount};

        testAccountList = TestUtils.createAccount(NUMBER_TO_CREATE_ACCOUNT, parentAccount.Id, false);
        insert testAccountList;

        List<Account> allAccountsList = new List<Account>();
        allAccountsList.addAll(testAccountList);

        allAccountsList.add(parentAccount);
        allAccountsList.add(accountWithoutParentAccount);

        testContactList = TestUtils.createContacts(allAccountsList, true);
    }

    private static testMethod void getSObjectsFromShare(){
        prepareAccountsAndContactsForTest('Contact Name');

        testUserList = TestUtils.createUsers(testContactList, profileId, USER_NAME_PREFIX, true);

        testBulletinList = TestUtils.createBulletins(NUMBER_TO_CREATE_BULLETIN, 'Bulletin', 'TestType', null, false);
        insert testBulletinList;

        List<UserRole> ur = [SELECT Id, PortalAccountId
                             FROM UserRole
                             WHERE PortalAccountId = : testContactList[0].AccountId];
        System.assert(!ur.isEmpty(), 'UserRole must be created');

        List<Group> gr = [SELECT Id, RelatedId
                          FROM Group
                          WHERE RelatedId = : ur];
        System.assert(!gr.isEmpty(), 'UserGroup must be created');

        List<Share> shareList = new List<Share>();
        for (Bulletin__c bulletinItem : testBulletinList){
            Share shareItem = new Share(bulletinItem.Id, gr[0].Id, 'cause', 'Edit', null);
            shareList.add(shareItem);
        }

        List<sObject> resList;

        Test.startTest();

            resList = testClass.getSObjectsFromShare(shareList);

        Test.stopTest();

        System.assert (!resList.isEmpty(), 'result cannot be empty');
        System.assertEquals(shareList.size(), resList.size(), 'Incorrect records number in the result');

        System.assert ( resList instanceof List<Bulletin__Share> );
    }

    private static testMethod void getUserOrGroupIdsMap(){
        prepareAccountsAndContactsForTest('Contact Name');

        testUserList = TestUtils.createUsers(testContactList, profileId, USER_NAME_PREFIX, true);

        testBulletinList = TestUtils.createBulletins(NUMBER_TO_CREATE_BULLETIN, 'Bulletin', 'TestType', null, false);
        insert testBulletinList;

        List<UserRole> ur = [SELECT Id, PortalAccountId
                             FROM UserRole
                             WHERE PortalAccountId = : testContactList[0].AccountId];
        System.assert(!ur.isEmpty(), 'UserRole must be created');

        List<Group> gr = [SELECT Id, RelatedId
                          FROM Group
                          WHERE RelatedId = : ur];
        System.assert(!gr.isEmpty(), 'UserGroup must be created');

        List<Share> shareList = new List<Share>();
        for (Bulletin__c bulletinItem : testBulletinList){
            Share shareItem = new Share(bulletinItem.Id, gr[0].Id, 'cause', 'Edit', null);
            shareList.add(shareItem);
        }

        //share Bulletin record
        Bulletin__Share shareRecordForTest = new Bulletin__Share( UserOrGroupId = gr[0].Id,
                                                                  ParentId      = testBulletinList[0].Id,
                                                                  AccessLevel   = 'Read',
                                                                  RowCause      = 'Account__c' );
        insert shareRecordForTest;

        Map<String, Set<Id>> result;

        Test.startTest();

            result = testClass.getUserOrGroupIdsMap( testBulletinList[0].Id );

        Test.stopTest();

        List<Bulletin__Share> existingBulletinShare = [SELECT Id, UserOrGroupId
                                                       FROM Bulletin__Share
                                                       WHERE ParentId = : testBulletinList[0].Id];

        System.assert (!result.isEmpty(), 'result cannot be empty');
        System.assertEquals(existingBulletinShare.size(), result.size(), 'Incorrect records number in the result');
    }

    private static testMethod void getParentAccountIdsForUsers(){
        prepareAccountsAndContactsForTest('Contact Name');

        testUserList = TestUtils.createUsers(testContactList, profileId, USER_NAME_PREFIX, true);

        Set<Id> accountSetIdForCheckResult = new Set<Id>{parentAccount.Id};

        Set<Id> result;

        Test.startTest();

            result = testClass.getParentAccountIdsForUsers( new Map<Id, User>(testUserList).keySet() );

        Test.stopTest();

        System.assert (!result.isEmpty(), 'result cannot be empty');
        System.assertEquals(accountSetIdForCheckResult, result, 'Incorrect result, the only Parrent Account record should be returned');
    }


    private static testMethod void getParentAccountIdsForGroups(){
        prepareAccountsAndContactsForTest('Contact Name');

        testUserList = TestUtils.createUsers(testContactList, profileId, USER_NAME_PREFIX, true);

        List<UserRole> ur = [SELECT Id, PortalAccountId
                             FROM UserRole
                             WHERE PortalAccountId = : testAccountList[0].Id];
        System.assert(!ur.isEmpty(), 'UserRole must be created');

        List<Group> gr = [SELECT Id, RelatedId
                          FROM Group
                          WHERE RelatedId = : ur];

        Set<Id> result;

        Test.startTest();

            result = testClass.getParentAccountIdsForGroups( new Map<Id, Group>(gr).keySet() );

        Test.stopTest();

        System.assert (!result.isEmpty(), 'result cannot be empty');
        System.assertEquals(new Set<Id>{parentAccount.Id}, result, 'Incorrect result, the only Parrent Account record should be returned');

        System.assertEquals(new Set<Id>{parentAccount.Id, testAccountList[0].Id}, testClass.getAllAccounts(), 'Incorrect allAccounts property in the Class');
    }

    private static testMethod void getSharesToCreate(){
        prepareAccountsAndContactsForTest('Contact Name');

        testUserList = TestUtils.createUsers(testContactList, profileId, USER_NAME_PREFIX, true);

        testBulletinList = TestUtils.createBulletins(NUMBER_TO_CREATE_BULLETIN, 'Bulletin', 'TestType', null, false);
        insert testBulletinList;

        List<UserRole> ur = [SELECT Id, PortalAccountId
                             FROM UserRole
                             WHERE PortalAccountId = : testContactList[0].AccountId];
        System.assert(!ur.isEmpty(), 'UserRole must be created');

        List<Group> gr = [SELECT Id, RelatedId
                          FROM Group
                          WHERE RelatedId = : ur];
        System.assert(!gr.isEmpty(), 'UserGroup must be created');

        Map<Id, Id> accountWithGroupMap = new Map<Id, Id>{testAccountList[0].Id => gr[0].Id};

        Set<Share> result;

        Test.startTest();

            result = testClass.getSharesToCreate( testBulletinList[0].Id, accountWithGroupMap );

        Test.stopTest();

        System.assert (!result.isEmpty(), 'result cannot be empty');
        System.assertEquals(accountWithGroupMap.size(), result.size(), 'Incorrect records number in the result');
    }

    //mandatory method for MapperInterface
    private static testMethod void getFieldOptions(){
        Map<String, Map<String, String>> result;

        Test.startTest();

            result = testClass.getFieldOptions();

        Test.stopTest();

        System.assert (result != null, 'Result can not be null');
    }

    //mandatory method for MapperInterface
    private static testMethod void getExistingShares(){
        Set<Share> result;

        Test.startTest();

            result = testClass.getExistingShares( new List<Id>() );

        Test.stopTest();

        System.assert (result != null, 'Result can not be null');
    }
}