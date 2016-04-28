trigger PxOLineAfterUndelete on PxOLine__c (after undelete) 
{
	System.debug('## >>> PxOLine after undelete <<< run by ' + UserInfo.getName());
	
	/**************************************************************************************************************
		AP73OpportunityViewerByOrigin
		- Adding Viewers by Origin to the related Opportunity Sales Team
	**************************************************************************************************************/
	if (PAD.canTrigger('AP73'))
	{
		AP73OpportunityViewerByOrigin.updateSalesTeamForViewerByOrigin(Trigger.new);
	}
	
	System.debug('## >>> PxOLine after undelete : END <<<');
}