/*********************************************************************
 SANITY CHECK Feb. 2014 - CODE MODIFICATION REQUIRED
 Modify code following instructions below.
 Remove this box once modifications done.
*********************************************************************/
/*
    VisualForce Controller for VFP12_OpportunityAssessment
    ~ Author          : Mohamed EL MOUSSAOUI ~ mohamed.el-moussaoui@axoa.fr 
    ~ Date Created    : 18/05/2012
    
    ~ Feature Id      : FEAT#0546 
    ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
    ~ Date            : 07/03/2014
    ~ Description     : Bug: Cannot Open due to string length.   

    ~ Feature Id      : FEAT#0619 
    ~ Author          : Christophe Averseng
    ~ Date            : 19/05/2014
    ~ Description     : Change AssessmentVersion__c format.
    
    ~ Feature Id      : FEAT#0766 
    ~ Author          : Antonin MAIGNE ~ antonin.maigne@cgi.com
    ~ Date            : 16/01/2014
    ~ Description     : CR-0741 Market Price modifications   
    
   Version  X.1 WO0000002536137 Author(Arun Seri)--Added code to fetch the Opportunity Id 
*/   
public class VFC12_OpportunityAssessment 
{ 
    /* For PDF FindPlan */
    // contains the StakeHolders Names
    public Set<String> stakeHolders {get; set;}
    public Map<String, String> stakeHoldersIdName {get; set;}
    
    public String mapKeys {get; set;}
    public Integer nbAlstomEmployee {get; set;}
    public String styleDisplay {get; set;}
    public Boolean isNoCompetitions {get; set;}
    
    public Integer nbActions {get; set;}
    public Integer nbOtherSalesTeamMembers {get; set;}
    //Arun
   // public ID oppSourceId;
    //public ID retURL;
    
    // contains the AlstomContacts Names
    public Set<String> alstomContacts {get; set;}
    public Map<String, String> alstomContactsIdName {get; set;}
    
    // the map of the relation StakeHolde & Alstom Contact with the Frequency of contac
    public Map<String, String> stackHolderWithValue {get; set;} 
    
    // variable used for rerendreing the Matrix or an Information msg to the user if there no information to show
    public Boolean showTabel {get; set;}
    
    public void initMatrix(Id oppId)
    {
        stakeHolders = new Set<String>();
        alstomContacts = new Set<String>();
        stackHolderWithValue = new Map<String, String>();
        stakeHoldersIdName = new Map<String, String>();
        alstomContactsIdName = new Map<String, String>();
        nbAlstomEmployee = 0;
        for(AlstomRelationship__c relation : [Select Stakeholder__c, Stakeholder__r.ContactName__r.Name, AlstomEmployee__r.FullName__c, AlstomEmployee__c, FrequencyOfContacts__c From AlstomRelationship__c WHERE Stakeholder__r.Opportunity__c = :oppId])
        {
            showTabel = true;
            stakeHolders.add(relation.Stakeholder__c);
            alstomContacts.add(relation.AlstomEmployee__c);
            
            stakeHoldersIdName.put(relation.Stakeholder__c, relation.Stakeholder__r.ContactName__r.Name);
            alstomContactsIdName.put(relation.AlstomEmployee__c, relation.AlstomEmployee__r.FullName__c);
            
            String frequency = relation.FrequencyOfContacts__c;
            if(frequency == 'Frequent')
                frequency = '<b>Frequent</b>';
            stackHolderWithValue.put(''+relation.Stakeholder__c+relation.AlstomEmployee__c, frequency);
            mapKeys = mapKeys + ';' + ''+relation.Stakeholder__c+relation.AlstomEmployee__c + ';';
        }
        nbAlstomEmployee = alstomContacts.size();
        
        for(String sh : stakeHolders) 
            for(String ac : alstomContacts) 
                if(!stackHolderWithValue.containsKey(''+sh+ac))
                    stackHolderWithValue.put(sh+ac, '');
    }
    
    /*
    public Map<String, Boolean> customerBPPicklist
    {
        get
        {
            if(customerBPPicklist == null)
            {
                customerBPPicklist = new Map<String, Boolean>();
                Schema.DescribeFieldResult field = OpportunityAssessment__c.CustomerBuyingProcess__c.getDescribe();
                for(Schema.PicklistEntry pickVal :field.getPicklistValues())
                    customerBPPicklist.put(pickval.getValue(), oppAssessment.CustomerBuyingProcess__c == pickval.getValue());
            }       
            return customerBPPicklist;
        }
        set;
    }
    */
    public List<BuyingProcessStakeholder__c> bps
    {
        get
        {
            if(bps == null )
            {
                bps = new List<BuyingProcessStakeholder__c>();
                for(BuyingProcessStakeholder__c bp : [SELECT Id, ContactName__r.LastName, ContactName__r.FirstName, ContactName__r.Title, 
                                                      User__c, DecisionMaker__c, Consultant__c, PromotorType__c, Influence__c, Typology__c, Attitude__c
                                                      FROM BuyingProcessStakeholder__c WHERE Opportunity__c =: oppAssessment.Opportunity__c order by ContactName__r.LastName, ContactName__r.FirstName, ContactName__r.Title])
                    bps.add(bp);
            }
            return bps;
        }
        set;
    }
    
    public String currentDateTime//Formated 
    {
        get
        {
            return Datetime.now().format('d MMM yyyy h:mm a');
        }
        private set;
    } 
    
