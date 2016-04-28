trigger TenderSubmissionAfterUndelete on TenderSubmission__c (after undelete) 
{
	System.debug('## >>> TenderSubmission after undelete <<< run by ' + UserInfo.getName());
	
	/**************************************************************************************************************
		AP46ApproverGroup
		- Adding Approvers to sharing list of related Tender
	**************************************************************************************************************/
	if (PAD.canTrigger('AP46'))
		AP46ApproverGroup.updateTenderSharingList(trigger.new);
	
	System.debug('## >>> TenderSubmission after undelete : END <<<');
}