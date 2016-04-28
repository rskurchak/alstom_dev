trigger BuyingProcessStakeholderBeforeInsert on BuyingProcessStakeholder__c (before insert) {
    System.debug('## >>> BuyingProcessStakeholder Before Insert <<< run by ' + UserInfo.getName());
    
    /*****************************************************************************
        AP10BuyingProcessStakeholder
        - to update Alstom Contact with Contact Owner for all BuyingProcessStakeholder where this field is null
    ******************************************************************************/
    if(PAD.canTrigger('AP10')) {
        AP10BuyingProcessStakeholder.fillContact(Trigger.new);
    }//bypass

    System.debug('## >>> BuyingProcessStakeholder Before Insert : END <<<');
}