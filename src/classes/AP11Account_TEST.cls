/**
 * This class contains unit tests for validating the behavior of AP11Account Apex classes
 * and triggers.
 *   ~ Author          : Mohamed EL MOUSSAOUI ~ mohamed.el-moussaoui@axoa.fr 
     ~ Date Created    : 01/08/2012
 */
@isTest
private class AP11Account_TEST 
{
    static testMethod void testAP11() 
    {
        System.debug('## >>>>> testing class AP11Account START <<<<<');
        
        // data testing
        System.debug('## Create Account ..');
        Account parentAccount = UtilityTestMethod.getAccount();
        parentAccount.IsAGlobalAccount__c = true;
        insert parentAccount ;
        
        Account childAccount = UtilityTestMethod.getAccount();
		childAccount.ParentId = parentAccount.Id;

        Test.startTest();
		
		//trigger testing : insert
		insert childAccount;
		
        //trigger testing : update
		parentAccount.IsAGlobalAccount__c = false;
        try { update parentAccount; }
        catch(Exception ex)
        {
        	System.debug('AP11 Test Method error Msg :'+ex);	
        }

        Test.stopTest();
        
        System.debug('## >>>>> testing class AP11Account END <<<<<'); 
    }
}