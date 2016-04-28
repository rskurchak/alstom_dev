trigger PeriodicReportAfterInsert on PeriodicReport__c (after insert) 
{
    System.debug('## >>> PeriodicReport__c after insert <<< run by ' + UserInfo.getName());

    /*********************************************************************************************
        AP22PeriodicReport
        - Add a Chatter Feed on the Parent Opportunity
    *********************************************************************************************/
    if(PAD.canTrigger('AP22'))
        AP22PeriodicReport.addOpportunityInsertChatterFeed(Trigger.new);
    
    /*********************************************************************************************
        AP28PeriodicReport
        - set the IsLast Field
    *********************************************************************************************/
    if (PAD.canTrigger('AP28'))
        AP28PeriodicReport.updateIsLast(trigger.new);
    
    System.debug('## >>>  PeriodicReport__c after insert : END <<<');
}