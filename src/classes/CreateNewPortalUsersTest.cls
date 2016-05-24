@isTest
private class CreateNewPortalUsersTest {
	private final static Integer COUNT_ACCOUNT = 4;
	private final static String  PROFILE_CUSTOMER_PORTAL_CWC = 'AT - Customer Portal CWC User';
	private final static String  EMAIL_PREFIX = '@transport.alstom.com';

	private static List<Account> portalAccounts;
	private static List<Contact> portalContacts;
	private static Profile       profile;
	private static List<User>    portalUsers;

	private static CreateNewPortalUsers testBatchClass;

	private static void setupData(){
		//check if current user has UserRole
		if (UserInfo.getUserRoleId() == null){
			UserRole ur = [SELECT Id FROM UserRole LIMIT 1];
			System.runAs(new User(Id = UserInfo.getUserId())){
				//assign User to Role
				User u = new User(Id = UserInfo.getUserId(), UserRoleId = ur.Id);
				update u;
			}
		}

		//create a portal accounts
		portalAccounts = TestUtils.createAccount(COUNT_ACCOUNT, null, true);
		//create a portal contacts
		portalContacts = TestUtils.createContacts(portalAccounts, false);
		for (Contact contact : portalContacts){
			contact.Email = contact.LastName.replace(' ', '_') + '@gmail.com';
		}
		insert portalContacts;
	}

	private static testMethod void initController(){
		Test.startTest();
			testBatchClass = new CreateNewPortalUsers();
			System.assert (testBatchClass != null);

			testBatchClass = new CreateNewPortalUsers('');
			System.assert (testBatchClass != null);

			testBatchClass = new CreateNewPortalUsers('', '');
			System.assert (testBatchClass != null);

			testBatchClass = new CreateNewPortalUsers(new List<Id>(), '');
			System.assert (testBatchClass != null);
		Test.stopTest();
	}

	private static testMethod void executeBatch(){
		setupData();

		List<Id> contactListIds = new List<Id>();
		contactListIds.addAll( new Map<Id, Contact>(portalContacts).keySet() );

		testBatchClass = new CreateNewPortalUsers(contactListIds, '');
		System.assert (testBatchClass != null);

		Test.startTest();

			Database.executeBatch( testBatchClass );

		Test.stopTest();

		List<User> createdUsers = [SELECT Id
								   FROM User
								   WHERE ContactId IN : portalContacts AND
										Profile.Name = : PROFILE_CUSTOMER_PORTAL_CWC];

		System.assert(!createdUsers.isEmpty(), 'PortalUsers should be created');
		System.assertEquals( portalContacts.size(), createdUsers.size(), 'Incorrect user numbers are created');
	}

	private static testMethod void executeBatchContactWithUsers(){
		setupData();

		profile = [SELECT Id FROM Profile WHERE Name = : PROFILE_CUSTOMER_PORTAL_CWC LIMIT 1];
		//create a portal users
		portalUsers = TestUtils.createUsers(portalContacts, profile.Id, EMAIL_PREFIX, true);

		List<Id> contactListIds = new List<Id>();
		contactListIds.addAll( new Map<Id, Contact>(portalContacts).keySet() );

		testBatchClass = new CreateNewPortalUsers(contactListIds, '');
		System.assert (testBatchClass != null);

		Test.startTest();

			Database.executeBatch( testBatchClass );

		Test.stopTest();
	}

	private static testMethod void sendEmailContact(){
		setupData();

		profile = [SELECT Id FROM Profile WHERE Name = : PROFILE_CUSTOMER_PORTAL_CWC LIMIT 1];
		//create a portal users
		portalUsers = TestUtils.createUsers(portalContacts, profile.Id, EMAIL_PREFIX, true);

		List<Id> contactListIds = new List<Id>();
		contactListIds.addAll( new Map<Id, Contact>(portalContacts).keySet() );

		testBatchClass = new CreateNewPortalUsers(contactListIds, '');
		System.assert (testBatchClass != null);

		Test.startTest();

			testBatchClass.sendEmailContact('');

		Test.stopTest();
	}
}