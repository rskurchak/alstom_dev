/**
 * This class contains unit tests for validating the behavior of AP04User Apex classes
 * and triggers.
 * Mohamed EL MOUSSAOUI ~ mohamed.el-moussaoui@axoa.fr
 */
@isTest (SeeAllData=true)
private class AP04User_TEST 
{
    private static testMethod void testAP04(){
        System.debug('## >>>>> testing class AP04User START <<<<<');

        Integer numberToCreate = 5;
        List<Account> testAccountList = TestUtils.createAccount(numberToCreate, null, true);
        List<Contact> testContactList = TestUtils.createContacts(testAccountList, true);

        String USER_PROFILE_NAME = 'AT - Customer Community +';
        String USER_NAME_PREFIX  = '@transport.alstom.com';

        List<Profile> profile = [SELECT Id
                                 FROM Profile
                                 WHERE Name =: USER_PROFILE_NAME LIMIT 1];
        Id profileId = profile[0].Id;

        List<User> usersWithContacts = TestUtils.createUsers(testContactList, profileId, USER_NAME_PREFIX, false);

        List<User> chatterUsers = new List<User>();
        for(User u : UtilityTestMethod.getUsersToInsert(4)){
            u.isActive=true;
            chatterUsers.add(u);
        }

        List<User> users = new List<User>();
        users.addAll(chatterUsers);
        users.addAll(usersWithContacts);

        Test.startTest();
            insert users;
        Test.stopTest();

        List<EntitySubscription> autoFollowSubscription2Insert = [SELECT Id, SubscriberId
                                                                  FROM EntitySubscription
                                                                  WHERE ParentId = : System.Label.LBL0003 AND
                                                                        SubscriberId IN : users];

        System.assertEquals(chatterUsers.size(), autoFollowSubscription2Insert.size(), 'Incorrect EntitySubscription result number');

        Set<Id> checkResultSetId = new Set<Id>();
        for (EntitySubscription item : autoFollowSubscription2Insert){
            checkResultSetId.add(item.SubscriberId);
        }

        System.assertEquals(new Map<Id, User>(chatterUsers).keySet(), checkResultSetId, 'Incorrect created EntitySubscription Subscriber for Chatter Users');

        System.debug('## >>>>> testing class AP04User END <<<<<');
    }
}