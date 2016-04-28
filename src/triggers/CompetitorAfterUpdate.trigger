trigger CompetitorAfterUpdate on Competitor__c (after update) 
{
    System.debug('## >>> Competitor__c after Update <<< run by ' + UserInfo.getName());
    
    /**************************************************************************************************************
        AP06ConfidentialInformation
        - 
    **************************************************************************************************************/
    if(PAD.canTrigger('AP06'))
    {
        Set<Id> ap06Competitors = new Set<Id>(); 
        for(Competitor__c comp : Trigger.new)
            if(comp.OwnerId != Trigger.oldMap.get(comp.Id).OwnerId)
                ap06Competitors.add(comp.Id);
               
		if(ap06Competitors.size() > 0)
			AP06ConfidentialInformation.updateParentSharing(ap06Competitors);
    }//bypass   
    System.debug('## >>> Competitor__c after Update : END <<<');
}