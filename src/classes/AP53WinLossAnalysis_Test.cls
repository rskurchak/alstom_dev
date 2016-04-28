/**
 AP53WinLossAnalysis_Test 
    ~ Author            : jawad.ghoulam@cgi.com
    ~ Modification Date : 18/10/2013
    ~ Description       : This class contains unit tests for validating the behavior of AP53WinLossAnalysis Apex class.
 */
@isTest
private class AP53WinLossAnalysis_Test {

    static testMethod void AP53WinLossAnalysis_Test() {
        Account account = UtilityTestMethod.getAccount();
        insert account;
        
        System.debug('## Create Opportunity ..');
        Opportunity opp = UtilityTestMethod.getOpportunity();
        opp.AccountId = account.Id;
        insert opp;
        
    	List<WinLossAnalysis__c> winLossAnalysis = new List<WinLossAnalysis__c>();
        winLossAnalysis.add(new WinLossAnalysis__c(Opportunity__c=opp.Id));
        insert winLossAnalysis;
    }
}