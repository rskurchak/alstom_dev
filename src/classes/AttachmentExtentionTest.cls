@isTest
private class AttachmentExtentionTest {
	private static final Integer NUMBER_TO_CREATE_ACCOUNT = 1;
	private static final Integer NUMBER_TO_CREATE_RMA = 2;
	private static final Integer NUMBER_TO_CREATE_ITEM = 2;
	private static final String TEST_EMAIL = 'tes_email_very_long_string_value@gmail.com';

	private static List<Account> testAccountList;
	private static List<RMA__c> testRMAList;
	private static List<Item__c> testItemList;

	private static AttachmentExtention testController;

	private static void prepareDataForTest(String processingOption, Boolean doPopulateItemsField){
		testAccountList = TestUtils.createAccount(NUMBER_TO_CREATE_ACCOUNT, null, true);

		testRMAList = new List<RMA__c>();
		for (Account account : testAccountList){
			for (RMA__c item : TestUtils.createRMAs(NUMBER_TO_CREATE_RMA, account.Id, false)){
				item.Email__c = TEST_EMAIL;
				item.Emailc__c = TEST_EMAIL;
				item.Additional_Comments__c = 'test comment with long word 123456789012345678901234567890';
				testRMAList.add(item);
			}
		}
		insert testRMAList;

		testItemList = new List<Item__c>();
		for (RMA__c rma : testRMAList){
			for (Item__c item : TestUtils.createRMAItemss(NUMBER_TO_CREATE_ITEM, rma.Id, false)){
				item.Processing_Option__c = processingOption;
				if (doPopulateItemsField){
					//populate fields with long values
					item.Action__c = 'action12345678901234567890';
					item.Item_Description__c = 'description12345678901234567890';
					item.Serial_Number__c = 'serialNumber12345678901234567890';
					item.Reason_for_Return__c = 'reasonForReturn12345678901234567890';
					item.GE_Part_Number__c = 'gePartNumber12345678901234567890';
				}
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
		prepareDataForTest(RMAServices.RMA_ITEM_OPTION_STANDARD, true);

		Test.startTest();

			preparePageController(testRMAList[0]);

		Test.stopTest();

		System.assert(testController != null, 'AttachmentExtention should be created');

		System.assert(testController.rma != null, 'RMA should be populated');
		System.assertEquals(testRMAList[0].Id, testController.rma.Id, 'Incorrect RMA record');

		System.assert(testController.items != null, 'RMA should be populated');
		System.assert(!testController.items.isEmpty(), 'Items for RMA should be in the deteils');
		System.assertEquals(NUMBER_TO_CREATE_ITEM, testController.items.size(), 'Incorrect Items number');
		for (AttachmentExtention.ItemWrapper item : testController.items){
			System.assert(!String.isEmpty(item.processingOption), 'processingOption should be populated');
			System.assert(item.action.contains('<wbr>'), 'action should be split by <wbr> tag');
			System.assert(item.description.contains('<wbr>'), 'description should be split by <wbr> tag');
			System.assert(item.serialNumber.contains('<wbr>'), 'serialNumber should be split by <wbr> tag');
			System.assert(item.reasonForReturn.contains('<wbr>'), 'reasonForReturn should be split by <wbr> tag');
			System.assert(item.gePartNumber.contains('<wbr>'), 'gePartNumber should be split by <wbr> tag');
		}

		System.assert(!String.isEmpty(testController.headerValue), 'Header should be populated');
		System.assertEquals(RMAServices.RMA_ITEM_OPTION_STANDARD, testController.headerValue, 'Incorrect header type');

		System.assert(!String.isEmpty(testController.emailValue), 'Email should be populated');
		System.assert(testController.emailValue.contains('<wbr>'), 'Email should be split by <wbr> tag');

		System.assert(!String.isEmpty(testController.emailcValue), 'Emailc should be populated');
		System.assert(testController.emailcValue.contains('<wbr>'), 'Emailc should be split by <wbr> tag');

		System.assert(!String.isEmpty(testController.additionalComments), 'Additional Comment should be populated');
		System.assert(testController.additionalComments.contains('<wbr>'), 'Additional Comment should be split by <wbr> tag');
	}

	private static testMethod void testInitControllerExpedite(){
		prepareDataForTest(RMAServices.RMA_ITEM_OPTION_EXPEDITE, true);

		Test.startTest();

			preparePageController(testRMAList[0]);

		Test.stopTest();

		System.assert(testController != null, 'AttachmentExtention should be created');

		System.assert(testController.rma != null, 'RMA should be populated');
		System.assertEquals(testRMAList[0].Id, testController.rma.Id, 'Incorrect RMA record');

		System.assert(testController.items != null, 'RMA should be populated');
		System.assert(!testController.items.isEmpty(), 'Items for RMA should be in the deteils');
		System.assertEquals(NUMBER_TO_CREATE_ITEM, testController.items.size(), 'Incorrect Items number');

		System.assert(!String.isEmpty(testController.headerValue), 'Header should be populated');
		System.assertEquals(RMAServices.RMA_ITEM_OPTION_EXPEDITE, testController.headerValue, 'Incorrect header type');
	}

	private static testMethod void testInitControllerUX(){
		prepareDataForTest(RMAServices.RMA_ITEM_OPTION_UX, true);

		Test.startTest();

			preparePageController(testRMAList[0]);

		Test.stopTest();

		System.assert(testController != null, 'AttachmentExtention should be created');

		System.assert(testController.rma != null, 'RMA should be populated');
		System.assertEquals(testRMAList[0].Id, testController.rma.Id, 'Incorrect RMA record');


		System.assert(testController.items != null, 'RMA should be populated');
		System.assert(!testController.items.isEmpty(), 'Items for RMA should be in the deteils');
		System.assertEquals(NUMBER_TO_CREATE_ITEM, testController.items.size(), 'Incorrect Items number');

		System.assert(!String.isEmpty(testController.headerValue), 'Header should be populated');
		System.assertEquals(RMAServices.RMA_ITEM_OPTION_UX, testController.headerValue, 'Incorrect header type');
	}

	private static testMethod void testInitControllerWithoutItems(){
		prepareDataForTest(RMAServices.RMA_ITEM_OPTION_STANDARD, false);

		Test.startTest();

			preparePageController(testRMAList[0]);

		Test.stopTest();

		System.assert(testController.items != null, 'RMA should be populated');
		System.assert(testController.items.isEmpty(), 'Items for RMA should be empty');
	}
}