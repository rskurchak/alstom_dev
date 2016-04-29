@isTest
private class RMAServices_Test {
	private static final Integer NUMBER_TO_CREATE_ACCOUNT = 1;
	private static final Integer NUMBER_TO_CREATE_RMA = 2;
	private static final Integer NUMBER_TO_CREATE_ITEM = 2;

	private static List<Account> testAccountList;
	private static List<Contact> testContactList;
	private static List<RMA__c> testRMAList;
	private static List<Item__c> testItemList;

	private static void prepareDataForTest(){
		testAccountList = TestUtils.createAccount(NUMBER_TO_CREATE_ACCOUNT, null, true);

		testContactList = TestUtils.createContacts(testAccountList, true);

		testRMAList = new List<RMA__c>();
		for (Account account : testAccountList){
			testRMAList = TestUtils.createRMAs(NUMBER_TO_CREATE_RMA, account.Id, false);
		}
		insert testRMAList;

		testItemList = new List<Item__c>();
		for (RMA__c rma : testRMAList){
			testItemList.addAll(TestUtils.createRMAItemss(NUMBER_TO_CREATE_ITEM, rma.Id, false));
		}
		insert testItemList;
	}

	private static testMethod void getRMAById(){
		prepareDataForTest();

		RMA__c result;

		Test.startTest();

			result = RMAServices.getRMAById(testRMAList[0].Id);

		Test.stopTest();

		System.assert(result != null, 'Result can not be null.');
		System.assertEquals(testRMAList[0].Id, result.id, 'Incorrect RMA record returned.');
	}

	private static testMethod void getItemsByRMAId(){
		prepareDataForTest();

		List<Item__c> result;

		Test.startTest();

			result = RMAServices.getItemsByRMAId(testRMAList[0].Id);

		Test.stopTest();

		System.assert(result != null, 'Result can not be null.');
		System.assert(!result.isEmpty(), 'result can not be empty.');
		for (Item__c item : result){
			System.assertEquals(testRMAList[0].Id, item.RMA__c, 'Incorrect RMA details record returned.');
		}
	}

	private static testMethod void submitRMA(){
		prepareDataForTest();

		String result;

		Test.startTest();

			result = RMAServices.submitRMA( String.valueOf(testRMAList[0].Id), 'RMA Name', 'test_email@gmail.com', 'test_cc_email@gmail.com', testContactList[0].Id);

		Test.stopTest();

		System.assert(!String.isEmpty(result), 'Result can not be empty.');
		System.assertEquals( 'Success', result, 'Result should be "Success".');

		RMA__c check = [SELECT Id, Status__c, Submitted_Date__c
						FROM RMA__c WHERE Id = : testRMAList[0].Id];

		System.assertEquals(System.label.RMA_Submit_Status, check.Status__c, 'Status value should be updated.');
		System.assertEquals(Date.today(), check.Submitted_Date__c, 'Submitted_Date__c value should be updated to the current Date.');
	}

	private static testMethod void submitRMAWithoutContact(){
		prepareDataForTest();

		String result;

		Test.startTest();

			result = RMAServices.submitRMA( String.valueOf(testRMAList[0].Id), 'RMA Name', 'test_email@gmail.com', 'test_cc_email@gmail.com', null);

		Test.stopTest();

		System.assert(!String.isEmpty(result), 'Result can not be empty.');
		System.assertEquals( 'Success', result, 'Result should be "Success".');

		RMA__c check = [SELECT Id, Status__c, Submitted_Date__c
						FROM RMA__c WHERE Id = : testRMAList[0].Id];

		System.assertEquals(System.label.RMA_Submit_Status, check.Status__c, 'Status value should be updated.');
		System.assertEquals(Date.today(), check.Submitted_Date__c, 'Submitted_Date__c value should be updated to the current Date.');
	}

	private static testMethod void submitRMAWithoutEmailAddress(){
		prepareDataForTest();

		String result;

		Test.startTest();

			result = RMAServices.submitRMA( String.valueOf(testRMAList[0].Id), 'RMA Name', '', 'test_cc_email@gmail.com', testContactList[0].Id);

		Test.stopTest();

		System.assert(!String.isEmpty(result), 'Result can not be empty.');
		System.assertEquals( System.label.RMA_Email_Empty_Notification, result, 'Result should be "' + System.label.RMA_Email_Empty_Notification + '".');
	}

	private static testMethod void submitRMAWithIncorrectData(){
		Id incorrectRMAId = Id.valueOf(RMA__c.sObjectType.getDescribe().getKeyPrefix() + '000000000000');

		String result;

		Test.startTest();

			result = RMAServices.submitRMA( String.valueOf(incorrectRMAId), 'RMA Name', 'test_email@gmail.com', 'test_cc_email@gmail.com', null/*testContactList[0].Id*/);

		Test.stopTest();

		System.assert(!String.isEmpty(result), 'Result can not be empty.');
	}
}