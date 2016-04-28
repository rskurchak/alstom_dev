trigger OpportunityAssessmentAfterUpdate on OpportunityAssessment__c (after update) 
{
	System.debug('## >>> Opportunity Assessment after update <<< run by ' + UserInfo.getName());
	
	/**************************************************************************************************************
		AP23OpportunityAssessment
		- Add a Chatter Feed on the Parent Opportunity 
	**************************************************************************************************************/
	if(PAD.canTrigger('AP23'))
		AP23OpportunityAssessment.addOpportunityUpdateChatterFeed(Trigger.new);

	
	System.debug('## >>> Opportunity Assessment after update : END <<<');
}