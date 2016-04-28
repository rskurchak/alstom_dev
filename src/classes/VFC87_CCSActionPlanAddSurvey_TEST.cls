/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class VFC87_CCSActionPlanAddSurvey_TEST {

    static testMethod void VFC87_CCSActionPlanAddSurvey_TEST() {
    	Project__c ProjectCur = UtilityTestMethod.getProject();
    	insert ProjectCur;
    	
    	CSSActionPlan__c CSSActionPlanCur = UtilityTestMethod.getCSSActionPlan(ProjectCur.Id);
    	insert CSSActionPlanCur;
    	
    	ProjectSurvey__c ProjectSurveyCur = UtilityTestMethod.getProjectSurvey(ProjectCur.Id);
    	insert ProjectSurveyCur;
    	
    	ProjectSurvey__c ProjectSurveyCur2 = UtilityTestMethod.getProjectSurvey(ProjectCur.Id,CSSActionPlanCur.Id);
    	insert ProjectSurveyCur2;
    	
		Test.startTest();
        
        PageReference VFP87 = Page.VFP87_CCSActionPlanAddSurvey;
		Test.setCurrentPage(VFP87);
		ApexPages.currentPage().getParameters().put('id', CSSActionPlanCur.Id);
		VFC87_CCSActionPlanAddSurvey VFC87 = new VFC87_CCSActionPlanAddSurvey(new ApexPages.StandardController(CSSActionPlanCur));
        PageReference pr = VFC87.AddRemoveSurvey();
        
        
        
        Test.stopTest();
       	System.assertEquals(true, pr.getUrl().contains(CSSActionPlanCur.Id));
    }
}