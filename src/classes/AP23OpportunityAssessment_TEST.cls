/**
 * This class contains unit tests for validating the behavior of AP23OpportunityAssessment Apex classes
 * and triggers.
 *   ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com
     ~ Date Created    : 21/03/2013
 */
@isTest
private class AP23OpportunityAssessment_TEST 
{
    static testMethod void AP23OpportunityAssessment_TEST() 
    {
    	Opportunity opp = UtilityTestMethod.getOpportunity();
		insert opp;
		
		OpportunityAssessment__c oa = new OpportunityAssessment__c(Opportunity__c = opp.Id, AssessmentVersion__c = '123456');
		
		
		test.startTest();
		
		insert oa;
		oa.BenefitROIQuantified__c = true;
		update oa;
		
		test.stopTest();
	}
}