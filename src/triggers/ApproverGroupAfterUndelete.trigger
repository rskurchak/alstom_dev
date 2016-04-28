trigger ApproverGroupAfterUndelete on ApproverGroup__c (after undelete) 
{
	System.debug('## >>> ApproverGroup after undelete <<< run by ' + UserInfo.getName());
	
	/**************************************************************************************************************
		AP46ApproverGroup
		- Adding Approvers to sharing list of related Tender
	**************************************************************************************************************/
	if (PAD.canTrigger('AP46'))
		AP46ApproverGroup.updateTenderSharingList(trigger.new);
	
	System.debug('## >>> ApproverGroup after undelete : END <<<');
}