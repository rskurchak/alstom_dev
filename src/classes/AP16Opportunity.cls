/*
 AP16Opportunity apex class
    ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com 
    ~ Date Created    : 19/02/2013
    ~ Description     : Apex Class 
    					- set the TECH_ForecastedGrossMarginEdited__c field to true if the Forecasted Gross Margin field has been manually modified
    					- sync Forecasted Gross Margin field with Gross Margin field				
*/
public with sharing class AP16Opportunity 
{
	/* CR-0734 - Not used anymore */
	/*
	public static void forecastedGrossMarginManuallyUpdated(list<Opportunity> oppList)
	{
		for(Opportunity opp : oppList)
            opp.TECH_ForecastedGrossMarginEdited__c = true;
	}
	
	public static void setForecastedGrossMargin(list<Opportunity> oppList)
	{
		for(Opportunity opp : oppList)
            opp.ForecastedGrossMargin__c = opp.GrossMargin__c;
	}
	*/
}