/**
 * This class contains unit tests for validating the behavior of AP20Product Apex classes
 * and triggers.
 *   ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com
     ~ Date Created    : 21/03/2013
 */
@isTest
private class AP20Product_TEST 
{
    static testMethod void AP20Product_TEST() 
    {
    	Opportunity opp = UtilityTestMethod.getOpportunity();
		insert opp;
		
		Product__c p = new Product__c(Opportunity__c = opp.Id, Leading__c = true, ProductLine__c='Rolling Stock & Components', Platform__c = 'Metro', Contribution__c = 50);
		
		
		test.startTest();
		
		insert p;
		p.ProductLine__c = '';
		p.Platform__c = '';
		p.Contribution__c = 40;
		update p;
		delete p;
		undelete p; 
		
		test.stopTest();
    }
}