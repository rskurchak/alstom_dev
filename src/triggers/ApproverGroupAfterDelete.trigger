trigger ApproverGroupAfterDelete on ApproverGroup__c (after delete) 
{
	System.debug('## >>> ApproverGroup after delete <<< run by ' + UserInfo.getName());
	
	/**************************************************************************************************************
		AP46ApproverGroup
		- Adding Approvers to sharing list of related Tender
	**************************************************************************************************************/
	if (PAD.canTrigger('AP46'))
		AP46ApproverGroup.updateTenderSharingList(trigger.old);
	
	System.debug('## >>> ApproverGroup after delete : END <<<');
}