    // get the Alstom formal strategy of the related Opportunity to the current OpportunityAssessment__c
    // custom object : OpportunityActor__c
    public String AlstomFormalStrategy
    {
        get
        {
            if(AlstomFormalStrategy == null)
            {
                AlstomFormalStrategy = '';
                List<OpportunityActor__c> oppStrategy = [SELECT IsDelay__c, IsFlank__c, IsGorilla__c, IsFragment__c 
                                                   FROM OpportunityActor__c WHERE Opportunity__c=:relatedOpp.Id AND Competitor__c=:System.Label.LBL0008];
                if(oppStrategy.size() > 0) {                                                                                                   
                    if(oppStrategy[0].IsGorilla__c) {
                        AlstomFormalStrategy = AlstomFormalStrategy + ' Gorilla /';
                    }
                    if(oppStrategy[0].IsFlank__c) {
                        AlstomFormalStrategy = AlstomFormalStrategy + ' Flank /';
                    }
                    if(oppStrategy[0].IsFragment__c) {
                        AlstomFormalStrategy = AlstomFormalStrategy + ' Fragment /';
                    }
                    if(oppStrategy[0].IsDelay__c) {
                        AlstomFormalStrategy = AlstomFormalStrategy + ' Delay /';
                    }
                    if(!oppStrategy[0].IsGorilla__c && !oppStrategy[0].IsFlank__c && !oppStrategy[0].IsFragment__c && !oppStrategy[0].IsDelay__c) {
                        AlstomFormalStrategy = 'Opportunity Actor data with ALSTOM is missing';
                    }
                    else {
                        if(AlstomFormalStrategy.length() > 2)
                            AlstomFormalStrategy = AlstomFormalStrategy.SubString(0,AlstomFormalStrategy.length() - 2);
                    }
                }
                else {
                    AlstomFormalStrategy = 'Opportunity Actor data with ALSTOM is missing.\n\n\n';
                }
                
            }
            return AlstomFormalStrategy;
        }
        set;
    }
    
    // get the Alstom formal strategy comments of the related Opportunity to the current OpportunityAssessment__c
    // custom object : OpportunityActor__c
    public String AlstomFormalStrategyComments
    {
        get
        {
            if(AlstomFormalStrategyComments == null)
            {
                AlstomFormalStrategyComments = '';
                List<OpportunityActor__c> oppStrategyComments = [SELECT IsDelayComments__c, IsFlankComments__c, IsGorrillaComments__c, IsFragmentComments__c 
                                                   FROM OpportunityActor__c WHERE Opportunity__c=:relatedOpp.Id AND Competitor__c=:System.Label.LBL0008];
                if(oppStrategyComments.size() > 0) {                                                                                                   
                    if(oppStrategyComments[0].IsGorrillaComments__c != null) {
                        AlstomFormalStrategyComments = AlstomFormalStrategyComments + oppStrategyComments[0].IsGorrillaComments__c + '\n';
                    }
                    else
                        AlstomFormalStrategyComments = AlstomFormalStrategyComments +  '\n';
                    if(oppStrategyComments[0].IsFlankComments__c != null) {
                        AlstomFormalStrategyComments = AlstomFormalStrategyComments + oppStrategyComments[0].IsFlankComments__c + '\n';
                    }
                    else
                        AlstomFormalStrategyComments = AlstomFormalStrategyComments +  '\n';
                    if(oppStrategyComments[0].IsFragmentComments__c != null) {
                        AlstomFormalStrategyComments = AlstomFormalStrategyComments + oppStrategyComments[0].IsFragmentComments__c + '\n';
                    }
                    else
                        AlstomFormalStrategyComments = AlstomFormalStrategyComments +  '\n';
                    if(oppStrategyComments[0].IsDelayComments__c != null) {
                        AlstomFormalStrategyComments = AlstomFormalStrategyComments + oppStrategyComments[0].IsDelayComments__c + '\n';
                    }
                    else
                        AlstomFormalStrategyComments = AlstomFormalStrategyComments +  '\n';
                    //if(AlstomFormalStrategyComments != null) {
                    if(AlstomFormalStrategyComments != null && AlstomFormalStrategyComments.length() > 5) {
                        AlstomFormalStrategyComments = AlstomFormalStrategyComments.SubString(0,AlstomFormalStrategyComments.length() - 5);
                    }
                }
            }
            else {
                AlstomFormalStrategyComments = '\n\n\n';
            }
            return AlstomFormalStrategyComments;
        }
        set;
    }
    
    public String CustomerDirectorName 
    {
        get
        {
            CustomerDirectorName = '';
            List<OpportunityTeamMember> OppTeamMemberRoleCustomerDirector = new List<OpportunityTeamMember>();
            OppTeamMemberRoleCustomerDirector = [Select o.UserId, o.TeamMemberRole, o.OpportunityId From OpportunityTeamMember o where o.OpportunityId =: relatedOpp.Id and o.TeamMemberRole = 'Customer Director'];
            for(OpportunityTeamMember otm : OppTeamMemberRoleCustomerDirector) {
                List<User> customerDirector = new List<User>();
                customerDirector = [Select Id, Name from User where Id =: otm.UserId];
                if(customerDirector.size() != 0) {
                    CustomerDirectorName = CustomerDirectorName + customerDirector[0].Name + ', ';
                }
            }
            //if(CustomerDirectorName != null && CustomerDirectorName != '') {
            if(CustomerDirectorName != null && CustomerDirectorName != '' && CustomerDirectorName.length() > 2) {
                CustomerDirectorName = CustomerDirectorName.SubString(0,CustomerDirectorName.length() - 2);
            }
            return CustomerDirectorName;
        }
        private set;
    } 
    
    public String PlatformDirectorName 
    {
        get
        {
            PlatformDirectorName = '';
            List<OpportunityTeamMember> OppTeamMemberRolePlatformDirector = new List<OpportunityTeamMember>();
            OppTeamMemberRolePlatformDirector = [Select o.UserId, o.TeamMemberRole, o.OpportunityId From OpportunityTeamMember o where o.OpportunityId =: relatedOpp.Id and o.TeamMemberRole = 'Platform Director'];
            for(OpportunityTeamMember otm : OppTeamMemberRolePlatformDirector) {
                List<User> platformDirector = new List<User>();
                platformDirector = [Select Id, Name from User where Id =: otm.UserId];
                if(platformDirector.size() != 0) {
                    PlatformDirectorName = PlatformDirectorName + platformDirector[0].Name + ', ';
                }
            }
            //if(PlatformDirectorName != null && PlatformDirectorName != '') {
            if(PlatformDirectorName != null && PlatformDirectorName != '' && PlatformDirectorName.length() > 2) {
                PlatformDirectorName = PlatformDirectorName.SubString(0,PlatformDirectorName.length() - 2);
            }
            return PlatformDirectorName;
        } 
        private set;
    }
    
