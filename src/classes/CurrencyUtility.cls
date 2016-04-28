public class CurrencyUtility 
{
	public class CurrencyException extends Exception {}

	private map<String, list<DatedConversionRate>> conversionRateMap;
	
	public CurrencyUtility()
	{
		conversionRateMap = new map<String, list<DatedConversionRate>>();
		list<DatedConversionRate> conversionRateList = [SELECT ISOCode, ConversionRate,
		          										StartDate, NextStartDate FROM DatedConversionRate];
		          										
		for (DatedConversionRate dcr : conversionRateList)
		{
			if (conversionRateMap.get(dcr.ISOCode) != null)
			{
				list<DatedConversionRate> lDated = conversionRateMap.get(dcr.ISOCode);
		        lDated.add(dcr);
		        conversionRateMap.put(dcr.ISOCode, lDated);	
			}
		    else
		    {
		    	list<DatedConversionRate> lDated = new list<DatedConversionRate>();
		        lDated.add(dcr);
		        conversionRateMap.put(dcr.ISOCode, lDated);
		    }
		}          										          										
	}
	
	public CurrencyUtility(Set<String> currencyIsoCodes, Date fromPeriod, Date toPeriod)
	{
		conversionRateMap = new map<String, list<DatedConversionRate>>();
		list<DatedConversionRate> conversionRateList = [SELECT ISOCode, ConversionRate,
		          										StartDate, NextStartDate FROM DatedConversionRate
		          										WHERE ISOCode in :currencyIsoCodes 
		          										AND StartDate <= :fromPeriod AND NextStartDate > :toPeriod];
		          										
		for (DatedConversionRate dcr : conversionRateList)
		{
			if (conversionRateMap.get(dcr.ISOCode) != null)
			{
				list<DatedConversionRate> lDated = conversionRateMap.get(dcr.ISOCode);
		        lDated.add(dcr);
		        conversionRateMap.put(dcr.ISOCode, lDated);	
			}
		    else
		    {
		    	list<DatedConversionRate> lDated = new list<DatedConversionRate>();
		        lDated.add(dcr);
		        conversionRateMap.put(dcr.ISOCode, lDated);
		    }
		}          										          										
	}
	
	public Decimal convertToCurrency(Decimal amount, String fromCurrencyCode, String toCurrencyCode, Date period)
	{	
		Decimal converted = 0;
		try
		{
			Decimal fromCurrencyCodeRate;
			for (DatedConversionRate dcr : conversionRateMap.get(fromCurrencyCode))
				if (dcr.StartDate <= period && dcr.NextStartDate > period)
					fromCurrencyCodeRate = dcr.ConversionRate;
			
			Decimal toCurrencyCodeRate;
			for (DatedConversionRate dcr : conversionRateMap.get(toCurrencyCode))
				if (dcr.StartDate <= period && dcr.NextStartDate > period)
					toCurrencyCodeRate = dcr.ConversionRate;
			
			converted = ((amount * toCurrencyCodeRate) / fromCurrencyCodeRate).round(System.RoundingMode.HALF_UP);
		}
		catch (Exception e)
		{
			throw new CurrencyException(e.getMessage());
		}
						
		return converted;
	}
}