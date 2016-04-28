trigger CompetitorContactAfterUpdate on CompetitorsContact__c (after update)
{
    System.debug('## >>> CompetitorsContact__c after Update <<< run by ' + UserInfo.getName());
    
    /**************************************************************************************************************
        AP06ConfidentialInformation
        - 
    **************************************************************************************************************/
    if(PAD.canTrigger('AP06'))
    {
        Set<Id> ap06CompetitorContacts = new Set<Id>(); 
        for(CompetitorsContact__c compCtt : Trigger.new)
            if(compCtt.OwnerId != Trigger.oldMap.get(compCtt.Id).OwnerId)
                ap06CompetitorContacts.add(compCtt.Id);
               
		if(ap06CompetitorContacts.size() > 0)
			AP06ConfidentialInformation.updateParentSharing(ap06CompetitorContacts);
    }//bypass   
    System.debug('## >>> CompetitorsContact__c after Update : END <<<');
}