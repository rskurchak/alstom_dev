/*
  Class Test Controller for VFC74_BulletinCreateReadReceipt
   ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
   ~ Date Created    : 18/04/2014 
*/
@isTest
private class VFC74_BulletinCreateReadReceipt_TEST {
    static testMethod void testVFC74() {
        System.debug('## >>>>> testing class VFC74_BulletinCreateReadReceipt START <<<<<');
        Account account = UtilityTestMethod.getAccount();
        insert account;
        Bulletin__c alert = new Bulletin__c(Name='Alert test', Account__c = account.Id, Language__c = 'EN', Status__c = 'Published', Type__c = 'Alert', Text__c = 'test text');
        insert alert;
        
        Test.startTest();
        PageReference VFP74 = Page.VFP74_BulletinCreateReadReceipt; 
        Test.setCurrentPage(VFP74);
        ApexPages.currentPage().getParameters().put('Id', alert.Id);
        VFC74_BulletinCreateReadReceipt VFC74 = new VFC74_BulletinCreateReadReceipt(new ApexPages.StandardController(alert));
        VFC74.createReadReceipt();
        Test.stopTest();        
        System.debug('## >>>>> testing class VFC74_BulletinCreateReadReceipt END <<<<<');
    }
}