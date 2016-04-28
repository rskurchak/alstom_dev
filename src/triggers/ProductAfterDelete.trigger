trigger ProductAfterDelete on Product__c (after delete) 
{
	System.debug('## >>> Product__c after delete <<< run by ' + UserInfo.getName());	
		
	/**************************************************************************************************************
		AP15Product
		- automatically update the related Opportunity : 'Product Line' summary fields 
	**************************************************************************************************************/
	if(PAD.canTrigger('AP15'))
		AP15Product.updateOppProductLineSummary(Trigger.old);

	
	/**************************************************************************************************************
		AP18Product
		- automatically update the related Opportunity : 'TECH_Platforms1' and 'TECH_Platforms2' summary fields 
	**************************************************************************************************************/
	if(PAD.canTrigger('AP18'))
		AP18Product.updateOppPlatformSummary(trigger.old);

	/**************************************************************************************************************
		AP18Product
		- automatically update the related Opportunity : 'TECH_Products' summary fields 
	**************************************************************************************************************/
	if(PAD.canTrigger('AP18'))
		AP18Product.updateOppProductSummary(trigger.old);
	
	System.debug('## >>> Product__c after delete : END <<<');
}