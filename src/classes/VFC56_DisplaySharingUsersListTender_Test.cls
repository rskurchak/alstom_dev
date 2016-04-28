/**
 * This class contains unit tests for validating the behavior of VFC56_DisplaySharingUsersListOfTender Apex Class.
 *   ~ Author          : Jawad GHOULAM ~ jawad.ghoulam@cgi.com
     ~ Date Created    : 14/11/2013
 */
@isTest
private class VFC56_DisplaySharingUsersListTender_Test {

    static testMethod void VFC56_DisplaySharingUsersListTender_Test() {
         // data testing
        System.debug('## Create Account ..');
        Account account = UtilityTestMethod.getAccount();
        insert account;
       
        System.debug('## Create Opportunity');
        Opportunity opp = UtilityTestMethod.getOpportunityWithBOID();
        opp.ATRegion__c = 'France';
        opp.AccountId = account.Id;
        insert opp;
        
        Tender__c tender = UtilityTestMethod.getTender(opp.Id);
        insert tender;
        
        Test.startTest();
        
        PageReference VFP56 = Page.VFP56_DisplaySharingUsersListOfTender; 
        Test.setCurrentPage(VFP56);
        ApexPages.currentPage().getParameters().put('Id', tender.Id);
        VFC56_DisplaySharingUsersListOfTender vfc56 = new VFC56_DisplaySharingUsersListOfTender(new ApexPages.StandardController(tender));
        
        Test.stopTest();
    }
}