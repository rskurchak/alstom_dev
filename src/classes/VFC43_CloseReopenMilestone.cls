/*********************************************************************
 SANITY CHECK Feb. 2014 - CODE MODIFICATION REQUIRED
 Modify code following instructions below.
 Remove this box once modifications done.
*********************************************************************/

/**
    ~ VFC43_CloseReopenMilestone Apex controller
    ~ Jawad GHOULAM ~ jawad.ghoulam@cgi.com
    ~ 06/09/2013
    ~ Description This class contains 3 methods :
        - close method contains folowing actions:
            - Status of the Milestone is set to Closed.
            - Call AttachPDF method to generate BOES and amounts as a PDF
        - reopen method contains folowing actions:
            - Status of the Milestone is set to Reopen.
            - Call AttachPDF method to generate BOES and amounts as a PDF
        - AttachPDF method contains folowing actions:
            - Generate BOES as a PDF and the PDF output file is attached to the Milestone, in the attachments. Attachment name is "BOES BOID - YYYY-MM-DD" where BOID is the BOID number of the opportunity and YYYY-MM-DD the current system date.
                Ex. : "BOES 118218 - 2013-12-25".
            - Generate Amounts as a PDF and the PDF output file is attached to the Milestone. Attachment name is "Amounts BOID - YYYY-MM-DD" with the same rules for BOID and current system date.
                Ex. : "Amounts 118218 - 2013-12-25".
    ~ Feature Id      : FEAT#0371 
 */
