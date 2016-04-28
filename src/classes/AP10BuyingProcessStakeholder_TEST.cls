/**
 * This class contains unit tests for validating the behavior of AP10BuyingProcessStakeholder Apex classes
 * and triggers.
 *   ~ Author          : Damian HERCUN ~ damian.hercun@axoa.fr 
     ~ Date Created    : 17/07/2012
 */
@isTest
public with sharing class AP10BuyingProcessStakeholder_TEST {
	static testMethod void testAP10()
	{
		System.debug('## >>>>> testing class AP10BuyingProcessStakeholder START <<<<<');
		
		 // data testing
      	System.debug('## Create Account ..');
        Account account = UtilityTestMethod.getAccount();
		insert account;
		
        System.debug('## Create Opportunity');
        Opportunity opp = UtilityTestMethod.getOpportunity();
        opp.ATRegion__c = 'France';
        opp.AccountId = account.Id;
        insert opp;
		
		System.debug('## Create Contact');
		Contact cont =  UtilityTestMethod.getContacts(1).get(0);
		insert cont;
		
		BuyingProcessStakeholder__c bps = new BuyingProcessStakeholder__c(Opportunity__c = opp.id, ContactName__c = cont.Id);
		
		Test.startTest();
		insert bps;
		Test.stopTest();
		
		System.debug('## >>>>> testing class AP10BuyingProcessStakeholder END <<<<<'); 
	}
}