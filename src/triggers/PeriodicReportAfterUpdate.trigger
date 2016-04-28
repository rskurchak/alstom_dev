/*********************************************************************
 SANITY CHECK Feb. 2014 - CODE MODIFICATION REQUIRED
 Modify code following instructions below.
 Remove this box once modifications done.
*********************************************************************/
trigger PeriodicReportAfterUpdate on PeriodicReport__c (after update) 
{
    System.debug('## >>> PeriodicReport__c after update <<< run by ' + UserInfo.getName());

    /*********************************************************************************************
        AP22PeriodicReport
        - Add a Chatter Feed on the Parent Opportunity
    *********************************************************************************************/
    if(PAD.canTrigger('AP22'))
    {
        List<PeriodicReport__c> ap22 = new List<PeriodicReport__c>();
        for (PeriodicReport__c pr : trigger.new)
            // Don't create a Chatter post when only updating IsLast (triggered by AP28)
            if ((pr.IssuesRisks__c != trigger.oldmap.get(pr.Id).IssuesRisks__c) ||
                (pr.LastInformation__c != trigger.oldmap.get(pr.Id).LastInformation__c) ||
                (pr.Name != trigger.oldmap.get(pr.Id).Name))
                    ap22.add(pr);
                    
        if (ap22.size() > 0)
            AP22PeriodicReport.addOpportunityUpdateChatterFeed(ap22);
    }
        
    /*********************************************************************************************
        AP28PeriodicReport
        - set the IsLast Field
    *********************************************************************************************/
/*********************************************************************
 SANITY CHECK INSTRUCTION: 
 Method PAD supposes to put logic in Apex Class.
 Risk : PAD is supposed to enable Parallel Apex Development (ie several
 developers working on same trigger). For this reason, triggers should 
 only contain calls to Apex Class methods.
 => the filtering on ReportDate__c should be done in AP28
 Remove this box once modification done.
*********************************************************************/

    if (PAD.canTrigger('AP28'))
    {
        List<PeriodicReport__c> ap28 = new List<PeriodicReport__c>();
        for (PeriodicReport__c pr : trigger.new)
            if (pr.ReportDate__c != trigger.oldmap.get(pr.Id).ReportDate__c)
                ap28.add(pr);
        
        if (ap28.size() > 0)        
            AP28PeriodicReport.updateIsLast(ap28);
    }
    
    System.debug('## >>>  PeriodicReport__c after update : END <<<');
}