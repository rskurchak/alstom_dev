/**
 * This class contains unit tests for validating the behavior of SchedulerTenderSharing & BatchTenderSharing APEX Class
 * and triggers.
 *   ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com 
     ~ Date Created    : 12/06/2013
 */
@isTest
private class SchedulerTenderSharing_TEST 
{
    static testMethod void SchedulerTenderSharing_TEST()
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
    
        TenderSubmission__c ts = new TenderSubmission__c();
        ts.Name = 'My TS';
        ts.Tender__c = tender.Id;
        insert ts;
        
        List<User> listUsers = UtilityTestMethod.getActiveUsers(2);

        ApproverGroup__c ag = new ApproverGroup__c();
        ag.ApproverGroupName__c = 'Experts';
        ag.Submission__c = ts.Id;
        ag.Approver1__c = listUsers.get(0).Id;
        insert ag;
        
        Tender__Share tenderShare = new Tender__Share(AccessLevel='Edit', ParentId=tender.Id, RowCause='Manual', UserOrGroupId=listUsers.get(1).Id);
        insert tenderShare;
        
        Test.startTest();

        SchedulerTenderSharing s = new SchedulerTenderSharing();
        String sch = '0 0 23 * * ?'; 
        system.schedule('SchedulerTenderSharing', sch, s);
        
        Test.stopTest();
    }
}