/*
    UtilityTestMethod apex class
    ~ Author          : Adrian Modolea ~ adrian.modolea@axoa.fr (POC Alstom Transport june 2011) 
    ~ Date Created    : 29/06/2011 
    ~ Description     : Apex Class to provide TestMethod sObjects creation
*/
public class UtilityTestMethod 
{
    /*===============================================
            I.N.T.E.R.N.A.L C.L.A.S.S. Global
    ================================================*/              
    //exception class used for the test methods
    public class myException extends Exception {}

    /*************************************
        A.C.C.O.U.N.T.
    **************************************/
    // create a generic Account 
    public static Account getAccount() {
        return new Account(Name='TestAccount');
    } 
        
    // create some (size) accounts
    public static List<Account> getAccounts(Integer size) {
        List<Account> accounts = new List<Account>();
        for(Integer i=0; i<size; i++)
            accounts.add(getAccount());
        return accounts;
    }
    
    /*************************************
        A.L.S.T.O.M. E.M.P.L.O.Y.E.E.
    **************************************/
    // create a generic Alstom Employee 
    public static AlstomEmployee__c getAlstomEmployee() 
    {
        return new AlstomEmployee__c(Name='TestEmpl', EmployeeNumber__c='xxxxxxxxx99', Email__c='test@transport.alstom.com');
    } 
        
    // create some (size) Alstom Employees
    public static List<AlstomEmployee__c> getAlstomEmployees(Integer size) {
        List<AlstomEmployee__c> employees = new List<AlstomEmployee__c>();
        for(Integer i=0; i<size; i++)
            employees.add(new AlstomEmployee__c(Name='TestEmpl', EmployeeNumber__c='xxxxxxxxx99'+i,Email__c='test@transport.alstom.com'));
        return employees;
    }
    
    /*************************************
        A.L.S.T.O.M. R.E.L.A.T.I.O.N.S.H.I.P.
    **************************************/
    // create a generic Alstom Relationship 
    public static AlstomRelationship__c getAlstomRelationship() 
    {
        return new AlstomRelationship__c();
    } 
        
    // create some (size) Alstom Relationships
    public static List<AlstomRelationship__c> getAlstomRelationships(Integer size) {
        List<AlstomRelationship__c> relations = new List<AlstomRelationship__c>();
        for(Integer i=0; i<size; i++)
            relations.add(getAlstomRelationship());
        return relations;
    }
    
    /*************************************
        A.M.O.U.N.T.S
    **************************************/  
    // create a generic Tender 
    public static Amounts__c getAmounts(String tenderId) {
        return new Amounts__c(Tender__c=tenderId);
    } 
    
    /********************************** 
        B.U.D.G.E.T  L.I.N.E
    **********************************/ 
    // create a generic Budget Line
    public static BudgetLine__c getBudgetLine() {
        return new BudgetLine__c();
    } 
    
    /****************************************************
       B.Y.U.I.N.G. P.R.O.C.E.S.S. S.T.A.C.H.O.L.D.E.R.
    *****************************************************/ 
    // create a generic Buying Process Stakeholder
    public static BuyingProcessStakeholder__c getBuyingProcessStakeholder() 
    {
        return new BuyingProcessStakeholder__c();
    } 
    
    public static List<BuyingProcessStakeholder__c> getBuyingProcessStakeholders(Integer size) 
    {
        List<BuyingProcessStakeholder__c> bps = new List<BuyingProcessStakeholder__c>();
            for(Integer i=0; i<size; i++)
                bps.add(getBuyingProcessStakeholder());
        return bps;
    } 
    
    
    /********************************** 
        C.O.N.T.A.C.T.
    **********************************/ 
    // provides contacts
    public static List<Contact> getContacts(Integer size) {
        List<Contact> contacts = new List<Contact>();
                        
        for(Integer i=0; i<size; i++) {
            contacts.add(new Contact(Salutation='Mr', FirstName='Test', LastName='Contact Test Bulk')); 
        }
        return contacts;
    }
    
    // create a generic Contact 
    public static Contact getContact() {
        return new Contact(Salutation='Mr', FirstName='Test', LastName='Contact Test Bulk');
    }
    
