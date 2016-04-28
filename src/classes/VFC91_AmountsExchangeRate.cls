/*
 VFC91_AmountsExchangeRate 
    ~ Author            : Ali BEN AISSA ~ ali.ben.aissa@cgi.com
    ~ Created Date : 20/07/2015
    ~ Description       : Controller of VFP91_AmountsExchangeRate Page
*/

public with sharing class VFC91_AmountsExchangeRate {
	private Amounts__c  amountRecord;
	public Boolean bRateDifferente {get;set;}

	public VFC91_AmountsExchangeRate(ApexPages.StandardController controller)
	{
		System.debug('## >>> Starting VFC91_AmountsExchangeRate <<<');
		bRateDifferente =false;
		this.amountRecord = (Amounts__c)controller.getRecord();
		Amounts__c amount = [select CurrencyIsoCode,  ExchangeRate__c, Tender__c from Amounts__c where Id=:amountRecord.id limit 1];
		if (amount != null)
		{
		  Date ComingIntoForce;
			// getOpportunity close date 
          Tender__c tender = [SELECT Opportunity__r.CloseDate FROM Tender__c WHERE Id=:amount.Tender__c limit 1];
         
          if(null !=tender  && null != tender.Opportunity__r && null !=tender.Opportunity__r.CloseDate){
      	         ComingIntoForce= tender.Opportunity__r.CloseDate;
          }else {
      	         ComingIntoForce = date.today();
          }
			
		 list<DatedConversionRate> RateList = [SELECT ISOCode, ConversionRate,
                                                        StartDate, NextStartDate FROM DatedConversionRate where 
                                                        ( ISOCode = :amount.CurrencyIsoCode )];
			
		 for(DatedConversionRate convRate : RateList){
			if (RateList.size() > 0 && convRate.StartDate <= ComingIntoForce && convRate.NextStartDate > ComingIntoForce
			                        && convRate.ConversionRate != amount.ExchangeRate__c)
			{
 		       bRateDifferente =true;
			   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 
				                   System.label.LBL0341 +' ['+string.valueOf(convRate.ConversionRate).replace('.',',') +']'));
			   break;
			 }
				
		   }
			
		}
		System.debug('## >>> End VFC91_AmountsExchangeRate <<<');
	}

}