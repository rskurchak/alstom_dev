/**
 * This class contains unit tests for validating the behavior of AP52BudgetLine Apex Class
 * and triggers.
 *   ~ Author          : Jawad GHOULAM ~ jawad.ghoulam@cgi.com 
     ~ Date Created    : 17/10/2013
 */
@isTest
private class AP52BudgetLine_Test {

    static testMethod void AP52BudgetLine_Test() {
        System.debug('## >>>>> testing class AP52BudgetLine START <<<<<');
		
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
		
		BudgetLine__c budgetLine = new BudgetLine__c(FI15__c = fi15.id, BudgetLineAmount__c = 11);
		
		Test.startTest();
		
		insert budgetLine;
		budgetLine.BudgetLineAmount__c = 22;
		update budgetLine;
		Test.stopTest();
		
		System.debug('## >>>>> testing class AP52BudgetLine END <<<<<');
    }
}