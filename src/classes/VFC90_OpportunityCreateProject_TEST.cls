/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *   ~ Author          : Ali BEN AISSA ~ ali.ben.aissa@cgi.com
     ~ Date Created    : 10/07/2015
 */
@isTest
private class VFC90_OpportunityCreateProject_TEST {

    static testMethod void VFC90_OpportunityCreateProject_TEST() {
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
        
        PageReference VFP90 = Page.VFP90_OpportunityCreateProject; 
        Test.setCurrentPage(VFP90);
        ApexPages.currentPage().getParameters().put('Id', opp.Id);
        VFC90_OpportunityCreateProject vfc90 = new VFC90_OpportunityCreateProject();
        vfc90.checkPermission();
        Test.stopTest();
    }
}