trigger AccountBeforeUpdate on Account (before update) 
{
    System.debug('## >>> Account Before Update <<< run by ' + UserInfo.getName());
    
    /************************************************************************************
        AP11Account
        - sync ParentId field with TECH_GlobalAccount to maintain the custom lookup relation
    *************************************************************************************/
    if(PAD.canTrigger('AP11'))//bypass
        AP11Account.syncParentField(Trigger.new);

    /************************************************************************************
        AP11Account
        - prevent changing the value of Is AGlobal Account field to false (unchecked) 
        if the concerned account is referenced as a Parent
    *************************************************************************************/
    if(PAD.canTrigger('AP11'))
    {
        Map<Id, Account> ap11accounts = new Map<Id, Account>();
        for(Account acc : Trigger.new)
            if(!acc.IsAGlobalAccount__c && acc.IsAGlobalAccount__c != Trigger.oldMap.get(acc.Id).IsAGlobalAccount__c)
                ap11accounts.put(acc.Id, acc);
                
        if(ap11accounts.size() > 0)
            AP11Account.isParent(ap11accounts);
    }
    
    /****************************************************************************************
        AP03ATRegion - Update ATRegion when the Country changes
    *****************************************************************************************/
    if(PAD.canTrigger('AP03'))
    {
        List<Account> ap03Accounts = new List<Account>();
        for(Account account : Trigger.new) 
            if(account.Country__c != Trigger.oldMap.get(account.Id).Country__c) 
                ap03Accounts.add(account);

        if(ap03Accounts.size() > 0)
            AP03ATRegion.updateSObjectATRegion(ap03Accounts);
    }//bypass
    
    System.debug('## >>> Account Before Update END');
}