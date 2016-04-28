@isTest
private class BulletinServicesTest {
	private final static Integer COUNT_BULLETIN = 4;
	private final static String  PROFILE_COMMUNITY_NAME = 'AT - Customer Community +';
	private final static String  EMAIL_PREFIX = '@transport.alstom.com';

	private static User 		 userWithRole;
	private static Profile 		 profile;
	private static List<Account> portalAccounts;
	private static List<Contact> portalContacts;
	private static List<User> 	 portalUsers;
	private static List<Bulletin__c> bulletinlist;
	private static List<Bulletin__c> alertslist;
	private static List<Bulletin_Sent_Notification__c> bulletinSentNotification;

	private static void setupData(){
		profile = [SELECT Id FROM Profile WHERE Name = :PROFILE_COMMUNITY_NAME LIMIT 1];	
		//create a portal accounts
		portalAccounts = TestUtils.createAccount(2, null, true);
		//create a portal contacts
		portalContacts = TestUtils.createContacts(portalAccounts, false);
		for (Contact contact : portalContacts){
			contact.Email = contact.LastName.replace(' ', '_') + '@gmail.com';
		}
		insert portalContacts;
		//create a portal users
		portalUsers = TestUtils.createUsers(portalContacts, profile.Id, EMAIL_PREFIX, true);
        //create bulletins
        bulletinlist = TestUtils.createBulletins(COUNT_BULLETIN, 'Bulletin', BulletinServices.BULLETIN_TYPE_BULLETIN, portalAccounts[0].Id, false);
        alertslist = TestUtils.createBulletins(COUNT_BULLETIN, 'Bulletin', BulletinServices.BULLETIN_TYPE_ALERT, portalAccounts[1].Id, false);
        List<Bulletin__c> bulletinsToInsert = new List<Bulletin__c>();
        bulletinsToInsert.addAll(bulletinlist);
        bulletinsToInsert.addAll(alertslist);
        insert bulletinsToInsert;
	}

	@isTest static void testBulletinServices() {
		setupData();

		Test.startTest();
			Map<String, List<Bulletin__c>> bulletinAlertMap = BulletinServices.getAvailableBulletinsByTypes('%en%');
		Test.stopTest();

		System.assertEquals(COUNT_BULLETIN, bulletinAlertMap.get(BulletinServices.BULLETIN_TYPE_ALERT).size(), 'Count bulletins with type "Alert" should be equlas created.');
		System.assertEquals(COUNT_BULLETIN, bulletinAlertMap.get(BulletinServices.BULLETIN_TYPE_BULLETIN).size(), 'Count bulletins with type "Bulletin" should be equlas created.');
	}

	@isTest static void notiyExternalUsersAboutBulletinUpdate() {
		setupData();

		bulletinSentNotification = TestUtils.createBulletinSentNotifications(new List<Bulletin__c>{bulletinlist[0]}, bulletinlist[0].Account__c, true);

		List<Bulletin__c> processingList = new List<Bulletin__c>();
		processingList.addAll(bulletinlist);
		processingList.addAll(alertslist);

		Test.startTest();
			BulletinServices.notiyExternalUsersAboutBulletinUpdate( processingList );
		Test.stopTest();
	}

	@isTest static void shareAndNotifyUsers() {
		setupData();

		List<UserRole> ur = [SELECT Id, PortalAccountId
							 FROM UserRole
							 WHERE PortalAccountId = : portalAccounts[0].Id];
		System.assert(!ur.isEmpty(), 'UserRole must be created');

		List<Group> gr = [SELECT Id, RelatedId
						  FROM Group
						  WHERE RelatedId = : ur];
		System.assert(!gr.isEmpty(), 'UserGroup must be created');

		//share Bulletin record
		Bulletin__Share shareRecordForTest = new Bulletin__Share( UserOrGroupId = gr[0].Id,
																  ParentId      = bulletinlist[0].Id,
																  AccessLevel   = 'Read',
																  RowCause      = 'Account__c' );
		insert shareRecordForTest;

		List<Bulletin__c> processingList = new List<Bulletin__c>();
		processingList.addAll(bulletinlist);
		processingList.addAll(alertslist);

		String result;

		Test.startTest();
			result = BulletinServices.shareAndNotifyUsers( bulletinlist[0].Id, bulletinlist[0].Language__c );
		Test.stopTest();

		System.assertEquals('Success', result, 'Incoorect result has been returned');

		//get Bulletin_Sent_Notification__c records
		List<Bulletin_Sent_Notification__c> bulletinSentNotificationCheckList = [SELECT Id
																				 FROM Bulletin_Sent_Notification__c
																				 WHERE Bulletin__c = : bulletinlist[0].Id AND
																						Account__c = : portalAccounts[0].Id];

		System.assert(!bulletinSentNotificationCheckList.isEmpty(), 'Bulletin_Sent_Notification__c should be created for avoiding sending duplicate emails');
	}

	@isTest static void shareAndNotifyUsersWithBulletinSentNotificationRecords() {
		setupData();

		List<UserRole> ur = [SELECT Id, PortalAccountId
							 FROM UserRole
							 WHERE PortalAccountId = : portalAccounts[0].Id];
		System.assert(!ur.isEmpty(), 'UserRole must be created');

		List<Group> gr = [SELECT Id, RelatedId
						  FROM Group
						  WHERE RelatedId = : ur];
		System.assert(!gr.isEmpty(), 'UserGroup must be created');

		//share Bulletin record
		Bulletin__Share shareRecordForTest = new Bulletin__Share( UserOrGroupId = gr[0].Id,
																  ParentId      = bulletinlist[0].Id,
																  AccessLevel   = 'Read',
																  RowCause      = 'Account__c' );
		insert shareRecordForTest;

		bulletinSentNotification = TestUtils.createBulletinSentNotifications(new List<Bulletin__c>{bulletinlist[0]}, bulletinlist[0].Account__c, true);

		List<Bulletin__c> processingList = new List<Bulletin__c>();
		processingList.addAll(bulletinlist);
		processingList.addAll(alertslist);

		String result;

		Test.startTest();
			result = BulletinServices.shareAndNotifyUsers( bulletinlist[0].Id, bulletinlist[0].Language__c );
		Test.stopTest();

		System.assertEquals('Success', result, 'Incoorect result has been returned');

		//get Bulletin_Sent_Notification__c records
		List<Bulletin_Sent_Notification__c> bulletinSentNotificationCheckList = [SELECT Id
																				 FROM Bulletin_Sent_Notification__c
																				 WHERE Bulletin__c = : bulletinlist[0].Id AND
																						Account__c = : portalAccounts[0].Id AND
																						(NOT Id IN : bulletinSentNotification)];

		System.assert(bulletinSentNotificationCheckList.isEmpty(), 'Bulletin_Sent_Notification__c should not be created if this records already exist');
	}
}