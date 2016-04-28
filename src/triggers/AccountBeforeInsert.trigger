trigger AccountBeforeInsert on Account (before insert) 
{
    System.debug('## >>> Account Before insert <<< run by ' + UserInfo.getName());
        
    /************************************************************************************
        AP11Account
        - sync ParentId field with TECH_GlobalAccount to maintain the custom lookup relation
    *************************************************************************************/
    if(PAD.canTrigger('AP11'))//bypass
        AP11Account.syncParentField(Trigger.new);
        
    /****************************************************************************************
        AP03ATRegion - Update ATRegion when the Country changes
    *****************************************************************************************/
    if(PAD.canTrigger('AP03'))
    {
        List<Account> ap03Accounts = new List<Account>();
        for(Account account : Trigger.new) 
            ap03Accounts.add(account);

        if(ap03Accounts.size() > 0)
            AP03ATRegion.updateSObjectATRegion(ap03Accounts);
    }//bypass
            
    System.debug('## >>> Account Before insert END');
}