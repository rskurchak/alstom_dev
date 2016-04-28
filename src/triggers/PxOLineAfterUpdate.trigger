trigger PxOLineAfterUpdate on PxOLine__c (after update) 
{
	System.debug('## >>> PxOLine after update <<< run by ' + UserInfo.getName());
	
	/**************************************************************************************************************
		AP73OpportunityViewerByOrigin
		- Adding Viewers by Origin to the related Opportunity Sales Team
	**************************************************************************************************************/
	if (PAD.canTrigger('AP73'))
	{
		List<PxOLine__c> listAp73Pxol = new List<PxOLine__c>();
		for (PxOLine__c pxol : Trigger.new)
		{
			// If the Site has changed
			if (pxol.Site__c != Trigger.oldMap.get(pxol.Id).Site__c)
				listAp73Pxol.add(pxol);
		}

		if (listAp73Pxol.size() > 0)
			AP73OpportunityViewerByOrigin.updateSalesTeamForViewerByOrigin(listAp73Pxol);
	}
	
	System.debug('## >>> PxOLine after update : END <<<');
}