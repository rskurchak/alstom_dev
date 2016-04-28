trigger TenderReportAfterDelete on TenderReport__c (after delete) {
    System.debug('## >>> TenderReport__c after delete <<< run by ' + UserInfo.getName()); 
    
    /*********************************************************************************************
        AP44TenderReport
        - set the IsLast Field for the last Tender Report
    *********************************************************************************************/
    if (PAD.canTrigger('AP44'))
        AP44TenderReport.updateIsLast(trigger.old);
    
    System.debug('## >>>  TenderReport__c after delete : END <<<');
}