trigger CompetitionAfterUpdate on Competition__c (after update) {
	
    System.debug('## >>> Competition__c after Update <<< run by ' + UserInfo.getName());
    
    /**************************************************************************************************************
        AP55WinLossAnalysisCompetition
        - 
    **************************************************************************************************************/
    if(PAD.canTrigger('AP55'))
    {
        List<Competition__c> ap55Competitions = new List<Competition__c>();
		for(Competition__c comp : Trigger.new) {
			if(comp.Account__c != Trigger.oldMap.get(comp.Id).Account__c
				|| comp.Competitor__c != Trigger.oldMap.get(comp.Id).Competitor__c) {
				ap55Competitions.add(comp);
			}
		}
		if(ap55Competitions.size() > 0) {
        	AP55WinLossAnalysisCompetition.concatenateWLACompetitions(ap55Competitions);
		}
    }//bypass
    
    System.debug('## >>> Competition__c after Update : END <<<');
}