    /***************************************
        C.O.M.P.E.T.I.T.I.O.N
    ****************************************/ 
    // get Opportunity Actor Record Types
    public static Map<String, Id> competitionRecTypes
    {
        get
        {
            if(competitionRecTypes == null)
            {
                competitionRecTypes = new Map<String, Id>();
                for(RecordType rt : [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType='Competition__c']){
                    System.debug('## >>> rt.DeveloperName , rt.Id <<< : '+rt.DeveloperName +' , '+ rt.Id);
                    competitionRecTypes.put(rt.DeveloperName , rt.Id);
                }
            }
            return competitionRecTypes;
        }
        set;
    }
    
    /********************************** 
        C.O.M.P.E.T.I.T.O.R.
    **********************************/ 
    public static List<Competitor__c> getCompetitors(Integer size) 
    {
        List<Competitor__c> competitors = new List<Competitor__c>();
                        
        for(Integer i=0; i<size; i++) {
            competitors.add(new Competitor__c()); 
        }
        return competitors;
    }
    
    // create a generic Competitor 
    public static Competitor__c getCompetitor() {
        return new Competitor__c(Name='TestCompetitor');
    } 
    
    /***************************************** 
        C.O.M.P.E.T.I.T.O.R.S. C.O.N.T.A.C.T.
    ******************************************/ 
    public static List<CompetitorsContact__c> getCompetitorsContacts(Integer size) 
    {
        List<CompetitorsContact__c> competitorsContacts = new List<CompetitorsContact__c>();
                        
        for(Integer i=0; i<size; i++) {
            competitorsContacts.add(new CompetitorsContact__c()); 
        }
        return competitorsContacts;
    }    
    
    /****************************************************** 
        C.O.N.F.I.D.E.N.T.I.A.L. I.N.F.O.R.M.A.T.I.O.N.
    ******************************************************/ 
    public static List<ConfidentialInformation__c> getConfidentialInformations(Integer size) 
    {
        List<ConfidentialInformation__c> confidentialInformations = new List<ConfidentialInformation__c>();
                        
        for(Integer i=0; i<size; i++) {
            confidentialInformations.add(new ConfidentialInformation__c()); 
        }
        return confidentialInformations;
    }
    
    /*********************************************************************** 
        C.U.S.T.O.M.E.R. V.I.S.I.O.N. A.N.D. G.L.O.B.A.L. S.T.R.A.T.E.G.Y.
    ************************************************************************/ 
    // provides CustomerVisionAndGlobalStrategy__c 
    public static List<CustomerVisionAndGlobalStrategy__c > getCustomerVision(Integer size) 
    {
        List<CustomerVisionAndGlobalStrategy__c > customerVisions = new List<CustomerVisionAndGlobalStrategy__c >();
                        
        for(Integer i=0; i<size; i++) 
            customerVisions.add(new CustomerVisionAndGlobalStrategy__c (Name='Axis Tets', Description__c='Test')); 
        return customerVisions;
    }
    
    /**************************************** 
        D.E.C.I.S.I.O.N. C.R.I.T.E.R.I.A. 
    ****************************************/ 
    // provides decision criterias
    public static List<DecisionCriteria__c > getDecisionCriterias(Integer size) 
    {
        List<DecisionCriteria__c> decisionCriterias = new List<DecisionCriteria__c>();
                        
        for(Integer i=0; i<size; i++) 
            decisionCriterias.add(new DecisionCriteria__c(/*Name='dc test', */Comment__c='cmt test', Rating__c='='));            
   
        return decisionCriterias;
    }
    /********************************** 
        F.I.1.5
    **********************************/ 
    // create a generic FI15
    public static FI15__c getFI15() {
        // Give me 4 approvers
        List<User> users =  UtilityTestMethod.getUsersToInsert(4);
        insert users;
    
        return new FI15__c(CountryFinanceDirector__c = users[0].Id, CountryMD__c = users[1].Id, PlatformController__c = users[2].Id, PlatformDirector__c = users[3].Id);
    } 
         
    /*************************************
        I.N.S.T.A.L.L.E.D B.A.S.E R.S
    **************************************/
    // create a generic Installed Base RS 
    public static InstalledBaseRS__c getInstalledBaseRS() {
        return new InstalledBaseRS__c(Name='IBRS1', Country__c = 'France');
    } 
     
    /*************************************
        M.I.L.E.S.T.O.N.E
    **************************************/  
    // create a generic Milestone 
    public static Milestone__c getMilestone(String tenderId) {
        return new Milestone__c(Type__c='TGR', Name='My test', Tender__c=tenderId, MeetingDate__c=System.today());
    }
     
