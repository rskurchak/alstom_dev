/*
 CCC09_BPS_TEST
    ~ Author            : Adrian Modolea ~ adrian.modolea@axoa.fr
    ~ Created Date      : 09/02/2012
    ~ Description       : Apex controller for visualforce component CCC09_BPS
                            This class contains unit tests for validating the behavior 
                            of CCC09_BPS Apex class (and IconPicklistValue apex class)
*/
@isTest
class CCC09_BPS_TEST 
{
    static testMethod void testCCC09_BPS_TEST() 
    {
        System.debug('## >>>>> testing class CCC09_BPS_TEST START <<<<<');
        
        System.debug('## Preparing test..');
        Account account = UtilityTestMethod.getAccount();
        insert account;
        Contact contact = UtilityTestMethod.getContacts(1).get(0);
        insert contact;
        Opportunity opp = UtilityTestMethod.getOpportunity();
        opp.AccountId = account.Id;
        insert opp;
        
        Test.startTest();
        CCC09_BPS ccc09 = new CCC09_BPS();
        System.debug('## test getWCSIcons() : ' + ccc09.getWCSIcons().size());
        
        System.debug('## test saveBPS() without required fiels => espected error occurs');
        ccc09.saveBPS();
        
        System.debug('## test saveBPS() with dml exception');
        ccc09.bps.DecisionMaker__c = true;
        ccc09.saveBPS();
        
        ccc09.oppId = opp.Id;
        
        System.debug('## test saveBPS() with all required fiels => bps will be inserted');
        ccc09.saveBPS();
        
        System.debug('## test saveBPS() with all required fiels => bps will be updated');
        ccc09.bps.ContactName__c = contact.Id;
        //ccc09.bps.AlstomUser__c = null;
        System.debug('Title : ' + ccc09.contactTitle);
        ccc09.saveBPS();
        
        System.debug('## test cancel()');
        ccc09.cancel();
        
        Test.stopTest();
        
        System.debug('## >>>>> testing class CCC09_BPS_TEST END <<<<<');
    }
}