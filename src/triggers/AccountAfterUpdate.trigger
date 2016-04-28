trigger AccountAfterUpdate on Account (after update) 
{
    System.debug('## >>> Account after update <<< run by ' + UserInfo.getName());
    
    /****************************************************************************************
        AP06ConfidentialInformation
        - Update the Sharing for the ConfidentialInformation when the owner of the parent Object changes
    *****************************************************************************************/
    if(PAD.canTrigger('AP06'))
    { 
        Set<Id> ap06AccountIds = new Set<Id>(); 
        
        for(Account account : Trigger.new) 
            if(account.OwnerId != null && account.OwnerId != Trigger.oldMap.get(account.Id).OwnerId) 
                ap06AccountIds.add(account.Id);

        if(ap06AccountIds.size() > 0)
            AP06ConfidentialInformation.updateParentSharing(ap06AccountIds);
    }//bypass*/
    
    System.debug('## >>> Account after update : END <<<');
}