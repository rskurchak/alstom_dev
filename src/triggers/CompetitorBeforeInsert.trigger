trigger CompetitorBeforeInsert on Competitor__c (before insert)
{
    System.debug('## >>> Competitor__c before insert <<< run by ' + UserInfo.getName());

    /****************************************************************************************
        AP03ATRegion - Update ATRegion when the Country changes
    *****************************************************************************************/
    if(PAD.canTrigger('AP03'))
    {
        List<Competitor__c> ap03Competitors = new List<Competitor__c>();
        for(Competitor__c comp : Trigger.new) 
            ap03Competitors.add(comp);

        if(ap03Competitors.size() > 0)
            AP03ATRegion.updateSObjectATRegion(ap03Competitors);
    }//bypass
           
    System.debug('## >>> Competitor__c before insert : END <<<');
}