    /*************************************
        O.P.P.O.R.T.U.N.I.T.Y.
    **************************************/  
    // create a generic Opportunity 
    public static Opportunity getOpportunity() {
        return new Opportunity(Name='TestOpportunity', StageName=System.Label.LBL0001, CloseDate=System.today());
    } 
    
    // create a generic Opportunity with BOID
    // Note: could be merged with getOpportunity(), no difference now that BOID__c is auto-number
    public static Opportunity getOpportunityWithBOID() {
        return new Opportunity(Name='TestOpportunity2', StageName=System.Label.LBL0001, LeadingProductLine__c='Information Solutions',Platform__c='Mainlines' , CloseDate=System.today());
    } 
        
    // create some (size) opportunities
    public static List<Opportunity> getOpportunities(Integer size) {
        List<Opportunity> opportunities = new List<Opportunity>();
        for(Integer i=0; i<size; i++)
            opportunities.add(getOpportunity());
        return opportunities;
    }   
    
    /***************************************
        O.P.P.O.R.T.U.N.I.T.Y. A.C.T.O.R.
    ****************************************/ 
    // get Opportunity Actor Record Types
    public static Map<String, Id> oppActorRecTypes
    {
        get
        {
            if(oppActorRecTypes == null)
            {
                oppActorRecTypes = new Map<String, Id>();
                for(RecordType rt : [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType='OpportunityActor__c'])
                    oppActorRecTypes.put(rt.DeveloperName , rt.Id);
            }
            return oppActorRecTypes;
        }
        set;
    }
      
    // create Opportunity Actor
    public static List<OpportunityActor__c> getOpportunityActors(Integer size) 
    {    
        List<OpportunityActor__c> opportunityActors = new List<OpportunityActor__c>();
        for(Integer i=0; i<size; i++)
            opportunityActors.add(new OpportunityActor__c());
        return opportunityActors;
    }
    
    /*************************************************
        O.P.P.O.R.T.U.N.I.T.Y. S.A.L.E.S T.E.A.M.
    **************************************************/  
    // create a generic OpportunityTeamMember 
    public static OpportunityTeamMember getOpportunityTeamMember() 
    { 
        return new OpportunityTeamMember(TeamMemberRole='Other');
    } 
        
    // create some (size) Opportunity TeamMembers
    public static List<OpportunityTeamMember> getOpportunityTeam(Integer size) 
    {
        List<OpportunityTeamMember> opportunityTeam = new List<OpportunityTeamMember>();
        for(Integer i=0; i<size; i++)
            opportunityTeam.add(getOpportunityTeamMember());
        return opportunityTeam;
    }   
    
    /****************************************************
        O.P.P.O.R.T.U.N.I.T.Y. A.S.S.E.S.S.E.M.E.N.T.
    *****************************************************/  
    // create a generic Opportunity Assessement
    public static OpportunityAssessment__c getOpportunityAssessement() 
    {
        return new OpportunityAssessment__c();
    } 
        
    // create some (size)  Opportunity Assessements
    public static List<OpportunityAssessment__c> getOpportunityAssessements(Integer size) 
    {
        List<OpportunityAssessment__c> opportunityAssessements = new List<OpportunityAssessment__c>();
        for(Integer i=0; i<size; i++)
            opportunityAssessements.add(getOpportunityAssessement());
        return opportunityAssessements;
    }   
    
    
    
    /********************************* 
       P.E.R.I.O.D.I.C.R.E.P.O.R.T. 
    *********************************/ 
    // provides periodic reports
    public static List<PeriodicReport__c> getPeriodicReports(Integer size) 
    {
        List<PeriodicReport__c> periodicReports = new List<PeriodicReport__c>();
                        
        for(Integer i=0; i<size; i++) 
            periodicReports.add(new PeriodicReport__c());            
   
        return periodicReports;
    }
    
    /******************* 
       P.R.O.D.U.C.T. 
    *********************/ 
    // provides products
    public static List<Product__c> getProducts(Integer size) 
    {
        List<Product__c> products = new List<Product__c>();
                        
        for(Integer i=0; i<size; i++) 
            products.add(new Product__c());            
   
        return products;
    }
    
