trigger CompetitorContactBeforeUpdate on CompetitorsContact__c (before update) 
{
    System.debug('## >>> CompetitorsContact__c before update <<< run by ' + UserInfo.getName());
    if(PAD.canTrigger('AP29'))
    {
        List<CompetitorsContact__c> ap29CompetitorsContact = new List<CompetitorsContact__c>();

        for(CompetitorsContact__c comCon : Trigger.new){

            if(comCon.ReportsTo__c != null)
                ap29CompetitorsContact.add(comCon);
        }
         if(ap29CompetitorsContact.size() > 0)
            AP29CompetitorContact.CompetitorContactCheckLoop(ap29CompetitorsContact);
    }//bypass
}