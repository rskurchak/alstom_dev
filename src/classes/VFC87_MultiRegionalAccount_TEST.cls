@isTest
public with sharing class VFC87_MultiRegionalAccount_TEST 
{
	public static testMethod void VFC87_MultiRegionalAccount_TEST()
	{
		Account acc = UtilityTestMethod.getAccount();
		insert acc;
		
		Opportunity opp = UtilityTestMethod.getOpportunity();
		insert opp;
		
		opp.AccountId = acc.Id;
		update opp;
		
		Test.startTest();
        
        PageReference VFP87 = Page.VFP87_MultiRegionalAccounts;
		Test.setCurrentPage(VFP87);
		ApexPages.currentPage().getParameters().put('id', acc.Id);
		VFC87_MultiRegionalAccount VFC87 = new VFC87_MultiRegionalAccount();
         
        Test.stopTest();
	}

}