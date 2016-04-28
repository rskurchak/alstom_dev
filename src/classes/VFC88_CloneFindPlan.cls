public class VFC88_CloneFindPlan 
{
    public ID objSourceId;
    public ID objDestParentId;
    public ID oppSourceId;
    public OpportunityAssessment__c record;
    
    /* Constructor */
    public VFC88_CloneFindPlan(ApexPages.StandardController stdCtrl)
    {
        
        objSourceId = ApexPages.currentPage().getParameters().get('pId');
        oppSourceId=  ApexPages.currentPage().getParameters().get('oId');
        record = (OpportunityAssessment__c)stdCtrl.getRecord();
        
    }
        
    public PageReference cloneFindPlan()
    {
         objDestParentId = record.Opportunity__c;
         system.debug('***********'+objDestParentId );
         system.debug('$$$$$$$$$$$'+oppSourceId);
         if(objDestParentId == oppSourceId){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Select A Different Opportunity'));
            return null;
         }  
        
        List<OpportunityAssessment__c> findPlans = new List<OpportunityAssessment__c>();
        //Initialiser en select tous les champs de Find Plan
        Map<String, Schema.SObjectField> findPlanFields = Schema.getGlobalDescribe().get('OpportunityAssessment__c').getDescribe().fields.getMap();
        String SOQL='Select ';
            
        // Attention � la limite des 10000 caract�res, il faudrait n'ajouter que les champs createable
        for (String fieldName : findPlanFields.keySet()) 
        {
            Schema.DescribeFieldResult field = findPlanFields.get(fieldName).getDescribe();
            if (!field.isCalculated())
            {
                SOQL += fieldName + ', ';
            }
        }
        System.debug('##SOQL'+SOQL);
        SOQL = SOQL.substring(0,SOQL.length() - 2);//Remove the last , unnecessary comma
        String strChildQuery = SOQL + ' FROM OpportunityAssessment__c WHERE Id = \'' + objSourceId + '\'';
        system.debug('query'+strChildQuery);
        for (OpportunityAssessment__c childSource : Database.Query(strChildQuery)) 
        {
            OpportunityAssessment__c childDest = childSource.clone(false);
            childDest.put('Opportunity__c', objDestParentId);
            findPlans.add(childDest);
            system.debug('childopp'+childDest);
            
        }        
        insert findPlans;
                 
        PageReference pageRef = new PageReference('/'+objDestParentId);
        return pageRef;
    }
    
    public PageReference cancel()
    {           
        PageReference pageRef = new PageReference('/'+objSourceId);
        return pageRef;
    }

}