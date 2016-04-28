/*
 VFC60_Criteria_Weight_Banner
    ~ Author            : christophe.averseng@sfr.fr
    ~ Modification Date : 21/11/2013
    ~ Description       : - Controller of VFC60_Criteria_Weight_Banner
                - Allows to display a banner on WLA page layout
    ~ Feature Id      : FEAT#0492
*/
public with sharing class VFC60_Criteria_Weight_Banner {
  
  // Contains current Opportunity
    private WinLossAnalysis__c wla;
    
    // Contains Banner Message of WLA
    public String wlaTECHCriteriaBannerMessage{get;set;}
    // Allows to display or hide Schedule Banner Message
    public Boolean isEmptyTECHCriteriaBannerMessage{get;set;}
  
    public VFC60_Criteria_Weight_Banner(ApexPages.StandardController controller) {
      // Getting current WinLossAnalysis
        this.wla = (WinLossAnalysis__c)controller.getRecord();
        if(this.wla != null) {
          // Getting needed informations on wla
            WinlossAnalysis__c winloss = [Select TECH_WeightBannerText__c from WinLossanalysis__c where Id =: this.wla.Id];
            wlaTECHCriteriaBannerMessage = winloss.TECH_WeightBannerText__c;
            
            if (wlaTECHCriteriaBannerMessage == null) {
              // Set isEmptyTECHCriteriaBannerMessage to true allows to display the Banner Message
              isEmptyTECHCriteriaBannerMessage = true;
            }
            else {
              // Set isEmptyTECHCriteriaBannerMessage to false allows to hide the Banner Message
              isEmptyTECHCriteriaBannerMessage = false;
            }
            
        }
    }
}