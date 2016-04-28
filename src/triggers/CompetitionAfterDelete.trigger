trigger CompetitionAfterDelete on Competition__c (after delete) {
	
    System.debug('## >>> Competition__c after Delete <<< run by ' + UserInfo.getName());
    
    /**************************************************************************************************************
        AP55WinLossAnalysisCompetition
        - 
    **************************************************************************************************************/
    if(PAD.canTrigger('AP55'))
    {
        AP55WinLossAnalysisCompetition.concatenateWLACompetitions(Trigger.old);
    }//bypass
    
    System.debug('## >>> Competition__c after Delete : END <<<');
}