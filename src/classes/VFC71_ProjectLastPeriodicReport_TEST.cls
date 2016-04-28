/*
 * This class contains unit tests for validating the behavior of VFC71_ProjectLastPeriodicReport Apex Class
 * and triggers.
 *   ~ Author           : Christophe Averseng
     ~ Date Created     : 19/05/2014 - copied from VFC30
*/
@isTest
private class VFC71_ProjectLastPeriodicReport_TEST 
{
    static testMethod void VFC71_ProjectLastPeriodicReportWithPR_TEST() 
    {
        Project__c prj = UtilityTestMethod.getProject();
        insert prj;
        
        ProjectPeriodicReport__c pr = new ProjectPeriodicReport__c(Project__c = prj.Id);
        insert pr;
        
        PageReference VFP71 = Page.VFP71_ProjectLastPeriodicReport; 
        Test.setCurrentPage(VFP71);
        ApexPages.currentPage().getParameters().put('Id', prj.Id);
        
        
        Test.startTest();
        
        VFC71_ProjectLastPeriodicReport VFC71 = new VFC71_ProjectLastPeriodicReport(new ApexPages.StandardController(prj));

        Test.stopTest();
    }
    
    static testMethod void VFC71_ProjectLastPeriodicReportNoPR_TEST() 
    {
        Project__c prj = UtilityTestMethod.getProject();
        insert prj;
        
        PageReference VFP71 = Page.VFP71_ProjectLastPeriodicReport; 
        Test.setCurrentPage(VFP71);
        ApexPages.currentPage().getParameters().put('Id', prj.Id);
        
        
        Test.startTest();
        
        VFC71_ProjectLastPeriodicReport VFC71 = new VFC71_ProjectLastPeriodicReport(new ApexPages.StandardController(prj));
        
        Test.stopTest();
    }
}