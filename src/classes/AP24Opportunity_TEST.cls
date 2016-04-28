/**
 * This class contains unit tests for validating the behavior of AP24Opportunity Apex classes
 * and triggers.
 *   ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com 
     ~ Date Created    : 17/04/2013
 */
@isTest
private class AP24Opportunity_TEST 
{
	static testMethod void AP24Opportunity_TEST() 
    {
    	Account acc = UtilityTestMethod.getAccount();
    	insert acc;
    	
    	Opportunity opp = UtilityTestMethod.getOpportunity();
        opp.AccountId = acc.Id;
        insert opp;
        
        OpportunityActor__c oppActor = UtilityTestMethod.getOpportunityActors(1).get(0);
        oppActor.Opportunity__c = opp.Id;
        insert oppActor;
        
        
        Test.startTest();
        
        delete opp;
        undelete opp;
        
        Test.stopTest();
    }
}