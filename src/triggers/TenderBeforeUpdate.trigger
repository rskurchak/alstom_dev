trigger TenderBeforeUpdate on Tender__c (before update) {
    System.debug('## >>> Tender before update <<< run by ' + UserInfo.getName());

    /****************************************************************************************
        Tender Name field (standard record name from Salesforce) will be calculated in a "before insert" trigger 
        so that it equals "T_BOID" where BOID is the BOID from the related Opportunity (e.g. "T_118218"). 
        The insert must fail if a Tender record exists with the same name. 
        The insert must also fail if the Opportunity is not provided (security in the case of external data load).
     *****************************************************************************************/
    if(PAD.canTrigger('AP40'))
    {
        List<Tender__c> ap40Tenders = new List<Tender__c>();
        for(Tender__c tend : Trigger.new) 
            if(tend.Id != Trigger.oldMap.get(tend.Id).Id || tend.Opportunity__c != Trigger.oldMap.get(tend.Id).Opportunity__c) 
                ap40Tenders.add(tend);

        if(ap40Tenders.size() > 0)
            AP40Tender.CheckTenderOpp(ap40Tenders);
    }
    
    System.debug('## >>> Tender before update : END <<<');
}