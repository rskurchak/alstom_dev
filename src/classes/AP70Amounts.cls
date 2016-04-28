/*
 AP70Amounts apex class
    ~ Author          : Ali BEN AISSA ~ ali.ben.aissa@cgi.com 
    ~ Date Created    : 17/07/2015 
    ~ Description     : Apex Class 
                      - automatically update the ExchangeRate Amounts when the Currency Amounts is changed and ExchangeRate is unchanged.
*/
public with sharing class AP70Amounts {
   
    public static void updateExchangeRate (list<Amounts__c> amounts){
      System.debug('## >>> Starting AP70Amounts.updateExchangeRate <<<');      
      Date dateJours = date.today();
      Date ComingIntoForce;
      // Rate Exchange   
      list<DatedConversionRate> RateList = [SELECT ISOCode, ConversionRate,
                                              StartDate, NextStartDate FROM DatedConversionRate where ISOCode =:amounts.get(0).CurrencyIsoCode];
      // Amounts updated
      //list<Amounts__c> amounts = [SELECT Id,Tender__c, ExchangeRate__c, CurrencyIsoCode FROM Amounts__c WHERE Id =: amount.id limit 1];
      
      // getOpportunity close date 
      Tender__c tender = [SELECT Opportunity__r.CloseDate FROM Tender__c WHERE Id=:amounts.get(0).Tender__c limit 1];
      
      
      if(null !=tender  && null != tender.Opportunity__r && null !=tender.Opportunity__r.CloseDate){
      	     ComingIntoForce= tender.Opportunity__r.CloseDate;
      }else {
      	     ComingIntoForce = dateJours;
      }
      
      for(Amounts__c amount : amounts){
      	
      	    for(DatedConversionRate datecon : RateList){
                 if(datecon.StartDate <= ComingIntoForce && datecon.NextStartDate > ComingIntoForce )  {
                 	 // update the value of ExchangeRate__c
                       amount.ExchangeRate__c = datecon.ConversionRate;
                  }
             } 
      	
      }
 
      System.debug('## >>> END AP70Amounts.updateExchangeRate <<<');
    }

}