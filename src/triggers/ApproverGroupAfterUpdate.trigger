trigger ApproverGroupAfterUpdate on ApproverGroup__c (after update) 
{
	System.debug('## >>> ApproverGroup after update <<< run by ' + UserInfo.getName());
	
	/**************************************************************************************************************
		AP46ApproverGroup
		- Adding Approvers to sharing list of related Tender
	**************************************************************************************************************/
	if (PAD.canTrigger('AP46'))
	{
		List<ApproverGroup__c> ap46 = new List<ApproverGroup__c>();
		for (ApproverGroup__c ag : trigger.new)
		{
			if (ag.Approver1__c != Trigger.oldMap.get(ag.Id).Approver1__c
				|| ag.Approver2__c != Trigger.oldMap.get(ag.Id).Approver2__c
				|| ag.Approver3__c != Trigger.oldMap.get(ag.Id).Approver3__c
				|| ag.Approver4__c != Trigger.oldMap.get(ag.Id).Approver4__c
				|| ag.Approver5__c != Trigger.oldMap.get(ag.Id).Approver5__c
				|| ag.Approver6__c != Trigger.oldMap.get(ag.Id).Approver6__c
				|| ag.Approver7__c != Trigger.oldMap.get(ag.Id).Approver7__c
				|| ag.Approver8__c != Trigger.oldMap.get(ag.Id).Approver8__c
				|| ag.Approver9__c != Trigger.oldMap.get(ag.Id).Approver9__c
				|| ag.Approver10__c != Trigger.oldMap.get(ag.Id).Approver10__c)
			{
				ap46.add(ag);
			}
		}
		
		if (ap46.size() > 0)
			AP46ApproverGroup.updateTenderSharingList(ap46);
	}
	
	System.debug('## >>> ApproverGroup after update : END <<<');
}