/**
 * This class contains unit tests for validating the behavior of VFC08_Opportunity_BOExecutiveSummary Apex controller and VFP08_Opportunity_BOExecutiveSummary
 * Mohamed EL MOUSSAOUI ~ mohamed.el-moussaoui@axoa.fr 13/08/2012
 */
@isTest
private class VFC08_Opportunity_BOExecutive_TEST 
{
    static testMethod void testVFC08() 
    {
        System.debug('## >>>>> testing class VFC08_Opportunity_BOExecutiveSummary START <<<<<');
        
        System.debug('## Create accounts ..');
        Account account = UtilityTestMethod.getAccount();
        insert account;
        
        System.debug('## Create Opportunity ..');
        Opportunity opp = UtilityTestMethod.getOpportunityWithBOID();
        insert opp;
    
        System.debug('## Create Product__c ..');
        Product__c product = UtilityTestMethod.getProducts(1).get(0);
        product.Opportunity__c = opp.Id;
        product.Leading__c = true;
        insert product;
        
        opp.AccountId = account.Id;
        //opp.BOID__c = 'Y1234';
        opp.LeadingProductLine__c='Information Solutions';
        opp.Platform__c='Mainlines';
        opp.Sum_of_Global_Child_Opp_Selling_Price__c = 0;
        update opp;
    
    
        System.debug('## Create Periodic Report ..');
        PeriodicReport__c prdRep = new PeriodicReport__c(LastInformation__c='test', IssuesRisks__c='test', ReportDate__c=Date.today());
        prdRep.Opportunity__c = opp.Id;
        insert prdRep;
        
        Tender__c tend = new Tender__c(Opportunity__c=opp.Id, Name='123');
        insert tend;
        
        TenderReport__c tendReport = new TenderReport__c(Tender__c=tend.Id, Abstract__c='test', ReportDate__c=Date.today());
        insert tendReport;
        
        //User user1 = new User(FirstName='FToto1', LastName='LToto1');
        List<User> usersToinsert = new List<User>();
        usersToInsert = UtilityTestMethod.getUsersToInsert(4);
        User user1 = usersToInsert.get(0);
        insert user1;
        User user2 = usersToInsert.get(1);
        insert user2;
        User user3 = usersToInsert.get(2);
        insert user3;
        User user4 = usersToInsert.get(3);
        insert user4;
        
        OpportunityTeamMember BidManager = new OpportunityTeamMember(UserId = user1.Id , TeamMemberRole = 'Bid Manager', OpportunityId = opp.Id);
        insert BidManager;
        
        OpportunityTeamMember TenderLeader = new OpportunityTeamMember(UserId = user2.Id , TeamMemberRole = 'Tender Leader', OpportunityId = opp.Id);
        insert TenderLeader;
        
        OpportunityTeamMember PlatformDirector = new OpportunityTeamMember(UserId = user3.Id , TeamMemberRole = 'Platform Director', OpportunityId = opp.Id);
        insert PlatformDirector;
        
        OpportunityTeamMember CustomerDirector = new OpportunityTeamMember(UserId = user4.Id , TeamMemberRole = 'Customer Director', OpportunityId = opp.Id);
        insert CustomerDirector;
        
        Milestone__c milestone1 = new Milestone__c(Tender__c=tend.Id, Type__c = 'WNG',MeetingDate__c=Date.today());
        insert milestone1;
        
        Milestone__c milestone2 = new Milestone__c(Tender__c=tend.Id, Type__c = 'TRM',MeetingDate__c=Date.today());
        insert milestone2;
        

        TenderSubmission__c tenderSubmission = new TenderSubmission__c(Tender__c=tend.Id, SubmittalDate__c = Date.today(),OfferValidityDate__c=Date.today());
        insert tenderSubmission;

    
        Test.startTest();
        PageReference vfp08 = Page.VFP08_Opportunity_BOExecutiveSummary; 
        Test.setCurrentPage(vfp08);
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', opp.Id);
        VFC08_Opportunity_BOExecutiveSummary vfc08 = new VFC08_Opportunity_BOExecutiveSummary(new ApexPages.StandardController(opp));
        System.Debug(vfc08.currentDateTime);     
        System.Debug(vfc08.lastPeriodicReport);
        System.Debug(vfc08.leadingProduct);
        System.Debug(vfc08.periodicReportDate);
        System.Debug(vfc08.lastInformation);
        System.Debug(vfc08.issuesRisks);
        System.Debug(vfc08.BidManagerName);
        System.Debug(vfc08.TenderLeaderName);
        System.Debug(vfc08.PlatformDirectorName);
        System.Debug(vfc08.CustomerDirectorName);
        System.Debug(vfc08.LatestWinNoGo);
        System.Debug(vfc08.LatestTRM);
        System.Debug(vfc08.LatestOfferValidity);
        System.Debug(vfc08.diffMarketPriceSellingPrice);
        System.Debug(vfc08.globalSellingPrice);
             
        Test.stopTest();
        System.debug('## >>>>> testing class VFC08_Opportunity_BOExecutiveSummary END <<<<<');
    }
}