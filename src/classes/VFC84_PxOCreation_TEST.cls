@isTest
private class VFC84_PxOCreation_TEST
{
    static testMethod void PxOCreated_TEST()
    {
    	RecordType pxoStdRT = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'PxOStandard__c' and DeveloperName = :System.Label.LBL0312];
    	RecordType pxoRT = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'PxO__c' and DeveloperName = :System.Label.LBL0312];
    	
    	Opportunity opp = UtilityTestMethod.getOpportunity();
        insert opp;
		
		Product__c product = UtilityTestMethod.getProducts(1).get(0);
        product.Opportunity__c = opp.Id;
        Product.Platform__c = System.Label.LBL0305.split(';')[0];
        insert product;
        
		PxOStandard__c pxoStd = UtilityTestMethod.getAlstomPxOStandards(1, new List<Id>{pxoStdRT.Id}).get(0);
		pxoStd.Approver__c = UserInfo.getUserId();
		pxoStd.Product__c = 'Citadis CIS';
		pxoStd.Platform__c = 'Metro';
		pxoStd.ATRegion__c = 'Europe';
		pxoStd.SubRegion__c = 'Germany';
		pxoStd.Comments__c = 'My Comments';
		insert pxoStd;
		
		TerangaUnit__c tu = new TerangaUnit__c();
		tu.TrainsSite__c = true;
		insert tu;
		
		RecordType pxoLineStdRt = [SELECT Id FROM RecordType WHERE SObjectType = 'PxOStandardLine__c' and DeveloperName = :System.Label.LBL0312];
		PxOStandardLine__c pxoStdLine = UtilityTestMethod.getAlstomPxOStandardLines(1, new List<Id>{pxoLineStdRt.Id}, new List<Id>{pxoStd.Id}, new List<Id>{tu.Id}).get(0);
		pxoStdLine.MoBStrategy__c = 'Make';
		pxoStdLine.Type__c = 'CVS';
		insert pxoStdLine;
		
		Test.startTest();
        
        PageReference VFP84 = Page.VFP84_PxOCreation;
		Test.setCurrentPage(VFP84);
		ApexPages.currentPage().getParameters().put('oppId', opp.Id);
		ApexPages.currentPage().getParameters().put('RecordType', pxoRT.Id);
		VFC84_PxOCreation VFC84 = new VFC84_PxOCreation(new ApexPages.StandardController(new PxO__c()));
		VFC84.getPxOStandards();
		VFC84.selectedPxOId = pxoStd.Id;
        VFC84.selectPxOStandard();
            
        Test.stopTest();
        
        // Getting some informations for checking PxO Results
        PxO__c resultPxO = [Select Id, Name, RecordTypeId, Platform__c, Product__c,
							ATRegion__c, SubRegion__c, Approver__c, Comments__c
                            from PxO__c Limit 1];
		opp = [Select Id, BOID__c from Opportunity where Id = :opp.Id];
		
		System.assertEquals(pxoRT.Name + '-' + opp.BOID__c, resultPxO.Name);
		System.assertEquals(pxoRT.Id, resultPxO.RecordTypeId);
        System.assertEquals('Metro', resultPxO.Platform__c);
        System.assertEquals('Citadis CIS', resultPxO.Product__c);
        System.assertEquals('Europe', resultPxO.ATRegion__c);
        System.assertEquals('Germany', resultPxO.SubRegion__c);
        System.assertEquals(UserInfo.getUserId(), resultPxO.Approver__c);
        System.assertEquals('My Comments', resultPxO.Comments__c);
        
        // Getting some informations for checking PxO Lines Results
        PxOLine__c resultPxOLine = [Select Id, Name, RecordTypeId, PxO__c, MoBStrategy__c,
									StandardMoBStrategy__c, Site__c, StandardSite__c, Type__c
		                            from PxOLine__c Limit 1];
		                            
		RecordType pxoLineRt = [SELECT Id FROM RecordType WHERE SObjectType = 'PxOLine__c' 
								and DeveloperName = :System.Label.LBL0312];
		
		System.assertEquals(pxoLineRt.Id, resultPxOLine.RecordTypeId);
		System.assertEquals(resultPxO.Id, resultPxOLine.PxO__c);
		System.assertEquals('Make', resultPxOLine.MoBStrategy__c);
		System.assertEquals('Make', resultPxOLine.StandardMoBStrategy__c);
		System.assertEquals(tu.Id, resultPxOLine.Site__c);
		System.assertEquals(tu.Id, resultPxOLine.StandardSite__c);
		System.assertEquals('CVS', resultPxOLine.Type__c);
    }
    
    static testMethod void NoProductFound_TEST()
    {
    	RecordType pxoStdRT = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'PxOStandard__c' and DeveloperName = :System.Label.LBL0312];
    	RecordType pxoRT = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'PxO__c' and DeveloperName = :System.Label.LBL0312];
    	
    	Opportunity opp = UtilityTestMethod.getOpportunity();
        insert opp;
		
		Test.startTest();
        
        PageReference VFP84 = Page.VFP84_PxOCreation;
		Test.setCurrentPage(VFP84);
		ApexPages.currentPage().getParameters().put('oppId', opp.Id);
		ApexPages.currentPage().getParameters().put('RecordType', pxoRT.Id);
		VFC84_PxOCreation VFC84 = new VFC84_PxOCreation(new ApexPages.StandardController(new PxO__c()));
		VFC84.getPxOStandards();
            
        Test.stopTest();
        
        // Assertion that the correct warning message is displayed
        List<ApexPages.Message> message = ApexPages.getMessages();
        System.assertEquals(message.size(), 1);
        System.assertEquals(message.get(0).getDetail(), System.Label.LBL0304);
    }
    
    static testMethod void NoPxOStdForRecType_TEST()
    {
    	RecordType pxoStdRT = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'PxOStandard__c' and DeveloperName != :System.Label.LBL0312 Limit 1];
    	RecordType pxoRT = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'PxO__c' and DeveloperName = :System.Label.LBL0312];
    	
    	Opportunity opp = UtilityTestMethod.getOpportunity();
        insert opp;
        
        Product__c product = UtilityTestMethod.getProducts(1).get(0);
        product.Opportunity__c = opp.Id;
        Product.Platform__c = System.Label.LBL0305.split(';')[0];
        insert product;
		
		PxOStandard__c pxoStd = UtilityTestMethod.getAlstomPxOStandards(1, new List<Id>{pxoStdRT.Id}).get(0);
		insert pxoStd;
		
		Test.startTest();
        
        PageReference VFP84 = Page.VFP84_PxOCreation;
		Test.setCurrentPage(VFP84);
		ApexPages.currentPage().getParameters().put('oppId', opp.Id);
		ApexPages.currentPage().getParameters().put('RecordType', pxoRT.Id);
		VFC84_PxOCreation VFC84 = new VFC84_PxOCreation(new ApexPages.StandardController(new PxO__c()));
		VFC84.getPxOStandards();
            
        Test.stopTest();
        
        // Assertion that the correct warning message is displayed
        List<ApexPages.Message> message = ApexPages.getMessages();
        System.assertEquals(message.size(), 1);
        System.assertEquals(message.get(0).getDetail(), System.Label.LBL0311 + ' ' + pxoRT.DeveloperName);
    }
}