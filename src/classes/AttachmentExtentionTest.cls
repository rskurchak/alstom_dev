@isTest
private class AttachmentExtentionTest {
	private static final Integer NUMBER_TO_CREATE_ACCOUNT = 1;
	private static final Integer NUMBER_TO_CREATE_RMA = 2;
	private static final Integer NUMBER_TO_CREATE_ITEM = 2;

	private static List<Account> testAccountList;
	private static List<RMA__c> testRMAList;
	private static List<Item__c> testItemList;

	private static AttachmentExtention testController;

	private static void prepareDataForTest(String processingOption){
		testAccountList = TestUtils.createAccount(NUMBER_TO_CREATE_ACCOUNT, null, true);

		testRMAList = new List<RMA__c>();
		for (Account account : testAccountList){
			testRMAList = TestUtils.createRMAs(NUMBER_TO_CREATE_RMA, account.Id, false);
		}
		insert testRMAList;

		testItemList = new List<Item__c>();
		for (RMA__c rma : testRMAList){
			for (Item__c item : TestUtils.createRMAItemss(NUMBER_TO_CREATE_ITEM, rma.Id, false)){
				item.Processing_Option__c = processingOption;
				testItemList.add(item);
			}
		}
		insert testItemList;
	}

	private static void preparePageController (RMA__c rma){
		ApexPages.StandardController std = new ApexPages.StandardController(rma);
		testController = new AttachmentExtention(std);
		Test.setCurrentPage( Page.AttachmentPDF );
	}

	private static testMethod void testInitControllerStandard(){
		prepareDataForTest(RMAServices.RMA_ITEM_OPTION_STANDARD);

		Test.startTest();

			preparePageController(testRMAList[0]);

		Test.stopTest();

		System.assert(testController != null, 'AttachmentExtention should be created');

		System.assert(testController.rma != null, 'RMA should be populated');
		System.assertEquals(testRMAList[0].Id, testController.rma.Id, 'Incorrect RMA record');

		System.assert(testController.itemDetailList != null, 'RMA should be populated');
		System.assert(!testController.itemDetailList.isEmpty(), 'Items for RMA should be in the deteils');
		for (Item__c item : testController.itemDetailList){
			System.assertEquals(testRMAList[0].Id, item.RMA__c, 'Incorrect Items for test RMA record');
		}

		System.assert(!String.isEmpty(testController.headerValue), 'Header should be populated');
		System.assertEquals(RMAServices.RMA_ITEM_OPTION_STANDARD, testController.headerValue, 'Incorrect header type');
	}

	private static testMethod void testInitControllerExpedite(){
		prepareDataForTest(RMAServices.RMA_ITEM_OPTION_EXPEDITE);

		Test.startTest();

			preparePageController(testRMAList[0]);

		Test.stopTest();

		System.assert(testController != null, 'AttachmentExtention should be created');

		System.assert(testController.rma != null, 'RMA should be populated');
		System.assertEquals(testRMAList[0].Id, testController.rma.Id, 'Incorrect RMA record');

		System.assert(testController.itemDetailList != null, 'RMA should be populated');
		System.assert(!testController.itemDetailList.isEmpty(), 'Items for RMA should be in the deteils');
		for (Item__c item : testController.itemDetailList){
			System.assertEquals(testRMAList[0].Id, item.RMA__c, 'Incorrect Items for test RMA record');
		}

		System.assert(!String.isEmpty(testController.headerValue), 'Header should be populated');
		System.assertEquals(RMAServices.RMA_ITEM_OPTION_EXPEDITE, testController.headerValue, 'Incorrect header type');
	}

	private static testMethod void testInitControllerUX(){
		prepareDataForTest(RMAServices.RMA_ITEM_OPTION_UX);

		Test.startTest();

			preparePageController(testRMAList[0]);

		Test.stopTest();

		System.assert(testController != null, 'AttachmentExtention should be created');

		System.assert(testController.rma != null, 'RMA should be populated');
		System.assertEquals(testRMAList[0].Id, testController.rma.Id, 'Incorrect RMA record');


		System.assert(testController.itemDetailList != null, 'RMA should be populated');
		System.assert(!testController.itemDetailList.isEmpty(), 'Items for RMA should be in the deteils');
		for (Item__c item : testController.itemDetailList){
			System.assertEquals(testRMAList[0].Id, item.RMA__c, 'Incorrect Items for test RMA record');
		}

		System.assert(!String.isEmpty(testController.headerValue), 'Header should be populated');
		System.assertEquals(RMAServices.RMA_ITEM_OPTION_UX, testController.headerValue, 'Incorrect header type');

	}
}