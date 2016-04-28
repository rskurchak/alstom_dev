/**
 * This class contains unit tests for validating the behavior of VFC28_DeleteProduct Apex classes
 * and triggers.
 *   ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com 
     ~ Date Created    : 11/03/2013
 */
@isTest
private class VFC28_DeleteProduct_TEST 
{
    static testMethod void VFC28_DeleteProductNotLeading_TEST() 
    {
    	Opportunity opp = UtilityTestMethod.getOpportunity();
		insert opp;
		
		Product__c product = new Product__c(Opportunity__c = opp.Id, Leading__c=false, ProductLine__c='Rolling Stock & Components', Platform__c = 'Metro');
		insert product;
    	
    	
    	test.startTest();
    	
    	VFC28_DeleteProduct vfc28 = new VFC28_DeleteProduct(new ApexPages.StandardController(product));
    	vfc28.back();
    	vfc28.deleteProduct();
    	
    	test.stopTest();
    }
    
    static testMethod void VFC28_DeleteProductLeading_TEST() 
    {
    	Opportunity opp = UtilityTestMethod.getOpportunity();
		insert opp;
		
		Product__c product = new Product__c(Opportunity__c = opp.Id, Leading__c=true, ProductLine__c='Rolling Stock & Components', Platform__c = 'Metro');
		insert product;
    	
    	
    	test.startTest();
    	
    	VFC28_DeleteProduct vfc28 = new VFC28_DeleteProduct(new ApexPages.StandardController(product));
    	try
    	{
    		vfc28.deleteProduct();
    	}
    	catch (Exception e)
    	{
    		System.assertEquals(true, e.getMessage().contains(System.label.LBL0048));
    	}
    	
    	test.stopTest();
    }
}