/*
  Class Test Controller for VFC61_InstalledBaseInfra_New
    ~ Author          : Tiantian HE ~ tiantian.he@cgi.com 
    ~ Date Created    : 23/02/2015
*/
@isTest
private class VFC61_InstalledBaseInfra_New_TEST {

	static testMethod void testVFC61() {
        System.debug('## >>>>> testing class VFC61_InstalledBaseInfra_New START <<<<<');
        Test.startTest();
        
        PageReference VFP61 = Page.VFP61_InstalledBaseInfra_New;
        Test.setCurrentPage(VFP61);
        VFC61_InstalledBaseInfra_New VFC61 = new VFC61_InstalledBaseInfra_New(new ApexPages.Standardcontroller(new InstalledBaseInfra__c()));
        
        Account testAccount = UtilityTestMethod.getAccount();
        insert testAccount;
        VFC61.IBI.put('Account__c', testAccount.Id);
        
        // Test if the RecordType is changed according to selected EquipmentClass__c
        List<RecordType> listRecType = [SELECT Name, Id FROM RecordType WHERE sObjectType = 'InstalledBaseInfra__c' AND Name = 'Road Signalling'];
        if (!listRecType.isEmpty()) {
	        VFC61.IBI.put('EquipmentCategory__c', 'E&M Equipment');
	        VFC61.IBI.put('EquipmentClass__c', 'Road Signalling');
	        VFC61.changeRecordType();
	        System.assertEquals(listRecType.get(0).Id, VFC61.IBI.get('RecordTypeId'));
        }
        
        try {
        	VFC61.doSave();
        } catch (UtilityTestMethod.MyException e) {
        }
        
        Test.stopTest();        
        System.debug('## >>>>> testing class VFC61_InstalledBaseInfra_New END <<<<<');
	}
}