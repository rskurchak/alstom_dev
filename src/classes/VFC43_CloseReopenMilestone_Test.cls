/**
 * This class contains unit tests for validating the behavior of VFC43_CloseReopenMilestone Apex 
 * controller and VFP43_CloseReopenMilestone
 * Jawad GHOULAM ~ jawad.ghoulam@cgi.com
 * 06/09/2013
 */
@isTest
private class VFC43_CloseReopenMilestone_Test {

    static testMethod void testVFC43() {
        System.debug('## >>>>> testing class VFC43_CloseReopenMilestone START <<<<<');
        
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
        PageReference vfp43 = Page.VFP43_CloseReopenMilestone; 
        Test.setCurrentPage(vfp43);
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', mileStone.Id);
		VFC43_CloseReopenMilestone vfc43 = new VFC43_CloseReopenMilestone(new ApexPages.StandardController(mileStone));
		pagereference pgClose1 = vfc43.close();
		vfc43.oppName = '';
		pagereference pgReopen = vfc43.reopen();
		vfc43.oppName = opp.Name;
		pagereference pgClose2 = vfc43.close();
		
		mileStone.Status__c  = System.label.LBL0065;
		update mileStone;
        PageReference vfp43_1 = Page.VFP43_CloseReopenMilestone; 
        Test.setCurrentPage(vfp43_1);
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', mileStone.Id);
		VFC43_CloseReopenMilestone vfc43_1 = new VFC43_CloseReopenMilestone(new ApexPages.StandardController(mileStone));
		
		pgClose1 = vfc43_1.close();
		vfc43_1.oppName = '';
		pgReopen = vfc43_1.reopen();
		vfc43_1.oppName = opp.Name;
		pgClose2 = vfc43_1.close();
 		     
 		Test.stopTest();
        System.debug('## >>>>> testing class VFC43_CloseReopenMilestone END <<<<<');
    }
}