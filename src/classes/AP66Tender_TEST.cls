@isTest
private class AP66Tender_TEST 
{
    static testMethod void AP66Tender_TEST() 
    {
		Account acc = UtilityTestMethod.getAccount();
        insert acc;
        
        Opportunity opp = UtilityTestMethod.getOpportunity();
        opp.AccountId = acc.Id;
        insert opp;
        
        Tender__c tender = UtilityTestMethod.getTender(opp.Id);
        
        Test.startTest();
        
        insert tender;
        
        Test.stopTest();
        
        System.assertEquals([Select Body from FeedItem where ParentId = :tender.Opportunity__c Limit 1].Body, System.Label.LBL0301);
    }
}