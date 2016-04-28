trigger ProjectAfterUndelete on Project__c (after undelete) 
{
	System.debug('## >>> Project after undelete <<< run by ' + UserInfo.getName());

    /**********************************************************************************************
        AP25Project - Update Account Team
    ***********************************************************************************************/
    if (PAD.canTrigger('AP25'))
    {
    	List<Project__c> AP25proj = new List<Project__c>();
		for (Project__c p : trigger.new)
			if (p.Account__c != null)
				AP25proj.add(p);
				
    	if (AP25proj.size() > 0)
			AP25Project.updateAccountTeam(Trigger.new);
    }
    
    System.debug('## >>> Project after undelete : END <<<');
}