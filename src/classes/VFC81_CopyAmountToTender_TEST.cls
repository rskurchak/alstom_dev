@isTest
private class VFC81_CopyAmountToTender_TEST 
{
    static testMethod void VFC81_CopyAmountToTender_TEST1() 
    {
    	Account acc = UtilityTestMethod.getAccount();
        insert acc;
        
        Opportunity opp = UtilityTestMethod.getOpportunity();
        opp.AccountId = acc.Id;
        opp.LeadingProductLine__c = 'Rolling Stock & Components';
        opp.Platform__c = 'Mainlines';
        insert opp;
        
        Tender__c tender = UtilityTestMethod.getTender(opp.Id);
        insert tender;
        
        Amounts__c amount = new Amounts__c();
        amount.Tender__c = tender.Id;
        amount.Option__c = false;
        amount.MinimumSellingPrice__c = 40000000;
        amount.ExchangeRate__c = 1;
		amount.GrossMargin__c = 10;
        amount.GrossMarginAdjusted__c = 20;
		amount.OperatingMargin__c = 30;       
        amount.NetMargin__c = 40;
        amount.Contingencies__c = 50;
        amount.Ambition__c = 60;
        amount.DownPayment__c = 70;
        amount.OnwardPayment__c = 80;
        Amount.ExchangeRate__c =1.3738;
        insert amount;
        // Querying to get the formula value
        amount = [Select Id, Tender__c, Option__c, MinimumSellingPrice__c , MinimumSellingPriceMEUR__c, 
                 		 GrossMargin__c, GrossMarginAdjusted__c, OperatingMargin__c, 
                  		 NetMargin__c, Contingencies__c, Ambition__c, DownPayment__c, 
                  		 OnwardPayment__c, ExchangeRate__c from Amounts__c where Id = :amount.Id];
        
        Test.startTest();
        
        PageReference VFP81 = Page.VFP81_CopyAmountToTender;
		Test.setCurrentPage(VFP81);
		ApexPages.currentPage().getParameters().put('id', amount.Id);
		VFC81_CopyAmountToTender VFC81 = new VFC81_CopyAmountToTender(new ApexPages.StandardController(amount));
		VFC81.copyAmountToTender();
            
        Test.stopTest();
        
        // Checking that Tender values were updated correctly
        Tender__c resultTender = [Select Id, SellingPrice__c, Gross_Margin__c, GrossMarginAdjusted__c,
										 OperatingMargin__c, NetMargin__c, Contingencies__c, Ambitions__c,
                                 		 DownPayment__c, OnwardPayment__c, ConversionRate__c from Tender__c where Id = :tender.Id];
        
        System.assertEquals(amount.MinimumSellingPriceMEUR__c * 1000000, resultTender.SellingPrice__c);
        System.assertEquals(amount.GrossMargin__c, resultTender.Gross_Margin__c);
        System.assertEquals(amount.GrossMarginAdjusted__c, resultTender.GrossMarginAdjusted__c);
        System.assertEquals(amount.OperatingMargin__c, resultTender.OperatingMargin__c);
        System.assertEquals(amount.NetMargin__c, resultTender.NetMargin__c);
        System.assertEquals(amount.Contingencies__c, resultTender.Contingencies__c);
        System.assertEquals(amount.Ambition__c, resultTender.Ambitions__c);
        System.assertEquals(amount.DownPayment__c, resultTender.DownPayment__c);
        System.assertEquals(amount.OnwardPayment__c, resultTender.OnwardPayment__c);
        System.assertEquals(amount.ExchangeRate__c, resultTender.ConversionRate__c);
    }
    
    static testMethod void VFC81_CopyAmountToTender_TEST() 
    {
    	Account acc = UtilityTestMethod.getAccount();
        insert acc;
        
        Opportunity opp = UtilityTestMethod.getOpportunity();
        opp.AccountId = acc.Id;
        opp.LeadingProductLine__c = 'Rolling Stock & Components';
        opp.Platform__c = 'Mainlines';
        insert opp;
        
        Tender__c tender = UtilityTestMethod.getTender(opp.Id);
        insert tender;
        
        Amounts__c amount = new Amounts__c();
        amount.Tender__c = tender.Id;
        amount.Option__c = true;
        amount.MinimumSellingPrice__c = 40000000;
        amount.ExchangeRate__c = 1;
		amount.GrossMargin__c = 10;
        amount.GrossMarginAdjusted__c = 20;
		amount.OperatingMargin__c = 30;       
        amount.NetMargin__c = 40;
        amount.Contingencies__c = 50;
        amount.Ambition__c = 60;
        amount.DownPayment__c = 70;
        amount.OnwardPayment__c = 80;
        insert amount;
        // Querying to get the formula value
        amount = [Select Id, Tender__c, Option__c, MinimumSellingPrice__c , MinimumSellingPriceMEUR__c, 
                 		 GrossMargin__c, GrossMarginAdjusted__c, OperatingMargin__c, 
                  		 NetMargin__c, Contingencies__c, Ambition__c, DownPayment__c, 
                  		 OnwardPayment__c, ExchangeRate__c from Amounts__c where Id = :amount.Id];
        
        Test.startTest();
        
        PageReference VFP81 = Page.VFP81_CopyAmountToTender;
		Test.setCurrentPage(VFP81);
		ApexPages.currentPage().getParameters().put('id', amount.Id);
		VFC81_CopyAmountToTender VFC81 = new VFC81_CopyAmountToTender(new ApexPages.StandardController(amount));
		VFC81.copyAmountToTender();
            
        Test.stopTest();
        
        // Checking that Tender values were updated correctly
        Tender__c resultTender = [Select Id, OptionsSellingPrice__c, OptionsGrossMargin__c, OptionsGrossMarginAdjusted__c,
										 OptionsOperatingMargin__c, OptionsNetMargin__c, OptionsContingencies__c, OptionsAmbitions__c,
                                 		 DownPayment__c, OnwardPayment__c, OptionConversionRate__c from Tender__c where Id = :tender.Id];
        
        System.assertEquals(amount.MinimumSellingPriceMEUR__c * 1000000, resultTender.OptionsSellingPrice__c);
        System.assertEquals(amount.GrossMargin__c, resultTender.OptionsGrossMargin__c);
        System.assertEquals(amount.GrossMarginAdjusted__c, resultTender.OptionsGrossMarginAdjusted__c);
        System.assertEquals(amount.OperatingMargin__c, resultTender.OptionsOperatingMargin__c);
        System.assertEquals(amount.NetMargin__c, resultTender.OptionsNetMargin__c);
        System.assertEquals(amount.Contingencies__c, resultTender.OptionsContingencies__c);
        System.assertEquals(amount.Ambition__c, resultTender.OptionsAmbitions__c);
        System.assertEquals(amount.ExchangeRate__c, resultTender.OptionConversionRate__c);
    }
}