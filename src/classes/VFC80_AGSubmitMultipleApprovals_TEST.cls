@isTest
private class VFC80_AGSubmitMultipleApprovals_TEST 
{
	static testMethod void submitWithSuccess() 
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
        
        List<User> listUsers = UtilityTestMethod.getActiveUsers(2);

        ApproverGroup__c ag = new ApproverGroup__c();
        ag.ApproverGroupName__c = 'Experts';
        ag.Submission__c = ts.Id;
        ag.Approver1__c = listUsers.get(0).Id;
        ag.Approver2__c = listUsers.get(1).Id;
        insert ag;

        Test.startTest();

		PageReference VFP80 = Page.VFP80_AGSubmitMultipleApprovals;
		Test.setCurrentPage(VFP80);
		ApexPages.currentPage().getParameters().put('id', ts.Id);
		VFC80_AGSubmitMultipleApprovals VFC80 = new VFC80_AGSubmitMultipleApprovals(new ApexPages.StandardController(ts));
		VFC80.submitForMultipleApprovals();

        Test.stopTest();

		List<ProcessInstance> pi = [select Id, Status from ProcessInstance where TargetObjectId = :ag.Id];
		System.assertEquals('Pending', pi.get(0).Status);
    }

    static testMethod void submitWithError() 
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
        
        List<User> listUsers = UtilityTestMethod.getActiveUsers(1);

        ApproverGroup__c ag = new ApproverGroup__c();
        ag.ApproverGroupName__c = 'Experts';
        ag.Submission__c = ts.Id;
        ag.Approver1__c = listUsers.get(0).Id;
        insert ag;

        Approval.ProcessSubmitRequest apRequest = new Approval.ProcessSubmitRequest();
		apRequest.setObjectId(ag.Id);
		
        Test.startTest();

		PageReference VFP80 = Page.VFP80_AGSubmitMultipleApprovals;
		Test.setCurrentPage(VFP80);
		ApexPages.currentPage().getParameters().put('id', ts.Id);
		VFC80_AGSubmitMultipleApprovals VFC80 = new VFC80_AGSubmitMultipleApprovals(new ApexPages.StandardController(ts));
		Approval.process(apRequest);
		VFC80.submitForMultipleApprovals();

        Test.stopTest();

		// Assertion that exception is correctly catched
		System.assert(ApexPages.getMessages().size() > 0);
    }
}