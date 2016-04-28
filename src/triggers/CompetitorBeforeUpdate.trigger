trigger CompetitorBeforeUpdate on Competitor__c (before update) 
{
    System.debug('## >>> Competitor__c before Update <<< run by ' + UserInfo.getName());
    
    /**************************************************************************************************************
       AP12Competitor - prevent changing the value of Is AGlobal Competitor field to false (unchecked) 
        if the Competitor is referenced as a Parent
    **************************************************************************************************************/
    if(PAD.canTrigger('AP12'))
    {
        Map<Id, Competitor__c> ap12Competitors = new Map<Id, Competitor__c>();
        for(Competitor__c comp : Trigger.new)
            if(!comp.IsAGlobalCompetitor__c && comp.IsAGlobalCompetitor__c != Trigger.oldMap.get(comp.Id).IsAGlobalCompetitor__c)
                ap12Competitors.put(comp.Id, comp);
        if(ap12Competitors.size() > 0)
            AP12Competitor.isParent(ap12Competitors);
    }//bypass   
    
    /****************************************************************************************
        AP03ATRegion - Update ATRegion when the Country changes
    *****************************************************************************************/
    if(PAD.canTrigger('AP03'))
    {
        List<Competitor__c> ap03Competitors = new List<Competitor__c>();
        for(Competitor__c comp : Trigger.new) 
            if(comp.Country__c != Trigger.oldMap.get(comp.Id).Country__c) 
                ap03Competitors.add(comp);

        if(ap03Competitors.size() > 0)
            AP03ATRegion.updateSObjectATRegion(ap03Competitors);
    }//bypass
           
    System.debug('## >>> Competitor__c before Update : END <<<');
}