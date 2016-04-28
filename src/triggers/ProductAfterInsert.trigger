trigger ProductAfterInsert on Product__c (after insert) 
{
	System.debug('## >>> Product__c after insert <<< run by ' + UserInfo.getName());
	
	/**************************************************************************************************************
		AP07Product
		- automatically update the related Opportunity : 'Product Line' and 'Platform' fields 
		when the Leading product is created
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
	{
		list<Product__c> ap15Products = new list<Product__c>();
		for (Product__c prd : Trigger.new)
			if (prd.ProductLine__c != null
				|| prd.Leading__c)
				ap15Products.add(prd);
		 
		 if(ap15Products.size() > 0)
		 	AP15Product.updateOppProductLineSummary(ap15Products);
	}
	
	/**************************************************************************************************************
		AP18Product
		- automatically update the related Opportunity : 'TECH_Platforms1' and 'TECH_Platforms2' summary fields 
	**************************************************************************************************************/
	if(PAD.canTrigger('AP18'))
	{
		list<Product__c> ap18Products = new list<Product__c>();
		for (Product__c prd : Trigger.new)
			if (prd.Platform__c != null)
				ap18Products.add(prd);
		 
		 if(ap18Products.size() > 0)
		 	AP18Product.updateOppPlatformSummary(ap18Products);
	}

	/**************************************************************************************************************
		AP18Product
		- automatically update the related Opportunity : 'TECH_Products' summary fields 
	**************************************************************************************************************/
	if(PAD.canTrigger('AP18'))
	{
		list<Product__c> ap18Products = new list<Product__c>();
		for (Product__c prd : Trigger.new)
			if (prd.Platform__c != null)
				ap18Products.add(prd);
		 
		 if(ap18Products.size() > 0)
		 	AP18Product.updateOppProductSummary(ap18Products);
	}

	
	/**************************************************************************************************************
		AP20Product
		- Add a Chatter Feed on the Parent Opportunity 
	**************************************************************************************************************/
	if(PAD.canTrigger('AP20'))
		AP20Product.addOpportunityInsertChatterFeed(Trigger.new);

	
	System.debug('## >>> Product__c after insert : END <<<');
}