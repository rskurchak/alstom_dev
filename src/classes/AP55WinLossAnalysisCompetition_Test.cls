/**
 AP55WinLossAnalysisCompetition_Test 
    ~ Author            : jawad.ghoulam@cgi.com
    ~ Modification Date : 24/10/2013
    ~ Description       : This class contains unit tests for validating the behavior of AP55WinLossAnalysisCompetition Apex class.
    ~ Author            : tiantian.he@cgi.com
    ~ Modification Date : 19/02/2015
    ~ Description       : Add ConcatenateWLACompetitionsTest.
 */
@isTest
private class AP55WinLossAnalysisCompetition_Test {

    static testMethod void AP55WinLossAnalysisCompetition_Test() {
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
    
    static testMethod void ConcatenateWLACompetitionsTest() {
    	Test.startTest();
    	
    	// prepare test data
        Account account = UtilityTestMethod.getAccount();
        insert account;
        Competitor__c competitor = UtilityTestMethod.getCompetitor();
        insert competitor;
        Opportunity oppty = UtilityTestMethod.getOpportunity();
        insert oppty;
        
        WinLossAnalysis__c winLossAnalysis = UtilityTestMethod.getWinLossAnalysis();
        winLossAnalysis.Opportunity__c = oppty.Id;
        insert winLossAnalysis;
        // insert 2 competitions of 2 record types to the test WinLossAnalysis__c
        List<Competition__c> listCompetitions = new List<Competition__c>();
        Competition__c competition1 = new Competition__c(
        				Account__c = account.Id,
        				RecordTypeId = UtilityTestMethod.competitionRecTypes.get('Account'),
        				WinLossAnalysis__c = winLossAnalysis.Id);
        listCompetitions.add(competition1);
    	Competition__c competition2 = new Competition__c(
        				Competitor__c = competitor.Id,
        				RecordTypeId = UtilityTestMethod.competitionRecTypes.get('Competitor'),
        				WinLossAnalysis__c = winLossAnalysis.Id);
        listCompetitions.add(competition2);
        insert listCompetitions;
        
        // test the concatenation of competitions
        AP55WinLossAnalysisCompetition.concatenateWLACompetitions(listCompetitions);
        
        // assert competition name concatenation result
        WinLossAnalysis__c updatedWinLossAnalysis = [SELECT Id, TECH_Competitions__c FROM WinLossAnalysis__c WHERE Id = :winLossAnalysis.Id LIMIT 1];
        try {
        	System.assertEquals(';' + account.Name + ';' + competitor.Name + ';', updatedWinLossAnalysis.TECH_Competitions__c);
        } catch (AssertException e) {
        	System.assertEquals(';' + competitor.Name + ';' + account.Name + ';', updatedWinLossAnalysis.TECH_Competitions__c);
        }
        
        // trigger code coverage
        Competitor__c competitor2 = UtilityTestMethod.getCompetitor();
        insert competitor2;
        competition2.Competitor__c = competitor2.Id;
        update competition2;
        delete competition2;
        undelete competition2;
        
    	Test.stopTest();
    }
}