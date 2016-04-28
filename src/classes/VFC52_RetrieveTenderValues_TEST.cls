@isTest
private class VFC52_RetrieveTenderValues_TEST 
{
    static testMethod void VFC52_RetrieveTenderValues_TEST() 
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

        Amounts__c amount = UtilityTestMethod.getAmounts(tender.Id);
        amount.Name = 'Amount';
        insert amount;
    
        TenderSubmission__c ts = new TenderSubmission__c(Name = 'My TS', Tender__c = tender.Id);
        insert ts;
        
        Test.startTest();
        
        PageReference VFP52 = Page.VFP52_RetrieveTenderValues; 
        Test.setCurrentPage(VFP52);
        ApexPages.currentPage().getParameters().put('Id', ts.Id);
        
        VFC52_RetrieveTenderValues VFC52 = new VFC52_RetrieveTenderValues(new ApexPages.StandardController(ts));
        VFC52.retrieveTenderValues();
        VFC52.back();
        
        Test.stopTest();
    }
}