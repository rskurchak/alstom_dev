/**
 * This class contains unit tests for validating the behavior of AP17Opportunity Apex classes
 * and triggers.
 *   ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com 
     ~ Date Created    : 19/02/2013
 */
@isTest
private class AP17Opportunity_TEST 
{
    static testMethod void AP17Opportunity_TEST() 
    {
        Opportunity opp = UtilityTestMethod.getOpportunity();
        opp.IsAGlobalOpportunity__c = true;
    	insert opp;
    	
    	Opportunity oppChild = UtilityTestMethod.getOpportunity();
    	oppChild.Global_Opportunity__c = opp.Id;
    	insert oppChild;
    	
    	
    	Test.startTest();
    	
    	opp.IsAGlobalOpportunity__c = false;
    	
    	try
    	{
    		update opp;
    	}
    	catch (Exception e)
    	{
    		System.assertEquals(true, e.getMessage().contains(System.label.LBL0047));
    	}
    	
    	Test.StopTest();
    }
}