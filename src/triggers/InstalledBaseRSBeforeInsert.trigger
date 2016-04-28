trigger InstalledBaseRSBeforeInsert on InstalledBaseRS__c (before insert) {
    System.debug('## >>> InstalledBaseRS__c Before insert <<< run by ' + UserInfo.getName());
    /****************************************************************************************
        AP03ATRegion - Update ATRegion and ATCluster when the Country changes
    *****************************************************************************************/
    if(PAD.canTrigger('AP03'))
    {
        List<InstalledBaseRS__c> ap03InstalledBaseRS = new List<InstalledBaseRS__c>();
        for(InstalledBaseRS__c installBaseRS : Trigger.new) 
            ap03InstalledBaseRS.add(installBaseRS);

        if(ap03InstalledBaseRS.size() > 0)
            AP03ATRegion.updateSObjectATRegion(ap03InstalledBaseRS);
    }//bypass
            
    System.debug('## >>> InstalledBaseRS__c Before insert END');
}