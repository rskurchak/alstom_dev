/**
 * This class contains unit tests for validating the behavior of VFC45_Tender_Amount Apex controller and VFP45_Tender_Amount
 * Jawad GHOULAM ~ jawad.ghoulam@cgi.com
 * 06/09/2013
 */
@isTest
private class VFC45_Tender_Amount_Test {

    static testMethod void testVF45() {
        System.debug('## >>>>> testing class VFC45_Tender_Amount START <<<<<');
        
   		System.debug('## Create accounts ..');
        Account account = UtilityTestMethod.getAccount();
        insert account;
        
        System.debug('## Create Opportunity ..');
        Opportunity opp = UtilityTestMethod.getOpportunityWithBOID();
        opp.AccountId = account.Id;
        insert opp;
        
        Tender__c tender = UtilityTestMethod.getTender(opp.Id);
        insert tender;
        
        Milestone__c mileStone = UtilityTestMethod.getMilestone(tender.Id);
        insert mileStone;

		Amounts__c amount1 = UtilityTestMethod.getAmounts(tender.Id);
		amount1.Name = 'Base1';
		amount1.Option__c = true;
		insert amount1;
		
		Amounts__c amount2 = UtilityTestMethod.getAmounts(tender.Id);
		amount2.Name = 'Base2';
		amount2.Option__c = false;
		insert amount2;
		
    
        Test.startTest();
        PageReference vfp45_1 = Page.VFP45_Tender_Amount; 
        Test.setCurrentPage(vfp45_1);
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', amount1.Id);
		VFC45_Tender_Amount vfc45_1 = new VFC45_Tender_Amount(new ApexPages.StandardController(tender));
		String str = vfc45_1.currentDateTime;
		
        PageReference vfp45_2 = Page.VFP45_Tender_Amount; 
        Test.setCurrentPage(vfp45_2);
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', amount2.Id);
		VFC45_Tender_Amount vfc45_2 = new VFC45_Tender_Amount(new ApexPages.StandardController(tender));
 		     
 		Test.stopTest();
        System.debug('## >>>>> testing class VFC45_Tender_Amount END <<<<<');
    }
}