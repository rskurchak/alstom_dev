/*
  VisualForce Test Controller for VCP18_Opportunity_Clone
    ~ Author          : Damian HERCUN ~ damian.hercun@axoa.fr 
    ~ Date Created    : 27/07/2012
*/
@isTest
private class VFC18_Opportunity_Clone_TEST {

    static testMethod void testVFC18() {
      System.debug('## >>>>> testing class VFC18_Opportunity_Clone START <<<<<');
      
      System.debug('Create a Account');
      Account account = UtilityTestMethod.getAccount();
      insert account;
      
      System.debug('Create a Opportunity');
      Opportunity opportunity = UtilityTestMethod.getOpportunity();
      opportunity.AccountId = account.Id;
      insert opportunity;

      System.Debug('Create the associated Product');
      Product__c product = UtilityTestMethod.getProducts(1).get(0);
      product.Leading__c = true;
      product.Opportunity__c = opportunity.Id;
      insert product;
      
      System.Debug('Create the associated Find Plan');
      OpportunityAssessment__c findPlan = UtilityTestMethod.getOpportunityAssessements(1).get(0);
      findPlan.Opportunity__c = opportunity.Id;
      insert findPlan;

    /* TEST START */
	  Test.startTest();
	  PageReference vfp18 = Page.VFP18_Opportunity_Clone; 
      Test.setCurrentPage(vfp18);
      VFC18_Opportunity_Clone vfc18 = new VFC18_Opportunity_Clone(new ApexPages.StandardController(opportunity));
	// we fix the previous bug
	  vfc18.childObjName = 'Product__c';
	// and run again
	  vfc18.doClone();
	  vfc18.CancelClone();
  
	  Test.stopTest();
  
	  System.debug('## >>>>> testing class VFC18_Opportunity_Clone END <<<<<');
    }
}