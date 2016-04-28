trigger TenderSubmissionAfterDelete on TenderSubmission__c (after delete) 
{
	System.debug('## >>> TenderSubmission after delete <<< run by ' + UserInfo.getName());
	
	/**************************************************************************************************************
		AP46ApproverGroup
		- Updating Approvers to sharing list of related Tender
	**************************************************************************************************************/
	if (PAD.canTrigger('AP46'))
		AP46ApproverGroup.updateTenderSharingList(trigger.old);
	
	System.debug('## >>> TenderSubmission after delete : END <<<');
}