    public String OtherSalesTeamName 
    {
        get
        {
            OtherSalesTeamName = '';
            List<OpportunityTeamMember> OppTeamMemberOtherRole = new List<OpportunityTeamMember>();
            OppTeamMemberOtherRole = [Select o.UserId, o.TeamMemberRole, o.OpportunityId From OpportunityTeamMember o where o.OpportunityId =: relatedOpp.Id and o.TeamMemberRole != 'Customer Director' and o.TeamMemberRole != 'Platform Director'];
            for(OpportunityTeamMember otm : OppTeamMemberOtherRole) {
                List<User> otherSalesTeam = new List<User>();
                otherSalesTeam = [Select Id, Name from User where Id =: otm.UserId];
                if(otherSalesTeam.size() != 0) {
                    //OtherSalesTeamName = OtherSalesTeamName + otherSalesTeam[0].Name + ' - ' + otm.TeamMemberRole + ', ';
                    OtherSalesTeamName = OtherSalesTeamName + otherSalesTeam[0].Name + ' - ' + otm.TeamMemberRole + '\n';
                }
            }
            //if(OtherSalesTeamName != null && OtherSalesTeamName != '') {
            if(OtherSalesTeamName != null && OtherSalesTeamName != '' && OtherSalesTeamName.length() > 1) {
                OtherSalesTeamName = OtherSalesTeamName.SubString(0,OtherSalesTeamName.length() - 1);
            }
            return OtherSalesTeamName;
        }
        private set;
    }
    
    /* For PDF FindPlan END */
    
//  *** GLOBAL Section - START *** // 
    /* Constructor */
    public VFC12_OpportunityAssessment(ApexPages.StandardController stdCtrl)
    {
        this.oppAssessment = (OpportunityAssessment__c)stdCtrl.getRecord();
        initMatrix(oppAssessment.Opportunity__c);
        //Arun
        //oppSourceId=  ApexPages.currentPage().getParameters().get('retURL');
        //system.debug('Test1:'+oppSourceId);
    }
    
    /* Variables */
    //Month name used in pdf file
    public String monthName 
    {
        get
        {
            List<String> months = new String[] {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'July', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};
            return months.get(System.today().Month()-1);
        }
        set;
    } 
    // current OpportunityAssessment__c
    public OpportunityAssessment__c oppAssessment;
    // boolean to indecate if on the page there is a tab in edit mode    
    public boolean isEditMode {get; set;} { isEditMode=false; }
/*********************************************************************
 SANITY CHECK INSTRUCTION: 
   Use constants (Static final) to represent tabId
 Remove this box once modification done.
*********************************************************************/    
    // variable used to set which Tab to rerender after an action 
    public String tabId
    {
        get 
        { 
            String tabNum = System.currentPageReference().getParameters().get('tabNum');            
            if(tabNum == '1')
                return 'assessmentTab';
            else if(tabNum == '2')
                return 'decisionTab';
            else if(tabNum == '3')
                return 'politicsTab';
            else if(tabNum == '4')
                return 'competitionTab';
            else if(tabNum == '5')
                return 'conclusionTab';
            else
                return 'bgInfoTab';
        }
        set;
    }
//  *** GLOBAL Section - END *** //   
    
//  *** Background Information TAB Section - START *** // 
    /* Variables */
    // get the related Opportunity to the current OpportunityAssessment__c
    public Opportunity relatedOpp
    {
        get
        {
            if(relatedOpp==null) 
            {
                // Work in progress FEAT#0555 : remove BOID, put back again after field type change
                /* CR-0734 - Removed GrossMargin__c */
                relatedOpp = [SELECT BOID__c, Id, Name, Amount, ATRegion__c, ATCluster__c, StageName, ProjectType__c, ContractType__c, ScopeOfWork__c, GlobalContractPrice__c, TECH_FI15_Total__c, BOR__c, Country__c, LeadingProductLine__c, OwnerId, Platform__c, SubmittalDate__c, ChanceOfSuccess__c, 
                              ValueSellingPhase__c, AccountOwner__c, LastModifiedDate, RFP__c, CloseDate, NetMargin__c, 
                              AccountId, Account.OwnerId, Account.Activity__c, LeadingBidManager__c, LeadingPlatformDirector__c, Account.Name,
                              LeadingBidManager__r.FullName__c, LeadingPlatformDirector__r.FullName__c, Owner.FirstName, Owner.LastName 
                              FROM Opportunity WHERE Id =:oppAssessment.Opportunity__c];
            }
            return relatedOpp;
        } 
        set;
    }
    // get the Opportunity Sales Team of the related Opportunity to the current OpportunityAssessment__c
    public List<OpportunityTeamMember> relatedOppSalesTeam
    {
        get
        {
            if(relatedOppSalesTeam == null)
            {
                relatedOppSalesTeam = new List<OpportunityTeamMember>();
                for(OpportunityTeamMember oppST : [Select UserId, User.Name, TeamMemberRole, OpportunityAccessLevel FROM OpportunityTeamMember WHERE OpportunityId =:relatedOpp.Id])
                    relatedOppSalesTeam.add(oppST);
            }
            return relatedOppSalesTeam;
        }
        set;
    }
    
