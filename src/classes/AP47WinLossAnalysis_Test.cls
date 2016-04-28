/**
 AP47WinLossAnalysis_Test 
    ~ Author            : jawad.ghoulam@cgi.com
    ~ Modification Date : 01/10/2013
    ~ Description       : This class contains unit tests for validating the behavior of Apex classes.
 */
@isTest
private class AP47WinLossAnalysis_Test {

    static testMethod void myUnitTest() {
        
        Account account = UtilityTestMethod.getAccount();
        insert account;
        
        System.debug('## Create Opportunity ..');
        Opportunity opp = UtilityTestMethod.getOpportunity();
        opp.AccountId = account.Id;
        insert opp;
        
        List<WinLossAnalysis__c> winLossAnalysis1 = new List<WinLossAnalysis__c>();
        //List<WinLossAnalysis__c> winLossAnalysis2 = new List<WinLossAnalysis__c>();
        winLossAnalysis1.add(new WinLossAnalysis__c(Opportunity__c=opp.Id));
        insert winLossAnalysis1;
        
        update winLossAnalysis1;
        delete winLossAnalysis1;
        undelete winLossAnalysis1;
        
        //winLossAnalysis2.add(new WinLossAnalysis__c(Opportunity__c=opp2.Id));
        //insert winLossAnalysis2;
        //AP47WinLossAnalysis.UpdateTECHUniqueWinLossAnalysis(UtilityTestMethod.getListTenders());
    }
}