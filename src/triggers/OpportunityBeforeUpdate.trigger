trigger OpportunityBeforeUpdate on Opportunity (before update) 
{
    System.debug('## >>> Opportunity before update <<< run by ' + UserInfo.getName());

    /****************************************************************************************
        AP03ATRegion - Update ATRegion when the Country changes
    *****************************************************************************************/
    if(PAD.canTrigger('AP03'))
    {
        List<Opportunity> ap03Opportunities = new List<Opportunity>();
        for(Opportunity opp : Trigger.new) 
            if(opp.Country__c != Trigger.oldMap.get(opp.Id).Country__c) 
                ap03Opportunities.add(opp);

        if(ap03Opportunities.size() > 0)
            AP03ATRegion.updateSObjectATRegion(ap03Opportunities);
    }//bypass
    
    /**************************************************************************************************************
        AP14Opportunity
        - set the TECH_AdjustedSellingPriceEdited field to true if the Adjusted Selling Price field has been manually modified
    **************************************************************************************************************/
    if(PAD.canTrigger('AP14'))
    {
        list<Opportunity> ap014OppManual = new list<Opportunity>();
        
        // If Adjusted Selling Price has been change manually
        // --> Track this information in TECH_AdjustedSellingPriceEdited__c
        for (Opportunity opp : Trigger.new)
            if (opp.AdjustedSellingPrice__c != Trigger.oldMap.get(opp.Id).AdjustedSellingPrice__c
                && !opp.TECH_AdjustedSellingPriceEdited__c)
                ap014OppManual.add(opp);     
        
        if (ap014OppManual.size() > 0)
            AP14Opportunity.adjustedSellingPriceManuallyUpdated(ap014OppManual);
    }//bypass
    
    /**************************************************************************************************************
        AP14Opportunity
        - sync Adjusted Selling Price field with Selling Price field converted in EUR
    **************************************************************************************************************/
    if(PAD.canTrigger('AP14'))
    {
        list<Opportunity> ap014OppCopy = new list<Opportunity>();
        
        for (Opportunity opp : Trigger.new)
            if ((opp.Amount != Trigger.oldMap.get(opp.Id).Amount
                 || opp.CurrencyIsoCode != Trigger.oldMap.get(opp.Id).CurrencyIsoCode)
                && !opp.TECH_AdjustedSellingPriceEdited__c)
                ap014OppCopy.add(opp);
            
        if (ap014OppCopy.size() > 0)
            AP14Opportunity.setAdjustedSellingPrice(ap014OppCopy);
    }//bypass
    
    /**************************************************************************************************************
        AP16Opportunity
        - set the TECH_ForecastedGrossMarginEdited__c field to true if the Forecasted Gross Margin field has been manually modified
    **************************************************************************************************************/
    /* CR-0734 - Not used anymore */
    /*if(PAD.canTrigger('AP16'))
    {
        list<Opportunity> ap016OppManual = new list<Opportunity>();
        
        for (Opportunity opp : Trigger.new)
            if (opp.ForecastedGrossMargin__c != Trigger.oldMap.get(opp.Id).ForecastedGrossMargin__c
                && !opp.TECH_ForecastedGrossMarginEdited__c)
                ap016OppManual.add(opp);     
        
        if (ap016OppManual.size() > 0)
            AP16Opportunity.forecastedGrossMarginManuallyUpdated(ap016OppManual);
    }//bypass
    */
    
    /**************************************************************************************************************
        AP16Opportunity
        - sync Forecasted Gross Margin field with Gross Margin field
    **************************************************************************************************************/
    /* CR-0734 - Not used anymore */
    /*
    if(PAD.canTrigger('AP16'))
    {
        list<Opportunity> ap016OppCopy = new list<Opportunity>();
        
        for (Opportunity opp : Trigger.new)
            if (opp.GrossMargin__c != Trigger.oldMap.get(opp.Id).GrossMargin__c
                && !opp.TECH_ForecastedGrossMarginEdited__c)
                ap016OppCopy.add(opp);
            
        if (ap016OppCopy.size() > 0)
            AP16Opportunity.setForecastedGrossMargin(ap016OppCopy);
    }//bypass
    */
    
    /**************************************************************************************************************
        AP17Opportunity
        - check if the the Opportunity is Global if there is child Opportunities
    **************************************************************************************************************/
    if(PAD.canTrigger('AP17'))
    {
        list<Opportunity> ap017Opp = new list<Opportunity>();
        
        for (Opportunity opp : Trigger.new)
            if (!opp.IsAGlobalOpportunity__c)
                ap017Opp.add(opp);
            
        if (ap017Opp.size() > 0)
            AP17Opportunity.checkHasChildOpportunity(ap017Opp);
    }//bypass
    
    /**************************************************************************************************************
        AP19Opportunity
        - calculate Field Sum of Global + all Child Opportunities Selling Prices on Global Opportunity
    **************************************************************************************************************/
    if(PAD.canTrigger('AP19'))
    {
        list<Opportunity> ap19GlobalOpp = new list<Opportunity>();
        list<Opportunity> ap19notGlobalOpp = new list<Opportunity>();
        for(Opportunity opp : Trigger.new)
        {
            if (opp.IsAGlobalOpportunity__c)
                ap19GlobalOpp.add(opp);
            else if (opp.Sum_of_Global_Child_Opp_Selling_Price__c != 0)
                ap19notGlobalOpp.add(opp);
        }
            
        if(ap19GlobalOpp.size() > 0)
            AP19Opportunity.calculateGlobalSellingPrice(ap19GlobalOpp);
            
        if(ap19notGlobalOpp.size() > 0)
            AP19Opportunity.emptySellingPrice(ap19notGlobalOpp);
    }//bypass  
    
    /**************************************************************************************************************
        AP27Opportunity
        - set the TECH_ForecastedFiscalPeriodEdited__c field to true if the Forecasted Fiscal Period field has been manually modified
    **************************************************************************************************************/
    if(PAD.canTrigger('AP27'))
    {
        list<Opportunity> ap027OppManual = new list<Opportunity>();
        
        // If Forecast Fiscal Period has been manually changed
        // --> Track this information in TECH_ForecastedFiscalPeriodEdited__c
        for (Opportunity opp : Trigger.new)
            if (opp.ForecastedFiscalPeriod__c != Trigger.oldMap.get(opp.Id).ForecastedFiscalPeriod__c
                && !opp.TECH_ForecastedFiscalPeriodEdited__c)
                ap027OppManual.add(opp);     
        
        if (ap027OppManual.size() > 0)
            AP27Opportunity.forecastedFiscalPeriodManuallyUpdated(ap027OppManual);
    }
    
    /**************************************************************************************************************
        AP27Opportunity
        - - update TECH_FiscalPeriod__c
    **************************************************************************************************************/
    if(PAD.canTrigger('AP27'))
    {
        list<Opportunity> ap027OppManual = new list<Opportunity>();
        
        for (Opportunity opp : Trigger.new)
            if ((opp.ForecastedFiscalPeriod__c != Trigger.oldMap.get(opp.Id).ForecastedFiscalPeriod__c
                && opp.TECH_ForecastedFiscalPeriodEdited__c)
                || 
                (opp.CloseDate != Trigger.oldMap.get(opp.Id).CloseDate
                && !opp.TECH_ForecastedFiscalPeriodEdited__c))
                ap027OppManual.add(opp);     
        
        if (ap027OppManual.size() > 0)
            AP27Opportunity.updateTechFiscalPeriod(ap027OppManual);
    }
    
     /**************************************************************************************************************
		AP71Opportunity
		- automatically update the value of the field Estimated Selling Price(€)
	  **************************************************************************************************************/
    if(PAD.canTrigger('AP71'))
    {
       List<Opportunity> opportunity = new List<Opportunity>(); 
     	// before update opportunity
     	   for (Opportunity opp : Trigger.new) {       
              if(opp.Amount != Trigger.oldMap.get(opp.Id).Amount
                     || opp.CloseDate != Trigger.oldMap.get(opp.Id).CloseDate
                     || opp.CurrencyIsoCode != Trigger.oldMap.get(opp.Id).CurrencyIsoCode){
            	    opportunity.add(opp);
               }
            }
      if(opportunity.size() > 0){
        	 AP71Opportunity.updateEstimationSellingPriceEUR(opportunity);
      }
     	
   }//bypass 
    System.debug('## >>> Opportunity before update : END <<<');
}