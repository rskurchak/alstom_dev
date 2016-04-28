trigger TenderReportAfterUpdate on TenderReport__c (after update) {
    System.debug('## >>> TenderReport__c after update <<< run by ' + UserInfo.getName()); 
    
    /*********************************************************************************************
        AP44TenderReport
        - set IsLast Field for the most recent Tender Report
        - Set Last Tender Report field for Opportunity
    *********************************************************************************************/ 
    
    if (PAD.canTrigger('AP44'))
    {
        List<TenderReport__c> AP44 = new List<TenderReport__c>();
        List<TenderReport__c> AP44AbstractField = new List<TenderReport__c>();
        for (TenderReport__c tr : trigger.new) {
            if (tr.ReportDate__c != trigger.oldmap.get(tr.Id).ReportDate__c)
                AP44.add(tr);
                
            // Check if Abstract__c or ReportDate__c fields are updated and the IsLast__c field is flagged for the current Tender Report
            if ((tr.Abstract__c != trigger.oldmap.get(tr.Id).Abstract__c || tr.ReportDate__c != trigger.oldmap.get(tr.Id).ReportDate__c) && tr.IsLast__c)
                AP44AbstractField.add(tr);
        }
        
        // Call updateIsLast method to set IsLast Field for the most recent Tender Report
        if (AP44.size() > 0)        
            AP44TenderReport.updateIsLast(trigger.new);
            
        // If the previous conditons are verified call the method setAbstractFieldForOpp to Set LastTenderReport__c field for Opportunity from Abstract__c field of the last Tender Report
        /* YMR
        if (AP44AbstractField.size() > 0)        
            AP44TenderReport.setAbstractFieldForOpp(trigger.new);
        */
    }
    System.debug('## >>>  TenderReport__c after update : END <<<');
}