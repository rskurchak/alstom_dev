/*
 VFC40_OpportunityCockpit 
    ~ Author            : jawad.ghoulam@cgi.com
    ~ Modification Date : 27/08/2013
    ~ Description       : Controller of VFP40_Cockpit_FindWin
    ~ Feature Id      : FEAT#0356 
    CR-0828 (27/11/2015) - F. Taillon : Alerts: Dates/Status/Fields/Forecast/
*/
public without sharing class VFC40_OpportunityCockpit {

    private Opportunity opportunity;
    // Allows to display or not the Button and Link of Find Plan
    public Boolean isFindPlan{get;set;}
    // Allows to display or not the Button and Link of Tender
    public Boolean isTender{get;set;}
    // Allows to display or not the Button and Link of WinLossAnalysis
    public Boolean isWinLoss{get;set;}
    // Contains WinLossAnalysis Id
    public String winLossId{get;set;}
    // Contains Status of related Opportunity
    public String statusOpp{get;set;}
    // Contains FindPlan Id
    public String findPlanId{get;set;}
    // Contains Tender Id
    public String tenderId{get;set;}
    // Contains Opportunity Id
    public String oppId{get;set;}
    // Contains Opportunity Name
    public String oppName{get;set;}
    // Contains BOID of Opportunity
    public String oppBOID{get;set;}
    // Contains Grading of Opportunity
    public String oppGrading{get;set;}
    // Contains TECH_WLA_Image value
    public String oppWLA{get;set;}
    // Contains list of alerts to display
    public List<String> listAlerts {get;set;}
    
    public String htmlErrorMessage {
        get {
            String html = '';
            if (listAlerts != null && listAlerts.size() > 0)
            {
                html = '<ul>';
                for (String alert : listAlerts)
                {
                    html += '<li>'+alert+'</li>';
                }
                html += '</ul>';
            }
            return html;
        }
        set;
    }

    public VFC40_OpportunityCockpit(ApexPages.StandardController controller) {
        // Getting current record of Opportunity
        this.opportunity = (Opportunity)controller.getRecord();
        if(this.opportunity != null) {
            // Getting needed information on Opportunity            
            Opportunity Opp = [Select BOID__c, Id, Name, TECH_FindOrWin__c, Grading__c, TECH_WLA_Image__c,
                                PrequalDate__c, RFP__c, SubmittalDate__c, AwardDate__c, CloseDate,
                                Platform__c, ScopeOfWork__c, AdjustedForecastCategory__c, StageName,
                                ForecastedFiscalPeriod__c, FiscalPeriod__c from Opportunity where Id =: this.opportunity.Id];
            oppId = Opp.Id;
            oppName = Opp.Name;
            oppBOID = Opp.BOid__c;
            oppGrading = Opp.Grading__c;
            oppWLA = Opp.TECH_WLA_Image__c;
            
            // Getting needed informations on related Opportunity Assessment (Find Plan)
            List<OpportunityAssessment__c> findPlan = new List<OpportunityAssessment__c>();
            findPlan = [Select Id, Name from OpportunityAssessment__c where Opportunity__c =: Opp.Id and Status__c =: System.label.LBL0061];

            if(findPlan.size() != 0) {
                OpportunityAssessment__c vFindPlan = [Select Id from OpportunityAssessment__c where Opportunity__c =: Opp.Id and Status__c =: System.label.LBL0061];
                // Set isFindPlan to true. This allows to hide button "Create Find Plan" and display link "Go to Find Plan"
                isFindPlan = true;
                // Allows to display Find Plan page
                findPlanId = vFindPlan.Id;
            }
            
            // Getting needed informations on related Tender
            List<Tender__c> tender = new List<Tender__c>();
            tender = [Select Id from Tender__c where Opportunity__c =: Opp.Id];
            if(tender.size() != 0) {
                Tender__c vTender = [Select Id from Tender__c where Opportunity__c =: Opp.Id];
                // Set isTender to true. This allows to hide button "Create Tender" and display link "Go to Tender"
                isTender = true;
                // Allows to display Tender page
                tenderId = vTender.Id;
            }
            
            // Getting needed informations on related WinLossAnalysis
            List<WinLossAnalysis__c> winLossAnalysis = new List<WinLossAnalysis__c>();
            winLossAnalysis = [Select Id from WinLossAnalysis__c where Opportunity__c =: Opp.Id];
            if(winLossAnalysis.size() > 0) {
                // Set isWinLoss to true. This allows to hide button "Create WinLoss" and display link "Go to WinLoss"
                isWinLoss = true;
                // Allows to display WinLossAnalysis page
                winLossId = winLossAnalysis[0].Id;
            }

            statusOpp = Opp.TECH_FindOrWin__c;

            /********** Displaying Alerts **********/
            /********** DATES **********/
            listAlerts = new List<String>();
            // The following cases should be consider an inconsistency
            // Prequalification date > RFP date
            /*
            if (Opp.PrequalDate__c > Opp.RFP__c)
                listAlerts.add(System.label.LBL0345.replace('{0}', Schema.SObjectType.Opportunity.fields.PrequalDate__c.getLabel()).replace('{1}', Schema.SObjectType.Opportunity.fields.RFP__c.getLabel())); 
            
            // RFP date > Submittal Date
            if (Opp.RFP__c > Opp.SubmittalDate__c)
                listAlerts.add(System.label.LBL0345.replace('{0}', Schema.SObjectType.Opportunity.fields.RFP__c.getLabel()).replace('{1}', Schema.SObjectType.Opportunity.fields.SubmittalDate__c.getLabel())); 
            
            // Submittal Date > Signature date 
            if (Opp.SubmittalDate__c > Opp.AwardDate__c)
                listAlerts.add(System.label.LBL0345.replace('{0}', Schema.SObjectType.Opportunity.fields.SubmittalDate__c.getLabel()).replace('{1}', Schema.SObjectType.Opportunity.fields.AwardDate__c.getLabel())); 
            
            // Signature date > Coming into force date
            if (Opp.AwardDate__c > Opp.CloseDate)
                listAlerts.add(System.label.LBL0345.replace('{0}', Schema.SObjectType.Opportunity.fields.AwardDate__c.getLabel()).replace('{1}', Schema.SObjectType.Opportunity.fields.CloseDate.getLabel())); 
            */


            // Dates must follow this order: Prequalification submittal Date > RFP Date > Offer Submittal Date > Contract Signature Date > Coming into force Date
            boolean dateAreIncoherent = false;
            if (Opp.PrequalDate__c > Opp.RFP__c
                || Opp.PrequalDate__c > Opp.SubmittalDate__c
                || Opp.PrequalDate__c > Opp.AwardDate__c
                || Opp.PrequalDate__c > Opp.CloseDate)
            {
                // Prequalification date
                dateAreIncoherent = true;
            }
            else if (Opp.RFP__c > Opp.SubmittalDate__c
                     || Opp.RFP__c > Opp.AwardDate__c
                     || Opp.RFP__c > Opp.CloseDate)
            {
                // RFP date
                dateAreIncoherent = true;
            }
            else if (Opp.SubmittalDate__c > Opp.AwardDate__c
                     || Opp.SubmittalDate__c > Opp.CloseDate)
            {
                // Submittal Date
                dateAreIncoherent = true;
            }
            else if (Opp.AwardDate__c > Opp.CloseDate)
            {
                // Coming into force date
                dateAreIncoherent = true;
            }

            if (dateAreIncoherent)
                listAlerts.add(System.label.LBL0362);


            // Empty Dates: RFP, Submittal and Signature date - Fields Leading Platform, Scope of work
            List<String> missingFields = new List<String>();
            if (Opp.RFP__c == null)
                missingFields.add(Schema.SObjectType.Opportunity.fields.RFP__c.getLabel());

            /* To be removed as the field is already mandatory
            if (Opp.SubmittalDate__c == null)
                missingFields.add(Schema.SObjectType.Opportunity.fields.SubmittalDate__c.getLabel());
            */

            /* Comment on Chatter CR-0828: no need to check Contract Signature date */
            /* CR-0884: Wanted again */
            if (Opp.AwardDate__c == null)
                missingFields.add(Schema.SObjectType.Opportunity.fields.AwardDate__c.getLabel());
            
            /* Empty Leading Platform, or no Platform at all */
            List<Product__c> listProducts = [Select Id, Platform__c from Product__c where Opportunity__c = :Opp.Id and Platform__c != ''];
            if (listProducts.size() == 0)
            {
                missingFields.add(Schema.SObjectType.Opportunity.fields.Platform__c.getLabel());
                //listAlerts.add(System.Label.LBL0364);
            }
            else
            {
                // If there is at least one Platform, one must be Leading
                if (Opp.Platform__c == null || Opp.Platform__c == '')
                    missingFields.add(Schema.SObjectType.Opportunity.fields.Platform__c.getLabel());
            }

            if (Opp.ScopeOfWork__c == null || Opp.ScopeOfWork__c == '')
                missingFields.add(Schema.SObjectType.Opportunity.fields.ScopeOfWork__c.getLabel());

            // Check Sales Team
            List<OpportunityTeamMember> listOppMembers = [Select Id from OpportunityTeamMember where OpportunityId = :Opp.Id];
            if (listOppMembers.size() == 0)
                missingFields.add(System.Label.LBL0359);

            if (missingFields.size() > 0)
            {
                String missingValues = '';
                for (String missingField : missingFields)
                {
                    missingValues = missingValues + missingField + ', ';
                }
                // Removing last ','
                missingValues = missingValues.substring(0, missingValues.length()-2);
                listAlerts.add(System.label.LBL0346.replace('{0}', missingValues)); 
            }

            // To be submitted, to be resubmitted, Pre-BOR/Post-BOR BOs & submittal date in the past
            if ((Opp.StageName == System.Label.LBL0350
                 || Opp.StageName == System.Label.LBL0351
                 || Opp.StageName == System.Label.LBL0001
                 || Opp.StageName == System.Label.LBL0353)
                && Opp.SubmittalDate__c < Date.today())
            {
                listAlerts.add(System.Label.LBL0348);
            }

            // Pre-BOR / Post-BOR / To be Submitted, to be resubmitted, submitted BOs  & signature date in the past
            if ((Opp.StageName == System.Label.LBL0001
                 || Opp.StageName == System.Label.LBL0353
                 || Opp.StageName == System.Label.LBL0350
                 || Opp.StageName == System.Label.LBL0351
                 || Opp.StageName == System.Label.LBL0352)
                && Opp.AwardDate__c < Date.today())
            {
                listAlerts.add(System.Label.LBL0365);
            }

            /* Specs have changed again, so this is not used anymore. I don't delete it just in case of another change
            // Previous LBL0348: The following date{0} should not be in the past for this status: {1}
            // TODO: Not the best way to handle it, do a more generic status when more time available
            if (submittalDateStatusError && signatureDateStatusError)
                listAlerts.add(System.Label.LBL0348.replace('{0}', '').replace('{1}', Schema.SObjectType.Opportunity.fields.SubmittalDate__c.getLabel() + ', ' + Schema.SObjectType.Opportunity.fields.AwardDate__c.getLabel()));
            else if (submittalDateStatusError)
                listAlerts.add(System.Label.LBL0348.replace('{0}', '').replace('{1}', Schema.SObjectType.Opportunity.fields.SubmittalDate__c.getLabel()));
            else if (signatureDateStatusError)
                listAlerts.add(System.Label.LBL0348.replace('{0}', '').replace('{1}', Schema.SObjectType.Opportunity.fields.AwardDate__c.getLabel()));
            */

            // Submitted /Preferred Bidder/Contract Signed/Lost BOs & submittal date in the future
            // CR-0828 comment: Offer Submittal Date should not be in the future for these status : please remove "Cancelled"
            if ((Opp.StageName == System.Label.LBL0352
                 || Opp.StageName == System.Label.LBL0135
                 || Opp.StageName == System.Label.LBL0136
                 || Opp.StageName == System.Label.LBL0354)
                && Opp.SubmittalDate__c > Date.today())
            {
                listAlerts.add(System.Label.LBL0349);
            }

            // Contract Signed or Lost BOs & Signature date in the future
            if ((Opp.StageName == System.Label.LBL0136
                 || Opp.StageName == System.Label.LBL0354)
                && Opp.AwardDate__c > Date.today())
            {
                listAlerts.add(System.Label.LBL0366);
            }

            // Alert for the status lost, no bid, cancelled (must be in out of pipeline)
            // Forecast Category should be "Out Of Pipeline" for this Status
            // Opportunity Status should be at "Contract Signed" when Forecast Category is "Booked"
            // Changed in UAT to :
            // The 2 messages together are contradictory. We should say: 
            // Status & Forecast Category are not coherent. (Lost, No Bid, Cancelled must be out of pipeline. Contract Signed must be Booked.)
            if (((Opp.StageName == System.Label.LBL0354
                 || Opp.StageName == System.Label.LBL0356
                 || Opp.StageName == System.Label.LBL0355)
                && Opp.AdjustedForecastCategory__c != System.Label.LBL0038)
                || (Opp.AdjustedForecastCategory__c == System.Label.LBL0039 && Opp.StageName != System.Label.LBL0136))
            {
                listAlerts.add(System.Label.LBL0363);
            }

            // Forecasted Fiscal Period and Coming into force date are not consistent
            if (Opp.ForecastedFiscalPeriod__c != Opp.FiscalPeriod__c)
                listAlerts.add(System.Label.LBL0358);

            // No Periodic report last 3 Months (when status is not Lost, cancelled, dormant, No Bid)
            // Comment on Chatter CR-0828: for Empty Period reports (more than 3 months), please no need Contract Signed & Preferred bidder
            if (Opp.StageName != System.Label.LBL0354
                 && Opp.StageName != System.Label.LBL0355
                 && Opp.StageName != System.Label.LBL0361
                 && Opp.StageName != System.Label.LBL0356
                 && Opp.StageName != System.Label.LBL0136
                 && Opp.StageName != System.Label.LBL0135)
            {
                List<PeriodicReport__c> listPeriodicReports = [Select Id from PeriodicReport__c 
                                                                            where Opportunity__c = :Opp.Id
                                                                            AND ReportDate__c > :DateTime.Now().addMonths(-3)];
                if (listPeriodicReports.size() == 0)
                    listAlerts.add(System.Label.LBL0360);  
            }
        }
    }
}