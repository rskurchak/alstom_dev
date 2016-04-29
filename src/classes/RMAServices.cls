global without sharing class RMAServices {
    public static final String RMA_ITEM_OPTION_UX = 'UX';
    public static final String RMA_ITEM_OPTION_EXPEDITE = 'Expedite';
    public static final String RMA_ITEM_OPTION_STANDARD = 'Standard';
    private static final String REPLASMENT_VALUE = '{!RMA__c.Name}';

    public static RMA__c getRMAById(Id rmaId){
        List<RMA__c> listRMA = [SELECT Id, Name, Submitted_Date__c, CustomerName_Returnto__c, Attention_Returnto__c,
                                    Street_Returnto__c, City_Returnto__c, StateProvince_Returnto__c, Zip_Returnto__c,
                                    CustomerName_Billto__c, Attention_Bilto__c, Street_Billto__c, City_Billto__c,
                                    StateProvince_Billto__c, Zip_Billto__c, Phone__c, Fax__c, Email__c, Emailc__c,
                                    Priority_Code__c, Loco_Number__c, Additional_Comments__c, Payment_Type__c, PO_Number__c
                                FROM RMA__c
                                WHERE Id =: rmaId];

        return !listRMA.isEmpty() ? listRMA[0] : new RMA__c();
    }

    public static List<Item__c> getItemsByRMAId(Id rmaId){
        return [SELECT Id, Name, Action__c, Item_Description__c, Serial_Number__c, RMA__c,
                    Reason_for_Return__c, GE_Part_Number__c, Processing_Option__c
                FROM Item__c
                WHERE RMA__c = : rmaId];
    }

    webservice static String submitRMA(String rmaId, String rmaName, String emailToAddress, String emailToCCAddress, String contactId) {
        //check if Email field is populated
        if (String.isEmpty(emailToAddress)){
            return System.label.RMA_Email_Empty_Notification;
        }

        try {
            //update Status__c and Submitted_Date__c field values in the incomming RMA__c record
            RMA__c rma = new RMA__c(Id = Id.valueOf(rmaId),
                                    Status__c = System.label.RMA_Submit_Status,
                                    Submitted_Date__c = Date.today());
            update rma;

            //send email with attachment
            if (String.isEmpty(contactId)){
                sendEmailWithAttachment(Id.valueOf(rmaId), rmaName, emailToAddress, emailToCCAddress);
            } else {
                sendEmailWithAttachmentFuture(Id.valueOf(rmaId), rmaName, emailToAddress, emailToCCAddress);
            }

            return 'Success';
        } catch (Exception ex){
            return 'An error has occurred: ' + ex.getMessage();
        }
    }
@future
    private static void sendEmailWithAttachmentFuture(Id rmaId, String rmaName, String emailToAddress, String emailToCCAddress){//For Portal Users
        sendEmailWithAttachment(rmaId, rmaName, emailToAddress, emailToCCAddress);
    }

    private static void sendEmailWithAttachment(Id rmaId, String rmaName, String emailToAddress, String emailToCCAddress){
        RMA_Form__mdt setting = CustomMetadataServices.getPDFFormSetting( CustomMetadataServices.RMA_FORM_SETTING_NAME );

        EmailTemplate templ = getSubjectBodyForEmail( setting != null ? setting.Email_Template_Name__c : '' );

        String emailBody    = !String.isEmpty(templ.Body)    ? templ.Body.replace(REPLASMENT_VALUE, rmaName)    : '';
        String emailSubject = !String.isEmpty(templ.Subject) ? templ.Subject.replace(REPLASMENT_VALUE, rmaName) : 'Return Material Authorization';

        //prepare Email Attachment
        PageReference pdf = Page.AttachmentPDF;
        pdf.setRedirect(false);
        pdf.getParameters().put('id', rmaId);
        Blob body = (!Test.isRunningTest()) ? pdf.getContentAsPDF() : Blob.valueOf('test blob');

        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        attach.setContentType('application/pdf');
        attach.setFileName( setting != null && !String.isEmpty(setting.Attachment_Name__c) ? setting.Attachment_Name__c : 'Attachment.pdf');
        attach.setInline(false);
        attach.Body = body;

        //prepare mail with attachment
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses( new List<String>{ emailToAddress } );
        if ( !String.isEmpty(emailToCCAddress) ) mail.setCcAddresses( new List<String>{ emailToCCAddress } );
        mail.setSubject( emailSubject );
        mail.setPlainTextBody( emailBody );
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });

        //send Email
        Messaging.sendEmail( new Messaging.SingleEmailMessage[] { mail } );
    }

    private static EmailTemplate getSubjectBodyForEmail(String emailTemplateName){
        List<EmailTemplate> emailTemplateList = String.isEmpty(emailTemplateName) ? new List<EmailTemplate>() :
                                                                                    [SELECT Id, Body, HtmlValue, Subject
                                                                                     FROM EmailTemplate
                                                                                     WHERE DeveloperName = : emailTemplateName];

        return emailTemplateList.isEmpty() ? new EmailTemplate() : emailTemplateList[0];
    }
}