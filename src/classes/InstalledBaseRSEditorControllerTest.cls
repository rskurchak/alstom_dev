@isTest
private class InstalledBaseRSEditorControllerTest {
	private final static String  EMAIL_PREFIX = '@transport.alstom.com';
	private static final Integer KM_PER_YEAR = 10;
	private final static String  PROFILE_COMMUNITY_NAME = 'AT - Customer Community +';
	private static InstalledBaseRS__c installedBase;

	private static void setupData(){
		Profile profile = [SELECT Id FROM Profile WHERE Name = :PROFILE_COMMUNITY_NAME LIMIT 1];
		//create a portal accounts
		List<Account> portalAccounts = TestUtils.createAccount(1, null, true);
		//create a portal contacts
		List<Contact> portalContacts = TestUtils.createContacts(portalAccounts, true);
		//create a portal users
		List<User> portalUsers = TestUtils.createUsers(portalContacts, profile.Id, EMAIL_PREFIX, true);
		//create installedBaseRS
		installedBase = TestUtils.createInstalledBaseRSs(1, portalAccounts[0].Id, true)[0];
	}

	@isTest static void testActionSaveEditOne() {
		setupData();
		ApexPages.StandardController std = new ApexPages.StandardController(installedBase);
		InstalledBaseRSEditorController con = new InstalledBaseRSEditorController(std);
		con.isEdit = true;
		installedBase.AverageOfKmPerYear__c = KM_PER_YEAR;

		Test.setCurrentPage(Page.InstalledBaseRSEditor);
		Test.startTest();
			con.actionSaveEdit();	
		Test.stopTest();

		InstalledBaseRS__c rec = [SELECT Id, AverageOfKmPerYear__c FROM InstalledBaseRS__c WHERE Id = :installedBase.Id];
		System.assertEquals(KM_PER_YEAR, rec.AverageOfKmPerYear__c, 'Controller should update field AverageOfKmPerYear__c');
	}
	
	@isTest static void testActionSaveEditTwo() {
		setupData();
		ApexPages.StandardController std = new ApexPages.StandardController(installedBase);
		InstalledBaseRSEditorController con = new InstalledBaseRSEditorController(std);
		con.isEdit = true;
		installedBase.MaxSpeed__c = 999999;

		Test.setCurrentPage(Page.InstalledBaseRSEditor);
		Test.startTest();
			con.actionSaveEdit();	
		Test.stopTest();

		System.assert(ApexPages.hasMessages(), 'Page should has a message.');
	}
	
}