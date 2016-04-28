/*
 VFC62_OpportunityRealignForecastVal_TEST
   ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
    ~ Date Created    : 26/03/2014 
    ~ Description     : Test Class of VFC62_OpportunityRealignForecastValues.
*/
@isTest
private class VFC62_OpportunityRealignForecastVal_TEST 
{
    static testMethod void VFC62_OpportunityRealignForecastVal_TEST() 
    {
        Opportunity o = UtilityTestMethod.getOpportunity();
        o.Sum_of_Global_Child_Opp_Selling_Price__c = 50000;
        insert o;
        
        Test.startTest();
        PageReference VFP62 = Page.VFP62_OpportunityRealignForecastValues; 
        Test.setCurrentPage(VFP62);
        ApexPages.currentPage().getParameters().put('Id', o.Id);
        VFC62_OpportunityRealignForecastValues VFC62 = new VFC62_OpportunityRealignForecastValues(new ApexPages.StandardController(o));
        VFC62.OppRealignForecastData();
        Test.stopTest();
    }
}