trigger BulletinAfterUpdate on Bulletin__c (after update) {
    
    System.debug('## >>> Bulletin after Update <<< run by ' + UserInfo.getName());
    
    /**************************************************************************************************************
        AP68Bulletin
        - 
    **************************************************************************************************************/
    /*if(PAD.canTrigger('AP68')) {
        List<Bulletin__c> ap68Bulletins = new List<Bulletin__c>();
        List<Boolean> isFirstPublication = new List<Boolean>();
        for(Bulletin__c bulletin : Trigger.new) {
            if ((bulletin.Status__c == System.label.LBL0325 && bulletin.ReadCounter__c == 0)  // Bulletin/Alert Published and non-read
                && (bulletin.Status__c != Trigger.oldMap.get(bulletin.Id).Status__c // is first publication
                    || bulletin.PublicationDate__c != Trigger.oldMap.get(bulletin.Id).PublicationDate__c) // is post-publication update
            ) {
                ap68Bulletins.add(bulletin);
                isFirstPublication.add(bulletin.Status__c != Trigger.oldMap.get(bulletin.Id).Status__c); // status changes to Published => is first publication
            }
        }
        if(ap68Bulletins.size() > 0) {
            AP68Bulletin.sendBulletinPublicationEmail(ap68Bulletins, isFirstPublication);
        }
    }//bypass
    
    System.debug('## >>> Bulletin after Update : END <<<');*/

}