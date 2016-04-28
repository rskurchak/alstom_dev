/*********************************************************************
 SANITY CHECK Feb. 2014 - CODE MODIFICATION REQUIRED
 Modify code following instructions below.
 Remove this box once modifications done.
*********************************************************************/

/*
 VFC46_Currency apex controller
    ~ Author          : Jawad GHOULAM ~ jawad.ghoulam@cgi.com 
    ~ Date Created    : 20/09/2013 
    ~ Description     : Calculate Exchange Rate
    ~ Feature Id      : FEAT#0366 
*/
public with sharing class VFC46_Currency {
    // Getting current amount
    public Amounts__c amount {get; set;}
    // Contains Id of related Tender
    public String tenderId {get; set;}
    // Contains Name of related Tender
    public String tenderName {get; set;}
    // Contains currencyIsoCode of amount
    public String currencyIsoCode {get; set;}
    
    // This Boolean is true if we clic on Button New from the list of amounts 
    public Boolean isFromListAmounts {get; set;}
    
    public Date ComingIntoForce;
    
    ApexPages.standardController m_sc = null;
    
    /* Constructor */
    public VFC46_Currency(ApexPages.StandardController stdCtrl)
    {
        // Getting Id Tender parameter from URL of the current page
        tenderId = ApexPages.currentPage().getParameters().get('IdTender');
        if(tenderId != null) {
            amount = new Amounts__c();
            currencyIsoCode = amount.CurrencyIsoCode;
            
/*********************************************************************
 SANITY CHECK INSTRUCTION: 
   Instead of querying Tender Name, add this field as hidden field on the page
   <apex:hidden value="{!Tender__c.Name}"/>
 Remove this box once modification done.
*********************************************************************/

            // Getting needed informations on related Tender
            Tender__c tend = [Select Id, Name, Opportunity__r.CloseDate from Tender__c where Id =: tenderId];
            tenderName = tend.Name;
            ComingIntoForce =tend.Opportunity__r.CloseDate;
            
            // Set isFromListAmounts to false. Allows to display new amount page whith Tender name by default
            isFromListAmounts = false;
        }
        else {
            amount = new Amounts__c();
            currencyIsoCode = amount.CurrencyIsoCode;
            tenderName = '';
            // Set isFromListAmounts to true. Allows to display new amount page whithout Tender name by default
            isFromListAmounts = true;
        }
    }
    
    public pagereference NextStep() {
        List<DatedConversionRate> datedConversionRate;
        // Getting needed informations on related DatedConversionRate
        if(tenderId != null)
            datedConversionRate = [SELECT ISOCode, ConversionRate, StartDate, NextStartDate FROM DatedConversionRate WHERE ISOCode = :amount.CurrencyIsoCode and StartDate <= :ComingIntoForce and NextStartDate > :ComingIntoForce];
        else
            datedConversionRate = [SELECT ISOCode, ConversionRate, StartDate, NextStartDate FROM DatedConversionRate WHERE ISOCode = :amount.CurrencyIsoCode];
           
        PageReference redirectUrl;
        
        if(!isFromListAmounts) {
            // Getting URL of Create page amonut with Tender name populated by default
            redirectUrl = new pagereference('/'+System.label.LBL0110+'/e?nooverride=1&'+System.label.LBL0112+'='+tenderName+'&'+System.label.LBL0112+'_lkid='+tenderId+'&CurrencyIsoCode='+datedConversionRate[0].IsoCode+'&retURL=%2F'+tenderId+'&'+System.label.LBL0111+'='+datedConversionRate[0].ConversionRate.format());
        }
        else {
            // Getting URL of Create page amonut without Tender name populated by default
            redirectUrl = new pagereference('/'+System.label.LBL0110+'/e?nooverride=1&CurrencyIsoCode='+datedConversionRate[0].IsoCode+'&retURL=%2F'+System.label.LBL0110+'%2Fo&'+System.label.LBL0111+'='+datedConversionRate[0].ConversionRate.format());
        }
        redirectUrl.setRedirect(true);
        return redirectUrl;
    }
    
    // Return to previous page
    public pagereference CancelCurrency() {     
        return new PageReference('/' + tenderId);
    }
}