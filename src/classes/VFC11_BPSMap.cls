public with sharing class VFC11_BPSMap {
    /*============================================================================
        V.A.R.I.A.B.L.E.S
    =============================================================================*/
    // current BPS Plan Id
    public String oppAsId {
        get { return ApexPages.currentPage().getParameters().get('oppAsId'); }
        private set;
    } 
    
    // current Opp Id
    public String oppId { 
        get { return ApexPages.currentPage().getParameters().get('oppId'); }
        private set;
    }
    
    public OpportunityAssessment__c oppAssessment {
        get { 
            if(oppAssessment == null) {
                oppAssessment = [SELECT id, Name FROM OpportunityAssessment__c WHERE Id =: oppAsId LIMIT 1];
            }
            return oppAssessment;
        }
        private set;
    }
    
    // current json file attachment
    public Attachment currentJSONFile           {get; private set;}
    
    // current html file attachment
    public Attachment currentHTMLFile           {get; private set;}
        
    // generic javascript function used for remoting callbacks
    public String pageJsCallback                    {get; set;}
    
    // get json content string from the file attachment
    public String currentJSONContent            {
        get {
            if(currentJSONFile != null) {
                try {
                    currentJSONContent = EncodingUtil.urlDecode(currentJSONFile.Body.toString(), 'UTF-8');
                } catch(Exception ex) {
                    currentJSONContent = currentJSONFile.Body.toString();
                }
            }
            return currentJSONContent;
        }
        private set;
    }
    
    // collection of available BPSs
    public List<BuyingProcessStakeholder__c> availableBpcs  
    {
        get{
            if(availableBpcs == null) {
                availableBpcs = new List<BuyingProcessStakeholder__c>();
                for(BuyingProcessStakeholder__c bps : [SELECT Id, Opportunity__c, ContactName__c, ContactName__r.Title, ContactName__r.Name,
                                                                AlstomUser__r.Name, 
                                                                Influence__c, Attitude__c, PromotorType__c,
                                                                Consultant__c, DecisionMaker__c, User__c,
                                                                Typology__c, Comments__c, ReportsTo__c
                                                        FROM BuyingProcessStakeholder__c
                                                        WHERE Opportunity__c = :oppId
                                                        ORDER BY ContactName__c DESC]){
                    availableBpcs.add(bps);
                }
            }
            return availableBpcs;
        } 
        set;
    }
    
    // temporary html file attachment used for generating the PDF preview
    public String htmlContent {
        get {
            if(currentHTMLFile != null) {
                try {
                    htmlContent = EncodingUtil.urlDecode(currentHTMLFile.Body.toString(), 'UTF-8');
                } catch(Exception ex) {
                    htmlContent = currentHTMLFile.Body.toString();
                }
            }
            return htmlContent;
        }
        set;
    }
    
    /*============================================================================
        C.O.N.S.T.R.U.C.T.O.R
    =============================================================================*/ 
    public VFC11_BPSMap()
    {
        // get current json and html attachment files
        if(oppAsId != null) {
            for(Attachment file : [SELECT Id, Name, Body FROM Attachment WHERE ParentId=:oppAsId 
                                        AND (Name='TECH_JSON_PLAN' OR Name='TECH_HTML_PLAN') ORDER BY CreatedDate]) {
                if(file.Name == 'TECH_JSON_PLAN')
                    currentJSONFile = file;
                else if(file.Name == 'TECH_HTML_PLAN')
                    currentHTMLFile = file;
            }
        }
    }
    
    /*============================================================================
        M.E.T.H.O.D.S
    =============================================================================*/
    // deleting a single bps
    public String deleteBPSId               {get; set;}
    public PageReference deleteBPS()
    {
        try {
            delete new BuyingProcessStakeholder__c(Id=deleteBPSId);
            pageJsCallback = 'ToolBar.prototype.removeMenuItem(\'BCP_'+deleteBPSId+'\');';
            if(Test.isRunningTest())
                throw new TestException();      
        } catch(Exception ex) {
            ApexPages.addMessages(ex);
        }
        return null;
    }

    // PROPERTIES TO DESCRIBE THE NEW JSON AND NEW HTML CONTENT (used for PageReference methods) :
    public String jsonText                  {get; set;}
    public String htmlText                  {get; set;}
    public Boolean preview                  {get; set;}
    public Boolean close                    {get; set;}
    
    public class TestException extends Exception {}
}