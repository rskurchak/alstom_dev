/**
* Service class for Bulletin__c object
*  
* @author Roman Skutchak
* @version 1.0
* @since   2016-03-15
*/
global with sharing class BulletinServices {

    static public final String BULLETIN_TYPE_BULLETIN = 'Bulletin';
    static public final String BULLETIN_TYPE_ALERT = 'Alert';

    static public final String BULLETIN_STATUS_PUBLISHED = 'Published';

    private static EmailTemplate bulletinAlertNotifEmailTemplate {
        get{
            if( bulletinAlertNotifEmailTemplate == null ){
                bulletinAlertNotifEmailTemplate = [select Id from EmailTemplate where DeveloperName = :System.label.LBL0324 LIMIT 1];
            }
            return bulletinAlertNotifEmailTemplate;
        }
        set;
    }

    private static EmailTemplate bulletinAlertUpdateNotifEmailTemplate {
        get{
            if( bulletinAlertUpdateNotifEmailTemplate == null ){
                bulletinAlertUpdateNotifEmailTemplate = [select Id from EmailTemplate where DeveloperName = :System.label.LBL0326 LIMIT 1];
            }
            return bulletinAlertUpdateNotifEmailTemplate;
        }
        set;
    }


    static public Map<String, List<Bulletin__c>> getAvailableBulletinsByTypes( String languageCode ){
        Map<String, List<Bulletin__c>> bulletinAlertMap = new Map<String, List<Bulletin__c>>();

        String bulletinQueryStr =  ' SELECT Id, Type__c, Name, Image__c, Text__c, PublicationDate__c, ReadCounter__c, Language__c, ';
        bulletinQueryStr        += ' ( Select Id FROM Read_Receipts__r where CreatedById = \'' + UserInfo.getUserID() + '\' ) ';
        bulletinQueryStr        += ' FROM Bulletin__c ';
        bulletinQueryStr        += ' WHERE Displayed__c = true ';
        if( languageCode != null ) bulletinQueryStr        += ' and Language__c like :languageCode ';
        bulletinQueryStr        += ' ORDER BY PublicationDate__c desc LIMIT 100 ';

        for( Bulletin__c bull : Database.query( bulletinQueryStr ) ){
            if( !bulletinAlertMap.containsKey( bull.Type__c ) ){
                bulletinAlertMap.put( bull.Type__c, new List<Bulletin__c>() );
            }
            bulletinAlertMap.get( bull.Type__c ).add( bull );
        }

        return bulletinAlertMap;
    }

    static public void notiyExternalUsersAboutBulletinUpdate( List<Bulletin__c> updatedBulletins ){
        Map<Id, Set<Id>> bulletinIdToAccountIds = new Map<Id, Set<Id>>();
        Map<Id, String> bulletinLanguage = new Map<Id, String>();

        for( Bulletin_Sent_Notification__c bsn : [ Select Id, Account__c, Bulletin__c, Bulletin__r.Language__c From  Bulletin_Sent_Notification__c Where Bulletin__c IN :updatedBulletins ] ){
            if( !bulletinLanguage.containsKey( bsn.Bulletin__c ) ){
                bulletinLanguage.put( bsn.Bulletin__c, bsn.Bulletin__r.Language__c );
            }
            if( !bulletinIdToAccountIds.containsKey( bsn.Bulletin__c ) ){
                bulletinIdToAccountIds.put( bsn.Bulletin__c, new Set<Id>() );
            }
            bulletinIdToAccountIds.get( bsn.Bulletin__c ).add( bsn.Account__c );
        }

        sendEmailsForContacts( bulletinIdToAccountIds, bulletinLanguage, bulletinAlertUpdateNotifEmailTemplate.Id );
    }


    /**
     *  Implements sequence of steps:
     *  1) Shares record with parent of accounts of shared users
     *  2) Sends notification to selected users
     *  3) Creates Bulletin_Sent_Notification__c records to mark Users that were already notified by email
     *  Called by Bulletin Detail Page Custom Button ShareAndNotifyUsers.
     */    
    webservice static String shareAndNotifyUsers( String bulletinId, String lang ) {
        try {
            // Update Bulletin with Published Status
            updateBulletinStatus( bulletinId );

            SharingService service = new SharingService( new BulletinMapper() );

            // Share Bulletin with appropriate accounts
            service.shareBulletin( bulletinId );

            if( lang != null ){
                Set<Id> accountIds = service.getAccountsForBulletinToSendNotification( bulletinId );
                if( !accountIds.isEmpty() ){
                    Map<Id, Set<Id>> bulletinIdToAccountIds = new Map<Id, Set<Id>>();
                    Map<Id, String> bulletinLanguage = new Map<Id, String>();
                    bulletinIdToAccountIds.put( bulletinId, accountIds );
                    bulletinLanguage.put( bulletinId, lang );
                    // Send notification to all external users related to appropriate accounts
                    String errors = sendEmailsForContacts( bulletinIdToAccountIds, bulletinLanguage, bulletinAlertNotifEmailTemplate.Id );
                    if( errors!='' ){
                        return errors;
                    } else { //Create notification records for sent records
                        createNotificationRecords( bulletinId, accountIds );
                    }
                }
            } else {
                return 'langIsEmpty';
            }

            return 'Success';
        } catch ( Exception e ) {
            return 'An error has occurred: ' + e.getMessage();
        }
    }

    static private String sendEmailsForContacts( Map<Id, Set<Id>> bulletinIdToAccountIds, Map<Id, String> bulletinLanguageMap, Id templateId ){
        List<Messaging.Email> emailList = new List<Messaging.Email>();

        List<Id> allAccIds = new List<Id>();
        for( Id bullId : bulletinIdToAccountIds.keySet() ){
            allAccIds.addAll( new List<Id>( bulletinIdToAccountIds.get( bullId ) ) );
        }

        Map<Id, List<User>> accIdToUserMap = new Map<Id, List<User>>();
        for( User u : [ Select Id, LanguageLocaleKey, ContactId, Contact.Email, Contact.AccountId
                        From User
                        Where isActive = true And
                            IsPortalEnabled = true And
                            Contact.AccountId IN : allAccIds ] ){
            if( !accIdToUserMap.containsKey( u.Contact.AccountId ) ){
                accIdToUserMap.put( u.Contact.AccountId, new List<User>() );
            }
            accIdToUserMap.get( u.Contact.AccountId ).add( u );
        }

        // prepare the email per contact
        for( Id bullId : bulletinIdToAccountIds.keySet() ){
            for( Id accId : bulletinIdToAccountIds.get( bullId ) ){
                for ( User u : ( accIdToUserMap.containsKey(accId) ) ? accIdToUserMap.get( accId ) : new List<User>() ) {
                    if ( isTheSameLanguage( u.LanguageLocaleKey, bulletinLanguageMap.get( bullId ) ) && u.Contact.Email != null ) {
                        // Only SingleEmailMessage works with Custom Object as WhatId
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setTemplateId( templateId );

                        mail.setWhatId( bullId ); // mail prepared for current bulletin
                        mail.setTargetObjectId( u.ContactId ); // send the mail to customer portal Contact email addr
                        mail.setSaveAsActivity( false );
                        emailList.add(mail);
                    }
                }
            }
        }


        // send the notification Emails
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(emailList, false); // send the mails by ignoring errors occurred
        String errors = '';
        for (Messaging.SendEmailResult result: results) {
            if (!result.isSuccess()) {
                errors = result.getErrors()[0].getMessage() + ' | ';
            }
        }
        return errors;
    }

    static private Boolean isTheSameLanguage( String userLang, String bulletinLang ){
        String userLanguageCode =  '(' + userLang.substring(0, 2) + ')';
        if (userLanguageCode != '(fr)') {
            userLanguageCode =  '(en)';
        }
        return bulletinLang.contains( userLanguageCode );
    }

    static private void updateBulletinStatus( Id bulletinId ){
        if( [Select Id, Status__c From Bulletin__c Where Id = :bulletinId ].Status__c != BULLETIN_STATUS_PUBLISHED ){
            update new Bulletin__c( Id = bulletinId, Status__c = BULLETIN_STATUS_PUBLISHED );
        }
    }

    static private void createNotificationRecords( Id bulletinId, Set<Id> accountIds ){
        List<Bulletin_Sent_Notification__c> notifications = new List<Bulletin_Sent_Notification__c>();
        for( Id accId : accountIds ){
            notifications.add( new Bulletin_Sent_Notification__c( Account__c = accId, Bulletin__c = bulletinId ) );
        }
        insert notifications;
    }

}