@isTest
private class VFC74_BulletinSurveyReadReceiptTest {
	private static String BULLETINNAME = 'Bulletin';
	private static String BULLETINTYPE = 'bulletin';

	@isTest static void testSave() {
		Account account = TestUtils.createAccount(1, null, true)[0];
		Bulletin__c bulletin = TestUtils.createBulletin(BULLETINNAME, BULLETINTYPE, account.Id, true);
		ReadReceipt__c receipt = TestUtils.createReadReceipt(bulletin.Id, UserInfo.getUserId(), false);
		ApexPages.StandardController std = new ApexPages.StandardController(receipt);
		VFC74_BulletinSurveyCreateReadReceipt con = new VFC74_BulletinSurveyCreateReadReceipt(std);

		Test.startTest();
			PageReference page = con.save();
		Test.stopTest();

		System.assert(page.getURL().contains('VFP64_PortalHome'), 'Method should return reference on page VFP64_PortalHome');
		System.assertEquals(UserInfo.getUserId(), receipt.User__c, 'User id should equal current user Id');
		System.assertEquals(bulletin.Id, receipt.Bulletin__c, 'Bulletin id should equal created bulletin');
		System.assertNotEquals(null, receipt.Id, 'ReadReceipt__c object should have Id');
	}
	
	@isTest static void testSaveWithError() {
		ReadReceipt__c receipt = TestUtils.createReadReceipt('a1t4E0000004DibQAE', UserInfo.getUserId(), false);
		ApexPages.StandardController std = new ApexPages.StandardController(receipt);
		VFC74_BulletinSurveyCreateReadReceipt con = new VFC74_BulletinSurveyCreateReadReceipt(std);

		Test.startTest();
			PageReference page = con.save();
		Test.stopTest();

		System.assertEquals(null, page, 'Method should return null reference.');
		System.assertEquals(UserInfo.getUserId(), receipt.User__c, 'User id should equal current user Id');
		System.assertEquals(null, receipt.Id, 'ReadReceipt__c object doesn`t should created');
	}	
}