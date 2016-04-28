/**
 * AP52BudgetLine Apex Class
 *   ~ Author          : Jawad GHOULAM ~ jawad.ghoulam@cgi.com 
     ~ Date Created    : 17/10/2013
     ~ Description     : Ensure that when modifying a Budget Line Amount, the resulting new  Grand Total at FI15 level doesn't exceed the value of Approved Amount.
                         If the new Grand Total exceeds Approved Amount, the transaction is aborted and a error message will be displayed.
                         If Approved Amount is empty, then no error. It means that the FI15 hasn't been approved yet. 
     ~ Triggers        : BudgetLineBeforeInsert, BudgetLineBeforeUpdate
     ~ Feature Id      : FEAT#0438
 *   ~ Author          : yamyle Merle-Remond ~ yamyle.merle-remond@axoa.fr 
     ~ Date Created    : 04/04/2014
     ~ Description     : Correction Governor Limits
 */
public with sharing class AP52BudgetLine {
    public static void checkGrandTotal(list<BudgetLine__c> budgetLineList)
    {
        List<Id> fi15Id = new List<Id>();
        for (BudgetLine__c bl : budgetLineList) {
            fi15Id.add(bl.FI15__c);
        }        
        // Getting needed informations on related FI15
        Map<Id, FI15__c> fi15Map = new Map<Id, FI15__c>([Select Id, Name, GrandTotal__c, ApprovedAmount__c, ApprovalStatus__c From FI15__c where Id IN: fi15Id]);
        for (BudgetLine__c budgetLine : budgetLineList)
        {   
            // grandTotalCalc calculate the sum of current BugetLineAmount and GrandTotal of FI15 after modification
            Decimal grandTotalCalc = budgetLine.BudgetLineAmount__c + fi15Map.get(budgetLine.FI15__c).GrandTotal__c;
            
            // If Approval Status of FI15 is Approved or Reallocated and Grand Total calculated after modification is greater than Approved Amount
            if((grandTotalCalc > fi15Map.get(BudgetLine.FI15__c).ApprovedAmount__c) 
                 && (fi15Map.get(budgetLine.FI15__c).ApprovalStatus__c == System.label.LBL0107 || fi15Map.get(budgetLine.FI15__c).ApprovalStatus__c == System.label.LBL0126)) {
                 // error message with 2 variables
                String template = System.Label.LBL0076; // Contains {0} and {1} placeholders
                List<String> valuesList = new List<String>();
                String value1 = String.valueOf(grandTotalCalc);
                valuesList.add(value1);
                String value2 = String.valueOf(fi15Map.get(BudgetLine.FI15__c).ApprovedAmount__c);
                valuesList.add(value2);
                budgetLine.addError(String.format(template, valuesList));
            }
        }
    }
}