@isTest
private class AP43TenderSubmission_TEST 
{
    static testMethod void AP43TenderSubmission_TEST() 
    {
        Account acc = UtilityTestMethod.getAccount();
        insert acc;
        
        Opportunity opp = UtilityTestMethod.getOpportunity();
        opp.AccountId = acc.Id;
        opp.LeadingProductLine__c = 'Rolling Stock & Components';
        opp.Platform__c = 'Mainlines';
        //opp.BOid__c = '12345';
        insert opp;
        
        Tender__c tender = UtilityTestMethod.getTender(opp.Id);
        insert tender;

        Amounts__c amount = UtilityTestMethod.getAmounts(tender.Id);
        amount.Name = 'Amount';
        insert amount;
    
        TenderSubmission__c ts = new TenderSubmission__c(Name = 'My TS', Tender__c = tender.Id);
        
        Test.startTest();
        
        insert ts;
        
        Test.stopTest();
    }
}