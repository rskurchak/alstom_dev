trigger BuyingProcessStakeholderAfterInsert on BuyingProcessStakeholder__c (after insert) 
{
	System.debug('## >>> BuyingProcessStakeholder After Insert <<< run by ' + UserInfo.getName());
    
    /*****************************************************************************
        AP26BuyingProcessStakeholder
        - add a Chatter Post to the related Contact Feed
    ******************************************************************************/
    if (PAD.canTrigger('AP26'))
    {
    	List<BuyingProcessStakeholder__c> ap26bps = new List<BuyingProcessStakeholder__c>();
    	
    	for (BuyingProcessStakeholder__c bps : trigger.new)
    		if (bps.ContactName__c != null)
    			ap26bps.add(bps);
    	
    	if (ap26bps.size() > 0)		
    		AP26BuyingProcessStakeholder.addContactChatterPost(ap26bps);
    }
    
    System.debug('## >>> BuyingProcessStakeholder After Insert : END <<<');
}