/*
 VFC69_Project_New apex controller
    ~ Author          : Christophe AVERSENG
    ~ Date Created    : 07/05/2014
    ~ Description     : "Create Project" from Opportunity
    ~ Feature Id      : FEAT#0613
*/
public without sharing class VFC69_Project_New {
    public Project__c project {get;set;}
    private Opportunity opp;
    
    public VFC69_Project_New(ApexPages.StandardController controller) {
        opp = (Opportunity) controller.getrecord();
        // Instantiate a new Project__c for creation, with values defaulted from Opportunity
        this.project = new Project__c(Name=opp.Name, Account__c=opp.AccountId, Opportunity__c=opp.Id, Country__c=opp.Country__c, CT_Code__c=opp.CTCode__c, ScopeOfWork__c=opp.ScopeOfWork__c);
    }
    
    public PageReference saveWithProducts() {
        TRY
        {
            insert project;
            
            /* If the user is in the Account Team, add it to the Project sharing to avoid access error before the batch runs */
            List<AccountTeamMember> listAccTeamMember = [Select Id from AccountTeamMember where AccountId = :opp.AccountId AND UserId = :UserInfo.getUserId()];
            if (listAccTeamMember.size() > 0)
            {
                Project__Share projShare = new Project__Share(ParentId = project.Id, rowCause = Schema.Project__Share.rowCause.Account_Team__c, UserOrGroupId = UserInfo.getUserId(), AccessLevel = 'Edit');
                insert projShare;
            }

            // Create Project Products from Opportunity Products
            List<ProjectProduct__c> prjProds = new List<ProjectProduct__c>();        
            List<Product__c> oppProds = [SELECT ProductLine__c, Platform__c, Product__c, Leading__c FROM Product__c WHERE Opportunity__c =: this.opp.Id];
            for (Product__c oppProd : oppProds) {
                prjProds.add (new ProjectProduct__c(Project__c=project.Id,ProductLine__c=oppProd.ProductLine__c,Platform__c=oppProd.Platform__c,Product__c=oppProd.Product__c,Leading__c=oppProd.Leading__c));
            }
            insert prjProds;
        }
        CATCH(Exception e)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.GetMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
        
        return new PageReference('/'+project.Id);
    }
}