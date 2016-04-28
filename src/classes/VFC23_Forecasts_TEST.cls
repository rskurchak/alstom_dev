/**
 * This class contains unit tests for validating the behavior of VFC23_Forecasts Apex classes
 * and triggers.
 *   ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com 
     ~ Date Created    : 06/02/2013
 */
@isTest
private class VFC23_Forecasts_TEST 
{
    static testMethod void VFC23_Forecasts_TEST() 
    {
        Forecast_Snapshot__c fs = new Forecast_Snapshot__c(Snapshot_Start_Quarter__c = 'FQ1 / FY 12-13', Current__c = true);
        insert fs;
        
        Opportunity opp = UtilityTestMethod.getOpportunity();
        opp.AdjustedForecastCategory__c = System.label.LBL0039;
        opp.AdjustedSellingPrice__c = 10000;
        insert opp;
        
        Opportunity opp2 = UtilityTestMethod.getOpportunity();
        insert opp2;
        
        Opportunity_Snapshot__c os = new Opportunity_Snapshot__c(Forecast_Snapshot__c = fs.Id, Opportunity__c = opp.Id, AdjustedSellingPrice__c = 10000, FiscalPeriod__c = 'FQ1 / FY 12-13', AdjustedForecastCategory__c = System.label.LBL0039);
        insert os;
        
        
        Test.startTest();
        
        PageReference vfp23 = Page.VFP23_Forecasts; 
        Test.setCurrentPage(vfp23);
        
        VFC23_Forecasts vfc23 = new VFC23_Forecasts();
        vfc23.refreshForecastList();
        vfc23.viewOpportunities();
        vfc23.sortOpportunities();
        vfc23.editOpportunities();
        vfc23.cancelEdit();
        vfc23.saveOpportunities();
        vfc23.exportData();
        vfc23.getOpportunitiesFullList();
        vfc23.copyEditableFields(opp, opp2);
        vfc23.getOppQueryRecordLimit();
        vfc23.setNumberOfRows();
        vfc23.next();
        vfc23.previous();
        
        Test.stopTest();
    }
    
    static testMethod void VFC23_Forecasts_TEST2() 
    {
        Forecast_Snapshot__c fs = new Forecast_Snapshot__c(Snapshot_Start_Quarter__c = 'FQ1 / FY 12-13', Current__c = true);
        insert fs;
        
        Opportunity opp = UtilityTestMethod.getOpportunity();
        opp.LeadingProductLine__c = 'Information Solutions';
        insert opp;
        
        Opportunity_Snapshot__c os = new Opportunity_Snapshot__c(Forecast_Snapshot__c = fs.Id, Opportunity__c = opp.Id, LeadingProductLine__c = 'Information Solutions', AdjustedForecastCategory__c = System.label.LBL0039);
        insert os;
        
        
        Test.startTest();
        
        PageReference vfp23 = Page.VFP23_Forecasts; 
        Test.setCurrentPage(vfp23);
        
        VFC23_Forecasts vfc23 = new VFC23_Forecasts();
        vfc23.oppParams.LeadingProductLine__c = 'Information Solutions';
        vfc23.refreshForecastList();
        
        Test.stopTest();
    }
    
    static testMethod void VFC23_Forecasts_TEST3() 
    {
        Forecast_Snapshot__c fs = new Forecast_Snapshot__c(Snapshot_Start_Quarter__c = 'FQ1 / FY 12-13', Current__c = true);
        insert fs;
        
        Opportunity opp = UtilityTestMethod.getOpportunity();
        opp.LeadingProductLine__c = 'Information Solutions';
        opp.Platform__c = 'Urban';
        insert opp;
        
        Opportunity_Snapshot__c os = new Opportunity_Snapshot__c(Forecast_Snapshot__c = fs.Id, Opportunity__c = opp.Id, LeadingProductLine__c = 'Information Solutions', Platform__c = 'Urban', AdjustedForecastCategory__c = System.label.LBL0039);
        insert os;
        
        
        Test.startTest();
        
        PageReference vfp23 = Page.VFP23_Forecasts; 
        Test.setCurrentPage(vfp23);
        
        VFC23_Forecasts vfc23 = new VFC23_Forecasts();
        vfc23.oppParams.LeadingProductLine__c = 'Information Solutions';
        vfc23.oppParams.Platform__c = 'Urban';
        vfc23.refreshForecastList();
        
        Test.stopTest();
    }   
}