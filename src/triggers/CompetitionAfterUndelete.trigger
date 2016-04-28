trigger CompetitionAfterUndelete on Competition__c (after undelete) {
	
    System.debug('## >>> Competition__c after Undelete <<< run by ' + UserInfo.getName());
    
    /**************************************************************************************************************
        AP55WinLossAnalysisCompetition
        - 
    **************************************************************************************************************/
    if(PAD.canTrigger('AP55'))
    {
        AP55WinLossAnalysisCompetition.concatenateWLACompetitions(Trigger.new);
    }//bypass
    
    System.debug('## >>> Competition__c after Undelete : END <<<');
}