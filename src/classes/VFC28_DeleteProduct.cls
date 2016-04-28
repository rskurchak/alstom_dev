/*
 VFC28_DeleteProduct 
    ~ Author            : fabien.taillon@cgi.com
    ~ Modification Date : 11/03/2013
    ~ Description       : Controller of VFP28_DeleteProduct, Custom Delete for Product 
*/
public with sharing class VFC28_DeleteProduct 
{
	Product__c product {get;set;}
	
	public VFC28_DeleteProduct(ApexPages.StandardController controller) 
	{
		this.product = (Product__c)controller.getRecord();
	}
	
	public PageReference deleteProduct()
	{
		if (product.Leading__c)
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.label.LBL0048);
			ApexPages.addMessage(myMsg);
		}
		else
		{
			try
			{
				delete product;
				return back();
			}
			catch(Exception e)
			{
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
				ApexPages.addMessage(myMsg);
			}
		}
		
		return null;
	}
	
	public PageReference back()
	{
		return new PageReference('/'+product.Opportunity__c);
	}
}