    /*************************************
        P.R.O.J.E.C.T
    **************************************/  
    // create a generic Project
    public static Project__c getProject() {
        return new Project__c(Name='Test project');
    }
   
      
    /*************************************
        P.R.O.J.E.C.T S.U.R.V.E.Y
    **************************************/  
    // create a generic Project
    public static ProjectSurvey__c getProjectSurvey(ID ProjectId ) {
        return new ProjectSurvey__c(Name='Test ProjectSurvey',Project__c=ProjectId);
    }
    
    // provides products
    public static ProjectSurvey__c getProjectSurvey(ID ProjectId,ID CSSActionPlanId) 
    {
        return new ProjectSurvey__c(Name='Test ProjectSurvey with CCSA',Project__c=ProjectId,CSSActionPlan__c=CSSActionPlanId);
    }
    

    /******************* 
       P.R.O.J.E.C.T P.R.O.D.U.C.T. 
    *********************/ 
    // provides products
    public static List<ProjectProduct__c> getProjectProducts(Integer size) 
    {
        List<ProjectProduct__c> products = new List<ProjectProduct__c>();
                        
        for(Integer i=0; i<size; i++) 
            products.add(new ProjectProduct__c());            
   
        return products;
    }
    
    /******************* 
       C.S.S.A.C.T.I.O.N.P.L.A.N
    *********************/ 
    // provides products
    public static CSSActionPlan__c getCSSActionPlan(ID ProjectId) 
    {
        return new CSSActionPlan__c(Name='Test CSSActionPlan',Project__c=ProjectId);
    }
   
    
        
    /********************************************
        S.U.B.S.Y.S.T.E.M R.O.L.L.I.N.G S.T.O.C.K
    *********************************************/
    // create a generic Subsystem RS 
    public static SubsystemRS__c getSubsystemRS() {
        return new SubsystemRS__c(Name='SRS1');
    }
    
    /******************* 
        T.A.S.K.
    *********************/ 
    // provides tasks
    public static List<Task> getTasks(Integer size) 
    {
        List<Task> tasks = new List<Task>();
                        
        for(Integer i=0; i<size; i++) 
            tasks.add(new Task(Type='Other', Subject='Other', Status='Completed', ActivityDate=System.today()));            
   
        return tasks;
    }
    
    /*************************************
        T.E.N.D.E.R
    **************************************/  
    // create a generic Tender 
    public static Tender__c getTender(String oppId) {
        return new Tender__c(Opportunity__c=oppId, Name='123');
    } 
    
    // List Tenders
    public static List<Tender__c> getListTenders() 
    {
        List<Tender__c> tenders = new List<Tender__c>();
        Opportunity opp = UtilityTestMethod.getOpportunityWithBOID();
        insert opp;
        tenders.add(new Tender__c(Opportunity__c=opp.Id, Name='123'));
        System.debug('## >>> UtilityTestMethod opp.Id ' + opp.Id);
        System.debug('## >>> UtilityTestMethod tenders ' + tenders);        
        return tenders;
    }
    
    /*************************************
        T.E.N.D.E.R S.U.B.M.I.S.S.I.O.N
    **************************************/  
    // create a generic Tender 
    public static List<TenderSubmission__c> getListTenderSubmission(String oppId) {
        List<TenderSubmission__c> tenderSubmissions = new List<TenderSubmission__c>();
        tenderSubmissions.add(new TenderSubmission__c(Tender__c=getTender(oppId).Id, Name='123'));            
        return tenderSubmissions;
    }  
    
    /****************
        U.S.E.R.
    *****************/  
    // retrieve some (size) active users   
    public static List<User> getActiveUsers(Integer size) 
    {    
        return [SELECT Id, Name, ProfileId, Profile.Name FROM User WHERE IsActive = true and UserType = 'Standard' LIMIT :size];
    }
  
    public static List<User> getActiveUsersFromProfile(Integer size, String profilename) 
    {    
        String profileId = [SELECT Id FROM Profile WHERE Name = :profilename LIMIT 1].Id;
        
        return [SELECT Id, Name, ProfileId, Profile.Name FROM User WHERE IsActive = true AND ProfileId = :profileId LIMIT :size];
    }

    // loading Map of the Profile Id
    public static Map<String, Id> mapProfileId 
    {
        get 
        {
            if(mapProfileId == null) 
            {
                mapProfileId = new Map<String, Id>();
                for(Profile pr : [SELECT Id, Name FROM Profile])
                    mapProfileId.put(pr.Name, pr.Id);
            }
            return mapProfileId;
        }
        set;
    }
  
