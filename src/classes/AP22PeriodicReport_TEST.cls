/**
 * This class contains unit tests for validating the behavior of AP22PeriodicReport Apex classes
 * and triggers.
 *   ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com
     ~ Date Created    : 21/03/2013
 */
@isTest
private class AP22PeriodicReport_TEST 
{
    static testMethod void AP22PeriodicReport_TEST() 
    {
    	Opportunity opp = UtilityTestMethod.getOpportunity();
		insert opp;
		
		PeriodicReport__c pr = new PeriodicReport__c(Opportunity__c = opp.Id, Name = 'My Periodic Report');
		
		
		test.startTest();
		
		insert pr;
		pr.IssuesRisks__c = 'No risk.';
		update pr;
		
		test.stopTest();
	}
}