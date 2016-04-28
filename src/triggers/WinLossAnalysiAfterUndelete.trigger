trigger WinLossAnalysiAfterUndelete on WinLossAnalysis__c (after undelete) {
    System.debug('## >>> WinLossAnalysis__c after undelete <<< run by ' + UserInfo.getName()); 
    
    /*********************************************************************************************
        AP47WinLossAnalysis
        - Check if WLA record exists for the same Opportunity
    *********************************************************************************************/
    if (PAD.canTrigger('AP47'))
        AP47WinLossAnalysis.CheckUniquenessOfWinLossAnalysis(trigger.new);
    
    System.debug('## >>>  WinLossAnalysis__c after undelete : END <<<');
}