    // provide a List of Users to Insert 
    public static List<User> getUsersToInsert(Integer size) 
    {   
        String profileId = [SELECT Id FROM Profile WHERE Name = 'AT - Sales' LIMIT 1].Id;
                
        List<User> users = new List<User>();
        for(Integer i=0; i<size; i++) 
        {
            String login = 'testAP' + i + '@transport.alstom.com';
            users.add(new User(FirstName='Test', LastName='Test',Alias='AP'+i, Email='test.apex123'+i+'@transport.alstom.com', Username=login, TimeZoneSidKey='Europe/Paris', LocaleSidKey='en_GB', EmailEncodingKey='ISO-8859-1', ProfileId=profileId, LanguageLocaleKey='en_US', UserPermissionsMobileUser=false));
        }
        return users;
    }
    
    // provide a List of Users to Insert
    public static List<User> getUsersPQM(Integer size) 
    {   
        String profileId = [SELECT Id FROM Profile WHERE Name = 'AT - Survey Manager (Chatter+)' LIMIT 1].Id;
                
        List<User> users = new List<User>();
        for(Integer i=0; i<size; i++) 
        {
            String login = 'testAP' + i + '@transport.alstom.com';
            users.add(new User(FirstName='Test', LastName='Test',Alias='AP'+i, Email='test.apex123'+i+'@transport.alstom.com', Username=login, TimeZoneSidKey='Europe/Paris', LocaleSidKey='en_GB', EmailEncodingKey='ISO-8859-1', ProfileId=profileId, LanguageLocaleKey='en_US', UserPermissionsMobileUser=false));
        }
        return users;
    }
 
     public static List<User> getUsersAdmin(Integer size) 
    {   
        String profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;
                
        List<User> users = new List<User>();
        for(Integer i=0; i<size; i++) 
        {
            String login = 'testAP' + i + '@transport.alstom.com';
            users.add(new User(FirstName='Test', LastName='Test',Alias='AP'+i, Email='test.apex123'+i+'@transport.alstom.com', Username=login, TimeZoneSidKey='Europe/Paris', LocaleSidKey='en_GB', EmailEncodingKey='ISO-8859-1', ProfileId=profileId, LanguageLocaleKey='en_US', UserPermissionsMobileUser=false));
        }
        return users;
    }   

    /****************************************************
        W.I.N  L.O.S.S  A.N.A.L.Y.S.I.S
    *****************************************************/  
    // Create a generic WLA
    public static WinLossAnalysis__c getWinLossAnalysis() {
        return new WinLossAnalysis__c();
    }
      
    
    /****************************************************
        I.N.S.T.A.L.L.E.D. B.A.S.E. R.S. L.I.S.T.
    *****************************************************/  
     public static List<InstalledBaseRS__c> getInstalledBaseList(Integer size, string AccountId) 
    {   
        List<InstalledBaseRS__c> InstalledBaseList = new List<InstalledBaseRS__c>();
        for(Integer i=0; i<size; i++) 
        {
            InstalledBaseList.add(new InstalledBaseRS__c(Name='IBRS'+i, Country__c = 'France', Account__c = AccountId));
        }
        return InstalledBaseList;
    }   


    /****************************************************
        N.E.W.S. L.I.S.T.
    *****************************************************/  
     public static List<News__c> getNewsList(Integer size, string Type) 
    {   
        List<News__c> NewsList = new List<News__c>();
        for(Integer i=0; i<size; i++) 
        {
            NewsList.add(new News__c(Name='News'+i, Language__c = 'English (en)', Status__c = 'Published', Type__c = Type));
        }
        return NewsList;
    }   

    /****************************************************
        B.U.L.L.E.T.I.N. L.I.S.T.
    *****************************************************/  
     public static List<Bulletin__c> getBulletinList(Integer size, string Type, String AccountId) 
    {   
        List<Bulletin__c> BulletinList = new List<Bulletin__c>();
        for(Integer i=0; i<size; i++) 
        {
            BulletinList.add(new Bulletin__c(Name='Bulletin'+i, Account__c = AccountId, Language__c = 'EN', Status__c = 'Published', Type__c = Type, Text__c = 'test text'));
        }
        return BulletinList;
    }   