public with sharing class VFC43_CloseReopenMilestone {

    // Getting current milestone
    private Milestone__c milestone;
    // Allows to display or hide the button "Close Milestone"
    public Boolean displayCloseButton{get;set;}
    // Allows to display or hide the button "Reopen Milestone"
    public Boolean displayReopenButton{get;set;}
    // Contains Id of next Milestone
    public String milestoneId{get;set;}
    // Contains Id of Tender
    public String tenderId{get;set;}
    // Contains Id of Opportunity
    public String oppId{get;set;}
    // Contains BOID of Opportunity
    public String oppBOID{get;set;}
    // Contains Name of Opportunity
    public String oppName{get;set;}
    // Contains Attachment PDF Name for BOES as "BOES BOID - YYYY-MM-DD"
    public String pdfBOESName {get;set;}
    // Contains Attachment PDF Name for Amounts as "Amounts BOID - YYYY-MM-DD"
    public String pdfAmountsName {get;set;}
    // Contains list of related amounts
    public List<Amounts__c> lstAmounts = new List<Amounts__c>();
    // Contains Id of current user profile
    public String profileId {get;set;}
    
    public VFC43_CloseReopenMilestone(ApexPages.StandardController controller) {
        // Getting current record of Milestone
        this.milestone = (Milestone__c)controller.getRecord();
        Milestone__c mlstn = [Select Id, Status__c, Tender__c from Milestone__c where Id =: this.milestone.Id];
        milestoneId = mlstn.Id;
        profileId = UserInfo.getProfileId();

        // Getting needed informations on related Tender
        List<Tender__c> tender = [Select Id, Opportunity__c from Tender__c where Id =: mlstn.Tender__c];
        if(tender.size()>0){
            tenderId = mlstn.Tender__c;
/*********************************************************************
 SANITY CHECK INSTRUCTION: 
   Instead of using 2 queries, add the needed field as hidden field of the VF page

   <apex:hidden value=""{!Milestone__c.Tender__r.Opportunity__r.BOid__c }""/>"
 Remove this box once modification done.
*********************************************************************/
            // Getting needed informations on related Opportunity
            List<Opportunity> Opp = [Select Id, BOid__c, Name from Opportunity where Id =: tender[0].Opportunity__c];
            if(Opp.size()>0) {
                oppId = Opp[0].Id;
                oppBOID = Opp[0].BOid__c;
                oppName = Opp[0].Name;

                // Getting all related amounts to display on PDF Attachment
                lstAmounts = [Select Id from Amounts__c where Tender__c =: tenderId];
                
                // Set displayCloseButton to true if Status of Milestone is not Closed and current user profile in ('System Administrator', 'AT - Tender Control', 'AT - Project Team')
                if (mlstn.Status__c != System.label.LBL0065 && (profileId == System.label.LBL0051 || profileId == System.label.LBL0052 || profileId == System.label.LBL0127)) {
                    displayCloseButton = true;
                }
                else {
                    // Set displayReopenButton to true if Status of Milestone is Closed and current user profile in ('System Administrator', 'AT - Tender Control', 'AT - Project Team')
                    if (mlstn.Status__c == System.label.LBL0065 && (profileId == System.label.LBL0051 || profileId == System.label.LBL0052 || profileId == System.label.LBL0127)) {
                        displayReopenButton = true;
                    }
                }
            }
        }
    }
    
    // This method cfalled when we click on button "Close Milestone"
    public pagereference close() {
        // Set status of milestone to Closed
        this.milestone.Status__c = System.label.LBL0065;
        update this.milestone;
        
        // Format today date to "YYYY-MM-DD"
        string strToday;
        strToday = string.valueOf(System.today().year());
        if(System.today().month() <10) {
            strToday += '-0' + string.valueOf(System.today().month());
        }
        else {
            strToday += '-' + string.valueOf(System.today().month());
        }
        if(System.today().day() <10) {
            strToday += '-0' + string.valueOf(System.today().day());
        }
        else {
            strToday += '-' + string.valueOf(System.today().day());
        }
        
        // Set Attachment name for BOES PDF
        pdfBOESName = System.label.LBL0079 + ' ' + oppBOID + ' - ' + strToday;
        // Set Attachment name for Amounts PDF
        pdfAmountsName = System.label.LBL0080 + ' ' + oppBOID + ' - ' + strToday;
        
/*********************************************************************
 SANITY CHECK INSTRUCTION: 
   Query + DML on Attachments: Use 1 query on Attachment => reduce number 
   of query (governor lim)
   Replace query clause : filter on Id not on name
   Delete both list in a single operation => reduce DML number
 Remove this box once modification done.
*********************************************************************/
        // Contains existing attachment of BOES
        List<Attachment> lstAttBOES = new List<Attachment>();
        // Contains existing attachment of Amounts
        List<Attachment> lstAttAmounts = new List<Attachment>();
        
        // Getting the existing attachment for BOES with the same name
        lstAttBOES = [Select Id, Name from Attachment where Name =: pdfBOESName+'.pdf'];
        // Getting the existing attachment for Amounts with the same name
        lstAttAmounts = [Select Id, Name from Attachment where Name =: pdfAmountsName+'.pdf'];
        
/*********************************************************************
 SANITY CHECK INSTRUCTION: 
   Use Try/Catch + error handling around delete operations.
 Remove this box once modification done.
*********************************************************************/
        // Delete existing attachment for BOES
        if(lstAttBOES.size() > 0) {
            delete lstAttBOES;
        }

        // Delete existing attachment for Amounts
        if(lstAttAmounts.size() > 0) {
            delete lstAttAmounts;
        }
        
        // Call method "AttachPDF" to create a new attachment for BOES
        AttachPDF(oppId, milestoneId, pdfBOESName, Page.VFP08_Opportunity_BOExecutiveSummary, '' );
        
        // Call method "AttachPDF" to create a new attachment for Amounts
        if(lstAmounts.size() > 0) {
                AttachPDF(tenderId, milestoneId, pdfAmountsName, Page.VFP45_Tender_Amount, oppName );
        }

        // Set URL to redirection page (return to current milestone page to refresh informations)
        PageReference redirectUrl = new pagereference('/apex/VFP43_RedirectPageMilestone');
        return redirectUrl;
    }
    
    // This method cfalled when we click on button "Reopen Milestone"
    public pagereference reopen() {
        // Set status of milestone to Open
        this.milestone.Status__c = System.label.LBL0064;
        update this.milestone;
        
        // Set URL to redirection page (return to current milestone page to refresh informations)
        PageReference redirectUrl = new pagereference('/apex/VFP43_RedirectPageMilestone');
        return redirectUrl;
    }
    
    // This method create attachment for BOES and Amounts
    public void AttachPDF( String pageParentId, String attachParentId, String PDFName, PageReference vPage, String oppName ){
        PageReference pdfBOES = vPage;
        // add parent id to the parameters for standardcontroller
        pdfBOES.getParameters().put('id',pageParentId);
        
        if(oppName != '') {
            pdfBOES.getParameters().put('oppName',oppName);
        }
        
        // create the new attachment
        Attachment attach = new Attachment();
     
        // the contents of the attachment from the pdf
        Blob body;

        try {
     
            // returns the output of the page as a PDF
            body = pdfBOES.getContent();
     
        // need to pass unit test
        } catch (VisualforceException e) {
            body = Blob.valueOf('Error: Can not create Output PDF');
        }

        attach.Body = body;
        // add the pdf file name
        attach.Name = PDFName + '.pdf';
        attach.IsPrivate = false;
        // attach the pdf to the account
        attach.ParentId = attachParentId;
/*********************************************************************
 SANITY CHECK INSTRUCTION: 
   Use Try/Catch + error handling around insert instruction.
 Remove this box once modification done.
*********************************************************************/        
        insert attach;
    }
}