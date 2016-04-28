trigger ApproverGroupBeforeUpdate on ApproverGroup__c (before update) 
{
	System.debug('## >>> ApproverGroup before update <<< run by ' + UserInfo.getName());
	
	/**************************************************************************************************************
		AP45ApproverGroup
		- Remove "Holes" in Approver selection 
	**************************************************************************************************************/
	if (PAD.canTrigger('AP45'))
		AP45ApproverGroup.regroupApprovers(trigger.new);
	
	/**************************************************************************************************************
		AP48ApproverGroup
		- Initialize BOID and Opportunity Name on Approver Group
	**************************************************************************************************************/
	if (PAD.canTrigger('AP48')) {
        List<ApproverGroup__c> ap48AG = new List<ApproverGroup__c>();
        for(ApproverGroup__c ag : Trigger.new) 
            if(ag.Submission__c != null) {
                ap48AG.add(ag);
            }

        if(ap48AG.size() > 0){
            AP48ApproverGroup.populateOppNameAndBOID(ap48AG);
        }
	}
	System.debug('## >>> ApproverGroup before update : END <<<');
}