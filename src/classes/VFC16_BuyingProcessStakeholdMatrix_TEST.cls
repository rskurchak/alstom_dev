/*
	VisualForce Test Controller for VCP16_BuyingProcessStakeholdersMatrix
    ~ Author          : Damian HERCUN ~ damian.hercun@axoa.fr 
    ~ Date Created    : 24/07/2012
*/
@isTest
private class VFC16_BuyingProcessStakeholdMatrix_TEST {
	static testMethod void testVFC16() 
    {
    	System.debug('## >>>>> testing class VFC16_VFC16_BuyingProcessStakeholder START <<<<<');
    	
    	System.debug('Create a account');
    	Account account = UtilityTestMethod.getAccount();
    	insert account;
    	
    	System.debug('Create a opportunity');
    	Opportunity opportunity = UtilityTestMethod.getOpportunity();
    	opportunity.AccountId = account.Id;
    	insert opportunity;
    	
    	System.debug('Create a BuyingProcessStakeholders');
    	BuyingProcessStakeholder__c bps1 = UtilityTestMethod.getBuyingProcessStakeholder();
    	bps1.Opportunity__c = opportunity.id;
    	insert bps1;
    	
    	BuyingProcessStakeholder__c bps2 = UtilityTestMethod.getBuyingProcessStakeholder();
    	bps2.Opportunity__c = opportunity.id;
    	insert bps2;
    	
    	Test.startTest();
    	
    	//set page parameters
    	PageReference vfp16 = Page.VFP16_BuyingProcessStakeholdersMatrix; 
    	vfp16.getParameters().put('oppId', opportunity.Id);
        Test.setCurrentPage(vfp16);
        
        //set controller
        VFC16_BuyingProcessStakeholdersMatrix vfc16 = new VFC16_BuyingProcessStakeholdersMatrix();
        // retreive data
        System.debug('allBps : ' + vfc16.allBps);
        System.debug('opp : ' + vfc16.opp);
        
    	Test.stopTest();
    	
    	System.debug('## >>>>> testing class VFC16_BuyingProcessStakeholder END <<<<<');
    }
}