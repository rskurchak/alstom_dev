/**
 * This class contains unit tests for validating the behavior of VFC12_Opportunity_Assessments Apex classes 
    and VFP12_OpportunityAssessments
 * Mohamed EL MOUSSAOUI ~ mohamed.el-moussaoui@axoa.fr 19/06/2012
 */
@isTest
private class VFC12_OpportunityAssessment_TEST
{
    static testMethod void testVFC12() 
    {
        System.debug('## >>>>> testing class VFC12_OpportunityAssessment_TEST START <<<<<');
        
         // data testing
        System.debug('## Create Account ..');
        Account account = UtilityTestMethod.getAccount();
        insert account;
        
        System.debug('## Create CustomerVisionAndGlobalStrategy__c ..');
        CustomerVisionAndGlobalStrategy__c cv = UtilityTestMethod.getCustomerVision(1).get(0);
        cv.Account__c = account.Id;
        insert cv;
       
        System.debug('## Create Opportunity');
        Opportunity opp = UtilityTestMethod.getOpportunity();
        opp.ATRegion__c = 'France';
        opp.AccountId = account.Id;
        insert opp;
        
        System.debug('## Create Opportunity SalesTeam');
        OpportunityTeamMember oppTeamMember = UtilityTestMethod.getOpportunityTeam(1).get(0);
        oppTeamMember.OpportunityId = opp.Id;
        oppTeamMember.UserId = UtilityTestMethod.getActiveUsers(1).get(0).Id; 
        insert oppTeamMember;
        
        System.debug('## Create Opportunity Roles');
        OpportunityActor__c oppActor = UtilityTestMethod.getOpportunityActors(1).get(0);
        oppActor.Opportunity__c = opp.Id;
        oppActor.Account__c = account.Id;
        oppActor.Role__c='Partner'; 
        insert oppActor;
        
        System.debug('## Create OpportunityAssessment__c and set Opportunity field ..');
        OpportunityAssessment__c oppAssessment = UtilityTestMethod.getOpportunityAssessements(1).get(0);
        oppAssessment.Opportunity__c = opp.Id;
        oppAssessment.AssessmentVersion__c = '01';
        oppAssessment.TECH_CustomerVisions__c = '%F%%R%%F%%R%';
        
        oppAssessment.Status__c = 'Archived';
        oppAssessment.TECH_SalesTeam__c = '%F%%R%%F%%R%';
        oppAssessment.TECH_Partners__c = '%F%%R%%F%%R%';
        oppAssessment.TECH_OppAssessmentActors__c = 'Competitor 1%F%2%F%null%F%null%F%null%F%null%F%null%F%null%F%false%F%false%F%false%F%false%F%null%F%null%F%null%F%null%F%null%F%null%R%Alstom%F%1%F%Prd%F%Serv%F%Bimage%F%Relation%F%Str%F%weak%F%true%F%true%F%true%F%true%F%with%F%info%F%Gorilla CommentsGorilla CommentsGorilla CommentsGorilla CommentsGorilla CommentsGorilla CommentsGorilla CommentsGorilla CommentsGorilla CommentsGorilla Comments%F%null%F%null%F%null%R%';
        insert oppAssessment;
        
        System.debug('## Create a Competitor__c ..');
        Competitor__c competitor = UtilityTestMethod.getCompetitors(1).get(0);
        insert competitor;
        //insert a new competetion (Opportunity Actor)
        
        System.debug('## Create a Competition ..');
        insert new OpportunityActor__c(Competitor__c=competitor.Id, Opportunity__c=opp.Id, Role__c='Competitor', RecordTypeId =UtilityTestMethod.oppActorRecTypes.get('OpportunityActorCompetitors'));
    
        // apex class and visualforce page testing
        Test.startTest();
        PageReference vfp12 = Page.VFP12_OpportunityAssessment; 
        Test.setCurrentPage(vfp12);
        
        // Add parameters to page URL
        VFC12_OpportunityAssessment vfc12 = new VFC12_OpportunityAssessment(new ApexPages.StandardController(oppAssessment));
        
        System.debug('## Create Decision Criteria');
        DecisionCriteria__c dc = UtilityTestMethod.getDecisionCriterias(1).get(0);
        dc.OpportunityAssessment__c = oppAssessment.Id;
        insert dc;
        
        System.debug('## Create Task');
        Task task = UtilityTestMethod.getTasks(1).get(0);
        task.WhatId = oppAssessment.Id;
        insert task;
        
        system.debug(vfc12.monthName);
        system.debug(vfc12.tabId);
        ApexPages.currentPage().getParameters().put('tabNum', '1');
        system.debug(vfc12.tabId);
        ApexPages.currentPage().getParameters().put('tabNum', '2');
        system.debug(vfc12.tabId);
        ApexPages.currentPage().getParameters().put('tabNum', '3');
        system.debug(vfc12.tabId);
        ApexPages.currentPage().getParameters().put('tabNum', '4');
        system.debug(vfc12.tabId);
        ApexPages.currentPage().getParameters().put('tabNum', '5');
        system.debug(vfc12.tabId);
        ApexPages.currentPage().getParameters().put('tabNum', '6');
        system.debug(vfc12.tabId);
        
        System.debug(vfc12.relatedOpp);
        System.debug(vfc12.relatedOppSalesTeam);
        System.debug(vfc12.relatedoppActors);
        System.debug(vfc12.customerVisions);
        
        /*
         for PDF (FindPlan)
         */
         
        System.debug('## Create Contact');
        List<Contact> contacts =  UtilityTestMethod.getContacts(3);
        insert contacts;
        
        System.debug('## Create BuyingProcess Stake holder');
        List<BuyingProcessStakeholder__c> bps = UtilityTestMethod.getBuyingProcessStakeholders(3);
        for(BuyingProcessStakeholder__c b : bps)
        {
            Integer i = 0;
            b.Opportunity__c = opp.id;
            b.ContactName__c = contacts.get(i).Id;
            i++;
        }
        insert bps;
        
        System.debug('## Create Alstom Employee');
        List<AlstomEmployee__c> employees = UtilityTestMethod.getAlstomEmployees(3);
        insert employees;
        
        System.debug('## Create Alstom Relations');
        AlstomRelationship__c relation = UtilityTestMethod.getAlstomRelationship();
        relation.AlstomEmployee__c = employees.get(0).Id;
        relation.FrequencyOfContacts__c = 'Frequent';
        relation.Stakeholder__c = bps.get(0).Id;
        insert relation;
        
        AlstomRelationship__c emptyRelation = UtilityTestMethod.getAlstomRelationship();
        emptyRelation.AlstomEmployee__c = employees.get(1).Id;
        emptyRelation.Stakeholder__c = bps.get(1).Id;
        insert emptyRelation;
        vfc12.initMatrix(opp.Id);
        
        System.Debug(vfc12.bps);
        /*
         for PDF (FindPlan)
         */
        
    // *** Assessment TAB Section - START *** //    
        vfc12.editAssessement();
        vfc12.cancelEditAssessement();
        vfc12.saveAssessement();
     // *** Assessment TAB Section - END *** //
    
    // *** Decision Criteria TAB Section - START *** // 
        /* Decision Criteria */
        vfc12.addDecision();
        vfc12.saveAllDecisions();
        
        vfc12.addDecision();
        vfc12.saveAllDecisions();
        
        vfc12.addDecision();
        vfc12.cancelEditAllDecisions();

        vfc12.decItem = 1;
        vfc12.editAllDecisions();
        
        vfc12.decItem = 2;          
        vfc12.removeDecision();
    /*  
        vfc12.decisions.get(0).dc.Weight__c =Decimal.valueOf('a');
        vfc12.saveAllDecisions();
    */
    // *** Decision Criteria TAB Section - END *** //
    
    // *** Politics TAB Section - START *** //
        Attachment file = new Attachment(Name='TECH_HTML_PLAN', Body=Blob.valueOf('Body'), ParentId=oppAssessment.Id);
        insert file;
        System.debug(vfc12.bcpMapHTML);
        vfc12.toggleMap();
    // *** Politics TAB Section - END *** //

    // *** Competition TAB Section - START *** //
        vfc12.addCompetition();
        vfc12.saveAllCompetitions();
        
        List<Integer> lC = vfc12.numberOfCompetitorPages;
        
        vfc12.addCompetition();
        vfc12.saveAllCompetitions();
        
        vfc12.addCompetition();
        vfc12.cancelEditAllCompetitions();

        vfc12.editAllCompetitions();
        vfc12.cancelEditAllCompetitions();
        
        vfc12.editAllCompetitions();
        
        vfc12.compItem = 2;
        vfc12.removeCompetition();
        
    // *** Competition TAB Section - END *** //
    
    // *** Conclusion TAB Section - START *** //
        vfc12.actionItem = 1; 
        vfc12.removeAction();
        vfc12.saveOpportunity();
        
        //archiving related methods and variables
        vfc12.archiveOppAssessemnt();
        System.debug(vfc12.archivedRelatedOppSalesTeam);
        System.debug(vfc12.archivedRelatedOppActors);
        System.debug(vfc12.archivedCustomerVisions);
        System.debug(vfc12.archivedCompetitions);
        
    // *** Conclusion TAB Section - END *** //
        Test.stopTest();
        System.debug('## >>>>> testing class VFC12_OpportunityAssessment_TEST END <<<<<');
    }
}