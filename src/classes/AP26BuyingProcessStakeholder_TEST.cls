/**
 * This class contains unit tests for validating the behavior of AP26BuyingProcessStakeholder Apex class
 * and triggers.
 *   ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com 
     ~ Date Created    : 22/05/2013
 */
@isTest
private class AP26BuyingProcessStakeholder_TEST 
{
    static testMethod void AP26BuyingProcessStakeholder_TEST() 
    {
        System.debug('## >>>>> testing class AP26BuyingProcessStakeholder START <<<<<');
		
        Account account = UtilityTestMethod.getAccount();
		insert account;
		
        Opportunity opp = UtilityTestMethod.getOpportunity();
        opp.ATRegion__c = 'France';
        opp.AccountId = account.Id;
        insert opp;
		
		Contact cont =  UtilityTestMethod.getContacts(1).get(0);
		insert cont;
		
		BuyingProcessStakeholder__c bps = new BuyingProcessStakeholder__c(Opportunity__c = opp.id, ContactName__c = cont.Id);
		
		
		Test.startTest();
		
		insert bps;
		
		Test.stopTest();
		
		System.debug('## >>>>> testing class AP26BuyingProcessStakeholder END <<<<<'); 
    }
}