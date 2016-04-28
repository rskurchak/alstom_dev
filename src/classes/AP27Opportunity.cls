/*
 AP27Opportunity Apex Class
    ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com 
    ~ Date Created    : 06/06/2013
    ~ Description     : Apex Class 
    					- set the TECH_ForecastedFiscalPeriodEdited__c field to true if the Forecasted Fiscal Period field has been manually modified					
						- update TECH_FiscalPeriod__c
*/
public with sharing class AP27Opportunity 
{
	public static void forecastedFiscalPeriodManuallyUpdated(list<Opportunity> opportunities)
	{
		System.debug('## >>> Starting AP27Opportunity.forecastedFiscalPeriodManuallyUpdated <<<');

        for(Opportunity opp : opportunities)
            opp.TECH_ForecastedFiscalPeriodEdited__c = true;
            
        System.debug('## >>> AP27Opportunity.forecastedFiscalPeriodManuallyUpdated END <<<');
	}
	
	public static void updateTechFiscalPeriod(list<Opportunity> opportunities)
	{
		System.debug('## >>> Starting AP27Opportunity.updateTechFiscalPeriod <<<');
		
		for (Opportunity opp : opportunities)
		{
	        if (opp.TECH_ForecastedFiscalPeriodEdited__c)
	        {
	        	opp.TECH_FiscalPeriod__c = opp.ForecastedFiscalPeriod__c;
	        }
	        else
	        {
	        	opp.TECH_FiscalPeriod__c = opp.FiscalPeriod__c;
	        	opp.ForecastedFiscalPeriod__c = opp.FiscalPeriod__c;
	        }
		}
		
        System.debug('## >>> AP27Opportunity.updateTechFiscalPeriod END <<<');
	}
}