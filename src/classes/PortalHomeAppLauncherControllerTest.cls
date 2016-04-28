@isTest
private class PortalHomeAppLauncherControllerTest {
	private final static String PROFILE_COMMUNITY_NAME = 'AT - Customer Community +';
	private final static String PERMISSION_SET_NAME = 'API Only User';
	private final static String EMAIL_PREFIX = '@transport.alstom.com';
	private final static String TILE_NAME = 'TestTile0';
	private final static String URL_NAME = 'TestUrl0';
	private final static String IMAGE_NAME = 'TestImage0';

	private static Profile 		 profile;
	private static List<Account> portalAccounts;
	private static List<Contact> portalContacts;
	private static List<User> 	 portalUsers;
	private static List<Tile__c> tiles;
	private static List<TileAssignment__c> tileAssignments;

	static {
		AP69User.avoidFutureMethodExecutionForTestNeeds = true;
	}

	private static void setupData(){
		System.runAs(new User(Id = UserInfo.getUserId())){			
			profile = [SELECT Id FROM Profile WHERE Name = :PROFILE_COMMUNITY_NAME LIMIT 1];	
			//create a portal accounts
			portalAccounts = TestUtils.createAccount(2, null, true);
			//create a portal contacts
			portalContacts = TestUtils.createContacts(portalAccounts, true);
			//create a portal users
			portalUsers = TestUtils.createUsers(portalContacts, profile.Id, EMAIL_PREFIX, true);
			//create a tiles
			tiles = TestUtils.createTiles(2, PERMISSION_SET_NAME, true);
			//create tileassignments
			tileAssignments = TestUtils.createTileAssignments(tiles, portalAccounts, true);
		}
	}

	@isTest static void testAvailableTilesForUser() {
		setupData();

		PortalHomeAppLauncherController con;

		List<Tile__c> tilesforUser;

		Test.startTest();

			System.runAs(portalUsers[0]){

				con = new PortalHomeAppLauncherController();
				tilesforUser = con.availableTilesForUser;

			}

		Test.stopTest();

		tilesforUser = [Select Id, Name, Image__c, Url__c, PermissionSet__c From Tile__c Where Id IN :tilesforUser];
		System.assertEquals(1, tilesforUser.size(), 'Count tiles for first user should be 1.');
		System.assertEquals(PERMISSION_SET_NAME, tilesforUser[0].PermissionSet__c, 'Permision set name should be API Only User');
		System.assertEquals(TILE_NAME, tilesforUser[0].Name, 'Field Name should be TestTile0.');
		System.assertEquals(URL_NAME, tilesforUser[0].Url__c, 'Field Url__c should be TestUrl0.');
		System.assertEquals(IMAGE_NAME, tilesforUser[0].Image__c, 'Field Url__c should be TestImage0.');
		System.assertEquals(portalUsers[0].Id, con.userId, 'User Id should equal portal user Id');
	}
		
}