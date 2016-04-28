/**
 AP40Tender_Test 
    ~ Author            : jawad.ghoulam@cgi.com
    ~ Modification Date : 03/09/2013
    ~ Description       : This class contains unit tests for validating the behavior of Apex classes.
 */
@isTest
private class AP40Tender_Test {

    static testMethod void myUnitTest() {       
        Opportunity opp = UtilityTestMethod.getOpportunity();
        opp.LeadingProductLine__c = 'Information Solutions';
        opp.Platform__c = 'Alstom RS Solutions';
        insert opp;
        
        Tender__c tend = UtilityTestMethod.getTender(opp.Id);
        
        test.startTest();
        
        insert tend;
        delete tend;
        undelete tend;
        
        test.stopTest();
    }
}