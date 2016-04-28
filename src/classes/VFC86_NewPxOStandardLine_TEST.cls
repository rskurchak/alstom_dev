@isTest
private class VFC86_NewPxOStandardLine_TEST 
{
    static testMethod void VFC86_NewPxOStandardLine_TEST() 
    {
    	RecordType pxoStdRT = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'PxOStandard__c' and DeveloperName = :System.Label.LBL0312];
		PxOStandard__c pxoStd = UtilityTestMethod.getAlstomPxOStandards(1, new List<Id>{pxoStdRT.Id}).get(0);
		insert pxoStd;
		// Getting some new fields, like auto-number Name
		pxoStd = [Select Id, Name, RecordType.DeveloperName from PxOStandard__c where Id = :pxoStd.Id];
		
		Test.startTest();
        
        PageReference VFP86 = Page.VFP86_NewPxOStandardLine;
		Test.setCurrentPage(VFP86);
		ApexPages.currentPage().getParameters().put('id', pxoStd.Id);
		VFC86_NewPxOStandardLine VFC86 = new VFC86_NewPxOStandardLine(new ApexPages.StandardController(pxoStd));
        PageReference pr = VFC86.createPxOStandardLine();
         
        Test.stopTest();
        
        // Asserting that the correct RecorTypeId is passed in the new URL
        RecordType pxoStdLineRT = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'PxOStandardLine__c' and DeveloperName = :System.Label.LBL0312];
		System.assertEquals(true, pr.getUrl().contains(pxoStdLineRT.Id));
    }
}