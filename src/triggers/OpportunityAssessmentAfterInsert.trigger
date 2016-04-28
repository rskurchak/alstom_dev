trigger OpportunityAssessmentAfterInsert on OpportunityAssessment__c (after insert) 
{
	System.debug('## >>> Opportunity Assessment after insert <<< run by ' + UserInfo.getName());
	
	/**************************************************************************************************************
		AP23OpportunityAssessment
		- Add a Chatter Feed on the Parent Opportunity 
	**************************************************************************************************************/
	if(PAD.canTrigger('AP23'))
			AP23OpportunityAssessment.addOpportunityInsertChatterFeed(Trigger.new);

	
	System.debug('## >>> Opportunity Assessment after insert : END <<<');
}