/*
 AP45ApproverGroup apex class
   ~ Author          : Fabien Taillon ~ fabien.taillon@cgi.com 
    ~ Date Created    : 30/09/2013
    ~ Description     : Apex Class 
                        - FEAT#0415: move Approver[1 to 10]__c field values so that they are filled in sequence without holes.
                          Also checks for duplicates in names and eliminates them.
*/
public with sharing class AP45ApproverGroup 
{
    public static void regroupApprovers(List<ApproverGroup__c> listAG) 
    {
        for (ApproverGroup__c ag : listAG)
        {
            // Using both Set and List
            // Set for unniqueness, and List for Order
            Set<Id> uniqueApprovers = new Set<Id>();
            List<Id> approvers = new List<Id>();
            for (Integer i = 1; i < 11; i++)
            {
                if (ag.get('Approver' + i + '__c') != null && !uniqueApprovers.contains((Id)ag.get('Approver' + i + '__c')))
                {
                    approvers.add((Id)ag.get('Approver' + i + '__c'));
                    uniqueApprovers.add((Id)ag.get('Approver' + i + '__c'));
                }
                ag.put('Approver' + i + '__c', null);
            }
            
            Integer i = 1;
            for (Id agId : approvers)
            {
                ag.put('Approver' + i + '__c', agId);
                i++;
            }
        }
    }
}