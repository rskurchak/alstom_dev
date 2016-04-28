public class CustomMetadataServices {

    static public final String CONTACT_UPDATE_ERROR_NOTIFICATION = 'ContactUpdateErrorNotification';
    static public final String PERMISSION_SET_ASSIGNMENT_EXCEPTION = 'PermissionSetAssignmentException';
    static public final String GENERAL_EMAIL_NOTIFICATION = 'GeneralEmailNotification';
    static public final String RMA_FORM_SETTING_NAME = 'RMA_Form';

    public static String getNotificationRecipients( String metadataName ){
        List<EmailNotificationSettings__mdt> mdList = [ Select Id, SendTo__c From EmailNotificationSettings__mdt Where DeveloperName = :metadataName ];
        if( mdList.isEmpty() ) return '';
        return mdList[0].SendTo__c;
    }

    public static RMA_Form__mdt getPDFFormSetting( String metadataName ){
        List<RMA_Form__mdt> settings = [SELECT Id, Attachment_Name__c, Email_Subject__c, Email_Template_Name__c
                                        FROM RMA_Form__mdt
                                        WHERE DeveloperName = : metadataName];

        return !settings.isEmpty() ? settings[0] : null;
    }
}