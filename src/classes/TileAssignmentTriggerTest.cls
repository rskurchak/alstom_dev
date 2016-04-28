@isTest
private class TileAssignmentTriggerTest {
	private final static String PROFILE_COMMUNITY_NAME = 'AT - Customer Community +';
	private final static String PERMISSION_SET_NAME = 'API Only User';
	private final static String EMAIL_PREFIX = '@transport.alstom.com';

	private static Profile 		 profile;
	private static List<Account> portalAccounts;
	private static List<Contact> portalContacts;
	private static List<User> 	 portalUsers;
	private static List<Tile__c> tiles;

	static {
		AP69User.avoidFutureMethodExecutionForTestNeeds = true;
	}
	
	private static void setupData(){
		profile = [SELECT Id FROM Profile WHERE Name = :PROFILE_COMMUNITY_NAME LIMIT 1];	
		//create a portal accounts
		portalAccounts = TestUtils.createAccount(2, null, true);
		//create a portal contacts
		portalContacts = TestUtils.createContacts(portalAccounts, true);
		//create a portal users
		portalUsers = TestUtils.createUsers(portalContacts, profile.Id, EMAIL_PREFIX, true);
		//create a tiles
		tiles = TestUtils.createTiles(2, PERMISSION_SET_NAME, true);
	}

	@isTest static void testAssign() {
		List<TileAssignment__c> tileAssignments;

		System.runAs(new User(Id = UserInfo.getUserId())){
			setupData();
			tileAssignments = TestUtils.createTileAssignments(tiles, portalAccounts, false);
		}

		Test.startTest();
			System.runAs(new User(Id = UserInfo.getUserId())){
				//create a tile assignments
				insert tileAssignments;
			}
		Test.stopTest();

		List<PermissionSetAssignment> assigments = [SELECT Id, AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Label = :PERMISSION_SET_NAME AND AssigneeId IN :portalUsers];
		System.assertEquals(2, assigments.size(), 'TileAssignmentTrigger must create two records');
	}

	@isTest static void testAssignWithInactiveUser() {
		List<TileAssignment__c> tileAssignments;

		System.runAs(new User(Id = UserInfo.getUserId())){
			setupData();
			tileAssignments = TestUtils.createTileAssignments(tiles, portalAccounts, false);

			portalUsers[0].isActive = false;
			update portalUsers[0];
		}

		Test.startTest();
			System.runAs(new User(Id = UserInfo.getUserId())){
				insert tileAssignments;
			}
		Test.stopTest();

		List<PermissionSetAssignment> assigments = [SELECT Id, AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Label = :PERMISSION_SET_NAME AND AssigneeId IN :portalUsers];
		System.assertEquals(1, assigments.size(), 'TileAssignmentTrigger must create two records');
	}

	@isTest static void testRevoke() {
		List<TileAssignment__c> tileAssignments;
		System.runAs(new User(Id = UserInfo.getUserId())){		
			setupData();
			PermissionSet ps = [SELECT Id, Label, Name FROM PermissionSet WHERE Label = :PERMISSION_SET_NAME LIMIT 1];
			List<PermissionSetAssignment> psAssignments = new List<PermissionSetAssignment>();
			psAssignments.add(TestUtils.createPermissionSetAssignment(ps.Id, portalUsers[0].Id, false));
			psAssignments.add(TestUtils.createPermissionSetAssignment(ps.Id, portalUsers[1].Id, false));
			insert psAssignments;
			tileAssignments = TestUtils.createTileAssignments(tiles, portalAccounts, true);
		}

		Test.startTest();
			System.runAs(new User(Id = UserInfo.getUserId())){
				//delete a tile assignment
				delete tileAssignments;	
			}
		Test.stopTest();

		List<PermissionSetAssignment> assigments = [SELECT Id, AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Label = :PERMISSION_SET_NAME AND AssigneeId IN :portalUsers];
		System.assertEquals(0, assigments.size(), 'TileAssignmentTrigger should delete two PermissionSetAssignment');
	}

	@isTest static void testRevokeWithInactiveUser() {
		List<TileAssignment__c> tileAssignments;
		System.runAs(new User(Id = UserInfo.getUserId())){
			setupData();
			PermissionSet ps = [SELECT Id, Label, Name FROM PermissionSet WHERE Label = :PERMISSION_SET_NAME LIMIT 1];
			List<PermissionSetAssignment> psAssignments = new List<PermissionSetAssignment>();
			psAssignments.add(TestUtils.createPermissionSetAssignment(ps.Id, portalUsers[0].Id, false));
			psAssignments.add(TestUtils.createPermissionSetAssignment(ps.Id, portalUsers[1].Id, false));
			insert psAssignments;
			tileAssignments = TestUtils.createTileAssignments(tiles, portalAccounts, true);

			portalUsers[0].isActive = false;
			update portalUsers[0];
		}

		Test.startTest();
			System.runAs(new User(Id = UserInfo.getUserId())){
				//delete a tile assignment
				delete tileAssignments;
			}
		Test.stopTest();

		List<PermissionSetAssignment> assigments = [SELECT Id, AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Label = :PERMISSION_SET_NAME AND AssigneeId IN :portalUsers];
		System.assertEquals(1, assigments.size(), 'TileAssignmentTrigger should delete two PermissionSetAssignment');
	}
}