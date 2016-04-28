trigger ProductAfterUndelete on Product__c (after undelete) 
{
	System.debug('## >>> Product__c after undelete <<< run by ' + UserInfo.getName());
	
	/**************************************************************************************************************
		AP07Product
		- automatically update the related Opportunity : 'Product Line' and 'Platform' fields 
		when the Leading product is changed it values
	**************************************************************************************************************/
	if(PAD.canTrigger('AP07'))
	{
		List<Product__c> ap07Products = new List<Product__c>();
		for(Product__c prd : Trigger.new)
			if(prd.Leading__c)
				ap07Products.add(prd);
		 
		 if(ap07Products.size() > 0)
		 	AP07Product.updateOpportunityProductInfo(ap07Products);
	}//bypass	
	
	
	/**************************************************************************************************************
		AP15Product
		- automatically update the related Opportunity : 'Product Line' summary fields 
	**************************************************************************************************************/
	if(PAD.canTrigger('AP15'))
		 AP15Product.updateOppProductLineSummary(Trigger.new);

	
	/**************************************************************************************************************
		AP18Product
		- automatically update the related Opportunity : 'TECH_Platforms1' and 'TECH_Platforms2' summary fields 
	**************************************************************************************************************/
	if(PAD.canTrigger('AP18'))
		AP18Product.updateOppPlatformSummary(trigger.new);

	/**************************************************************************************************************
		AP18Product
		- automatically update the related Opportunity : 'TECH_Product' summary fields 
	**************************************************************************************************************/
	if(PAD.canTrigger('AP18'))
		AP18Product.updateOppProductSummary(trigger.new);
	

	System.debug('## >>> Product__c after undelete : END <<<');
}