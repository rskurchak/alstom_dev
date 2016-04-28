/*********************************************************************
 SANITY CHECK Feb. 2014 - CODE MODIFICATION REQUIRED
 Modify code following instructions below.
 Remove this box once modifications done.
*********************************************************************/

/*********************************************************************
 SANITY CHECK INSTRUCTION: 
   Not bulkified : SOQL query in loop
 Remove this box once modification done.
*********************************************************************/
/*
 AP53WinLossAnalysis 
    ~ Author            : jawad.ghoulam@cgi.com
    ~ Modification Date : 23/10/2013
    ~ Description       : Initialize WLA Currency from parent Opportunity currency
     ~ Triggers         : WinLossAnalysisBeforeInsert
     ~ Feature Id       : FEAT#0451 
*/
public with sharing class AP54WinLossAnalysis {   
    public static void SetWLACurrencyFromOpp(List<WinLossAnalysis__c> lstWinLossSub) {
        for(WinLossAnalysis__c winLossSub : lstWinLossSub) {
            // Getting CurrencyIsoCode from Opportunity
            Opportunity opp = [SELECT Id, CurrencyIsoCode,BOID__c FROM Opportunity WHERE Id =: winLossSub.Opportunity__c];
            
            // Set CurrencyIsoCode of WinLossAnalysis from CurrencyIsoCode of Opportunity
            winLossSub.CurrencyIsoCode = opp.CurrencyIsoCode;
            
            // FEAT#0621: initialize record name
            winLossSub.Name = 'WLA_' + opp.BOID__c;
        }
    }
}