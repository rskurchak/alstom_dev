@isTest
private class TileTriggerTest {
	private final static String  PROFILE_COMMUNITY_NAME = 'AT - Customer Community +';
	private final static String  PERMISSION_SET_NAME = 'API Only User';
	private final static String  EMAIL_PREFIX = '@transport.alstom.com';
	private final static Integer COUNT_TILES = 4;

	private static User 		 userWithRole;
	private static Profile 		 profile;
	private static List<Account> portalAccounts;
	private static List<Contact> portalContacts;
	private static List<User> 	 portalUsers;
	private static List<Tile__c> tiles;

	private static void setupData(){
		List<User> users = [SELECT Id FROM User WHERE UserRoleId != null AND isActive = true AND Profile.Name = 'System Administrator'];
		System.assert(!users.isEmpty(), 'Please set user a role');
		userWithRole = users[0];
		profile = [SELECT Id FROM Profile WHERE Name = :PROFILE_COMMUNITY_NAME LIMIT 1];	
		System.runAs(userWithRole){
			//create a portal accounts
			portalAccounts = TestUtils.createAccount(2, null, true);
			//create a portal contacts
			portalContacts = TestUtils.createContacts(portalAccounts, true);
			//create a portal users
			portalUsers = TestUtils.createUsers(portalContacts, profile.Id, EMAIL_PREFIX, true);
			//create a tiles
			tiles = TestUtils.createTiles(COUNT_TILES, PERMISSION_SET_NAME, true);
		}
	}

	@isTest static void testReassignOrdersOnUpdate(){
		setupData();
		tiles[2].Order__c = 8;
		tiles[3].Order__c = 9;
		update tiles;
		tiles[2].Order__c = 1;

		TileService.isReasigned = false;
		Test.startTest();
			update tiles[2];
		Test.stopTest();

		List<Tile__c> tilesSelected = [SELECT Id, Name, Order__c FROM Tile__c WHERE Id = :tiles[1].Id];
		System.assertEquals(2, tilesSelected[0].Order__c, 'Second tile should be moved on third position.');
	}

	@isTest static void testReassignOrdersOnInsert(){
		setupData();
		Tile__c tile = TestUtils.createTiles(1, PERMISSION_SET_NAME, false)[0];
		tile.Order__c = 1;

		TileService.isReasigned = false;
		Test.startTest();
			insert tile;
		Test.stopTest();

		List<Tile__c> tilesSelected = [SELECT Id, Name, Order__c FROM Tile__c WHERE Id = :tiles[1].Id];
		System.assertEquals(2, tilesSelected[0].Order__c, 'Second tile should be moved on third position.');
	}

	@isTest static void testReassignOrdersOnError(){
		setupData();
		tiles[1].Order__c = 999999999;
		update tiles[1];
		tiles[2].Order__c = 999999999;
		String msg = '';

		TileService.isReasigned = false;
		Test.startTest();
			try{
				update tiles[2];
			}catch(Exception e){
				msg = e.getMessage();
			}			
		Test.stopTest();

		System.assert(msg.contains(tiles[2].Id), 'We should get error.');
	}		
}