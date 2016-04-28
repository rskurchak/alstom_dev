@isTest
private class VFC85_ClonePxOStandard_TEST 
{
    static testMethod void VFC85_ClonePxOStandard_TEST() 
    {
    	RecordType pxoStdRT = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'PxOStandard__c' and DeveloperName = :System.Label.LBL0312];
		PxOStandard__c pxoStd = UtilityTestMethod.getAlstomPxOStandards(1, new List<Id>{pxoStdRT.Id}).get(0);
		insert pxoStd;
		
		TerangaUnit__c tu = new TerangaUnit__c();
		tu.TrainsSite__c = true;
		insert tu;
		
		RecordType pxoLineStdRt = [SELECT Id FROM RecordType WHERE SObjectType = 'PxOStandardLine__c' and DeveloperName = :System.Label.LBL0312];
		PxOStandardLine__c pxoStdLine = UtilityTestMethod.getAlstomPxOStandardLines(1, new List<Id>{pxoLineStdRt.Id}, new List<Id>{pxoStd.Id}, new List<Id>{tu.Id}).get(0);
		insert pxoStdLine;
		
		Test.startTest();
        
        PageReference VFP85 = Page.VFP85_ClonePxOStandard;
		Test.setCurrentPage(VFP85);
		ApexPages.currentPage().getParameters().put('id', pxoStd.Id);
		VFC85_ClonePxOStandard VFC85 = new VFC85_ClonePxOStandard(new ApexPages.StandardController(pxoStd));
		VFC85.deepClone();
            
        Test.stopTest();
        
        // Getting some informations for checking PxO Standard clone results
        PxOStandard__c clonedPxoStd = [Select Id, RecordTypeId, Platform__c, Product__c, Approver__c, Comments__c
                            		   from PxOStandard__c where Id != :pxoStd.Id Limit 1];
		
		// Checking some fields (not all as anyway the list is dynamic)
		System.assertEquals(pxoStd.RecordTypeId, clonedPxoStd.RecordTypeId);
		System.assertEquals(pxoStd.Platform__c, clonedPxoStd.Platform__c);
		System.assertEquals(pxoStd.Product__c, clonedPxoStd.Product__c);
		System.assertEquals(pxoStd.Approver__c, clonedPxoStd.Approver__c);
		System.assertEquals(pxoStd.Comments__c, clonedPxoStd.Comments__c);
        
        // Getting some informations for checking PxO Standard Lines clone results
        PxOStandardLine__c clonedPxoStdLine = [Select Id, RecordTypeId, MoBStrategy__c, Site__c, Type__c
                            		   		   from PxOStandardLine__c where PxOStandard__c = :clonedPxoStd.Id Limit 1];
		
		// Checking some fields (not all as anyway the list is dynamic)
		System.assertEquals(pxoStdLine.RecordTypeId, clonedPxoStdLine.RecordTypeId);
		System.assertEquals(pxoStdLine.MoBStrategy__c, clonedPxoStdLine.MoBStrategy__c);
		System.assertEquals(pxoStdLine.Site__c, clonedPxoStdLine.Site__c);
		System.assertEquals(pxoStdLine.Type__c, clonedPxoStdLine.Type__c);
    }
}