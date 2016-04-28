/**
 * This class contains unit tests for validating the behavior of VFC51_FI15_ApprovalStatus Apex 
 * controller and VFP51_BudgetLine_New
 * Jawad GHOULAM ~ jawad.ghoulam@cgi.com
 * 11/10/2013
 */
@isTest
private class VFC51_FI15_ApprovalStatus_Test {

    static testMethod void testVFC51() {
        System.debug('## >>>>> testing class VFC51_FI15_ApprovalStatus START <<<<<');
        
        Account account = UtilityTestMethod.getAccount();
        insert account;
        
        Opportunity opp = UtilityTestMethod.getOpportunity();
        opp.ATRegion__c = 'France';
        opp.AccountId = account.Id;
        insert opp;
        
        List<User> users =  UtilityTestMethod.getUsersToInsert(4);
        insert users;
        
        FI15__c fi15 = new FI15__c(Opportunity__c = opp.id, CountryFinanceDirector__c = users[0].Id, CountryMD__c = users[1].Id, PlatformController__c = users[2].Id, PlatformDirector__c = users[3].Id);
        insert fi15;
        
        BudgetLine__c budgetLine1 = new BudgetLine__c(FI15__c = fi15.id, BudgetLineAmount__c = 11);
        //insert budgetLine1;
        
    
        Test.startTest();
        PageReference vfp51New1 = Page.VFP51_BudgetLine_New; 
        Test.setCurrentPage(vfp51New1);
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('CF00Nc0000000kb8n_lkid', fi15.Id);
        ApexPages.currentPage().getParameters().put('retURL', fi15.Id);
        VFC51_FI15_ApprovalStatus vfc51New1 = new VFC51_FI15_ApprovalStatus(new ApexPages.StandardController(budgetLine1));
        vfc51New1.sUrl();

        fi15.ApprovalStatus__c  = System.label.LBL0106;
        update fi15;

        PageReference vfp51New2 = Page.VFP51_BudgetLine_New; 
        Test.setCurrentPage(vfp51New2);
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('CF00Nc0000000kb8n_lkid', fi15.Id);
        ApexPages.currentPage().getParameters().put('retURL', '0012');
        VFC51_FI15_ApprovalStatus vfc51New2 = new VFC51_FI15_ApprovalStatus(new ApexPages.StandardController(budgetLine1));
             
        Test.stopTest();
        System.debug('## >>>>> testing class VFC51_FI15_ApprovalStatus END <<<<<');
    }
}