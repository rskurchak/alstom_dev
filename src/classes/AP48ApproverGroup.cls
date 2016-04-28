/*********************************************************************
 SANITY CHECK Feb. 2014 - CODE MODIFICATION REQUIRED
 Modify code following instructions below.
 Remove this box once modifications done.
*********************************************************************/

/*********************************************************************
 SANITY CHECK INSTRUCTION: 
   Not bulkified : 3 SOQL query in loop
 Remove this box once modification done.
*********************************************************************/
/**
 * AP48ApproverGroup Apex Class
 *   ~ Author          : Jawad GHOULAM ~ jawad.ghoulam@cgi.com 
     ~ Date Created    : 09/10/2013
     ~ Description     : Initialize BOID and Opportunity Name on Approver Group
                         The value are retrieved from the following path in the data model: 
                         Approver Group>Tender Submission>Tender>Opportunity
     ~ Triggers        : ApproverGroupBeforeInsert, ApproverGroupBeforeUpdate
     ~ Feature Id      : FEAT#0429 
 */
public with sharing class AP48ApproverGroup {
    public static void populateOppNameAndBOID(List<ApproverGroup__c> listAG) 
    {
        for (ApproverGroup__c ag : listAG)
        {
            TenderSubmission__c tendSub = [Select Id, Tender__c from TenderSubmission__c where Id =: ag.Submission__c LIMIT 1];
            Tender__c tend = [Select Id, Opportunity__c from Tender__c where Id =: tendSub.Tender__c LIMIT 1];
            Opportunity opp = [Select Id, Name, BOID__c from Opportunity where Id =: tend.Opportunity__c LIMIT 1];
            ag.OpportunityName__c = opp.Name;
            ag.BOID__c = opp.BOid__c;            
        }
    }
}