/**
 * This class contains unit tests for validating the behavior of VFC46_Currency Apex controller and VFP46_Currency
 * Jawad GHOULAM ~ jawad.ghoulam@cgi.com
 * 24/09/2013
 */
@isTest
private class VFC46_Currency_Test {

    static testMethod void testVFC46() {
        System.debug('## >>>>> testing class VFC46_Currency START <<<<<');
        
   		System.debug('## Create accounts ..');
        Account account = UtilityTestMethod.getAccount();
        insert account;
        
        System.debug('## Create Opportunity ..');
        Opportunity opp = UtilityTestMethod.getOpportunityWithBOID();
        opp.AccountId = account.Id;
        insert opp;
        
        Tender__c tender = UtilityTestMethod.getTender(opp.Id);
        tender.Name = 'TendedTest';
        insert tender;
    
        Test.startTest();
        PageReference vfp46 = Page.VFP46_Currency; 
        Test.setCurrentPage(vfp46);
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('IdTender', tender.Id);
        Amounts__c amount1 = new Amounts__c();
        amount1.CurrencyIsoCode = 'MAD';
		VFC46_Currency vfc46 = new VFC46_Currency(new ApexPages.StandardController(amount1));
		vfc46.amount = amount1;
		vfc46.tenderName = tender.Name;
		vfc46.tenderId = tender.Id;
		//vfc46.currencyIsoCode = amount1.CurrencyIsoCode;
		vfc46.NextStep();
		vfc46.CancelCurrency();
 		     
 		Test.stopTest();
        System.debug('## >>>>> testing class VFC46_Currency END <<<<<');
    }
}