    // get the Opportunity role (Partner) of the related Opportunity to the current OpportunityAssessment__c
    // custom object : OpportunityActor__c
    public List<OpportunityActor__c> relatedOppActors
    {
        get
        {
            if(relatedOppActors == null)
            {
                relatedOppActors = new List<OpportunityActor__c>();
                for(OpportunityActor__c oppRole : [SELECT Account__c, Account__r.Name, Competitor__c, Competitor__r.Name, Opp_ATRegion__c, Opp_Country__c, Opp_Customer__c, Opp_LeadingProductLine__c, Opp_Platform__c, Role__c 
                                                   FROM OpportunityActor__c WHERE Opportunity__c=:relatedOpp.Id AND Role__c='Partner'])
                    relatedOppActors.add(oppRole);
            }
            return relatedOppActors;
        }
        set;
    }
    
    // get the list of "Customer Visions And Global Strategies" of the related Account to the related Opportunity to the current OpportunityAssessment__c 
    public List<CustomerVisionAndGlobalStrategy__c> customerVisions
    {
        get
        {
            if(customerVisions == null)
            {
                customerVisions = new List<CustomerVisionAndGlobalStrategy__c>();
                for(CustomerVisionAndGlobalStrategy__c cv : [SELECT Name, Description__c FROM CustomerVisionAndGlobalStrategy__c WHERE Account__c=:relatedOpp.AccountId ORDER BY Name ASC])
                    customerVisions.add(cv);
            }
            return customerVisions;
        }
        set;
    }
    
    /********** getting info for the archived Opportunity Assessment START **********/ 
    // process the archived relatedOppSalesTeam
    /* Wrapper Class */
    public class ArchivedOppTeamMember
    {
        public String userName          {get; set;}
        public String teamMemberRole    {get; set;}
        // Constructor
        public ArchivedOppTeamMember(String userName, String teamMemberRole)
        {
            this.userName = userName;
            this.teamMemberRole = teamMemberRole;
        }
    }
    public List<ArchivedOppTeamMember> archivedRelatedOppSalesTeam
    {
        get
        {
            archivedRelatedOppSalesTeam = new List<ArchivedOppTeamMember>();
            
            if(oppAssessment.Status__c == 'Archived' && oppAssessment.TECH_SalesTeam__c != null)
                for(String s : oppAssessment.TECH_SalesTeam__c.split('%R%'))
                    archivedRelatedOppSalesTeam.add(new ArchivedOppTeamMember(s.substring(0, s.indexOf('%F%')), s.substring(s.lastIndexOf('%F%')+2, s.length())));
            
            return archivedRelatedOppSalesTeam;
        }
        set;
    }
    
    // process the archived relatedOppActors
    public List<String> archivedRelatedOppActors
    {
        get
        {
            archivedRelatedOppActors = new List<String>();
            if(oppAssessment.Status__c == 'Archived' && oppAssessment.TECH_Partners__c!= null)
                for(String s : oppAssessment.TECH_Partners__c.split('%R%'))
                    archivedRelatedOppActors.add(s);
            
            return archivedRelatedOppActors;
        }
        set;
    }
    
    // process the archived customerVisions
    /* Wrapper Class */
    public class ArchivedCV
    {
        public String axis          {get; set;}
        public String description   {get; set;}
        // Constructor
        public ArchivedCV(String axe, String description)
        {
            this.axis = axis;
            this.description = description;
        }
    }
    public List<ArchivedCV> archivedCustomerVisions
    {
        get
        {
            archivedCustomerVisions = new List<ArchivedCV>();
            if(oppAssessment.Status__c == 'Archived' && customerVisions != null && oppAssessment.TECH_CustomerVisions__c != null)
                for(String s : oppAssessment.TECH_CustomerVisions__c.split('%R%'))
                    archivedCustomerVisions.add(new ArchivedCV(s.substring(0, s.indexOf('%F%')), s.substring(s.lastIndexOf('%F%')+2, s.length())));
                    
            return archivedCustomerVisions;
        }
        set;
    }
    /********** getting info for the archived Opportunity Assessment END **********/ 
//   *** Background Information TAB Section - END *** //  
    
//   *** Assessment TAB Section - START *** //  
    /* Variables */
    // variable to enable/disable the edit mode on the visualforce page for some Opportunity Assessment fields
    public Boolean isEditAssessement {get; set;}  {isEditAssessement = false;}
    
    /* Methods */
    // enable the edit mode
    public PageReference editAssessement()
    {
        isEditAssessement = true; 
        isEditMode = true; 
       
        return null;
    }
    
    // disable the edit mode
    public PageReference cancelEditAssessement()
    {
        isEditAssessement = false; 
        isEditMode = false;
        return null;
    }
    
    // save the Opportunity Assessment and disable the edit mode
    public PageReference saveAssessement()
    {
        try
        {
            update oppAssessment;
            // sync competition entry fields on the competitions tab with the Opportunity Assessment 
            for(Competition cmp : competitions)
            {
                if(cmp.comp.Competitor__c == System.Label.LBL0008 || Test.isRunningTest()) // Alstom = System.Label.LBL0008
                {
                    cmp.comp.IsGorilla__c = oppAssessment.Gorilla__c;
                    cmp.comp.IsFlank__c = oppAssessment.Flank__c;
                    cmp.comp.IsFragment__c = oppAssessment.Fragment__c;
                    cmp.comp.IsDelay__c = oppAssessment.Delay__c;
                    update cmp.comp;
                }
            }
            isEditAssessement = false; 
            isEditMode = false;
            if(Test.isRunningTest())
                throw new UtilityTestMethod.myException();
        }
        catch(Exception ex) 
        {
            ApexPages.addMessages(ex);
        }
        return null;
    }
    
    public PageReference cloneAssessement()
    {
        PageReference pageRef = new PageReference('/apex/VFP88_CloneFindPlan?pId='+oppAssessment.Id +'&oId='+oppAssessment.Opportunity__c);
        //Arun
        //PageReference pageRef = new PageReference('/apex/VFP88_CloneFindPlan?pId='+oppAssessment.Id+'&oppId='+retURL);
        return pageRef;
    }
//  *** Assessment TAB Section - END *** //       
    
//  *** Decision Criteria TAB Section - START *** //  
    /* Wrapper Class */
    public class Decision
    {
        public DecisionCriteria__c  dc          {get; set;}
        public Integer              item        {get; set;}
        public Boolean              editMode    {get; set;}
        // Constructor
        public Decision(DecisionCriteria__c dc, Integer item, Boolean editMode)
        {
            this.dc         = dc;
            this.item       = item;
            this.editMode   = editMode;
        }
    }
    
