/**
 * This class contains unit tests for validating the behavior of AP51FI15Approvers Apex Class
 * and triggers.
 *   ~ Author          : Jawad GHOULAM ~ jawad.ghoulam@cgi.com 
     ~ Date Created    : 17/10/2013
 */
@isTest
private class AP51FI15Approvers_Test {

    static testMethod void AP51FI15Approvers_Test() {
        System.debug('## >>>>> testing class AP51FI15Approvers START <<<<<');
		
        Account account = UtilityTestMethod.getAccount();
		insert account;
		
        Opportunity opp = UtilityTestMethod.getOpportunity();
        opp.ATRegion__c = 'France';
        opp.AccountId = account.Id;
        insert opp;
		
		List<User> users =  UtilityTestMethod.getUsersToInsert(4);
		insert users;
		
		FI15__c fi15 = new FI15__c(Opportunity__c = opp.id, CountryFinanceDirector__c = users[0].Id, CountryMD__c = users[1].Id, PlatformController__c = users[2].Id, PlatformDirector__c = users[3].Id);
		
		
		Test.startTest();
		
		insert fi15;
		fi15.Category__c = 'B';
		update fi15;
		Test.stopTest();
		
		System.debug('## >>>>> testing class AP51FI15Approvers END <<<<<'); 
    }
}