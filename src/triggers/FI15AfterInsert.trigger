/*********************************************************************
 SANITY CHECK Feb. 2014 - CODE MODIFICATION REQUIRED
 Modify code following instructions below.
 Remove this box once modifications done.
*********************************************************************/

/*********************************************************************
 SANITY CHECK INSTRUCTION: 
   Trigger should not loop through records (increase CPU time - governor limit) as records are looped through in AP51
 Remove this box once modification done.
*********************************************************************/

trigger FI15AfterInsert on FI15__c (after insert) {
    System.debug('## >>> FI15 After Insert <<< run by ' + UserInfo.getName());
    
    /*****************************************************************************
        AP51FI15Approvers
        - Add FI15 approvers to parent Opportunity Sales Team
    ******************************************************************************/
    if (PAD.canTrigger('AP51'))
    {
        List<FI15__c> ap51ListFI15 = new List<FI15__c>();
        
        for (FI15__c fi15 : trigger.new)
            if (fi15.Opportunity__c != null)
                ap51ListFI15.add(fi15);
        
        if (ap51ListFI15.size() > 0)        
            AP51FI15Approvers.AddFI15ApproversToSalesTeam(ap51ListFI15);
    }
    
    System.debug('## >>> FI15 After Insert : END <<<');
}