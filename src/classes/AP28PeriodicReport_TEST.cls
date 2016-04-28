/**
 * This class contains unit tests for validating the behavior of AP28PeriodicReport Apex Class
 * and triggers.
 *   ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com 
     ~ Date Created    : 03/07/2013
 */
@isTest
private class AP28PeriodicReport_TEST 
{
    static testMethod void AP28PeriodicReport_TEST() 
    {
        Opportunity opp = UtilityTestMethod.getOpportunity();
		insert opp;
		
		PeriodicReport__c pr = new PeriodicReport__c(Opportunity__c = opp.Id, ReportDate__c = DateTime.Now(), Name = 'My Periodic Report');
		PeriodicReport__c pr2 = new PeriodicReport__c(Opportunity__c = opp.Id, ReportDate__c = DateTime.Now()+1, Name = 'My Periodic Report 2');
		
		test.startTest();
		
		insert pr;
		insert pr2;
			
		pr.ReportDate__c = DateTime.Now()+3;
		update pr;
		delete pr;
		undelete pr;
		
		test.stopTest();
    }
}