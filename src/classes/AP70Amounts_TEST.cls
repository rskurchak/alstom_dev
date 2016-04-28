/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 * Ali BEN AISSA ~ ali.ben.aissa@cgi.com 
 */
@isTest
private class AP70Amounts_TEST {

    static testMethod void ap70AmountsTest() {
    	System.debug('## >>>>> testing class AP70Amounts START <<<<<');
    	// create account
    	Account acc = UtilityTestMethod.getAccount();
        insert acc;
        // create Opportunity
        Opportunity opp = UtilityTestMethod.getOpportunity();
        opp.AccountId = acc.Id;
        insert opp;
        
        Tender__c tender = UtilityTestMethod.getTender(opp.Id);
        insert tender;
    	
    	Amounts__c amount = UtilityTestMethod.getAmounts(tender.Id);

    	amount.ExchangeRate__c = 2.4444;
    	amount.CurrencyIsoCode ='ARS';
        
        Test.startTest();
        //test triggers : insert
        insert amount;
        // update currency iso code (Currency)
        amount.CurrencyIsoCode = 'CAD';
        //test triggers : update
       
        update amount;
        Test.stopTest();
        System.debug('## >>>>> testing class AP70Amounts END <<<<<');
    
    }
}