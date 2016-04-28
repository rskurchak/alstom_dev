trigger ProjectPeriodicReportAfterDelete on ProjectPeriodicReport__c (after delete) 
{
  System.debug('## >>> ProjectPeriodicReport__c after delete <<< run by ' + UserInfo.getName());
  
  /*********************************************************************************************
        AP65ProjectPeriodicReport
        - set the IsLast Field
    *********************************************************************************************/
    if (PAD.canTrigger('AP65'))
        AP65ProjectPeriodicReport.updateIsLast(trigger.old);
    
  System.debug('## >>> ProjectPeriodicReport__c after delete : END <<<');
}