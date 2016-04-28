trigger ContactAfterUpdate on Contact (after update) 
{
    System.debug('## >>> Contact after Update <<< run by ' + UserInfo.getName());
    
    /**************************************************************************************************************
        AP06ConfidentialInformation
        - 
    **************************************************************************************************************/
    if(PAD.canTrigger('AP06'))
    {
        Set<Id> ap06Contacts = new Set<Id>(); 
        for(Contact ctt : Trigger.new)
            if(ctt.OwnerId != Trigger.oldMap.get(ctt.Id).OwnerId)
                ap06Contacts.add(ctt.Id);
               
		if(ap06Contacts.size() > 0)
			AP06ConfidentialInformation.updateParentSharing(ap06Contacts);
    }//bypass   
    System.debug('## >>> Contact after Update : END <<<');
}