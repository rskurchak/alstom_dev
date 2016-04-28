/*********************************************************************
 SANITY CHECK Feb. 2014 - CODE MODIFICATION REQUIRED
 Modify code following instructions below.
 Remove this box once modifications done.
*********************************************************************/

/*********************************************************************
 SANITY CHECK INSTRUCTION: 
 Method PAD supposes to put logic in Apex Class.
 Risk : PAD is supposed to enable Parallel Apex Development (ie several
 developers working on same trigger). For this reason, triggers should 
 only contain calls to Apex Class methods.
 => the filtering on ReportDate__c should be done in AP65
 Remove this box once modification done.
*********************************************************************/
trigger ProjectPeriodicReportAfterUpdate on ProjectPeriodicReport__c (after update) 
{
    System.debug('## >>> ProjectPeriodicReport__c after update <<< run by ' + UserInfo.getName());

    /*********************************************************************************************
        AP65PeriodicReport
        - set the IsLast Field
    *********************************************************************************************/
    if (PAD.canTrigger('AP65'))
    {
        List<ProjectPeriodicReport__c> ap65 = new List<ProjectPeriodicReport__c>();
        for (ProjectPeriodicReport__c pr : trigger.new)
            if (pr.ReportDate__c != trigger.oldmap.get(pr.Id).ReportDate__c)
                ap65.add(pr);
        
        if (ap65.size() > 0)        
            AP65ProjectPeriodicReport.updateIsLast(ap65);
    }
    
    System.debug('## >>> ProjectPeriodicReport__c after update : END <<<');
}