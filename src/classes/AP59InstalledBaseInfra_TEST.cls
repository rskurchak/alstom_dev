/**
 * This class contains unit tests for validating the behavior of AP59InstalledBaseInfra Apex classes
 * and triggers.
 *   ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
     ~ Date Created    : 26/02/2014
 */
@isTest
private class AP59InstalledBaseInfra_TEST {
    static testMethod void testAP59() 
    {
        System.debug('## >>>>> testing class AP59InstalledBaseInfra START <<<<<');
        
        // data testing
        System.debug('## Create account id..');
        Account account = UtilityTestMethod.getAccounts(1).get(0);
        insert account;
		
        InstalledBaseInfra__c InstalledBaseInfra = new InstalledBaseInfra__c(Account__c = account.id, Name = 'Test', EquipmentClass__c = 'Electronic interlocking');        
        System.debug('## Create Installed Base Infra ..');
        Test.startTest();
        insert InstalledBaseInfra;
        InstalledBaseInfra.EquipmentClass__c = 'PIS';
        update InstalledBaseInfra;
        Test.stopTest();
        
        System.debug('## >>>>> testing class AP59InstalledBaseInfra END <<<<<'); 
    }
}