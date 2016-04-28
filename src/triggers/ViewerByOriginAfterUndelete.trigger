trigger ViewerByOriginAfterUndelete on ViewerByOrigin__c (after undelete) 
{
	System.debug('## >>> ViewerByOrigin after undelete <<< run by ' + UserInfo.getName());
	
	/**************************************************************************************************************
		AP73OpportunityViewerByOrigin
		- Adding Viewers by Origin to the related Opportunity Sales Team
	**************************************************************************************************************/
	if (PAD.canTrigger('AP73'))
	{
		AP73OpportunityViewerByOrigin.updateSalesTeamForViewerByOrigin(Trigger.new);
	}
	
	System.debug('## >>> ViewerByOrigin after undelete : END <<<');
}