/*
  VFC64_PortalHome_TEST
  Class Test Controller for VFC64_PortalHome
   ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
   ~ Date Created    : 17/06/2014 
*/
@isTest
private class VFC64_PortalHome_TEST {
    private static final Integer COUNT_RECORDS = 4;
    private static final String  USER_PROFILE_NAME = 'AT - Customer Community +';
    private static final String  USER_NAME_PREFIX  = '@transport.alstom.com';

    private static Account account;
    private static Contact contact;
    private static User    testSystemAdministrator;
    private static User    testCommunityUser;
    private static Id      portalUserProfileId;

    private static List<Case>                    requestlist;
    private static List<InstalledBaseRS__c>      iblist;
    private static List<News__c>                 newslist;
    private static List<News__c>                 technewslist;
    private static List<News__c>                 tipsandTutorialslist;
    private static List<Tile__c>                 tiles;
    private static List<PermissionSetAssignment> psAssignments;
    private static List<TileAssignment__c>       tileAssignments;
    private static List<Bulletin__c>             bulletinsToInsert;

    private static PageReference VFP64 = Page.VFP64_PortalHome;
    private static VFC64_PortalHome VFC64;

    public static testMethod void testVFC64() {
        System.debug('## >>>>> testing class VFC64_PortalHome START <<<<<');

        //create additional System Administrator User for test needs
        testSystemAdministrator = TestUtils.createUser( 'additional_system_addministrator',
                                                        USER_NAME_PREFIX,
                                                        UserInfo.getProfileId(),
                                                        UserInfo.getUserRoleId() != null ? UserInfo.getUserRoleId() : [SELECT Id FROM UserRole LIMIT 1][0].Id, //User Role should be populated
                                                        true);

        System.runAs( testSystemAdministrator ){
            account = TestUtils.createAccount(1, null, true)[0];
            contact = TestUtils.createContacts(new List<Account>{account}, true)[0];

            portalUserProfileId = [SELECT Id FROM Profile WHERE Name = : USER_PROFILE_NAME][0].Id;
            testCommunityUser = TestUtils.createUsers( new List<Contact>{contact}, portalUserProfileId, USER_NAME_PREFIX, true )[0];

            iblist = UtilityTestMethod.getInstalledBaseList(COUNT_RECORDS, account.Id);
            insert iblist;

            //prepare News for test
            newslist             = UtilityTestMethod.getNewsList(COUNT_RECORDS, 'General');
            technewslist         = UtilityTestMethod.getNewsList(COUNT_RECORDS, 'Technical');
            tipsandTutorialslist = UtilityTestMethod.getNewsList(COUNT_RECORDS, 'Tips & Tutorials');

            List<News__c> newsListForInsert = new List<News__c>();
                   newsListForInsert.addAll(newslist);
                   newsListForInsert.addAll(technewslist);
                   newsListForInsert.addAll(tipsandTutorialslist);
            insert newsListForInsert;

                   tiles = new List<Tile__c>();
                   tiles.addAll( TestUtils.createTiles(1, TileService.TILE_PERMISSION_SET_BULLETINS, false) );
                   tiles.addAll( TestUtils.createTiles(1, TileService.TILE_PERMISSION_SET_REQUESTS, false) );
                   tiles[1].Order__c = 1;
            insert tiles;

            List<PermissionSet> ps = [SELECT Id, Label, Name FROM PermissionSet WHERE Label IN (:TileService.TILE_PERMISSION_SET_BULLETINS, :TileService.TILE_PERMISSION_SET_REQUESTS)];

                   psAssignments = new List<PermissionSetAssignment>();
                   psAssignments.add( TestUtils.createPermissionSetAssignment(ps[0].Id, testCommunityUser.Id, false) );
                   psAssignments.add( TestUtils.createPermissionSetAssignment(ps[1].Id, testCommunityUser.Id, false) );
            insert psAssignments;

            tileAssignments = TestUtils.createTileAssignments(tiles, new List<Account>{account, account}, true);
        }

        System.runAs( testCommunityUser ) {
                   bulletinsToInsert = new List<Bulletin__c>();
                   bulletinsToInsert.addAll( TestUtils.createBulletins(COUNT_RECORDS, 'Bulletin', 'Bulletin', account.Id, false) );
                   bulletinsToInsert.addAll( TestUtils.createBulletins(COUNT_RECORDS, 'Bulletin', 'Alert', account.Id, false) );
            insert bulletinsToInsert;

                   requestlist = UtilityTestMethod.getCaseList(COUNT_RECORDS, 'Open');
            insert requestlist; 
        }

        Test.startTest();

            System.runAs( testCommunityUser ) {

                Test.setCurrentPage(VFP64);

                VFC64 = new VFC64_PortalHome();

                //Just for test coverage.
                VFC64.getListViewURL('Test', 'Account');

            }

        Test.stopTest();

        System.assertEquals(COUNT_RECORDS, VFC64.bulletinList.size(), 'Count bulletins should be equlas created.');
        System.assertEquals(COUNT_RECORDS, VFC64.alertList.size(), 'Count bulletins should be equlas created.');
        System.assertEquals(COUNT_RECORDS, VFC64.requestList.size(), 'Count cases should be equlas created.');
    }
}