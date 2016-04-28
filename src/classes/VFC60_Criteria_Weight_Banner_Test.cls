/**
 * This class contains unit tests for validating the behavior of VFP60_Criteria_Weight_Warning_Banner Apex controller and VFC60_Criteria_Weight_Warning_Banner
 * Christophe AVERSENG ~ christophe.averseng@sfr.fr
 * 21/11/2013
 */
@isTest
private class VFC60_Criteria_Weight_Banner_Test {

    static testMethod void testVFC60() {
        System.debug('## >>>>> testing class VFC60_Criteria_Weight_Banner START <<<<<');
        
       System.debug('## Create accounts ..');
        Account account = UtilityTestMethod.getAccount();
        insert account;
        
        System.debug('## Create Opportunity ..');
        Opportunity opp = UtilityTestMethod.getOpportunity();
        opp.AccountId = account.Id;
        insert opp;
    
        system.debug('## Create Win Loss Analysis...');
        winLossAnalysis__c wla = UtilityTestMethod.getWinLossAnalysis();
        wla.Opportunity__c = opp.Id;
        insert wla;
        
        Test.startTest();
        PageReference vfp60 = Page.VFP60_Criteria_Weight_Banner; 
        Test.setCurrentPage(vfp60);
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('Id', wla.Id);
        VFC60_Criteria_Weight_Banner vfc60 = new VFC60_Criteria_Weight_Banner(new ApexPages.StandardController(wla));

        Test.stopTest();
        System.debug('## >>>>> testing class VFC60_Criteria_Weight_Banner END <<<<<');
    }
}