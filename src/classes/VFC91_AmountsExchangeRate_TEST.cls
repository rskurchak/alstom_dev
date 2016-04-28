/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *   ~ Author           : Ali BEN AISSA ~ ali.ben.aissa@cgi.com
 *   ~ Date Created    	: 20/07/2015
 */
@isTest
private class VFC91_AmountsExchangeRate_TEST {

    static testMethod void VFC91_AmountsExchangeRate_TEST() {
     
        Account account = UtilityTestMethod.getAccounts(1).get(0);
        insert account;
		
        Opportunity opp = UtilityTestMethod.getOpportunities(1).get(0);
        opp.AccountId = account.Id;
        opp.CloseDate =date.today();
        insert opp;
        
        Tender__c tender = UtilityTestMethod.getTender(opp.Id);
        insert tender;
       
       
        Amounts__c amount = UtilityTestMethod.getAmounts(tender.Id);
        amount.CurrencyIsoCode='BGL';
        amount.ExchangeRate__c=1.55555;
        insert amount;
        
        
        Pagereference VFP91 = Page.VFP91_AmountsExchangeRate;
        Test.setCurrentPage(VFP91);
        ApexPages.currentPage().getParameters().put('Id', amount.Id);
        
        
        Test.startTest();
        
        VFC91_AmountsExchangeRate VFC91 = new VFC91_AmountsExchangeRate(new ApexPages.StandardController(amount));

        Test.stopTest();

    }
     static testMethod void VFC91_AmountsExchangeRateNmsg_TEST() 
    {
        Account account = UtilityTestMethod.getAccounts(1).get(0);
        insert account;
       
        Opportunity opp = UtilityTestMethod.getOpportunities(1).get(0);
        opp.AccountId = account.Id;
        //opp.CloseDate =date.today();
        insert opp;
        
        Tender__c tender = UtilityTestMethod.getTender(opp.Id);
        insert tender;
        
        Amounts__c amount = UtilityTestMethod.getAmounts(tender.Id);
        amount.CurrencyIsoCode='BGL';
        amount.ExchangeRate__c=1.9558;
        insert amount;
        Pagereference VFP91 = Page.VFP91_AmountsExchangeRate;
        Test.setCurrentPage(VFP91);
        ApexPages.currentPage().getParameters().put('Id', amount.Id);
        
        
        Test.startTest();
        
        VFC91_AmountsExchangeRate VFC91 = new VFC91_AmountsExchangeRate(new ApexPages.StandardController(amount));

        Test.stopTest();
        
        
    }
}