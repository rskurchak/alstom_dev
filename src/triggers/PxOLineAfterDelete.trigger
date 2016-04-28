trigger PxOLineAfterDelete on PxOLine__c (after delete) 
{
	System.debug('## >>> PxOLine after delete <<< run by ' + UserInfo.getName());
	
	/**************************************************************************************************************
		AP73OpportunityViewerByOrigin
		- Adding Viewers by Origin to the related Opportunity Sales Team
	**************************************************************************************************************/
	if (PAD.canTrigger('AP73'))
	{
		AP73OpportunityViewerByOrigin.updateSalesTeamForViewerByOrigin(Trigger.old);
	}
	
	System.debug('## >>> PxOLine after delete : END <<<');
}