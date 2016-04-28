trigger OpportunityBeforeDelete on Opportunity (before delete) 
{
	System.debug('## >>> Opportunity before delete <<< run by ' + UserInfo.getName());

	/*********************************************************************************************
		AP24Opportunity
		- Delete related Opportunity Actors
    *********************************************************************************************/
    if (PAD.canTrigger('AP24'))
		AP24Opportunity.deleteOpportunityActors(trigger.old);	
	
	System.debug('## >>> Opportunity before delete : END <<<');
}