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

trigger BudgetLineBeforeUpdate on BudgetLine__c (before update) {
    System.debug('## >>> BudgetLine Before update <<< run by ' + UserInfo.getName());
    
    /*****************************************************************************
        AP52BudgetLine
        - FI15 reallocation (can't exceed approved amount)
    ******************************************************************************/
    if (PAD.canTrigger('AP52'))
    {
        List<BudgetLine__c> ap52ListBudgetLine = new List<BudgetLine__c>();
        Map<Id, BudgetLine__c> budgetLineMap = new Map<Id, BudgetLine__c>([Select Id, Name, FI15__r.GrandTotal__c, FI15__r.ApprovedAmount__c, FI15__r.ApprovalStatus__c From BudgetLine__c where Id IN :trigger.new]);
        
        for (BudgetLine__c budgetLine : trigger.new)
            if (budgetLine.FI15__c != null && budgetLine.BudgetLineAmount__c > Trigger.oldMap.get(budgetLine.Id).BudgetLineAmount__c) {
                Decimal grandTotalCalc = budgetLine.BudgetLineAmount__c + (budgetLineMap.get(budgetLine.Id).FI15__r.GrandTotal__c) - Trigger.oldMap.get(budgetLine.Id).BudgetLineAmount__c;
                if((budgetLineMap.get(budgetLine.Id).FI15__r.ApprovalStatus__c == System.label.LBL0107 || budgetLineMap.get(budgetLine.Id).FI15__r.ApprovalStatus__c == System.label.LBL0126) && (grandTotalCalc > budgetLineMap.get(BudgetLine.Id).FI15__r.ApprovedAmount__c))
                    budgetLine.addError('Grand total amount recalculated on FI15 record after modification (= '+grandTotalCalc+') cannot be greater than previously approved Grand Total (= '+budgetLineMap.get(BudgetLine.Id).FI15__r.ApprovedAmount__c+')');
            }
    }
    
    System.debug('## >>> BudgetLine Before update : END <<<');
}