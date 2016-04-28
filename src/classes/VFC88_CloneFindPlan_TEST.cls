@isTest
public class VFC88_CloneFindPlan_TEST 
{
    static testMethod void VFC88_CloneFindPlan_TEST()
    {
        System.debug('Create a Account');
      	Account account = UtilityTestMethod.getAccount();
      	insert account;
        
        System.debug('Create a Opportunity');
      	Opportunity opportunity = UtilityTestMethod.getOpportunity();
      	opportunity.AccountId = account.Id;
      	insert opportunity;
        
        System.Debug('Create the associated Find Plan');
      	OpportunityAssessment__c findPlan = UtilityTestMethod.getOpportunityAssessements(1).get(0);
      	findPlan.Opportunity__c = opportunity.Id;
      	insert findPlan;
        
        Test.startTest();
	  	PageReference VFP88 = Page.VFP88_CloneFindPlan; 
      	Test.setCurrentPage(VFP88);
        VFP88.getParameters().put('pId', opportunity.Id);
      	VFC88_CloneFindPlan VFC88 = new VFC88_CloneFindPlan(new ApexPages.StandardController(findPlan));
		
	  	VFC88.cloneFindPlan();
        VFC88.cancel();
        
        Test.stopTest();           
    }
}