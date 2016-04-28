trigger TenderReportAfterUndelete on TenderReport__c (after undelete) {
    System.debug('## >>> TenderReport__c after undelete <<< run by ' + UserInfo.getName()); 
    
    /*********************************************************************************************
        AP44TenderReport
        - set the IsLast Field for the last Tender Report
    *********************************************************************************************/
    if (PAD.canTrigger('AP44'))
        AP44TenderReport.updateIsLast(trigger.new);
    
    System.debug('## >>>  TenderReport__c after undelete : END <<<');
}