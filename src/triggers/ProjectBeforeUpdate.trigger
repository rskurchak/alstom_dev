trigger ProjectBeforeUpdate on Project__c (before update) 
{
    System.debug('## >>> Project before update <<< run by ' + UserInfo.getName());

    /****************************************************************************************
        AP03ATRegion - Update ATRegion when the Country changes
    *****************************************************************************************/
    if(PAD.canTrigger('AP03'))
    {
        List<Project__c> ap03Projects = new List<Project__c>();
        for(Project__c proj : Trigger.new) 
            if(proj.Country__c != Trigger.oldMap.get(proj.Id).Country__c) 
                ap03Projects.add(proj);

        if(ap03Projects.size() > 0)
            AP03ATRegion.updateSObjectATRegion(ap03Projects);
    }
    
    System.debug('## >>> Project before update : END <<<');
}