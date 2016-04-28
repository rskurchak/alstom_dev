@isTest
private class AP46ApproverGroup_TEST 
{
    static testMethod void AP46ApproverGroup_TEST() 
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
        delete ag;
        undelete ag;
        delete ts;
        undelete ts;
        
        Test.stopTest();
    }
}