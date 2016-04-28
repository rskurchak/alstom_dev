/*
 AP53WinLossAnalysis 
    ~ Author            : jawad.ghoulam@cgi.com
    ~ Modification Date : 18/10/2013
    ~ Description       : Set Qualitative return on Experience Rich text field on Win-Loss Analysis from Email Template.
     ~ Triggers         : WinLossAnalysisBeforeInsert
     ~ Feature Id       : FEAT#0447 
     CR-0847: Not used anymore
*/
public without sharing class AP53WinLossAnalysis {
    public static void SetQualitativeReturnOnExperienceRichText(List<WinLossAnalysis__c> lstWinLossSub) {
        
        // Getting needed Template informations on EmailTemplate
        EmailTemplate emailTemplate = [select Id, Body, HtmlValue from EmailTemplate where DeveloperName  =: System.label.LBL0119 LIMIT 1];
        
        for(WinLossAnalysis__c winLossSub : lstWinLossSub) {
            // Set Qualitative Return On Experience field of WinLossAnalysis from HTML value of EmailTemplate
            winLossSub.QualitativeReturnOnExperience__c = emailTemplate.HtmlValue;
        }
    }
}