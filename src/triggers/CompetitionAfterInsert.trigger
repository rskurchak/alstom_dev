trigger CompetitionAfterInsert on Competition__c (after insert) {
	
    System.debug('## >>> Competition__c after Insert <<< run by ' + UserInfo.getName());
    
    /**************************************************************************************************************
        AP55WinLossAnalysisCompetition
        - 
    **************************************************************************************************************/
    if(PAD.canTrigger('AP55'))
    {
    	AP55WinLossAnalysisCompetition.concatenateWLACompetitions(Trigger.new);
    }//bypass
    
    System.debug('## >>> Competition__c after Insert : END <<<');
}