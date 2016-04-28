/*
 VFC73_PortalCaseNew
   ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
    ~ Date Created    : 24/06/2014 
    ~ Description     : Apex Class to Create a new Portal Case.
*/
public class VFC73_PortalCaseNew {
    Public Case PortalCase {get; set;}
    public string retURL {get;set;}
    
    public Id citadisTypeId {
        get {
            return [SELECT Id FROM RecordType WHERE SobjectType = 'Case' AND DeveloperName = 'Citadis_Technical_Request'][0].Id;
        }        
    }

    public String issueFieldDescription {
        get {
            if( this.PortalCase.RecordTypeId == citadisTypeId ){
                return Label.Case_New_Issue_Citadis_Technical;
            } else {
                return Label.Case_New_Issue_all_except_Citadis_Technical;
            }
        }
    }

    public VFC73_PortalCaseNew(ApexPages.StandardController controller) {
        String id = ApexPages.currentpage().getparameters().get('id');
        
        if (id == null) {
            this.PortalCase = (Case) controller.getRecord();
            this.PortalCase.Type = ApexPages.currentpage().getparameters().get('cas5');
        } else {
            System.debug('Reopening an existing case: ' + id);
            Case fullCase = loadCase(id);
            this.PortalCase = reopenCase(fullCase);
        }
        retURL = apexpages.currentpage().getparameters().get('retURL');
    }

    public PageReference redirect() {
        ID contactId = [Select contactid from User where id =:UserInfo.getUserId()].contactId;
        if(contactId ==null){
            System.debug('Not a contact, redirecting to standard salesforce create page');
            String url = '/' + Case.SObjectType.GetDescribe().GetKeyPrefix() + '/e?&nooverride=1&RecordType=' + this.PortalCase.RecordTypeId;
            system.debug('url: ' + url);
            return new ApexPages.PageReference(url).SetRedirect(true);
        } else {
          return null;
        }
    }
    
    public PageReference doSave() {
        
        try {
            system.debug('returl: ' + retURL);
            if (retURL != null) {
                if (retURL.LastIndexOf('Home') != -1) {
                    this.PortalCase.Origin = 'Contact Us';
                } else{
                    this.PortalCase.Origin = 'Web';
                    //this.PortalCase.Origin = 'Fleet Center';              
                }
            }
            /* Now done in VF with required="true"
            if (string.isblank(this.PortalCase.Type))
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, System.Label.LBL0198 + ' ' + Schema.Case.fields.Type.getDescribe().getLabel()));
                return null;
            }
            if (string.isblank(this.PortalCase.Subject))
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, System.Label.LBL0198 + ' ' + Schema.Case.fields.Subject.getDescribe().getLabel()));
                return null;
            }
            if (string.isblank(this.PortalCase.Equipment__c))
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, System.Label.LBL0198 + ' ' + Schema.Case.fields.Equipment__c.getDescribe().getLabel()));
                return null;
            }
            if (string.isblank(this.PortalCase.Categories__c))
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, System.Label.LBL0198 + ' ' + Schema.Case.fields.Categories__c.getDescribe().getLabel()));
                return null;
            }
            */

            String richtextstr = string.valueof(this.PortalCase.Description);
            richtextstr = richtextstr.replaceall('<.*>','');
            if (string.isblank(richtextstr))
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, System.Label.LBL0198 + ' ' + Schema.Case.fields.Description.getDescribe().getLabel()));
                return null;
            }
            
            this.PortalCase.SatisfactionQuestionnaire__c = true;
            AssignmentRule AR = new AssignmentRule();
            AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
            dmlOpts.EmailHeader.triggerUserEmail= true;
            PortalCase.setOptions(dmlOpts);
            insert PortalCase;
            if(Test.isRunningTest()){ 
                throw new UtilityTestMethod.myException();
                return null; 
            }
        } catch (Exception e){// roll everything back in case of error
            ApexPages.addMessages(e);
            return null;
         }
         return new PageReference(System.Label.LBL0207);
    }    
    
        
    private static Case loadCase(Id caseId) {
        List<String> fields = new List<String>(Case.SObjectType.getDescribe().fields.getMap().keySet());
        String soql = 'select ' + String.join(fields, ',') + ' from Case where Id = \'' + caseId + '\'';
        List<Case> cases = Database.query(soql);
            
        if (cases.size() == 0) {
            return null;
        } else {
            return cases[0];
        }
    }

    private static Case reopenCase(Case c) {
        Case clonedCase = cloneCase(c);

        //Update new case values as we don't want some to clone over
        clonedCase.Status = 'New';
        
        // Clean survey fields
        clonedCase.Quality_of_Request_Resolution__c = null;
        clonedCase.Rapidity_of_request_resolution__c = null;
        clonedCase.Comments_on_Satisfaction__c = null;
        clonedCase.Survey_Taken_Date__c = null;

        //Add original Case ID to list so we can update
        clonedCase.ParentId = c.Id;

        return clonedCase;
    }

    private static Case cloneCase(Case c) {
        SObjectType objectType = Schema.getGlobalDescribe().get('Case');
        DescribeSObjectResult objDef = objectType.getDescribe();
        Map<String, SObjectField> fields = objDef.fields.getMap();

        Case cloned = new Case();
        
        for (SObjectField field : fields.values()) {
            if (field.getDescribe().isUpdateable()) {
                cloned.put(field, ((sObject) c).get(field));
            }
        }
        
        return cloned;
    }
    
    public class ReopenRequestException extends Exception {}

}