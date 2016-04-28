trigger WinLossAnalysisBeforeUpdate on WinLossAnalysis__c (before update) {
    System.debug('## >>> WinLossAnalysis after insert <<< run by ' + UserInfo.getName());

    /*************************************************************************************************
		Win/Loss Analysis (WLA) object is a child of Opportunity (Master-Detail relationship).
		There must not be more than one child record of WLA per Opportunity.
		A trigger (or anything else) must prevent creation of a second WLA record on an Opportunity. 
		An error message must be raised: "Win/Loss Analysis is already existing for this opportunity."
     **************************************************************************************************/
    if(PAD.canTrigger('AP47'))
    {
        List<WinLossAnalysis__c> ap47ListWinLossAnalysis = new List<WinLossAnalysis__c>();
        for(WinLossAnalysis__c winLossAnalysis : Trigger.new) 
            if(winLossAnalysis.Id != Trigger.oldMap.get(winLossAnalysis.Id).Id || winLossAnalysis.Opportunity__c != Trigger.oldMap.get(winLossAnalysis.Id).Opportunity__c) {
                ap47ListWinLossAnalysis.add(winLossAnalysis);
            }

        if(ap47ListWinLossAnalysis.size() > 0){
            AP47WinLossAnalysis.CheckUniquenessOfWinLossAnalysis(ap47ListWinLossAnalysis);
        }
    }
    
    System.debug('## >>> WinLossAnalysis after insert : END <<<');
}