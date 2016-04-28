/*
 * This class contains unit tests for validating the behavior of VFC30_OpportunityLastPeriodicReport Apex Class
 * and triggers.
 *   ~ Author           : Fabien TAILLON ~ fabien.taillon@cgi.com
     ~ Date Created    	: 08/07/2013
*/
@isTest
private class VFC30_OpportunityLastPeriodicReport_TEST 
{
    static testMethod void VFC30_OpportunityLastPeriodicReportWithPR_TEST() 
    {
        Account account = UtilityTestMethod.getAccounts(1).get(0);
        insert account;
		
        Opportunity opp = UtilityTestMethod.getOpportunities(1).get(0);
        opp.AccountId = account.Id;
        insert opp;
        
        PeriodicReport__c pr = new PeriodicReport__c(Opportunity__c = opp.Id);
        insert pr;
        
        PageReference VFP30 = Page.VFP30_OpportunityLastPeriodicReport; 
        Test.setCurrentPage(VFP30);
        ApexPages.currentPage().getParameters().put('Id', opp.Id);
        
        
        Test.startTest();
        
        VFC30_OpportunityLastPeriodicReport VFC30 = new VFC30_OpportunityLastPeriodicReport(new ApexPages.StandardController(opp));

        Test.stopTest();
    }
    
    static testMethod void VFC30_OpportunityLastPeriodicReportNoPR_TEST() 
    {
        Account account = UtilityTestMethod.getAccounts(1).get(0);
        insert account;
		
        Opportunity opp = UtilityTestMethod.getOpportunities(1).get(0);
        opp.AccountId = account.Id;
        insert opp;
        
        PageReference VFP30 = Page.VFP30_OpportunityLastPeriodicReport; 
        Test.setCurrentPage(VFP30);
        ApexPages.currentPage().getParameters().put('Id', opp.Id);
        
        
        Test.startTest();
        
        VFC30_OpportunityLastPeriodicReport VFC30 = new VFC30_OpportunityLastPeriodicReport(new ApexPages.StandardController(opp));
        
        Test.stopTest();
    }
}