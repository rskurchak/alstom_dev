/*
  Class Test Controller for VFC79_PortalTrainingSessionDetail
   ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
   ~ Date Created    : 02/07/2014 
*/
@isTest
private class VFC79_PortalTrainingSessionDetail_TEST {
    static testMethod void testVFC79() {
        System.debug('## >>>>> testing class VFC79_PortalTrainingSessionDetail START <<<<<');
        Account account = UtilityTestMethod.getAccount();
        insert account;        
        TrainingSession__c trainingtest = new TrainingSession__c(Name='Training Session test', Account__c = account.Id, Date__c = Date.Today(), Description__c = 'test Description');
        insert trainingtest;
        note n = new note(parentId=trainingtest.Id, body='news note', title='news note title', isPrivate=false);
        insert n;      
        
        Test.startTest();
        PageReference VFP79 = Page.VFP79_PortalTrainingSessionDetail; 
        Test.setCurrentPage(VFP79);
        ApexPages.currentPage().getParameters().put('Id', trainingtest.Id);
        VFC79_PortalTrainingSessionDetail VFC79 = new VFC79_PortalTrainingSessionDetail(new ApexPages.StandardController(trainingtest));
        VFC79.redirectView();
        Test.stopTest();        
        System.debug('## >>>>> testing class VFC79_PortalTrainingSessionDetail END <<<<<');
    }
}