/**
 * This class contains unit tests for validating the behavior of AP19Opportunity Apex classes
 * and triggers.
 *   ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com 
     ~ Date Created    : 19/02/2013
 */
@isTest
private class AP19Opportunity_TEST 
{
    static testMethod void AP19Opportunity_TEST() 
    {
    	Account acc = UtilityTestMethod.getAccount();
    	insert acc;
    	
    	Opportunity opp = UtilityTestMethod.getOpportunity();
        opp.IsAGlobalOpportunity__c = true;
        opp.AccountId = acc.Id;
        opp.Amount = 10;
        opp.CurrencyIsoCode = 'EUR';
        insert opp;
        
    	Opportunity opp2 = UtilityTestMethod.getOpportunity();
        opp2.IsAGlobalOpportunity__c = true;
        opp2.AccountId = acc.Id;
        opp2.Amount = 10;
        opp2.CurrencyIsoCode = 'EUR';
        
        list<Opportunity> oppChildList = new list<Opportunity>();
        for(Integer i=0; i<200; i++)
        {
	    	Opportunity oppChild = UtilityTestMethod.getOpportunity();
	    	oppChild.Name = 'Opp'+i;
	    	oppChild.AccountId = acc.Id;
	    	oppChild.Global_Opportunity__c = opp.Id;
			oppchild.Amount = 0;
	    	oppChild.CurrencyIsoCode = 'USD';
	    	oppChildList.add(oppChild);
        }
        
    	 
    	Test.startTest();
    	
    	insert opp2;
    	insert oppChildList;
    	
    	for(Opportunity o : oppChildList)
    		o.Amount = 10;
    	update oppChildList;
    	
    	opp2.IsAGlobalOpportunity__c = false;
    	update opp2;
    	
    	delete opp2;
    	undelete opp2;
    	
    	Test.StopTest();
    }
}