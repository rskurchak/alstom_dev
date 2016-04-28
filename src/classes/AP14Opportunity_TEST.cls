/**
 * This class contains unit tests for validating the behavior of AP14Opportunity Apex classes
 * and triggers.
 *   ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com 
     ~ Date Created    : 06/02/2013
 */
@isTest
private class AP14Opportunity_TEST 
{
    static testMethod void AP14Opportunity_TEST() 
    {
		Opportunity opp = UtilityTestMethod.getOpportunity();
    	opp.CloseDate = Date.today();
    	opp.amount = 10000;
    					
    	Test.startTest();
    	
    	insert opp;
    	opp.CurrencyIsoCode = 'USD';
    	update opp;
    	opp.AdjustedSellingPrice__c = 10000;
    	update opp;
    	
    	Test.StopTest();
    }
}