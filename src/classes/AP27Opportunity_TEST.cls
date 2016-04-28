/**
 * This class contains unit tests for validating the behavior of AP27Opportunity Apex Class
 * and triggers.
 *   ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com 
     ~ Date Created    : 06/06/2013
 */
@isTest
private class AP27Opportunity_TEST 
{
    static testMethod void AP27Opportunity_TEST() 
    {
    	Opportunity opp = UtilityTestMethod.getOpportunity();
    	
    	
    	Test.startTest();
    	
    	insert opp;
    	
    	opp.CloseDate = System.today() + 1;
    	update opp;
    	
    	opp.ForecastedFiscalPeriod__c = 'FQ4 / FY 2021-2022';
    	update opp;
    	
    	Test.StopTest();
    }
}