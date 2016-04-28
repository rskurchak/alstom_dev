trigger TenderAfterInsert on Tender__c (after insert) {
    System.debug('## >>> Tender before insert <<< run by ' + UserInfo.getName());

    /****************************************************************************************
        Tender Name field (standard record name from Salesforce) will be calculated in a "before insert" trigger 
        so that it equals "T_BOID" where BOID is the BOID from the related Opportunity (e.g. "T_118218"). 
        The insert must fail if a Tender record exists with the same name. 
        The insert must also fail if the Opportunity is not provided (security in the case of external data load).
     *****************************************************************************************/
    if(PAD.canTrigger('AP40'))
    {
        List<Tender__c> ap40Tenders = new List<Tender__c>();
        List<Id> ap40TenderIds = new List<Id>();
        
        for(Tender__c tend : Trigger.new) 
            if(tend.Opportunity__c != null) {
                ap40Tenders.add(tend);
                ap40TenderIds.add(tend.Id);
            }

        if(ap40Tenders.size() > 0){
            AP40Tender.UpdateOpp(ap40Tenders);
            AP40Tender.insertTenderSharing(ap40TenderIds);
        }
    }
    
    /*********************************************************************************************
        AP66Tender
        - Add a Chatter Feed on the Parent Opportunity
    *********************************************************************************************/
    if(PAD.canTrigger('AP66'))
        AP66Tender.addOpportunityChatterFeed(Trigger.new);
    
    System.debug('## >>> Tender before insert : END <<<');
}