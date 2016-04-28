/**
 * This class contains unit tests for validating the behavior of AP65ProjectPeriodicReport Apex Class
 * and triggers.
 *   ~ Author          : Christophe AVERSENG 
     ~ Date Created    : 15/05/2014
 */
@isTest
private class AP65ProjectPeriodicReport_TEST 
{
    static testMethod void AP65ProjectPeriodicReport_TEST() 
    {
        Project__c prj = UtilityTestMethod.getProject();
        insert prj;
        
        ProjectPeriodicReport__c pr = new ProjectPeriodicReport__c(Project__c = prj.Id, ReportDate__c = DateTime.Now(), Name = 'My Periodic Report');
        ProjectPeriodicReport__c pr2 = new ProjectPeriodicReport__c(Project__c = prj.Id, ReportDate__c = DateTime.Now()+1, Name = 'My Periodic Report 2');
        
        test.startTest();
        
        insert pr;
        insert pr2;
          
        pr.ReportDate__c = DateTime.Now()+3;
        update pr;
        delete pr;
        undelete pr;
            
        test.stopTest();
    }
}