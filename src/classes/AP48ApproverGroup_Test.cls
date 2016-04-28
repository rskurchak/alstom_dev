/**
 * This class contains unit tests for validating the behavior of AP48ApproverGroup Apex Class
 * and triggers.
 *   ~ Author          : Jawad GHOULAM ~ jawad.ghoulam@cgi.com 
     ~ Date Created    : 09/10/2013
 */
@isTest
private class AP48ApproverGroup_Test {

    static testMethod void AP48ApproverGroup_Test() 
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
    
        TenderSubmission__c ts = new TenderSubmission__c();
        ts.Name = 'My TS';
        ts.Tender__c = tender.Id;
        insert ts;
        
        List<User> listUsers = UtilityTestMethod.getActiveUsers(3);

        ApproverGroup__c ag = new ApproverGroup__c();
        ag.ApproverGroupName__c = 'Experts';
        ag.Submission__c = ts.Id;
        ag.Approver1__c = listUsers.get(0).Id;
        ag.Approver2__c = listUsers.get(1).Id;
        
        Test.startTest();
        
        insert ag;
        ag.Approver2__c = listUsers.get(2).Id;
        update ag;

        Test.stopTest();
    }
}