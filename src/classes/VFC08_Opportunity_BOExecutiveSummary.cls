/*
 VFC08_Opportunity_BOExecutiveSummary apex controller
   ~ Author          : Mohamed EL MOUSSAOUI ~ mohamed.el-moussaoui@axoa.fr 
    ~ Date Created    : 08/13/2012 
    ~ Description     : 
    ~ Feature Id      : FEAT#0546 
    ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
    ~ Date Created    : 07/03/2014
    ~ Description     : Bug: Flag IsLastTender should not be calculated based on TenderReports with empty date
    ~ Author          : Antonin MAIGNE ~ antonin.maigne@cgi.com 
    ~ Date Created    : 16/01/2015
    ~ Description     : CR-0741 : Market Price modifications
    ~ Author          : Antonin MAIGNE ~ antonin.maigne@cgi.com 
    ~ Date Created    : 06/02/2015
    ~ Description     : CR-0720 : One Selling Price field only in BO ES
    
*/
public without sharing class VFC08_Opportunity_BOExecutiveSummary
{
    /* Constructor */
    public VFC08_Opportunity_BOExecutiveSummary(ApexPages.StandardController stdCtrl)
    {
        this.opportunity = (Opportunity)stdCtrl.getRecord();
        
        Opp = [Select Id, Name, OwnerId, Grading__c, LeadingPlatformDirector__c, AccountOwner__c, LeadingBidManager__c,Tender__c, Amount, ScopeOfWork__c, Sum_of_Global_Child_Opp_Selling_Price__c, CurrencyIsoCode, CloseDate from Opportunity where Id =: this.opportunity.Id];
        
        System.debug('## this.opportunity.Id : ' + Opp.OwnerId);
        
        if (Opp.ScopeOfWork__c != null) {
            ScopeOfWork = Opp.ScopeOfWork__c.replaceAll('<[^>]+>',' ');
        }
        else {
            ScopeOfWork = '';
        }
        
        List<User> user = new List<User>();
        user = [Select Id, FirstName, LastName from User where Id =: Opp.OwnerId];
        if(user.size() != 0) {
            OwnerFirstName = user[0].FirstName;
            OwnerLastName = user[0].LastName;
        }
        else {
            OwnerFirstName = '';
            OwnerLastName = '';
        }
        
        // Query Periodic Report Object
        periodicReport = [Select p.Opportunity__c, p.LastInformation__c, p.IssuesRisks__c, p.IsLast__c, p.Id, p.ReportDate__c From PeriodicReport__c p where p.Opportunity__c =: Opp.Id and p.IsLast__c =: true];

        // Query Tender Object
        //
        tend = [Select Id, ProjectCategory__c, ManagementAttention__c, SellingPrice__c, Gross_Margin__c, GrossMarginAdjusted__c, NetMargin__c, OperatingMargin__c, Ambitions__c, Contingencies__c, OptionsSellingPrice__c, OptionsGrossMargin__c, OptionsGrossMarginAdjusted__c, OptionsNetMargin__c, OptionsOperatingMargin__c, OptionsAmbitions__c, OptionsContingencies__c, DownPayment__c, OnwardPayment__c, MarketPrice__c, (Select Id, ReportDate__c, Abstract__c From Tender_Reports__r where ReportDate__c != null order by ReportDate__c desc) from Tender__c where Id =: Opp.Tender__c];
        if (tend.size() != 0) {
            OptionsSellingPrice = tend[0].OptionsSellingPrice__c;
            OptionsGrossMargin = tend[0].OptionsGrossMargin__c;
            GrossMargin = tend[0].Gross_Margin__c;
            SellingPrice = tend[0].SellingPrice__c;
            GrossMarginAdjusted = tend[0].GrossMarginAdjusted__c;
            OptionsGrossMarginAdjusted = tend[0].OptionsGrossMarginAdjusted__c;
            NetMargin = tend[0].NetMargin__c;
            OptionsNetMargin = tend[0].OptionsNetMargin__c;
            OperatingMargin = tend[0].OperatingMargin__c;
            OptionsOperatingMargin = tend[0].OptionsOperatingMargin__c;
            Contingencies = tend[0].Contingencies__c;
            OptionsContingencies = tend[0].OptionsContingencies__c;
            Ambitions= tend[0].Ambitions__c;
            OptionsAmbitions= tend[0].OptionsAmbitions__c;            
            DownPayment= tend[0].DownPayment__c;            
            OnwardPayment= tend[0].OnwardPayment__c;  
            ManagementAttention= tend[0].ManagementAttention__c;
            ProjectCategory = tend[0].ProjectCategory__c;
            MarketPrice = tend[0].MarketPrice__c;
            if (tend[0].Tender_Reports__r.size() > 0) {
                ReportDate = tend[0].Tender_Reports__r[0].ReportDate__c;
                if (tend[0].Tender_Reports__r[0].Abstract__c != null) {
                    TenderReport = tend[0].Tender_Reports__r[0].Abstract__c.replaceAll('<[^>]+>',' ');
                }
                else {
                    TenderReport = '';
                }
            }
        }
        else {
            OptionsSellingPrice = 0;
            OptionsGrossMargin = 0;
            GrossMargin = 0;
            SellingPrice = 0;
            GrossMarginAdjusted = 0;
            OptionsGrossMarginAdjusted = 0;
            NetMargin = 0;
            OptionsNetMargin = 0;
            OperatingMargin = 0;
            OptionsOperatingMargin = 0;
            Contingencies = 0;
            OptionsContingencies = 0;
            Ambitions= 0;
            OptionsAmbitions= 0;            
            DownPayment= 0;            
            OnwardPayment= 0;
            MarketPrice= 0;            
        }
    }
    
    /* Variables */
    public Opportunity opportunity {get; set;}
    public Opportunity Opp;
    public String OwnerFirstName {get; set;}
    public String OwnerLastName {get; set;}
    public String Today { get { return Datetime.now().format('d MMM yyyy'); }}
    public List<PeriodicReport__c> periodicReport = new List<PeriodicReport__c>();
    public List<Tender__c> tend = new List<Tender__c>();
    public Decimal OptionsSellingPrice {get; set;}
    public Decimal OptionsGrossMargin {get; set;}
    public Decimal GrossMarginAdjusted {get; set;}    
    public Decimal OptionsGrossMarginAdjusted {get; set;}    
    public Decimal NetMargin {get; set;} 
    public Decimal OptionsNetMargin {get; set;} 
    public Decimal OperatingMargin {get; set;} 
    public Decimal OptionsOperatingMargin {get; set;} 
    public Decimal Contingencies {get; set;} 
    public Decimal OptionsContingencies {get; set;} 
    public Decimal Ambitions {get; set;} 
    public Decimal OptionsAmbitions {get; set;}             
    public Decimal DownPayment {get; set;}             
    public Decimal OnwardPayment {get; set;}
    //nouveaux champs Tender:              
    public Decimal GrossMargin {get; set;}    
    public Decimal SellingPrice {get; set;}
    public Decimal MarketPrice {get; set;}
    // nouveaux champs from Tender Report
    public Datetime ReportDate {get; set;}
    public String ManagementAttention {get; set;}
    public String TenderReport {get; set;}
    public String ProjectCategory {get; set;}
    public String ScopeOfWork {get; set;}

    public Datetime periodicReportDate 
    {
        get
        {
            If (periodicReport.size() != 0) {
                return periodicReport[0].ReportDate__c;
            }
            else {
                return null;
            }
        }
        private set;
    } 
    
    public String lastInformation 
    {
        get
        {
            If ((periodicReport.size() != 0) && (periodicReport[0].LastInformation__c != null)) {
                return periodicReport[0].LastInformation__c.replaceAll('<[^>]+>',' ');
            }
            else {
                return null;
            }
        }
        private set;
    } 
    
    public String issuesRisks 
    {
        get
        {
            If ((periodicReport.size() != 0) && (periodicReport[0].IssuesRisks__c != null)) {
                return periodicReport[0].IssuesRisks__c.replaceAll('<[^>]+>',' ');
            }
            else {
                return null;
            }
        }
        private set;
    } 
        
    public String BidManagerName 
    {
        get
        {
            List<OpportunityTeamMember> OppTeamMemberRoleBidManager = new List<OpportunityTeamMember>();
            OppTeamMemberRoleBidManager = [Select o.UserId, o.TeamMemberRole, o.OpportunityId From OpportunityTeamMember o where o.OpportunityId =: Opp.Id and o.TeamMemberRole = 'Bid Manager'  LIMIT 1];
            if(OppTeamMemberRoleBidManager.size() != 0){
                List<User> platformDirector = new List<User>();
                platformDirector = [Select Id, Name from User where Id =: OppTeamMemberRoleBidManager[0].UserId LIMIT 1];
                if(platformDirector.size() != 0) {
                    return platformDirector[0].Name;
                }
                else return null;
            }
            else return null;
        }
        private set;
    } 
    
    public String TenderLeaderName 
    {
        get
        {
            List<OpportunityTeamMember> OppTeamMemberRoleTenderLeader = new List<OpportunityTeamMember>();
            OppTeamMemberRoleTenderLeader = [Select o.UserId, o.TeamMemberRole, o.OpportunityId From OpportunityTeamMember o where o.OpportunityId =: Opp.Id and o.TeamMemberRole = 'Tender Leader'  LIMIT 1];
            if(OppTeamMemberRoleTenderLeader.size() != 0){
                List<User> platformDirector = new List<User>();
                platformDirector = [Select Id, Name from User where Id =: OppTeamMemberRoleTenderLeader[0].UserId LIMIT 1];
                if(platformDirector.size() != 0) {
                    return platformDirector[0].Name;
                }
                else return null;
            }
            else return null;
        }
        private set;
    } 
    
    public String PlatformDirectorName 
    {
        get
        {
            List<OpportunityTeamMember> OppTeamMemberRolePlatformDirector = new List<OpportunityTeamMember>();
            OppTeamMemberRolePlatformDirector = [Select o.UserId, o.TeamMemberRole, o.OpportunityId From OpportunityTeamMember o where o.OpportunityId =: Opp.Id and o.TeamMemberRole = 'Platform Director'  LIMIT 1];
            if(OppTeamMemberRolePlatformDirector.size() != 0){
                List<User> platformDirector = new List<User>();
                platformDirector = [Select Id, Name from User where Id =: OppTeamMemberRolePlatformDirector[0].UserId LIMIT 1];
                if(platformDirector.size() != 0) {
                    return platformDirector[0].Name;
                }
                else return null;
            }
            else return null;
        }
        private set;
    } 
    
    public String CustomerDirectorName 
    {
        get
        {
            List<OpportunityTeamMember> OppTeamMemberRoleCustomerDirector = new List<OpportunityTeamMember>();
            OppTeamMemberRoleCustomerDirector = [Select o.UserId, o.TeamMemberRole, o.OpportunityId From OpportunityTeamMember o where o.OpportunityId =: Opp.Id and o.TeamMemberRole = 'Customer Director'  LIMIT 1];
            if(OppTeamMemberRoleCustomerDirector.size() != 0){
                List<User> customerDirector = new List<User>();
                customerDirector = [Select Id, Name from User where Id =: OppTeamMemberRoleCustomerDirector[0].UserId LIMIT 1];
                if(customerDirector.size() != 0) {
                    return customerDirector[0].Name;
                }
                else return null;
            }
            else return null;
        }
        private set;
    } 
    
    public Date LatestWinNoGo//Formated 
    {
        get
        {
            String strlatestWinNoGo = '';
            List<Milestone__c> milestoneLatestWinNoGo = new List<Milestone__c>();
            List<Tender__c> tend1 = new List<Tender__c>();
            
            tend1 = [Select Id, Opportunity__c from Tender__c where Opportunity__c =: Opp.Id];
            if(tend1.size() != 0) {
                milestoneLatestWinNoGo = [Select Id, MeetingDate__c from Milestone__c where Tender__c =: tend1[0].Id and Type__c = 'WNG' order by MeetingDate__c desc LIMIT 1];
                if(milestoneLatestWinNoGo.size() != 0) {
                    return milestoneLatestWinNoGo[0].MeetingDate__c;
                } 
                else {
                    return null;
                }
            }
            else {
                return null;
            }
        }
        private set;
    }  
    
    public Date LatestTRM//Formated 
    {
        get
        {
            List<Milestone__c> milestoneLatestTRM = new List<Milestone__c>();
            List<Tender__c> tend1 = new List<Tender__c>();
            
            tend1 = [Select Id, Opportunity__c from Tender__c where Opportunity__c =: Opp.Id];
            if(tend1.size() != 0) {
                milestoneLatestTRM = [Select Id, MeetingDate__c from Milestone__c where Tender__c =: tend1[0].Id and Type__c = 'TRM' order by MeetingDate__c desc LIMIT 1];
                if(milestoneLatestTRM.size() != 0) {
                    return milestoneLatestTRM[0].MeetingDate__c;
                }
                else { 
                    return null; 
                }
            }
            else {
                return null;
            }
        }
        private set;
    }  
    
    public Date LatestOfferValidity //Formated 
    {
        get
        {
            List<TenderSubmission__c> latestOfferValidity = new List<TenderSubmission__c>();
            latestOfferValidity = [Select Id, OfferValidityDate__c from TenderSubmission__c where Tender__c =: Opp.Tender__c AND SubmittalDate__c <> null order by SubmittalDate__c desc LIMIT 1];
            if(latestOfferValidity.size() != 0 && latestOfferValidity[0].OfferValidityDate__c != null) {
                return latestOfferValidity[0].OfferValidityDate__c;
            }
            else { return null; }
        }
        private set;
    }  
    
    public String currentDateTime//Formated 
    {
        get
        {
            return Datetime.now().format('d MMM yyyy h:mm a');
        }
        private set;
    } 
    
    public PeriodicReport__c lastPeriodicReport
    {
        get
        {
            lastPeriodicReport = new PeriodicReport__c();
            for(PeriodicReport__c pr : [SELECT ReportDate__c, LastInformation__c, Id, IssuesRisks__c FROM PeriodicReport__c WHERE Opportunity__c =: opportunity.Id ORDER BY ReportDate__c DESC LIMIT 1])
                lastPeriodicReport = pr;
            return lastPeriodicReport;
        }
        private set;
    }
    
    public Product__c leadingProduct
    {
        get
        {
            leadingProduct = new Product__c();
            for(Product__c pr : [SELECT Id, ProductLine__c, Product__c FROM Product__c WHERE Opportunity__c=:opportunity.Id AND Leading__c=true])
                leadingProduct = pr;
            return leadingProduct;
        }
        private set;
    }
    
    public boolean diffMarketPriceSellingPrice
    {
        get
        {
            if(MarketPrice != NULL)
            {
	            if(0.9*MarketPrice > SellingPrice || 1.1*MarketPrice < SellingPrice)
	            {
	            	return true;
	            }
	            else
	            {
	            	return false;
	            }
            }
            else
            {
            	return false;
            }
        }
        private set;
    }
    
    public Decimal globalSellingPrice
    {
    	get
    	{
    		if(Opp.Sum_of_Global_Child_Opp_Selling_Price__c != NULL)
    		{
				CurrencyUtility cu = new CurrencyUtility();
    			return cu.convertToCurrency(Opp.Sum_of_Global_Child_Opp_Selling_Price__c, Opp.CurrencyIsoCode, 'EUR', Opp.CloseDate);
    		}
    		else
    		{
    			return NULL;
    		}
    	}
    	
    	private set;
    }
}