    /****************************************************
        C.A.S.E. L.I.S.T.
    *****************************************************/  
     public static List<Case> getCaseList(Integer size, string OpenStatus) 
    {   
        List<Case> CaseList = new List<Case>();
        for(Integer i=0; i<size; i++) 
        {
            CaseList.add(new Case(Subject='Case'+i, Status= OpenStatus));
        }
        return CaseList;
    }   

    /****************************************************
        A.L.S.T.O.M.  C.O.N.T.A.C.T.S.
    *****************************************************/  
    public static List<AlstomContact__c> getAlstomContacts(List<User>  AlstomUserList, Integer size, boolean IsTechnical, string ContactId) 
    {   
        List<AlstomContact__c> AlstomContactList = new List<AlstomContact__c>();
        for(Integer i=0; i<size; i++) 
        {
            AlstomContactList.add(new AlstomContact__c(AlstomContact__c= AlstomUserList[i].Id, Contact__c= ContactId, DisplayInCustomerPortal__c = (IsTechnical?'My Technical Contacts':'My Contacts')));
        }
        return AlstomContactList;
    }   
    
    /****************************************************
        A.L.S.T.O.M.  P.X.O. S.T.A.N.D.A.R.D.S.
    *****************************************************/  
    public static List<PxOStandard__c> getAlstomPxOStandards(Integer size, List<Id> recTypeId) 
    {   
        List<PxOStandard__c> AlstomPxOStandardList = new List<PxOStandard__c>();
        for(Integer i=0; i<size; i++) 
        {
            PxOStandard__c pxoStd = new PxOStandard__c();
            pxoStd.RecordTypeId = recTypeId.get(i);
            pxoStd.Platform__c = 'Metro';
            pxoStd.Product__c = 'Citadis CIS';
            pxoStd.ATRegion__c = 'Europe';
            pxoStd.SubRegion__c = 'Germany';
            pxoStd.Comments__c = 'My Comments';
            AlstomPxOStandardList.add(pxoStd);
        }
        return AlstomPxOStandardList;
    }   
    
    /****************************************************
        A.L.S.T.O.M.  P.X.O. S.T.A.N.D.A.R.D. L.I.N.E.S.
    *****************************************************/  
    public static List<PxOStandardLine__c> getAlstomPxOStandardLines(Integer size, List<Id> recTypeId, List<Id> pxoStdId, List<Id> siteId) 
    {   
        List<PxOStandardLine__c> AlstomPxOStandardLineList = new List<PxOStandardLine__c>();
        for(Integer i=0; i<size; i++) 
        {
            PxOStandardLine__c pxoStdLine = new PxOStandardLine__c();
            pxoStdLine.RecordTypeId = recTypeId.get(i);
            pxoStdLine.PxOStandard__c = pxoStdId.get(i);
            pxoStdLine.Site__c = siteId.get(i);
            pxoStdLine.MoBStrategy__c = 'Make';
            pxoStdLine.Type__c = 'CVS';
            AlstomPxOStandardLineList.add(pxoStdLine);
        }
        return AlstomPxOStandardLineList;
    } 
    public static List<User> getAccManagerUsers(Integer size) {
        return [SELECT Id, Name, Email FROM User WHERE IsActive=true AND Profile.Name = 'System Administrator' LIMIT :size];
    }

    // find some ordinary Users 
    public static List<User> getUsers(Integer size) {
        List<User> users = new List<User>();         
        if(users.size() == 0) { 
            List<AlstomEmployee__c> alstomEmployees = [SELECT SalesforceUser__r.Id FROM AlstomEmployee__c WHERE SalesforceUser__r.IsActive=true AND SalesforceUser__r.Profile.UserLicense.Name='Salesforce' LIMIT :size];
            List<Id> Ids = new List<Id>();
            for (AlstomEmployee__c ae : alstomEmployees) {
                Ids.add(ae.SalesforceUser__r.Id);
            }
            users = [SELECT Id, Name, UserName FROM User WHERE Id in :Ids];    
        }    
        system.debug('users in utility'+users);
        return users;
    }
    public static Boolean CanRunBatch()
    {
        Integer nb=0;
        for(sObject o :[ SELECT count(Id) nb FROM AsyncApexJob WHERE JobType='BatchApex' AND (Status = 'Processing' OR Status = 'Preparing') ] )
        {
            nb= Integer.valueOf(o.get('nb'));
        }
        if (nb < 5){    
            return true;
        }
        else
        {
            return false;   
        }
    }
 }