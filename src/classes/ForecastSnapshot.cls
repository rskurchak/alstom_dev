/*
 ForecastSnapshot 
    ~ Author          : Biswadeep Ghosh 
    ~ Date Created    : 04/2014 
    ~ Description     : Apex Batch to create new Forecast Snapshot 
*/
global class ForecastSnapshot implements Database.Batchable<sObject>{
    /*
        V.A.R.I.A.B.L.E.S.
    */
    global final String query;
    global final String email;
    global final Boolean bFreeze;
    global Forecast_Snapshot__c fsc = new Forecast_Snapshot__c();
    List<Opportunity_Snapshot__c> Opslist = new List<Opportunity_Snapshot__c>();
    /*
        C.O.N.S.T.R.U.C.T.O.R.
    */  
    global ForecastSnapshot(String query, String email) {
        this.query = query;
        this.email = email;
    
        // create a forecast snapshot record
        fsc.Description__c= 'Carousel month year ';
        String ThisYear = String.valueOf(date.today().Year()+1).substring(2,4);
        String NextYear = String.valueOf(date.today().Year()+2).substring(2,4);
        fsc.Snapshot_Start_Quarter__c = 'FQ4 / FY '+ThisYear+'-'+NextYear;
    	system.debug('ID value'+fsc.id);
        insert fsc;
        system.debug('ID value'+fsc.id);
    }
    /*
        S.T.A.R.T. The start method is called at the beginning of a batch Apex job. This method returns a Database.QueryLocator object
            that contains the records being passed into the job.
    */  
    global Database.QueryLocator start(Database.BatchableContext BC){
        system.debug('ID value'+fsc.id);
        return Database.getQueryLocator(query);
    }
    
    /*
        E.X.E.C.U.T.E. The executeBatch method is called for each batch of records passed to the method. It takes a list of sObjects.
            Use this method to process each chunk of records in the batch job.
    */  
    global void execute(Database.BatchableContext BC,List<Opportunity> OppList){
        system.debug('ID value'+fsc.id);
        system.debug('OppList'+OppList);
        
        Opslist.clear();    
        for(Opportunity opp : Opplist){
            
            Opportunity_Snapshot__c ops = new Opportunity_Snapshot__c();
            
            ops.AccountRef__c=opp.Accountid;
            ops.CurrencyIsoCode=opp.CurrencyIsoCode;
            ops.ownerid='005D0000003ux7D';
            ops.AdjustmentComment__c=opp.AdjustmentComment__c;
            ops.ComingIntoForceDate__c=opp.CloseDate;
            ops.FiscalPeriod__c=opp.FiscalPeriod__c;
            ops.FiscalYear__c=opp.FiscalYear__c;
            ops.AdjustedForecastCategory__c=opp.AdjustedForecastCategory__c;
            ops.ForecastedGrossMargin__c=opp.ForecastedGrossMargin__c;
            ops.AdjustedSellingPrice__c=opp.AdjustedSellingPrice__c;
            ops.Forecast_Snapshot__c=fsc.id;
            /* CR-0734 - Not used anymore */
            // ops.GrossMarginPercentage__c=opp.GrossMargin__c;
            ops.LastModifiedByRef__c=opp.LastModifiedByid;
            ops.Platform__c=opp.Platform__c;
            ops.Product__c=opp.Leading_Product__c;
            ops.LeadingProductLine__c=opp.LeadingProductLine__c;
            ops.Opportunity__c=opp.id;
            ops.OpportunityOwnerRef__c=opp.ownerid;
            ops.ProjectType__c=opp.ProjectType__c;
            ops.SellingPrice__c=opp.Amount;
            ops.Status__c=opp.StageName;
            ops.SuggestedForecastCategory__c=opp.SuggestedForecastCategory__c;
            ops.TECH_SellingPriceXGrossMargin__c=opp.TECH_SellingPriceXGrossMargin__c;
            ops.Country__c=opp.Country__c;
            ops.Cluster__c=opp.ATCluster__c;
            ops.Region__c=opp.ATRegion__c;
            ops.ForecastedFiscalPeriodRef__c=opp.ForecastedFiscalPeriod__c; 
        
            opslist.add(ops);
        }
        if(!opslist.isempty())
            try{
                system.debug('opslist'+ opslist);
                insert opslist;
            }
            catch(exception e){}        
        
    }
    global void finish(Database.BatchableContext BC){
        // Get the ID of the AsyncApexJob representing this batch job from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];
        Messaging.SingleEmailMessage Nmail = new Messaging.SingleEmailMessage();
        String[] setToAddresses=new String[]{email};
        Nmail.setToAddresses(setToAddresses);
        Nmail.setReplyTo('noreply@salesforce.com');
        Nmail.setSenderDisplayName('Batch Processing');
        Nmail.setSubject('Forecast Snapshot');
        Nmail.setPlainTextBody('Batch Process has completed. '+a.TotalJobItems +' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { Nmail });  
   }  
}