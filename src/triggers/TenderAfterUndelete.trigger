trigger TenderAfterUndelete on Tender__c (after undelete) {
    System.debug('## >>> Tender__c after undelete <<< run by ' + UserInfo.getName()); 
    
    /*********************************************************************************************
        ap40Tenders
        - Check if Tender record exists for the same Opportunity
    *********************************************************************************************/
    if (PAD.canTrigger('AP40'))
        AP40Tender.CheckTenderOpp(trigger.new);
    
    System.debug('## >>>  Tender__c after undelete : END <<<');
}