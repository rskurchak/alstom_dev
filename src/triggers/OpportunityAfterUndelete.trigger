trigger OpportunityAfterUndelete on Opportunity (after undelete) 
{
	System.debug('## >>> Opportunity after undelete <<< run by ' + UserInfo.getName());

	/*********************************************************************************************
		AP24Opportunity
		- Undelete related Opportunity Actors
    *********************************************************************************************/
    if (PAD.canTrigger('AP24'))
		AP24Opportunity.undeleteOpportunityActors(trigger.new);	
	
	System.debug('## >>> Opportunity after undelete : END <<<');
}