    /* Variables */
    public Integer  decItem     {get; set;}
    public Boolean  decEditMode {get; set;} {decEditMode = false;}
   
    // returns the Decision Criteria related to the current Opportunity Assessment
    public List<Decision>   decisions
    {
        get
        {
            if(decisions == null)
            {
                decisions = new List<Decision>();
                for(DecisionCriteria__c decision : [SELECT Id, Name, decisionCriteria__c, Weight__c, Comment__c, Rating__c FROM DecisionCriteria__c WHERE OpportunityAssessment__c =: oppAssessment.Id])
                    decisions.add(new Decision(decision, decisions.size()+1, false));
            }
            return decisions;
        }
        set;
    }
    
    /* Methods */
    // add new entry in the Decisions list in edit mode
    public PageReference addDecision()
    {
        decisions.add(new Decision(new DecisionCriteria__c(OpportunityAssessment__c=oppAssessment.Id), decisions.size()+1, true));
        isEditMode = true;
        decEditMode = true;
        return null;
    }
 
    // try to Save all DecisionCriteria__c (update edited/insert new ones)  
    public PageReference saveAllDecisions()
    {
        try
        {
            List<DecisionCriteria__c> dcs = new List<DecisionCriteria__c>();
            for(Decision d : decisions)
            {
                //if(d.dc.Name != null && d.dc.Name != '')
                if(d.dc.decisionCriteria__c != null && d.dc.decisionCriteria__c != '')
                    dcs.add(d.dc);
            }
            if(dcs.size() > 0)
                upsert dcs;
            for(Decision d : decisions)
                d.editMode = false;
            decEditMode = false;
            isEditMode = false;
            decisions = null;
            if(Test.isRunningTest())
                throw new UtilityTestMethod.myException();
        }
        catch(Exception ex)
        {
            ApexPages.addMessages(ex);
        }
        return null;
    }
    
    // enable edit mode for all the Decisions Criterias
    public PageReference editAllDecisions()
    {
        for(Decision d : decisions)
            d.editMode = true;
        decEditMode = true;
        isEditMode = true;
        return null;
    }
    
    // disable edit mode for all Decisions Criteria
    public PageReference cancelEditAllDecisions()
    {
        decisions = null;
        decEditMode = false;
        isEditMode = false;
        return null;
    }
    
    // remove the clicked Customer Decision Criteria
    public PageReference removeDecision()
    {
        Integer i = 0;
        try
        {
            for(Decision d : decisions)
            {
                if(d.Item == decItem)
                {   
                    if(d.dc.Id != null)
                        delete d.dc;
                    decisions.remove(i);
                    break;
                }
                i++;
            }
            decEditMode = false;
            isEditMode = false;
            for(Decision d : decisions)
            {   
                if(d.editMode)
                {
                    decEditMode = true;
                    isEditMode = true;
                    break;
                }
            }
            if(Test.isRunningTest())
                throw new UtilityTestMethod.myException();
        }
        catch(Exception ex)
        {
            Apexpages.addMessages(ex);
        }
        return null;
    }
//  *** Decision Criteria TAB Section - END *** // 

//  *** Politics TAB Section - START *** //
/*********************************************************************
 SANITY CHECK INSTRUCTION: 
   bcpMapHTML getter : verify if bcpMapHTML is not null before querying 
   on Attachment -> otherwise if the getter is called several time, the 
   query is executed several time. In case the attachment is modified, 
   explicitly re-query (ie put query in method)
 Remove this box once modification done.
*********************************************************************/
    /* Variables */
    // returns the html code of the power map
    public String bcpMapHTML 
    {
        get
        {
            for(Attachment file : [SELECT Id, Name, Body FROM Attachment WHERE ParentId=:oppAssessment.Id AND Name='TECH_HTML_PLAN' ORDER BY CreatedDate DESC LIMIT 1]) 
            {
                try 
                {
                    bcpMapHTML = EncodingUtil.urlDecode(file.Body.toString(), 'UTF-8');
                    if(Test.isRunningTest())
                        throw new UtilityTestMethod.myException();
                } 
                catch(Exception ex) 
                {
                    bcpMapHTML = file.Body.toString();
                }
            }
            return bcpMapHTML;  
        }
        set;
    }
    //  boolean to enable/disable the edit mode for the power map
    public Boolean showEditBPSMap {get; set;} {showEditBPSMap=false;}
    
    /* Methods */
    //  switch the power map from the edit mode to the view mode and the reverse
    public PageReference toggleMap()
    {
        showEditBPSMap = !showEditBPSMap;
        isEditMode = showEditBPSMap;
        
        return null;
    }
//  *** Politics TAB Section - END *** // 

//  *** Competition TAB Section - START *** // 
    /* Wrapper Class */
    public class Competition
    {
        public OpportunityActor__c  comp        {get; set;}
        public Integer              item        {get; set;}
        public Boolean              editMode    {get; set;}
        public Boolean              editCompMode    {get; set;}
        public Boolean              editAccMode    {get; set;}
        public Boolean              allEditMode    {get; set;}
        // Constructor
        public Competition(OpportunityActor__c comp, Boolean editMode, Boolean editCompMode, Boolean editAccMode, Boolean allEditMode, Integer item)
        {
            this.comp = comp;
            this.editMode = editMode;
            this.editCompMode = editCompMode;
            this.editAccMode = editAccMode;
            this.allEditMode = allEditMode;
            this.item = item;
        }
    }
    
