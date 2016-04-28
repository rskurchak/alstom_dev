/*
 VFC50_BudgetLine_ApprovalStatus 
    ~ Author            : jawad.ghoulam@cgi.com
    ~ Modification Date : 10/10/2013
    ~ Description       : Controller of VFP50_BudgetLine_Edit and VFP50_BudgetLine_Delete
                          Overide the Edit and Delete standard action
                          When FI15 status is Pending the related Budget Line can not edited or deleted
    ~ Feature Id      : FEAT#0441 
*/
public with sharing class VFC50_BudgetLine_ApprovalStatus {

    // Contains current budgetLine
    public BudgetLine__c budgetLine {get;set;}
    // Contains related FI15
    public FI15__c fi15 {get;set;}
    
    public VFC50_BudgetLine_ApprovalStatus(ApexPages.StandardController controller) {
        this.budgetLine = (BudgetLine__c)controller.getRecord();
        
        // Getting needed informations on related FI15
        fi15 = [Select Id, Name, ApprovalStatus__c from FI15__c where Id =: this.budgetLine.FI15__c];
    }
}