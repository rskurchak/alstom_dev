trigger WinLossAnalysisAfterInsert on WinLossAnalysis__c (after insert) {
	System.debug('## >>> WinLossAnalysis after insert <<< run by ' + UserInfo.getName());
    /********************************************************************************************************************************************
		Create child Competition records related to WLA
		Copying information from Opportunity Actor records related to the same Opportunity Of WLA.
     ********************************************************************************************************************************************/
    if (PAD.canTrigger('AP55'))
    {
    	
        List<WinLossAnalysis__c> ap55ListWinLossAnalysis = new List<WinLossAnalysis__c>();
        for(WinLossAnalysis__c winLossAnalysis : Trigger.new) 
            if(winLossAnalysis.Opportunity__c != null) 
                ap55ListWinLossAnalysis.add(winLossAnalysis);

        if(ap55ListWinLossAnalysis.size() > 0)
            AP55WinLossAnalysisCompetition.CreateWLACompetitionChildFromOppActor(ap55ListWinLossAnalysis);
        
    }
    
    /********************************************************************************************************************************************
		When a Win-Loss Analysis record is created, Create an Evaluation Criteria child record for each value of picklist EvaluationCriterion__c.
     ********************************************************************************************************************************************/
    if (PAD.canTrigger('AP56'))
    {
    	
        List<WinLossAnalysis__c> ap56ListWinLossAnalysis = new List<WinLossAnalysis__c>();
        for(WinLossAnalysis__c winLossAnalysis : Trigger.new) 
            if(winLossAnalysis.Opportunity__c != null) 
                ap56ListWinLossAnalysis.add(winLossAnalysis);

        if(ap56ListWinLossAnalysis.size() > 0)
            AP56WinLossAnalysisEvalCriterion.CreateWLAEvaluationCriterionChild(ap56ListWinLossAnalysis);
        
    }
    System.debug('## >>> WinLossAnalysis after insert : END <<<');
}