public with sharing class VFC81_CopyAmountToTender
{
    public Amounts__c currentAmount {get;set;}
    
    public VFC81_CopyAmountToTender(ApexPages.StandardController stdCtrl) 
    {
        this.currentAmount = (Amounts__c)stdCtrl.getRecord();
    }
    
    public PageReference copyAmountToTender()
    {
        Tender__c parentTender = new Tender__c(Id = currentAmount.Tender__c);
        
        if(currentAmount.Option__c == false)
        {
            parentTender.SellingPrice__c = currentAmount.MinimumSellingPriceMEUR__c * 1000000; 
            parentTender.Gross_Margin__c = currentAmount.GrossMargin__c;
            parentTender.GrossMarginAdjusted__c = currentAmount.GrossMarginAdjusted__c;
            parentTender.OperatingMargin__c = currentAmount.OperatingMargin__c;        
            parentTender.NetMargin__c = currentAmount.NetMargin__c;
            parentTender.Contingencies__c = currentAmount.Contingencies__c;
            parentTender.Ambitions__c = currentAmount.Ambition__c;
            parentTender.DownPayment__c = currentAmount.DownPayment__c;
            parentTender.OnwardPayment__c = currentAmount.OnwardPayment__c;
            parentTender.ConversionRate__c = currentAmount.ExchangeRate__c;
        }
        else if(currentAmount.Option__c == true)
        {
            parentTender.OptionsSellingPrice__c = currentAmount.MinimumSellingPriceMEUR__c * 1000000; 
            parentTender.OptionsGrossMargin__c = currentAmount.GrossMargin__c;
            parentTender.OptionsGrossMarginAdjusted__c = currentAmount.GrossMarginAdjusted__c;
            parentTender.OptionsOperatingMargin__c = currentAmount.OperatingMargin__c;        
            parentTender.OptionsNetMargin__c = currentAmount.NetMargin__c;
            parentTender.OptionsContingencies__c = currentAmount.Contingencies__c;
            parentTender.OptionsAmbitions__c = currentAmount.Ambition__c; 
            parentTender.OptionConversionRate__c = currentAmount.ExchangeRate__c;          
        }
        
        try
        {
            update parentTender;
        }
        catch(Exception e)
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, e.getMessage());
            ApexPages.addMessage(msg);
            return null;
        }

        return new PageReference('/' + parentTender.Id);
    }
}