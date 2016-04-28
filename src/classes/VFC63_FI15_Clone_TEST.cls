/*
  Class Test Controller for VFC63_FI15_Clone
   ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
   ~ Date Created    : 28/03/2014 
*/
@isTest
private class VFC63_FI15_Clone_TEST {
    static testMethod void testVFC63() {
        System.debug('## >>>>> testing class VFC63_FI15_Clone START <<<<<');
        
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
        BudgetLine__c budgetLine2 = new BudgetLine__c(FI15__c = fi15.id, BudgetLineAmount__c = 12);

        Test.startTest();
		PageReference VFP63 = Page.VFP63_FI15_Clone; 
	    Test.setCurrentPage(VFP63);
	    VFC63_FI15_Clone VFC63 = new VFC63_FI15_Clone(new ApexPages.StandardController(fi15));
		VFC63.doClone();
        Test.stopTest();
        System.debug('## >>>>> testing class VFC63_FI15_Clone END <<<<<');
    }
}