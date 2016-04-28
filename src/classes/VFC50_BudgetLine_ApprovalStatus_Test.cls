/**
 * This class contains unit tests for validating the behavior of VFC50_BudgetLine_ApprovalStatus Apex 
 * controller and VFP50_BudgetLine_Edit and VFP50_BudgetLine_Delete
 * Jawad GHOULAM ~ jawad.ghoulam@cgi.com
 * 11/10/2013
 */
@isTest
private class VFC50_BudgetLine_ApprovalStatus_Test {

    static testMethod void testVFC50() {
        System.debug('## >>>>> testing class VFC50_BudgetLine_ApprovalStatus START <<<<<');
        
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
		insert budgetLine1;
		
    
        Test.startTest();
        PageReference vfp50Edit1 = Page.VFP50_BudgetLine_Edit; 
        Test.setCurrentPage(vfp50Edit1);
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', budgetLine1.Id);
        ApexPages.currentPage().getParameters().put('retURL', fi15.Id);
		VFC50_BudgetLine_ApprovalStatus vfc50Edit1 = new VFC50_BudgetLine_ApprovalStatus(new ApexPages.StandardController(budgetLine1));

		PageReference vfp50Delete1 = Page.VFP50_BudgetLine_Delete;
		Test.setCurrentPage(vfp50Delete1);
		ApexPages.currentPage().getParameters().put('id', budgetLine1.Id);
		ApexPages.currentPage().getParameters().put('delID', fi15.Id);
		ApexPages.currentPage().getParameters().put('retURL','a0n');
		VFC50_BudgetLine_ApprovalStatus vfc50Delete1 = new VFC50_BudgetLine_ApprovalStatus(new ApexPages.StandardController(budgetLine1));
		
		
		fi15.ApprovalStatus__c  = System.label.LBL0106;
		update fi15;
		
        PageReference vfp50Edit2 = Page.VFP50_BudgetLine_Edit; 
        Test.setCurrentPage(vfp50Edit2);
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', budgetLine1.Id);
        ApexPages.currentPage().getParameters().put('retURL', budgetLine1.Id);
		VFC50_BudgetLine_ApprovalStatus vfc50Edit2 = new VFC50_BudgetLine_ApprovalStatus(new ApexPages.StandardController(budgetLine1));

		PageReference vfp50Delete2 = Page.VFP50_BudgetLine_Delete;
		Test.setCurrentPage(vfp50Delete2);
		ApexPages.currentPage().getParameters().put('id', budgetLine1.Id);
		ApexPages.currentPage().getParameters().put('delID', budgetLine1.Id);
		ApexPages.currentPage().getParameters().put('retURL','a0n');
		VFC50_BudgetLine_ApprovalStatus vfc50Delete2 = new VFC50_BudgetLine_ApprovalStatus(new ApexPages.StandardController(budgetLine1));
 		     
 		Test.stopTest();
        System.debug('## >>>>> testing class VFC50_BudgetLine_ApprovalStatus END <<<<<');
    }
}