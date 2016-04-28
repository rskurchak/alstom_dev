/*
 VFC11_BPSMap_TEST
    ~ Author            : Adrian Modolea ~ adrian.modolea@axoa.fr
    ~ Created Date 		: 09/02/2012
    ~ Description       : Apex controller for visualforce page VFC11_BPSMap
    						This class contains unit tests for validating the behavior 
    						of  Apex class (and IconPicklistValue apex class)
*/
@isTest
class VFC11_BPSMap_TEST 
{
    static testMethod void testVFC11_BPSMap_TEST() 
    {
        System.debug('## >>>>> testing class VFC11_BPSMap_TEST START <<<<<');
		
		System.debug('## Preparing test..');
		Account account = UtilityTestMethod.getAccount();
		insert account;
		Contact contact = UtilityTestMethod.getContacts(1).get(0);
		insert contact;
		Opportunity opp = UtilityTestMethod.getOpportunity();
		opp.AccountId = account.Id;
		insert opp;
		
		//
		OpportunityAssessment__c oppAsse = UtilityTestMethod.getOpportunityAssessement();
		oppAsse.Opportunity__c = opp.Id;
		insert oppAsse;
		
		//
		BuyingProcessStakeholder__c bps = UtilityTestMethod.getBuyingProcessStakeholder();
		bps.Opportunity__c = opp.id;
		insert bps;
		
		Attachment jsonFile = new Attachment(Name='TECH_JSON_PLAN', ParentId=oppAsse.Id, Body=Blob.valueOf('json'));
		Attachment htmlFile = new Attachment(Name='TECH_HTML_PLAN', ParentId=oppAsse.Id, Body=Blob.valueOf('html'));
		insert new List<Attachment>{jsonFile, htmlFile};	
		
        
        Test.startTest();
        PageReference pageRef = Page.VFP11_BPSMap; 
        Test.setCurrentPage(pageRef);
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('oppAsId', oppAsse.Id);   
        ApexPages.currentPage().getParameters().put('oppId', opp.Id);        
        VFC11_BPSMap vfc11 = new VFC11_BPSMap();
		System.debug('## test vfc11.availableBpcs : ' + vfc11.availableBpcs.size());        
        System.debug('## test vfc11.htmlContent : ' + vfc11.htmlContent);
        System.debug('## test vfc11.currentJSONContent : ' + vfc11.currentJSONContent);
        vfc11.deleteBPSId = bps.Id;
        vfc11.deleteBPS();
        Test.stopTest();
        
        System.debug('## >>>>> testing class VFC11_BPSMap_TEST END <<<<<');
    }
}