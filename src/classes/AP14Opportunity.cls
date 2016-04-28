/*
 AP14Opportunity apex class
    ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com 
    ~ Date Created    : 07/01/2013
    ~ Description     : Apex Class 
    					- set the TECH_AdjustedSellingPriceEdited field to true if the Adjusted Selling Price field has been manually modified
    					- sync Adjusted Selling Price field with Selling Price field converted in EUR					
*/
public with sharing class AP14Opportunity 
{
	public static void adjustedSellingPriceManuallyUpdated(list<Opportunity> opportunities)
	{
		System.debug('## >>> Starting AP14Opportunity.adjustedSellingPriceManuallyUpdated <<<');

        for(Opportunity opp : opportunities)
            opp.TECH_AdjustedSellingPriceEdited__c = true;
            
        System.debug('## >>> AP14Opportunity.adjustedSellingPriceManuallyUpdated END <<<');
	}
	
	public static void setAdjustedSellingPrice(list<Opportunity> opportunities)
	{
		System.debug('## >>> Starting AP14Opportunity.setAdjustedSellingPrice <<<');

		list<String> currIsoCodes = new list<String>();
		map<String, list<DatedConversionRate>> mapConversionRate = new map<String, list<DatedConversionRate>>();
		Date minDate;
		Date maxDate;
		
		for(Opportunity opp : opportunities)
		{
        	if (opp.CurrencyIsoCode != 'EUR')
        	{
        		currIsoCodes.add(opp.CurrencyIsoCode);
        		
        		if (minDate == null || minDate > opp.CloseDate)
        			minDate = opp.CloseDate;
        			
        		if (maxDate == null || maxDate > opp.CloseDate)
        			minDate = opp.CloseDate;
        	}
		}
		
        if (currIsoCodes.size() > 0)
        {		
	 		list<DatedConversionRate> conversionRateList = [SELECT ISOCode, ConversionRate,
	          												StartDate, NextStartDate FROM DatedConversionRate
	          												WHERE ISOCode in :currIsoCodes 
	          												AND StartDate <= :minDate AND NextStartDate > :maxDate];
	          
	        for (DatedConversionRate dcr : conversionRateList)
	        {
	        	if (mapConversionRate.get(dcr.ISOCode) != null)
	        	{
	        		list<DatedConversionRate> lDated = mapConversionRate.get(dcr.ISOCode);
	        		lDated.add(dcr);
	        		mapConversionRate.put(dcr.ISOCode, lDated);	
	        	}
	        	else
	        	{
	        		list<DatedConversionRate> lDated = new list<DatedConversionRate>();
	        		lDated.add(dcr);
	        		mapConversionRate.put(dcr.ISOCode, lDated);
	        	}
	        }
        }      
        
		for(Opportunity opp : opportunities)
		{
			if (opp.CurrencyIsoCode == 'EUR' || opp.Amount == 0 || opp.Amount == null)
				opp.AdjustedSellingPrice__c = opp.Amount;
			else 
			{
				try
				{
					list<DatedConversionRate> lDated = mapConversionRate.get(opp.CurrencyIsoCode);
					
					for (DatedConversionRate dcr : lDated)
					{
						if (dcr.StartDate <= opp.CloseDate && dcr.NextStartDate > opp.CloseDate)
						{
							opp.AdjustedSellingPrice__c = (opp.Amount/dcr.ConversionRate).round(System.RoundingMode.HALF_UP);
							break;
						}
					}	
				}
				catch(Exception e)
				{
					opp.addError('Invalid Currency Conversion Rate for the following Currency: '+opp.CurrencyIsoCode);
				}
			}	
		}
		   
        System.debug('## >>> AP14Opportunity.setAdjustedSellingPrice END <<<');
	}
}