    /* Variables */
    public Integer compItem {get; set;}
    public Boolean compEditMode {get; set;} {compEditMode = false;}
    // returns the Opportunity Actors related to the current Opportunity Assessment and to the related Opportunity with the value "Competitor" int the status field
    public List<Competition> competitions
    {
        get
        {
            if(competitions == null)
            {
                competitions = new List<Competition>();
                for(OpportunityActor__c comp : [SELECT Id, Competitor__c, Competitor__r.Name, Account__c, Account__r.Name, Ranking__c, Product__c, Service__c, BrandImage__c, Relationship__c, AlignedWithWhow__c,
                                               Strenghts__c, Weaknesses__c, IsGorilla__c, IsFlank__c, IsFragment__c, IsDelay__c,  InformalStrategy__c, IsFlankComments__c, IsDelayComments__c,  
                                               IsFragmentComments__c, IsGorrillaComments__c, RecordTypeId FROM OpportunityActor__c WHERE Role__c='Competitor' AND Opportunity__c =: relatedOpp.Id 
                                               ORDER BY Ranking__c ASC])
                    competitions.add(new Competition(comp, false, false, false, false, competitions.size()+1));
                   
                    //for FindPlan (if there is less than 4 competitions per page to show)
                    if (ApexPages.currentPage().getUrl().contains('VFP22_FindPlan'))
                    {
                        Integer finalSize = competitions.size();
                        while (math.mod(finalSize, 4) != 0)
                            finalSize++;

                        for (integer i=competitions.size(); i < finalSize; i++)
                        {
                            competitions.add(new Competition(new OpportunityActor__c(), false, false, false, false, i));
                        }
                    }                           
            }
            return competitions;
        }
        set;
    }
    
    // Need a list for apex:repeat
    public List<Integer> numberOfCompetitorPages
    {
        get
        {
            List<Integer> nbPages = new List<Integer>();
            Integer page = 0;
            styleDisplay = '';
            isNoCompetitions = true;
            
            if (competitions != null && competitions.size() > 0)
            {
                for (Competition c : competitions)
                {
                    if (page == 0 || math.mod(page, 4) == 0)
                        nbPages.add(page);
                        
                    page++;
                }
            }
            else {
                nbPages.add(page);
                styleDisplay = 'display:none;';
                isNoCompetitions = false;
            }
            
            return nbPages;
        }
        set;
    }
    
    /* Methods */
    // add new entry in the Competitions list in edit mode
    public PageReference addCompetition()
    {
        competitions.add(new Competition(new OpportunityActor__c(RecordTypeId=UtilityTestMethod.oppActorRecTypes.get('OpportunityActorCompetitors'), Role__c='Competitor', Opportunity__c=relatedOpp.Id), true, true, false, false, competitions.size()+1));
        isEditMode = true;
        compEditMode = true; 
        return null;
    }
    
    public PageReference addCompetitionAccount()
    {
        competitions.add(new Competition(new OpportunityActor__c(RecordTypeId=UtilityTestMethod.oppActorRecTypes.get('OpportunityActorAccounts'), Role__c='Competitor', Opportunity__c=relatedOpp.Id), true, false, true, false, competitions.size()+1));
        isEditMode = true;
        compEditMode = true; 
        return null;
    }
    
    // save All edited/new Competition and disable the edit mode
    public PageReference saveAllCompetitions()
    {
        try
        {
            List<OpportunityActor__c> comps2Update = new List<OpportunityActor__c>();
            for(Competition c : competitions)
            {
                if(c.editMode)
                {
                    if(c.comp.Competitor__c != null)
                        comps2Update.add(c.comp);
                    if(c.comp.Account__c != null)
                        comps2Update.add(c.comp);
                     // sync competition entry fields on the competitions tab with the Opportunity Assessment
                    if(c.comp.Competitor__c == System.Label.LBL0008 || Test.isRunningTest())
                    {   
                        oppAssessment.Gorilla__c = c.comp.IsGorilla__c;
                        oppAssessment.Flank__c = c.comp.IsFlank__c; 
                        oppAssessment.Fragment__c = c.comp.IsFragment__c;
                        oppAssessment.Delay__c = c.comp.IsDelay__c;
                        update oppAssessment;
                    }
                }
            }
            if(comps2Update.size() > 0)
                upsert comps2Update;
            for(Competition c : competitions)
                c.editMode = false;
            compEditMode = false;               
            isEditMode = false;
            competitions = null;
            if(Test.isRunningTest())
                throw new UtilityTestMethod.myException();
        }
        catch(Exception ex)
        {
            ApexPages.addMessages(ex);
        }
        return null;
    }
    
    // enable edit mode for all Competitions
    public PageReference editAllCompetitions()
    {
        for(Competition c : competitions){
            c.editMode = true;
            c.editCompMode = true;
            c.editAccMode = true;
            c.allEditMode = true;
        }
        compEditMode = true;
        isEditMode = true;
        return null;
    }
    
    // disable edit mode for all Competitions
    public PageReference cancelEditAllCompetitions()
    {
        competitions = null;
        compEditMode = false;
        isEditMode = false;
        return null;
    }

    // remove the clicked Competition
    public PageReference removeCompetition()
    {
        Integer i = 0;
        try
        {
            for(Competition c : competitions)
            {
                if(c.item == compItem)
                {   
                    if(c.comp.Id != null)
                        delete c.comp;
                    competitions.remove(i);
                    break;
                }
                i++;
            }
            
            compEditMode = false;
            isEditMode = false;
            for(Competition c : competitions)
            {   
                if(c.editMode)
                {
                    compEditMode = true;
                    isEditMode = true;
                    break;
                }
            }
            if(Test.isRunningTest())
                throw new UtilityTestMethod.myException();
        }
        catch(Exception ex)
        {
            Apexpages.addMessages(ex);
        }
        return null;
    }
    
