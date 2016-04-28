/*
 VFC27_SumGlobalChildSellingPrice_TEST
    ~ Author            : fabien.taillon@cgi.com
    ~ Modification Date : 20/03/2013
    ~ Description       : Test Class for VFC27_SumGlobalChildSellingPrice
*/
@isTest
private class VFC27_SumGlobalChildSellingPrice_TEST 
{
    static testMethod void VFC27_SumGlobalChildSellingPrice_TEST() 
    {
    	Opportunity o = UtilityTestMethod.getOpportunity();
    	o.Sum_of_Global_Child_Opp_Selling_Price__c = 50000;
    	insert o;
    	
    	Test.startTest();
        VFC27_SumGlobalChildSellingPrice vfc27 = new VFC27_SumGlobalChildSellingPrice(new ApexPages.StandardController(o));
        Test.stopTest();
    }
}