/**
 * This class contains unit tests for validating the behavior of AP64ProjectProduct Apex classes
 * and triggers.
 * Christophe AVERSENG - copied from AP07Product_TEST
 */
@isTest
private class AP64ProjectProduct_TEST 
{
    static testMethod void testAP64() 
    {
        System.debug('## >>>>> testing class AP64ProjectProduct START <<<<<');
        
        // data testing
        System.debug('## Create accounts..');
        List<Account> accounts = UtilityTestMethod.getAccounts(1);
        insert accounts;
        
        System.debug('## Create project.. ');
        Project__c prj = UtilityTestMethod.getProject();
        prj.Account__c = accounts.get(0).Id;
        prj.ProductLine__c = 'TEST PL';
        prj.Platform__c = 'TEST Platform';
        prj.Product__c = 'TEST Product';
        insert prj;
        
        System.debug('## Create Project Products.. ');
        List<ProjectProduct__c> prds = UtilityTestMethod.getProjectProducts(2);
        prds.get(0).Project__c = prj.Id;
        prds.get(0).Leading__c = true;
        prds.get(1).Project__c = prj.Id;
        prds.get(1).Leading__c = true;
        
        Test.startTest();
        //test triggers : insert
        insert prds;
    
        prds.get(1).ProductLine__c = 'New Platform';
        prds.get(1).Leading__c = true;
        //test triggers : update
        update prds.get(1);
        Test.stopTest();
        
        System.debug('## >>>>> testing class AP64ProjectProduct END <<<<<');
    }
}