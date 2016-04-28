/*
 VFC27_SumGlobalChildSellingPrice 
    ~ Author            : fabien.taillon@cgi.com
    ~ Modification Date : 20/03/2013
    ~ Description       : Controller of VFP27_SumGlobalChildSellingPrice
*/
public with sharing class VFC27_SumGlobalChildSellingPrice 
{
	public String formattedGlobalPrice {get;set;}
	
	public VFC27_SumGlobalChildSellingPrice(ApexPages.StandardController controller) 
	{
		Opportunity o = (Opportunity)controller.getRecord();
		
		if (o != null && o.Sum_of_Global_Child_Opp_Selling_Price__c != null)
			formattedGlobalPrice = o.CurrencyIsoCode + ' ' + o.Sum_of_Global_Child_Opp_Selling_Price__c.format();
		
	}
}