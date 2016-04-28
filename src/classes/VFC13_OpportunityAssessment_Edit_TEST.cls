/**
 * This class contains unit tests for validating the behavior of VFC13_OpportunityAssessment_Edit Apex classes 
 	and VFP13_OpportunityAssessment_Edit
 * Mohamed EL MOUSSAOUI ~ mohamed.el-moussaoui@axoa.fr 12/07/2012
 */
@isTest
private class VFC13_OpportunityAssessment_Edit_TEST
{
    static testMethod void testVFC13() 
    {
    	System.debug('## >>>>> testing class VFC13_OpportunityAssessment_Edit START <<<<<');
        
        // data testing
      	System.debug('## Create Account ..');
        Account account = UtilityTestMethod.getAccount();
		insert account;
       
        System.debug('## Create Opportunity');
        Opportunity opp = UtilityTestMethod.getOpportunity();
        opp.AccountId = account.Id;
        insert opp;
      
		// apex class and visualforce page testing
        Test.startTest();
      
        PageReference vfp13 = Page.VFP13_OpportunityAssessment_Edit; 
        vfp13.getParameters().put('Id', opp.Id);
        Test.setCurrentPage(vfp13);
        List<OpportunityAssessment__c> oppAssessments = [SELECT Id FROM OpportunityAssessment__c WHERE Opportunity__c = :opp.Id];
        
		VFC13_OpportunityAssessment_Edit vfc13 = new VFC13_OpportunityAssessment_Edit(new ApexPages.StandardSetController(oppAssessments));
 		vfc13.init();
      	
      	// restart the test without an Opportunity Id to fire the exception
      	vfp13.getParameters().put('Id', null);
        Test.setCurrentPage(vfp13);
      	oppAssessments.clear();
      	VFC13_OpportunityAssessment_Edit vfc13_b = new VFC13_OpportunityAssessment_Edit(new ApexPages.StandardSetController(oppAssessments));
      	vfc13_b.init();
		Test.stopTest();
		
        System.debug('## >>>>> testing class VFC13_OpportunityAssessment_Edit END <<<<<');
    }
}