/**
 * This class contains unit tests for validating the behavior of VFC65_DisplaySharingUsersListOfProject Apex Class.
 *   ~ Author          : Christophe AVERSENG
     ~ Date Created    : 06/05/2014 - copied and adapted from VFC56..._TEST
 */
@isTest
private class VFC65_DisplaySharingListProject_TEST {

    static testMethod void VFC65_DisplaySharingListProject_TEST() {
         // data testing
        System.debug('## Create Account ..');
        Account account = UtilityTestMethod.getAccount();
        insert account;
       
        Project__c project = UtilityTestMethod.getProject();
        project.Account__c = account.Id;
        insert project;
        
        Test.startTest();
        
        PageReference VFP65 = Page.VFP65_DisplaySharingUsersListOfProject; 
        Test.setCurrentPage(VFP65);
        ApexPages.currentPage().getParameters().put('Id', project.Id);
        VFC65_DisplaySharingUsersListOfProject vfc65 = new VFC65_DisplaySharingUsersListOfProject(new ApexPages.StandardController(project));
        
        Test.stopTest();
    }
}