@isTest
private class CustomMetadataServicesTest {
	
	@isTest static void testCustomMetadataServicesOne() {
		Test.startTest();
			String msg = CustomMetadataServices.getNotificationRecipients(CustomMetadataServices.CONTACT_UPDATE_ERROR_NOTIFICATION);
		Test.stopTest();

		System.assert(msg.contains('@'), 'Text should be valid value.');
	}
	
	@isTest static void testCustomMetadataServicesTwo() {
		Test.startTest();
			String msg = CustomMetadataServices.getNotificationRecipients(CustomMetadataServices.PERMISSION_SET_ASSIGNMENT_EXCEPTION);
		Test.stopTest();

		System.assert(msg.contains('@'), 'Text should be valid value.');
	}
	
	@isTest static void testGetPDFFormSetting() {
		RMA_Form__mdt  result;

		Test.startTest();
			result = CustomMetadataServices.getPDFFormSetting(CustomMetadataServices.RMA_FORM_SETTING_NAME);
		Test.stopTest();

		System.assert(result != null, 'RMA_Form__mdt should be created');
	}
}