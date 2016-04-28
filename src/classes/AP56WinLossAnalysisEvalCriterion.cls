/*
 AP56WinLossAnalysisEvalCriterion 
    ~ Author            : jawad.ghoulam@cgi.com
    ~ Modification Date : 24/10/2013
    ~ Description       : Looping on the Evaluation Criteria picklist LOV and create an Evaluation Criteria child record for each value of picklist EvaluationCriterion__c.
     ~ Triggers         : WinLossAnalysisAfterInsert
     ~ Feature Id       : FEAT#0448 
*/
public with sharing class AP56WinLossAnalysisEvalCriterion {
    public static void CreateWLAEvaluationCriterionChild(List<WinLossAnalysis__c> lstWinLoss) {
    	
    	// contains Evaluation criterion to insert
        List<EvaluationCriterion__c> listEvaluationCriterionToInsert = new List<EvaluationCriterion__c>();
        for(WinLossAnalysis__c winLoss : lstWinLoss) {
        	
           // Get the field describe result for the Evaluation Criterion picklist on the Evaluation Criterion object
           Schema.DescribeFieldResult fieldResult = EvaluationCriterion__c.EvaluationCriterion__c.getDescribe();
           
           // Get the list of picklist values for Evaluation Criterion picklist.
           List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                
           for( Schema.PicklistEntry f : ple)
           {
           		// Add a new Evaluation Criterion record for each value of the picklist
                listEvaluationCriterionToInsert.add(new EvaluationCriterion__c(WinLossAnalysis__c = winLoss.Id, EvaluationCriterion__c = f.getValue()));
           } 
            
        }
        // Insert all Evaluation Criterion records added
        insert listEvaluationCriterionToInsert;
    }
}