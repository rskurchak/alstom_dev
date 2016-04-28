/*
 VFC62_OpportunityRealignForecastValues
   ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
    ~ Date Created    : 24/03/2014 
    ~ Description     : Apex Class to replace Forecast Opportunity Values with its own 
                        Opportunity values.
*/

public with sharing class VFC62_OpportunityRealignForecastValues {
    public SObject Oppy;
    public boolean Authorised { get; set; }

    public VFC62_OpportunityRealignForecastValues(ApexPages.StandardController controller) {
        this.Oppy=controller.getRecord();
        // Button is visible only for certain profiles
        if (UserInfo.getProfileId() != Label.LBL0051 && UserInfo.getProfileId() != Label.LBL0052 && UserInfo.getProfileId() != Label.LBL0053 && UserInfo.getProfileId() != Label.LBL0057) {
            this.Authorised = false;
        } else {
            this.Authorised = true;
        }
    }
    public void OppRealignForecastData() {
        try {
        	/* CR-0734 - Removed GrossMargin__c */
            Opportunity OppUpdate = [SELECT Id, Name, CurrencyIsoCode, CloseDate, Amount, FiscalPeriod__c, AdjustedSellingPrice__c, ForecastedGrossMargin__c, ForecastedFiscalPeriod__c FROM Opportunity WHERE Id = :Oppy.Id LIMIT 1];
            if (OppUpdate.CurrencyIsoCode != 'EUR' && OppUpdate.Amount != null) {
                CurrencyUtility cu = new CurrencyUtility();
                OppUpdate.AdjustedSellingPrice__c = cu.convertToCurrency(OppUpdate.Amount, OppUpdate.CurrencyIsoCode, 'EUR', OppUpdate.CloseDate);
            } 
            else  
                OppUpdate.AdjustedSellingPrice__c = OppUpdate.Amount;

			/* CR-0734 - Not used anymore */
            // OppUpdate.ForecastedGrossMargin__c = OppUpdate.GrossMargin__c;
            OppUpdate.ForecastedFiscalPeriod__c = OppUpdate.FiscalPeriod__c;
            update OppUpdate;
            //if(Test.isRunningTest())
            //    throw new UtilityTestMethod.myException();
        } catch (Exception e){// roll everything back in case of error
            ApexPages.addMessages(e);
         }
    }    

}