/**
 * This class contains unit tests for validating the behavior of VFC68_OpportunityCreateProject Apex Class
 * and triggers.
 *   ~ Author          : Christophe AVERSENG
     ~ Date Created    : 06/05/2014
 */
@isTest
private class VFC68_OpportunityCreateProject_TEST {

    static testMethod void myUnitTest() {
         // data testing
        System.debug('## Create Account ..');
        Account account = UtilityTestMethod.getAccount();
        insert account;
       
        System.debug('## Create Opportunity');
        Opportunity opp = UtilityTestMethod.getOpportunityWithBOID();
        opp.ATRegion__c = 'France'; // ?
        opp.AccountId = account.Id;
        opp.StageName = System.Label.LBL0136;
        insert opp;
        
        Test.startTest();
        
        PageReference VFP68 = Page.VFP68_OpportunityCreateProject; 
        Test.setCurrentPage(VFP68);
        ApexPages.currentPage().getParameters().put('Id', opp.Id);
        VFC68_OpportunityCreateProject vfc68 = new VFC68_OpportunityCreateProject(new ApexPages.StandardController(opp));
        
        Test.stopTest();
    }
}