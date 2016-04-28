trigger OpportunityAfterUpdate on Opportunity (after update)
{
    System.debug('## >>> Opportunity after Update <<< run by ' + UserInfo.getName());
    
    /**************************************************************************************************************
        AP06ConfidentialInformation
        - Update the Sharing for the ConfidentialInformation when the owner of the parent Object changes
    **************************************************************************************************************/
    if(PAD.canTrigger('AP06'))
    {
        Set<Id> ap06Opportunities = new Set<Id>(); 
        for(Opportunity opp : Trigger.new)
            if(opp.OwnerId != Trigger.oldMap.get(opp.Id).OwnerId)
                ap06Opportunities.add(opp.Id);
			
		if(ap06Opportunities.size() > 0)
			AP06ConfidentialInformation.updateParentSharing(ap06Opportunities);
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
        {
        	if (!opp.IsAGlobalOpportunity__c)
        	{
        		if (opp.Global_Opportunity__c != null)
        			ap19GlobalOpp.add(opp.Global_Opportunity__c);
        			
        		// if Global Opportunity change (unusual but why not ? Don't underestimate user's creativity !)
        		if (opp.Global_Opportunity__c != trigger.oldMap.get(opp.Id).Global_Opportunity__c
        			&& trigger.oldMap.get(opp.Id).Global_Opportunity__c != null)
        			ap19GlobalOpp.add(trigger.oldMap.get(opp.Id).Global_Opportunity__c);
        	}
        }
        	
		if(ap19GlobalOpp.size() > 0)
			AP19Opportunity.calculateGlobalSellingPrice(ap19GlobalOpp);
    }//bypass  
    
    /**************************************************************************************************************
		AP02Opportunity
		- automatically update the OpportunityActor for the Opportunity Account
	**************************************************************************************************************/
	if(PAD.canTrigger('AP02'))
	{
		map<Id, Opportunity> AP02OppsMap = new map<Id, Opportunity>();
		for (Opportunity opp : trigger.new)
			if (opp.AccountId != trigger.oldMap.get(opp.Id).AccountId)
				AP02OppsMap.put(opp.Id, opp);
				
		if(AP02OppsMap.size() > 0)
			AP02Opportunity.updateOpportunityActors(AP02OppsMap, trigger.oldMap);
	}
	
    System.debug('## >>> Opportunity after Update : END <<<');
}