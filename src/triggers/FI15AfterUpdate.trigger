trigger FI15AfterUpdate on FI15__c (after update) {
    System.debug('## >>> FI15 After Update <<< run by ' + UserInfo.getName());
    
  /*****************************************************************************
        AP49FI15
        - add a Chatter Post to the related Opportunity Feed
    ******************************************************************************/
    if (PAD.canTrigger('AP49'))
    {
      List<FI15__c> ap49ApprovedListFI15 = new List<FI15__c>();
      
      for (FI15__c fi15 : trigger.new)
        if (fi15.Opportunity__c != null) {
          System.debug('## >>> fi15.ApprovalStatus__c <<< : '+fi15.ApprovalStatus__c);
          if(fi15.ApprovalStatus__c == System.Label.LBL0107 && fi15.ApprovalStatus__c != Trigger.oldMap.get(fi15.Id).ApprovalStatus__c)
            ap49ApprovedListFI15.add(fi15);
        }
      
      System.debug('## >>> ap49ApprovedListFI15.size() <<< : '+ap49ApprovedListFI15.size());
      if (ap49ApprovedListFI15.size() > 0)    
        AP49FI15.addOpportunityChatterPost(ap49ApprovedListFI15, System.Label.LBL0109);
    }    
    
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
    
    System.debug('## >>> FI15 After Update : END <<<');
}