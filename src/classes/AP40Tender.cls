/*
 AP40Tender 
    ~ Author            : jawad.ghoulam@cgi.com
    ~ Modification Date : 27/08/2013
    ~ Description       : Calculate Tender Name field. 
    ~ Triggers        : TenderAfterInsert, TenderAfterUndelete, TenderBeforeInsert, TenderBeforeUpdate
    ~ Feature Id      : FEAT#0354
                      : FEAT#0536 YMR. Update Gross Margin and Selling Price with Opportunity values
                      : FEAT#0543 YMR. Modification of SQL to get it out of the for cycle and avoid to reach the governor limits.
                      : FEAT#0555 CAV. No need to test BOID empty or not, since it is now an Auto-number field
                      : FEAT#0683 CAV. Add init of Product Lines and TECH_Platforms1/2 in CalculateTenderName()
*/

public without sharing class AP40Tender {
    /*
        - Calculate Tender Name field
        - Set TECH_UniqueTender. Permit to verify if there is no duplicated tender with the same opportunity
        - Update Gross Margin and Selling Price with Opportunity values.
    */
    public static void CalculateTenderName(List<Tender__c> lstTender) 
    {
        CurrencyUtility cu = new CurrencyUtility();
        List<Id> tenderOpp = new List<Id>();
        for(Tender__c t : lstTender)
        { 
            tenderOpp.add(t.Opportunity__c);
        }
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        /* CR-0734 - Removed GrossMargin__c */
        List<Opportunity> oList = [Select BOID__c, Amount, CurrencyIsoCode, CloseDate, ProductLines__c, ForecastedGrossMargin__c, TECH_Platforms1__c, TECH_Platforms2__c, ATCluster__c, ATRegion__c FROM Opportunity WHERE Id IN :tenderOpp];
        for(Opportunity opp : oList)
        {
            oppMap.put(opp.Id, opp);
        }        
        for(Tender__c tend : lstTender)
        {
            Opportunity BOIDOpp = oppMap.get(tend.Opportunity__c);
            String tenderName ='T_';
            tenderName = tenderName + BOIDOpp.BOid__c;
            tend.Name = tenderName;
            tend.TECH_UniqueTender__c = tend.Opportunity__c;
            /* CR-0734 - Previously set with Gross Margin, now with Forecasted Gross Margin if not empty */
            if (BOIDOpp.ForecastedGrossMargin__c != null)
            {
            	tend.Gross_Margin__c = BOIDOpp.ForecastedGrossMargin__c;
            }
            tend.CurrencyIsoCode = 'EUR';
            tend.ProductLines__c = BOIDOpp.ProductLines__c;
            tend.TECH_Platforms1__c = BOIDOpp.TECH_Platforms1__c;
            tend.TECH_Platforms2__c = BOIDOpp.TECH_Platforms2__c;
            
            if (BOIDOpp.CurrencyIsoCode != 'EUR' && BOIDOpp.Amount != null)
            {
                tend.SellingPrice__c = cu.convertToCurrency(BOIDOpp.Amount, BOIDOpp.CurrencyIsoCode, 'EUR', BOIDOpp.CloseDate);
            }
            else
            {             
                tend.SellingPrice__c = BOIDOpp.Amount;
            }
            /* CR-0744 - Tender Access to tender Directors*/
            tend.ATCluster__c = BOIDOpp.ATCluster__c;
            tend.ATRegion__c = BOIDOpp.ATRegion__c;
        }
    }
    
    /*
        Set Tender field for Opportunity
    */
    public static void UpdateOpp(List<Tender__c> lstTender) {
        list<Id> tenderOpp = new list<Id>();
        for(Tender__c t : lstTender) 
            tenderOpp.add(t.Opportunity__c);
        map<Id, Opportunity> oppMap = new map<Id, Opportunity>();
        list<Opportunity> oList = [SELECT Id, Tender__c FROM Opportunity WHERE Id IN :tenderOpp];
        for(Opportunity opp : oList)
            oppMap.put(opp.Id, opp);
        List<Opportunity> opp2Update = new List<Opportunity>();     
        for(Tender__c tend : lstTender)
        {
            Opportunity Opp = oppMap.get(tend.Opportunity__c);
            Opp.Tender__c = tend.Id;
            opp2Update.add(Opp);
        }
        update opp2Update;
    }
    
    /* called by Tender__c After Insert 
        Upon creation of a Tender record, the list of users in the sharing will be initialized from the Sales Team of the related Opportunity.
        Only the Sales Team Members with the following roles must be copied to the Tender Sharing list:
        - Tender Leader
        - Bid Manager
        - Platform Director
        - Customer Director
    */

    @future
    public static void insertTenderSharing(List<Id> tender)
    {
        List<Tender__c> tenderList = new List<Tender__c>();
        for(Tender__c t : [Select Id, Opportunity__c, OwnerId from Tender__c where Id IN: tender]){
            tenderList.add(t);
        }
        createParentSharing(tenderList);
    }
    
    public static void createParentSharing(List<Tender__c> tender)
    {
        System.debug('## >>> Starting tender createParentSharing <<<');
        
        List<Tender__Share> tenderSharing = new List<Tender__Share>();
        List<String> listeRoles = (List<String>)(System.label.LBL0075.split(';'));
        Set<String> SetRoles = new Set<String>();
        SetRoles.addall(listeRoles);
        Opportunity Opp;

        list<Id> tenderOpp = new list<Id>();
        for(Tender__c t : tender) 
            tenderOpp.add(t.Opportunity__c);
        map<Id, Opportunity> oppMap = new map<Id, Opportunity>();
        list<Opportunity> oList = [SELECT Id, (Select Id, UserId, TeamMemberRole, OpportunityAccessLevel From OpportunityTeamMembers) FROM Opportunity WHERE Id IN :tenderOpp];
        for(Opportunity oppTender : oList)
            oppMap.put(oppTender.Id, oppTender);
        
        for(Tender__c tend : tender)
        {
            Opp = oppMap.get(tend.Opportunity__c);
            List<OpportunityTeamMember> listOppTeam = new List<OpportunityTeamMember>();
            if(Opp.OpportunityTeamMembers.size()>0) {
                for(OpportunityTeamMember oppTeam : Opp.OpportunityTeamMembers){
                    if (SetRoles.Contains(oppTeam.TeamMemberRole) && oppTeam.UserId != tend.OwnerId)
                        listOppTeam.add(oppTeam);
                }
            }
            for(OpportunityTeamMember oppTeam : listOppTeam)
                tenderSharing.add(new Tender__Share(AccessLevel='Edit', ParentId=tend.Id, UserOrGroupId=oppTeam.UserId));
        }
        if(tenderSharing.size() > 0)
            insert tenderSharing;
        
        System.debug('## >>> End tender createParentSharing<<<');          
    }
    
    /*
        Check if there is no duplicated tender with the same opportunity
    */
    public static void CheckTenderOpp(List<Tender__c> lstTender) {
        list<Id> tenderOpp = new list<Id>();
        //list<Id> tenderId = new list<Id>();
        for(Tender__c t : lstTender) {
            tenderOpp.add(t.Opportunity__c);
            //tenderId.add(t.Id);
        }
        map<Id, Tender__c> tendMap = new map<Id, Tender__c>();
        list<Tender__c> tList = [Select Id, Opportunity__c FROM Tender__c WHERE Opportunity__c IN :tenderOpp];
        for(Tender__c tend : tList)
            tendMap.put(tend.Opportunity__c, tend);     
        for(Tender__c tend : lstTender)
        {   
            //List<Tender__c> lTender = new List<Tender__c>();
            //lTender = [SELECT Id FROM Tender__c WHERE Opportunity__c =: tend.Opportunity__c and Id !=:tend.Id ];
            //if (lTender.size() != 0) {
            if (tendMap.get(tend.Opportunity__c) != null && tendMap.get(tend.Opportunity__c).Id != tend.Id) {
                tend.addError('Error message for update Tender. Tender record exists with the same Opportunity');
            }
        }
    }
}