/*********************************************************************
 SANITY CHECK Feb. 2014 - CODE MODIFICATION REQUIRED
 Modify code following instructions below.
 Remove this box once modifications done.
*********************************************************************/

/*********************************************************************
 SANITY CHECK INSTRUCTION: 
   1. Not bulkified : SOQL query in loop
   2. Checks uniqueness of win/loss opportunity -> could be replaced by standard (unique field)
 Remove this box once modification done.
*********************************************************************/
/*
 AP47WinLossAnalysis 
    ~ Author            : jawad.ghoulam@cgi.com
    ~ Modification Date : 01/10/2013
    ~ Description       : Check if there is no more than one child record of WLA per Opportunity
                          Display a message error in case of a second WLA record on an Opportunity. 
    ~ Triggers          : WinLossAnalysiBeforeInsert, WinLossAnalysiBeforeUpdate, WinLossAnalysiAfterUndelete
    ~ Feature Id        : FEAT#0383 
*/
public with sharing class AP47WinLossAnalysis {
    public static void CheckUniquenessOfWinLossAnalysis(List<WinLossAnalysis__c> lstWinLossAnalysis) {
        for(WinLossAnalysis__c winLossAnalysis : lstWinLossAnalysis)
        {
            List<WinLossAnalysis__c> lWinLossAnalysis = new List<WinLossAnalysis__c>();
            lWinLossAnalysis = [SELECT Id FROM WinLossAnalysis__c WHERE Opportunity__c =: winLossAnalysis.Opportunity__c and Id !=: winLossAnalysis.Id];
            if (lWinLossAnalysis.size() != 0) {
                winLossAnalysis.addError(System.Label.LBL0081);
            }
        }
    
    }
}