trigger ProjectPeriodicReportAfterUndelete on ProjectPeriodicReport__c (after undelete) 
{
  System.debug('## >>> ProjectPeriodicReport__c after undelete <<< run by ' + UserInfo.getName());
  
  /*********************************************************************************************
        AP65ProjectPeriodicReport
        - set the IsLast Field
    *********************************************************************************************/
    if (PAD.canTrigger('AP65'))
        AP65ProjectPeriodicReport.updateIsLast(trigger.new);
    
  System.debug('## >>> ProjectPeriodicReport__c after undelete : END <<<');
}