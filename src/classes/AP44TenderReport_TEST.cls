/**
 * This class contains unit tests for validating the behavior of AP44TenderReport Apex Class
 * and triggers.
 *   ~ Author          : Jawad GHOULAM ~ jawad.ghoulam@cgi.com 
     ~ Date Created    : 26/09/2013
 */
@isTest
private class AP44TenderReport_TEST {

    static testMethod void AP44TenderReport_Test() {
        Opportunity opp = UtilityTestMethod.getOpportunity();
        //opp.BOID__c = '192';
        opp.LeadingProductLine__c = 'Information Solutions';
        opp.Platform__c = 'Alstom RS Solutions';
        insert opp;
        
        Tender__c tend = UtilityTestMethod.getTender(opp.Id);
        insert tend;
        
        TenderReport__c tr = new TenderReport__c(Tender__c = tend.Id, ReportDate__c = DateTime.Now(), Name = 'My Tender Report');
        TenderReport__c tr2 = new TenderReport__c(Tender__c = tend.Id, ReportDate__c = DateTime.Now()+1, Name = 'My Tender Report 2');
        
        test.startTest();
        
        insert tr;
        insert tr2;
            
        tr.ReportDate__c = DateTime.Now()+3;
        update tr;
        delete tr;
        undelete tr;
        
        test.stopTest();
    }
}