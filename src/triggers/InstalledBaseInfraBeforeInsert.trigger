trigger InstalledBaseInfraBeforeInsert on InstalledBaseInfra__c (before insert) {
    System.debug('## >>> Installed Base Infra Before insert <<< run by ' + UserInfo.getName());
    /****************************************************************************************
        AP03ATRegion - Update ATRegion when the Country changes
    *****************************************************************************************/
    if(PAD.canTrigger('AP03'))
    {
        List<InstalledBaseInfra__c> ap03InstalledBaseInfras = new List<InstalledBaseInfra__c>();
        for(InstalledBaseInfra__c InstalledBaseInfra : Trigger.new) 
            ap03InstalledBaseInfras.add(InstalledBaseInfra);

        if(ap03InstalledBaseInfras.size() > 0)
            AP03ATRegion.updateSObjectATRegion(ap03InstalledBaseInfras);
    }//bypass

    /*************************************************************************************************
        Rich-text field Subsystems specific information on Installed Base Infra must be initialized at 
        creation with a template Email. Template is defined in a Salesforce email template.
     **************************************************************************************************/
    if (PAD.canTrigger('AP60'))
    {
        AP60InstalledBaseInfra.SetSubsystemsSpecificInformationRichText(Trigger.new);
    }
            
    System.debug('## >>> Installed Base Infra Before insert END');
}