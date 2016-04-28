/*********************************************************************
 SANITY CHECK Feb. 2014 - CODE MODIFICATION REQUIRED
 Modify code following instructions below.
 Remove this box once modifications done.
*********************************************************************/

/*********************************************************************
 SANITY CHECK INSTRUCTION: 
   Trigger should not loop through records (increase CPU time - governor limit) as records are looped through in AP52
 Remove this box once modification done.
*********************************************************************/
trigger BudgetLineBeforeInsert on BudgetLine__c (before insert) {
    System.debug('## >>> BudgetLine Before insert <<< run by ' + UserInfo.getName());
    
    /*****************************************************************************
        AP52BudgetLine
        - FI15 reallocation (can't exceed approved amount)
    ******************************************************************************/
    if (PAD.canTrigger('AP52'))
    {
        List<BudgetLine__c> ap52ListBudgetLine = new List<BudgetLine__c>();
        
        for (BudgetLine__c budgetLine : trigger.new)
            if (budgetLine.BudgetLineAmount__c != null)
                    ap52ListBudgetLine.add(budgetLine);
        
        if (ap52ListBudgetLine.size() > 0)      
            AP52BudgetLine.checkGrandTotal(ap52ListBudgetLine);
    }
    
    System.debug('## >>> BudgetLine Before insert : END <<<');
}