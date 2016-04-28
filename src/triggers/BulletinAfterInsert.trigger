trigger BulletinAfterInsert on Bulletin__c (after insert) {
    
    System.debug('## >>> Bulletin after Insert <<< run by ' + UserInfo.getName());
    
    /**************************************************************************************************************
        AP68Bulletin
        - 
    **************************************************************************************************************/
    /*if(PAD.canTrigger('AP68')) {
        List<Bulletin__c> ap68Bulletins = new List<Bulletin__c>();
        List<Boolean> isFirstPublication = new List<Boolean>();
        for(Bulletin__c bulletin : Trigger.new) {
            if (bulletin.Status__c == System.label.LBL0325) { // Published
                ap68Bulletins.add(bulletin);
                isFirstPublication.add(true);
            }
        }
        if(ap68Bulletins.size() > 0) {
            AP68Bulletin.sendBulletinPublicationEmail(ap68Bulletins, isFirstPublication);
        }
    }//bypass
    
    System.debug('## >>> Bulletin after Insert : END <<<');*/

}