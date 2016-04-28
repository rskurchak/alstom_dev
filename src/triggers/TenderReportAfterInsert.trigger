trigger TenderReportAfterInsert on TenderReport__c (after insert) {
    System.debug('## >>> TenderReport__c after insert <<< run by ' + UserInfo.getName()); 
    
    /*********************************************************************************************
        AP44TenderReport
        - set the IsLast Field
    *********************************************************************************************/
    if (PAD.canTrigger('AP44'))
        AP44TenderReport.updateIsLast(trigger.new);
    
    System.debug('## >>>  TenderReport__c after insert : END <<<');
}