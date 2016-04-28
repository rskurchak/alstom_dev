/**
 * This class contains unit tests for validating the behavior of AP12Competitor Apex classes
 * and triggers.
 *   ~ Author          : Mohamed EL MOUSSAOUI ~ mohamed.el-moussaoui@axoa.fr 
     ~ Date Created    : 01/08/2012
 */
@isTest
private class AP12Competitor_TEST
{
    static testMethod void testAP12() 
    {
        System.debug('## >>>>> testing class AP12Competitor START <<<<<');
        
        // data testing
        System.debug('## Create Competitor ..');
        Competitor__c parentCompetitor = UtilityTestMethod.getCompetitors(1).get(0);
        parentCompetitor.IsAGlobalCompetitor__c = true;
        insert parentCompetitor ;
		Competitor__c childCompetitor = UtilityTestMethod.getCompetitors(1).get(0);
		childCompetitor.GlobalCompetitor__c = parentCompetitor.Id;
        insert childCompetitor;

        Test.startTest();

        //trigger testing : update
		parentCompetitor.IsAGlobalCompetitor__c = false;
        try
        {	
        	update parentCompetitor;
        }
        catch(Exception ex)
        {
        	System.debug('AP12 Test Method error Msg :'+ex);	
        }

        Test.stopTest();
        
        System.debug('## >>>>> testing class AP12Competitor END <<<<<'); 
    }
}