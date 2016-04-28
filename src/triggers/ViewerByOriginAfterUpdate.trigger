trigger ViewerByOriginAfterUpdate on ViewerByOrigin__c (after update) 
{
	System.debug('## >>> ViewerByOrigin after update <<< run by ' + UserInfo.getName());
	
	/**************************************************************************************************************
		AP73OpportunityViewerByOrigin
		- Adding Viewers by Origin to the related Opportunity Sales Team
	**************************************************************************************************************/
	if (PAD.canTrigger('AP73'))
	{
		List<ViewerByOrigin__c> listAp73Vbo = new List<ViewerByOrigin__c>();
		for (ViewerByOrigin__c vbo : Trigger.new)
		{
			// If the user has changed
			if (vbo.User__c != Trigger.oldMap.get(vbo.Id).User__c)
				listAp73Vbo.add(vbo);
		}

		if (listAp73Vbo.size() > 0)
			AP73OpportunityViewerByOrigin.updateSalesTeamForViewerByOrigin(listAp73Vbo);
	}
	
	System.debug('## >>> ViewerByOrigin after update : END <<<');
}