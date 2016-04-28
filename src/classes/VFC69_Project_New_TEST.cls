/**
 * This class contains unit tests for validating the behavior of VFC69_Project_New Apex classes
 * and triggers.
 *   ~ Author          : Christophe AVERSENG 
     ~ Date Created    : 15/05/2014
 */
@isTest
private class VFC69_Project_New_TEST 
{
    static testMethod void VFC69_Project_New_TEST() 
    {
        Opportunity opp = UtilityTestMethod.getOpportunity();
        insert opp;
        List<Product__c> prods = UtilityTestMethod.getProducts(1);
        Product__c prod = prods.get(0);
        prod.Opportunity__c = opp.id;
    
        test.startTest();
      
        VFC69_Project_New vfc69 = new VFC69_Project_New(new ApexPages.StandardController(opp));
        vfc69.saveWithProducts();
           
        test.stopTest();
    }
    
}