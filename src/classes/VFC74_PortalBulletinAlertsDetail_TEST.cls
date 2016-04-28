/*
  Class Test Controller for VFC74_PortalBulletinAlertsDetail
   ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
   ~ Date Created    : 02/07/2014 
*/
@isTest
private class VFC74_PortalBulletinAlertsDetail_TEST {
    static testMethod void testVFC74() {
        System.debug('## >>>>> testing class VFC74_PortalBulletinAlertsDetail START <<<<<');
        Account account = UtilityTestMethod.getAccount();
        insert account;        
        Bulletin__c bulletintest = new Bulletin__c(Name='Alert test', Account__c = account.Id, Language__c = 'EN', Status__c = 'Published', Type__c = 'Alert', Text__c = 'test text', Is_Obsolescence_Alert__c = true);
        insert bulletintest;
        note n = new note(parentId=bulletintest.Id, body='news note', title='news note title', isPrivate=false);
        insert n;        
        
        Test.startTest();
        PageReference VFP74 = Page.VFP74_PortalBulletinAlertsDetail; 
        Test.setCurrentPage(VFP74);
        ApexPages.currentPage().getParameters().put('Id', bulletintest.Id);
        VFC74_PortalBulletinAlertsDetail VFC74 = new VFC74_PortalBulletinAlertsDetail(new ApexPages.StandardController(bulletintest));
        VFC74.createReadReceipt();
        VFC74.redirectView();
        Test.stopTest();        
        System.debug('## >>>>> testing class VFC74_PortalBulletinAlertsDetail END <<<<<');
    }
}