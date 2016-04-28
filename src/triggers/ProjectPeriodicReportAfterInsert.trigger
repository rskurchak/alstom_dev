trigger ProjectPeriodicReportAfterInsert on ProjectPeriodicReport__c (after insert) 
{
    System.debug('## >>> ProjectPeriodicReport__c after insert <<< run by ' + UserInfo.getName());

    /*********************************************************************************************
        AP65ProjectPeriodicReport
        - set the IsLast Field
    *********************************************************************************************/
    if (PAD.canTrigger('AP65'))
        AP65ProjectPeriodicReport.updateIsLast(trigger.new);
    
    System.debug('## >>> ProjectPeriodicReport__c after insert : END <<<');
    
}