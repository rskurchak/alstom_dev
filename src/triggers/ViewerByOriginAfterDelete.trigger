trigger ViewerByOriginAfterDelete on ViewerByOrigin__c (after delete) 
{
	System.debug('## >>> ViewerByOrigin after delete <<< run by ' + UserInfo.getName());
	
	/**************************************************************************************************************
		AP73OpportunityViewerByOrigin
		- Adding Viewers by Origin to the related Opportunity Sales Team
	**************************************************************************************************************/
	if (PAD.canTrigger('AP73'))
	{
		AP73OpportunityViewerByOrigin.updateSalesTeamForViewerByOrigin(Trigger.old);
	}
	
	System.debug('## >>> ViewerByOrigin after delete : END <<<');
}