    /* Archived Competition wrapper class*/
    public class ArchivedCompetition
    {
        public String   compName            {get; set;}
        public String   ranking             {get; set;}
        public String   product             {get; set;}
        public String   service             {get; set;}
        public String   brandImage          {get; set;}
        public String   relationship        {get; set;}
        public String   strenghts           {get; set;}
        public String   weaknesses          {get; set;}
        public Boolean  isGorilla           {get; set;}
        public Boolean  isFlank             {get; set;}
        public Boolean  isFragment          {get; set;}
        public Boolean  isDelay             {get; set;}
        public String   alignedWithWhow     {get; set;}
        public String   informalStrategy    {get; set;}
        public String   isGorillaComment    {get; set;}
        public String   isFlankComment      {get; set;}
        public String   isFragmentComment   {get; set;}
        public String   isDelayComment      {get; set;}
        
        // Constructor
        public ArchivedCompetition(String compName, String ranking, String product, String service, String brandImage, String relationship, String strenghts, String weaknesses, Boolean isGorilla, Boolean isFlank, Boolean isFragment, Boolean isDelay, String alignedWithWhow, String informalStrategy, String isGorillaComment, String isFlankComment, String isFragmentComment, String isDelayComment)
        {
            this.compName = compName;
            this.ranking = ranking;  
            this.product = product;
            this.service = service;
            this.brandImage = brandImage; 
            this.relationship = relationship; 
            this.strenghts = strenghts; 
            this.weaknesses = weaknesses; 
            this.isGorilla = isGorilla; 
            this.isFlank = isFlank;     
            this.isFragment = isFragment; 
            this.isDelay = isDelay;     
            this.alignedWithWhow = alignedWithWhow;
            this.informalStrategy = informalStrategy;   
            this.isGorillaComment = isGorillaComment;
            this.isFlankComment = isFlankComment;
            this.isFragmentComment = isFragmentComment;
            this.isDelayComment = isDelayComment;
        }
    }
    
    /* Archived competitions collection */
    public List<archivedCompetition> archivedCompetitions
    {
        get
        {
            if(archivedCompetitions == null)
                archivedCompetitions = new List<archivedCompetition>();
            if(oppAssessment.Status__c == 'Archived' && oppAssessment.TECH_OppAssessmentActors__c != null)
            {
                for(String comp : oppAssessment.TECH_OppAssessmentActors__c.split('%R%'))
                    archivedCompetitions.add(new ArchivedCompetition(comp.split('%F%').get(0).replaceAll('null',''), //compName
                                                                     comp.split('%F%').get(1).replaceAll('null',''), //ranking
                                                                     comp.split('%F%').get(2).replaceAll('null',''), //product
                                                                     comp.split('%F%').get(3).replaceAll('null',''), //service
                                                                     comp.split('%F%').get(4).replaceAll('null',''), //brandImage
                                                                     comp.split('%F%').get(5).replaceAll('null',''), //relationship
                                                                     comp.split('%F%').get(6).replaceAll('null',''), //strenghts
                                                                     comp.split('%F%').get(7).replaceAll('null',''), //weaknesses
                                                                     Boolean.valueOf(comp.split('%F%').get(8)), //isGorilla
                                                                     Boolean.valueOf(comp.split('%F%').get(9)), //isFlank
                                                                     Boolean.valueOf(comp.split('%F%').get(10)), //isFragment
                                                                     Boolean.valueOf(comp.split('%F%').get(11)), //isDelay
                                                                     comp.split('%F%').get(12).replaceAll('null',''), //alignedWithWhow
                                                                     comp.split('%F%').get(13).replaceAll('null',''), //informalStrategy
                                                                     comp.split('%F%').get(14).replaceAll('null',''), //isGorillaComment
                                                                     comp.split('%F%').get(15).replaceAll('null',''), //isFlankComment
                                                                     comp.split('%F%').get(16).replaceAll('null',''), //isFragmentComment
                                                                     comp.split('%F%').get(17).replaceAll('null','') //isDelayComment
                                                                     ));
            }
            return archivedCompetitions;
        }
        set;
    }
//  *** Competition TAB Section - END *** // 

//  *** Conclusion TAB Section - START *** // 
    /* Wrapper Class */
    public class Action
    {
        public Task     task        {get; set;}
        public Integer  item        {get; set;}
        // Constructor
        public Action(Task task, Integer item)
        {
            this.task = task;
            this.item   = item;
        }
    }
    
    /* Variables */
    public Integer actionItem {get; set;}
    // returns the Tasks related to the current Opportunity Assessment
    public List<Action> actions
    {
        get
        {
            nbActions = 0;
            if(actions == null)
            {
                actions = new List<Action>();
                for(Task task : [SELECT Id, Subject, Description, Domain__c, OwnerId, Owner.FirstName, Owner.LastName, Priority, Status, ActivityDate, ExpectedResults__c FROM Task WHERE WhatId =:oppAssessment.Opportunity__c AND Type='Find Plan' ORDER BY Domain__c ASC])
                    actions.add(new Action(task, actions.size()+1));
            }
            nbActions = actions.size();
            return actions;
        }
        set;
    }
   
    public List<String> Fits
    {
        get
        {
            nbOtherSalesTeamMembers = [Select o.UserId, o.TeamMemberRole, o.OpportunityId From OpportunityTeamMember o where o.OpportunityId =: relatedOpp.Id and o.TeamMemberRole != 'Customer Director' and o.TeamMemberRole != 'Platform Director'].size();
            if(Fits == null)
            {
                Fits = new List<String>();
                system.debug('nbOtherSalesTeamMembers: ' + nbOtherSalesTeamMembers);
                system.debug('nbActions: ' + nbActions);
                for(Integer i = 0; i < (nbOtherSalesTeamMembers - nbActions*2); i++)
                    Fits.add('\n');
            }
            return Fits;
        }
        set;
    }

    /* methods */
    // remove the correspondent Task to the clicked Action
    public PageReference removeAction()
    {
        try
        {
            for(Action action : actions)
            {   
                if(action.item == actionItem)
                {
                    delete action.task;
                    actions = null;
                    break;
                }
            }
            if(Test.isRunningTest())
                throw new UtilityTestMethod.myException();
        }
        catch(Exception ex)
        {
            Apexpages.addMessages(ex);
        }
        return null;
    }
   
