trigger OpportunityAfterInsert on Opportunity (after insert) 
{
	System.debug('## >>> Opportunity after insert <<< run by ' + UserInfo.getName());
	
	/**************************************************************************************************************
		AP02Opportunity
		- automatically create an OpportunityActor for the Opportunity Account
	**************************************************************************************************************/
	if(PAD.canTrigger('AP02'))
	{
		AP02Opportunity.createOpportunityActors(trigger.new);
	}//bypass	
	
	/**************************************************************************************************************
        AP19Opportunity
        - calculate Field Sum of Global + all Child Opportunities Selling Prices on Global Opportunity
    **************************************************************************************************************/
    if(PAD.canTrigger('AP19'))
    {
    	// Set to avoid duplicate values
        Set<Id> ap19GlobalOpp = new Set<Id>();
        
        for(Opportunity opp : Trigger.new)
        	if (!opp.IsAGlobalOpportunity__c
        		&& opp.Global_Opportunity__c != null)
        			ap19GlobalOpp.add(opp.Global_Opportunity__c);
        	
		if(ap19GlobalOpp.size() > 0)
			AP19Opportunity.calculateGlobalSellingPrice(ap19GlobalOpp);
    }//bypass 
	
	System.debug('## >>> Opportunity after insert : END <<<');
}