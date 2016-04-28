trigger ApproverGroupAfterInsert on ApproverGroup__c (after insert) 
{
	System.debug('## >>> ApproverGroup after insert <<< run by ' + UserInfo.getName());
	
	/**************************************************************************************************************
		AP46ApproverGroup
		- Adding Approvers to sharing list of related Tender
	**************************************************************************************************************/
	if (PAD.canTrigger('AP46'))
		AP46ApproverGroup.updateTenderSharingList(trigger.new);
	
	System.debug('## >>> ApproverGroup after insert : END <<<');
}