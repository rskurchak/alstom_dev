/*
 AP70Amounts apex class
    ~ Author          : Ali BEN AISSA ~ ali.ben.aissa@cgi.com 
    ~ Date Created    : 22/07/2015 
    ~ Description     : Apex Class 
                      - automatically update the Estimated Selling Price (€).
*/
public with sharing class AP71Opportunity 
{	
	public static void updateEstimationSellingPriceEUR(list<Opportunity> oppList)
  {
    System.debug('## >>> Starting AP71Opportunity.updateEstimationSellingPriceEUR <<<');    
    
    // Getting IsoCode from Opportunities to get to related dated conversion rate
    Set<String> listIsoCodes = new Set<String>();
    for (Opportunity opp : oppList)
      listIsoCodes.add(opp.CurrencyIsoCode);

    Map<String, List<DatedConversionRate>> mapIsoCodes = new Map<String, List<DatedConversionRate>>();
    for (DatedConversionRate dcr : [SELECT ISOCode, ConversionRate,
                                              StartDate, NextStartDate FROM DatedConversionRate WHERE ISOCode IN :listIsoCodes])
    {
      // If the IsoCode is already in the Map, just add the value to the List, otherwise create it
      if (mapIsoCodes.get(dcr.ISOCode) != null)
      {
        List<DatedConversionRate> listDCR = mapIsoCodes.get(dcr.ISOCode);
        listDCR.add(dcr);
        mapIsoCodes.put(dcr.ISOCode, listDCR);
      }
      else 
      {
        List<DatedConversionRate> listDCR = new List<DatedConversionRate>();
        listDCR.add(dcr);
        mapIsoCodes.put(dcr.ISOCode, listDCR);
      }
    }

    Double rateComing;
    for(Opportunity o : oppList)
    {
      for (DatedConversionRate dateconv : mapIsoCodes.get(o.CurrencyIsoCode))
      {
     	  if (dateconv.StartDate <= o.CloseDate  && dateconv.NextStartDate > o.CloseDate)
        {
     	 	  rateComing = dateconv.ConversionRate;
     	 	  break;
     	  }
      }
     	
      // update Estimated Selling Price on €
     	o.Estimated_Selling_Price_EUR__c = (null != rateComing && null != o.Amount) ? o.Amount / rateComing : null;
    }

    System.debug('## >>> END AP71Opportunity.updateEstimationSellingPriceEUR <<<');
  }
}