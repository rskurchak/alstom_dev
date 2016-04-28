/*********************************************************************
 SANITY CHECK Feb. 2014 - CODE MODIFICATION REQUIRED
 Modify code following instructions below.
 Remove this box once modifications done.
*********************************************************************/

/*********************************************************************
 SANITY CHECK INSTRUCTION: 
   Trigger should not loop through records (increase CPU time - governor limit) 
   as records are looped through in AP53 ; in AP54 ; in AP55 ; in AP56 
   => records are looped through 8 times instead of 4
 Remove this box once modification done.
*********************************************************************/
trigger WinLossAnalysisBeforeInsert on WinLossAnalysis__c (before insert) {
    System.debug('## >>> WinLossAnalysis after insert <<< run by ' + UserInfo.getName());

    /*************************************************************************************************
        Win/Loss Analysis (WLA) object is a child of Opportunity (Master-Detail relationship).
        There must not be more than one child record of WLA per Opportunity.
        A trigger (or anything else) must prevent creation of a second WLA record on an Opportunity. 
        An error message must be raised: "Win/Loss Analysis is already existing for this opportunity."
     **************************************************************************************************/
    if(PAD.canTrigger('AP47'))
    {
        List<WinLossAnalysis__c> ap47ListWinLossAnalysis = new List<WinLossAnalysis__c>();
        for(WinLossAnalysis__c winLossAnalysis : Trigger.new) 
            if(winLossAnalysis.Opportunity__c != null) {
                ap47ListWinLossAnalysis.add(winLossAnalysis);
            }

        if(ap47ListWinLossAnalysis.size() > 0){
            AP47WinLossAnalysis.CheckUniquenessOfWinLossAnalysis(ap47ListWinLossAnalysis);
        }
    }
    
    /*************************************************************************************************
        Rich-text field Qualitative return on Experience on Win-Loss Analysis must be initialized at creation with a template Email.
        Template is defined in a Salesforce email template.
     **************************************************************************************************/
    /* CR-0847: This field is not used anymore */
    /* 
    if (PAD.canTrigger('AP53'))
    {
        
        List<WinLossAnalysis__c> ap53ListWinLossAnalysis = new List<WinLossAnalysis__c>();
        for(WinLossAnalysis__c winLossAnalysis : Trigger.new) 
            if(winLossAnalysis.Opportunity__c != null) 
                ap53ListWinLossAnalysis.add(winLossAnalysis);

        if(ap53ListWinLossAnalysis.size() > 0)
            AP53WinLossAnalysis.SetQualitativeReturnOnExperienceRichText(ap53ListWinLossAnalysis);
        
    }
    */
    
    /*************************************************************************************************
        Initialize WLA Currency from parent Opportunity currency.
     **************************************************************************************************/
    if (PAD.canTrigger('AP54'))
    {
        
        List<WinLossAnalysis__c> ap53ListWinLossAnalysis = new List<WinLossAnalysis__c>();
        for(WinLossAnalysis__c winLossAnalysis : Trigger.new) 
            if(winLossAnalysis.Opportunity__c != null) 
                ap53ListWinLossAnalysis.add(winLossAnalysis);

        if(ap53ListWinLossAnalysis.size() > 0)
            AP54WinLossAnalysis.SetWLACurrencyFromOpp(ap53ListWinLossAnalysis);
        
    }
    
    System.debug('## >>> WinLossAnalysis after insert : END <<<');
}