trigger ProjectBeforeInsert on Project__c (before insert) 
{
    System.debug('## >>> Project before insert <<< run by ' + UserInfo.getName());

    /****************************************************************************************
        AP03ATRegion - Update ATRegion when the Country changes
    *****************************************************************************************/
    if(PAD.canTrigger('AP03'))
    {
        List<Project__c> ap03Projects = new List<Project__c>();
        for(Project__c proj : Trigger.new) 
            ap03Projects.add(proj);

        if(ap03Projects.size() > 0)
            AP03ATRegion.updateSObjectATRegion(ap03Projects);
    }
    
    System.debug('## >>> Project before insert : END <<<');
}