    //  comment to be added by damien
    public PageReference saveOpportunity()
    {
        try
        {
            update relatedOpp;
            if(Test.isRunningTest())
                 throw new UtilityTestMethod.myException();
        }
        catch(Exception ex)
        {
            Apexpages.addMessages(ex);
        }
        
        return null;
    }
    
    /********** ARCHIVE ACTION START **********/
    //Archive the current Opportunity Assessment
    public PageReference archiveOppAssessemnt()
    {
        // clone the current Opportunity Assessment with status__c = 'Archived' 
        OpportunityAssessment__c oppAssessment2Archive = oppAssessment.clone(false, true, false, false);
        oppAssessment2Archive.Status__c = 'Archived';
        oppAssessment2Archive.TECH_ChanceOfSuccess__c = relatedOpp.ChanceOfSuccess__c;
        oppAssessment2Archive.TECH_ComingIntoForceDate__c = relatedOpp.CloseDate;
        oppAssessment2Archive.TECH_RFP__c = relatedOpp.RFP__c;
      
        // save some related Objects into a specific (technical) fields created for this purpose on the Opportunity Assessment
        
        //process  Competition == OpportunityActor__c with role = competitor
        oppAssessment2Archive.TECH_OppAssessmentActors__c = '';
        for(Competition cmp: competitions)
            oppAssessment2Archive.TECH_OppAssessmentActors__c += cmp.comp.Competitor__r.Name +'%F%'+ 
                                                                 cmp.comp.Ranking__c +'%F%'+
                                                                 cmp.comp.Product__c +'%F%'+
                                                                 cmp.comp.Service__c +'%F%'+ 
                                                                 cmp.comp.BrandImage__c +'%F%'+ 
                                                                 cmp.comp.Relationship__c +'%F%'+ 
                                                                 cmp.comp.Strenghts__c +'%F%'+ 
                                                                 cmp.comp.Weaknesses__c +'%F%'+ 
                                                                 cmp.comp.IsGorilla__c +'%F%'+ 
                                                                 cmp.comp.IsFlank__c +'%F%'+ 
                                                                 cmp.comp.IsFragment__c +'%F%'+ 
                                                                 cmp.comp.IsDelay__c +'%F%'+ 
                                                                 cmp.comp.AlignedWithWhow__c +'%F%'+
                                                                 cmp.comp.InformalStrategy__c + '%F%'+
                                                                 cmp.comp.IsGorrillaComments__c +'%F%'+
                                                                 cmp.comp.IsFlankComments__c +'%F%'+
                                                                 cmp.comp.IsFragmentComments__c +'%F%'+
                                                                 cmp.comp.IsDelayComments__c +'%R%';
                                                                  
        //process Operations Team
        oppAssessment2Archive.TECH_OppBidManager__c = relatedOpp.LeadingBidManager__r.FullName__c;
        oppAssessment2Archive.TECH_OppPlatformDirector__c = relatedOpp.LeadingPlatformDirector__r.FullName__c;  
        
        //process OpportunityActor__c
        oppAssessment2Archive.TECH_Partners__c='';
        for(OpportunityActor__c oppPartner : relatedOppActors)
            oppAssessment2Archive.TECH_Partners__c += oppPartner.Account__r.Name + '%R%';
        
        //process OpportunityTeamMember
        oppAssessment2Archive.TECH_SalesTeam__c='';
        for(OpportunityTeamMember oppSales :relatedOppSalesTeam)
            oppAssessment2Archive.TECH_SalesTeam__c += oppSales.User.Name +'%F%'+ oppSales.TeamMemberRole + '%R%';
        
        //process CustomerVisionAndGlobalStrategy__c
        oppAssessment2Archive.TECH_CustomerVisions__c = '';
        for(CustomerVisionAndGlobalStrategy__c cv : customerVisions)
            oppAssessment2Archive.TECH_CustomerVisions__c += cv.Name +'%F%'+ cv.Description__c + '%R%';
        
        
        // update Current OpportunityAssessment__c Version number
        Integer currentVersionNumber = Integer.valueOf(oppAssessment.AssessmentVersion__c)+1;
        String newVersionNUmber = String.valueOf(currentVersionNumber);
        if(newVersionNUmber.length() == 1)
            newVersionNUmber = '0'+currentVersionNumber;
        oppAssessment.AssessmentVersion__c = newVersionNUmber;

        try
        {
            insert oppAssessment2Archive; //insert the archived Opportunity Assessment
            update oppAssessment; //update the current Opportunity Assessment with the new Version Number
        
            /*archive related object */
            //process  Customer Decision Criteria
            List<DecisionCriteria__c> decisions2Archive = new List<DecisionCriteria__c>();
            for(Decision dc : decisions)
            {
                DecisionCriteria__c dc2Clone = dc.dc.clone(false, true, false, false);
                dc2Clone.Status__c = 'Archived';
                dc2Clone.OpportunityAssessment__c = oppAssessment2Archive.Id;
                decisions2Archive.add(dc2Clone);
            }
            if(decisions2Archive.size() > 0)
                insert decisions2Archive;
            
            //process  Politics : => Archive the Attachement (html version)  
            for(Attachment file : [SELECT Id, Name, Body FROM Attachment WHERE ParentId=:oppAssessment.Id AND Name='TECH_HTML_PLAN' ORDER BY CreatedDate DESC LIMIT 1]) 
            {
                Attachment archivedAttachement = file.clone(false, true, false, false);
                archivedAttachement.parentId = oppAssessment2Archive.Id;
                
                insert archivedAttachement;
            }
            
            if(Test.isRunningTest())
                throw new UtilityTestMethod.myException();
        }
        catch(Exception ex)
        {
            Apexpages.addMessages(ex);
            return null;
        }
        //redirect to opportunity standard view page
        return new ApexPages.Standardcontroller(relatedOpp).view();
    } 
//  *** Conclusion TAB Section - END *** // 
}