trigger OpportunityBeforeInsert on Opportunity (before insert) 
{
    System.debug('## >>> Opportunity before insert <<< run by ' + UserInfo.getName());

    /****************************************************************************************
        AP03ATRegion - Update ATRegion when the Country changes
    *****************************************************************************************/
    if(PAD.canTrigger('AP03'))
    {
        List<Opportunity> ap03Opportunities = new List<Opportunity>();
        for(Opportunity opp : Trigger.new) 
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
        
        for (Opportunity opp : Trigger.new)
            if (opp.AdjustedSellingPrice__c != null && opp.AdjustedSellingPrice__c != 0)
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
            if (!opp.TECH_AdjustedSellingPriceEdited__c && opp.amount != null)
                ap014OppCopy.add(opp);
                
        if (ap014OppCopy.size() > 0)
            AP14Opportunity.setAdjustedSellingPrice(ap014OppCopy);
    }//bypass
    
    /**************************************************************************************************************
        AP16Opportunity
        - set the TECH_ForecastedGrossMarginEdited__c field to true if the Forecasted Gross Margin field has been manually modified
    **************************************************************************************************************/
    /* CR-0734 - Not used anymore */
    /*
    if(PAD.canTrigger('AP16'))
    {
        list<Opportunity> ap016OppManual = new list<Opportunity>();
        
        for (Opportunity opp : Trigger.new)
            if (opp.ForecastedGrossMargin__c != null && opp.ForecastedGrossMargin__c != 0)
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
            if (!opp.TECH_ForecastedGrossMarginEdited__c && opp.GrossMargin__c != null)
                ap016OppCopy.add(opp);
        
        if (ap016OppCopy.size() > 0)
            AP16Opportunity.setForecastedGrossMargin(ap016OppCopy);
    }//bypass
    */
    
    /**************************************************************************************************************
        AP19Opportunity
        - calculate Field Sum of Global + all Child Opportunities Selling Prices on Global Opportunity
    **************************************************************************************************************/
    if(PAD.canTrigger('AP19'))
    {
        list<Opportunity> ap19GlobalOpp = new list<Opportunity>();
        for(Opportunity opp : Trigger.new)
            if (opp.IsAGlobalOpportunity__c)
                ap19GlobalOpp.add(opp);
            
        if(ap19GlobalOpp.size() > 0)
            AP19Opportunity.initGlobalSellingPrice(ap19GlobalOpp);
    }//bypass  
    
    /**************************************************************************************************************
        AP27Opportunity
        - set the TECH_ForecastedFiscalPeriodEdited__c field to true if the Forecasted Fiscal Period field has been manually modified
    **************************************************************************************************************/
    if(PAD.canTrigger('AP27'))
    {
        list<Opportunity> ap027OppManual = new list<Opportunity>();
        
        for (Opportunity opp : Trigger.new)
            if (opp.ForecastedFiscalPeriod__c != null && opp.ForecastedFiscalPeriod__c != '')
                ap027OppManual.add(opp);
                
        if (ap027OppManual.size() > 0)
            AP27Opportunity.forecastedFiscalPeriodManuallyUpdated(ap027OppManual);
    }
    
    /**************************************************************************************************************
        AP27Opportunity
        - - update TECH_FiscalPeriod__c
    **************************************************************************************************************/
    if(PAD.canTrigger('AP27'))
        AP27Opportunity.updateTechFiscalPeriod(Trigger.new);
        
   /**************************************************************************************************************
		AP71Opportunity
		- automatically update the value of the field Estimated Selling Price(€) 
	  **************************************************************************************************************/
   if(PAD.canTrigger('AP71'))
    {
       AP71Opportunity.updateEstimationSellingPriceEUR(Trigger.new);
     	
    }//bypass 
    
    System.debug('## >>> Opportunity before insert : END <<<');
}