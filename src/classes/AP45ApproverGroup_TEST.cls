@isTest
private class AP45ApproverGroup_TEST 
{
    static testMethod void AP45ApproverGroup_TEST() 
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
    
        TenderSubmission__c ts = new TenderSubmission__c();
        ts.Name = 'My TS';
        ts.Tender__c = tender.Id;
        insert ts;
        
        List<User> listUsers = UtilityTestMethod.getActiveUsers(3);

        ApproverGroup__c ag = new ApproverGroup__c();
        ag.ApproverGroupName__c = 'Experts';
        ag.Submission__c = ts.Id;
        ag.Approver1__c = listUsers.get(0).Id;
        ag.Approver3__c = listUsers.get(1).Id;
        
        Test.startTest();
        
        insert ag;
        ag = [Select Id, Approver1__c, Approver2__c, Approver3__c from ApproverGroup__c where Id = :ag.Id LIMIT 1];
        System.assertEquals(listUsers.get(0).Id, ag.Approver1__c, 'Approver Group User 1 not correct.');
        System.assertEquals(listUsers.get(1).Id, ag.Approver2__c, 'Approver Group User 2 not correct.');
        System.assertEquals(null, ag.Approver3__c, 'Approver Group User 3 not correct.');
        
        ag.Approver10__c = listUsers.get(2).Id;
        update ag;
        ag = [Select Id, Approver1__c, Approver2__c, Approver3__c, Approver4__c, Approver5__c,
                Approver6__c, Approver7__c, Approver8__c, Approver9__c, Approver10__c from ApproverGroup__c where Id = :ag.Id LIMIT 1];
        System.assertEquals(listUsers.get(0).Id, ag.Approver1__c, 'Approver Group User 1 not correct.');
        System.assertEquals(listUsers.get(1).Id, ag.Approver2__c, 'Approver Group User 2 not correct.');
        System.assertEquals(listUsers.get(2).Id, ag.Approver3__c, 'Approver Group User 3 not correct.');
        System.assertEquals(null, ag.Approver4__c, 'Approver Group User 4 not correct.');
        System.assertEquals(null, ag.Approver5__c, 'Approver Group User 5 not correct.');
        System.assertEquals(null, ag.Approver6__c, 'Approver Group User 6 not correct.');
        System.assertEquals(null, ag.Approver7__c, 'Approver Group User 7 not correct.');
        System.assertEquals(null, ag.Approver8__c, 'Approver Group User 8 not correct.');
        System.assertEquals(null, ag.Approver9__c, 'Approver Group User 9 not correct.');
        System.assertEquals(null, ag.Approver10__c, 'Approver Group User 10 not correct.');
        
        Test.stopTest();
    }
}