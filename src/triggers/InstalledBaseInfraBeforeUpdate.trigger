trigger InstalledBaseInfraBeforeUpdate on InstalledBaseInfra__c (before update) {
    System.debug('## >>> Installed Base Infra Before Update <<< run by ' + UserInfo.getName());
    /****************************************************************************************
        AP03ATRegion - Update ATRegion and ATCluster when the Country changes
    *****************************************************************************************/
    if(PAD.canTrigger('AP03'))
    {
        List<InstalledBaseInfra__c> ap03InstalledBaseInfras = new List<InstalledBaseInfra__c>();
        for(InstalledBaseInfra__c InstalledBaseInfra : Trigger.new) 
            if(InstalledBaseInfra.Country__c != Trigger.oldMap.get(InstalledBaseInfra.Id).Country__c) 
                ap03InstalledBaseInfras.add(InstalledBaseInfra);

        if(ap03InstalledBaseInfras.size() > 0)
            AP03ATRegion.updateSObjectATRegion(ap03InstalledBaseInfras);
    }//bypass   
    /****************************************************************************************
        AP59InstalledBaseInfra - Update RecordType when the Equipment Class changes
    *****************************************************************************************/
    if(PAD.canTrigger('AP59'))
    {
        List<InstalledBaseInfra__c> ap59InstalledBaseInfras = new List<InstalledBaseInfra__c>();
        for(InstalledBaseInfra__c InstalledBaseInfra : Trigger.new) 
            if(InstalledBaseInfra.EquipmentClass__c != null && InstalledBaseInfra.EquipmentClass__c != Trigger.oldMap.get(InstalledBaseInfra.Id).EquipmentClass__c) 
                ap59InstalledBaseInfras.add(InstalledBaseInfra);

        if(ap59InstalledBaseInfras.size() > 0)
            AP59InstalledBaseInfra.syncRecordTypeEquipmentClass(ap59InstalledBaseInfras);
    }//bypass   
    
    System.debug('## >>> Installed Base Infra Before Update END');
}