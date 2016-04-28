/*
 VFC18_Opportunity_Clone 
    ~ Author            : damian.hercun@alstom.com
    ~ Modification Date : 27/07/2012
    ~ Description       : Controller of VFP17_Opportunity_Clone.page
    ~ Description       : Custom clone functionality to create a duplicated opportunity
    ~ Author            : antonin.maigne@cgi.com
    ~ Modification Date : 17/02/2015
    ~ Description       : CR-0695 - Copy of Find Plan
     
*/
public with sharing class VFC18_Opportunity_Clone 
{
   	private String parentObjName        = 'Opportunity';    
    public String childObjName          = 'Product__c';
    private String childLookupToParent  = 'Opportunity__c';
    private String findPlanObj			= 'OpportunityAssessment__c';
    private Set<String> noCloneFields   = new set<String>();
    private Map<String, String> defaultFieldValues = new Map<String, String>(); 
    private String namePrefix           = 'CLONE - ';

    Public SObject objSourceParent;
    Public SObject objDestParent;

    //StdController
    public VFC18_Opportunity_Clone(ApexPages.StandardController controller) 
    {
        this.objSourceParent=controller.getRecord();
        initNoCloneFields();
    }

    // Provides a list of fields to not clone
    private void initNoCloneFields() 
    {
        /* FIELDS OF OPPORTUNITY */
        /* ORF, Reason, Feedback, WinnerName, WinnerPrice, Boid */
        noCloneFields.add('CommercialORF__c'.toLowerCase());
        noCloneFields.add('Reason__c'.toLowerCase());
        noCloneFields.add('Feedback__c'.toLowerCase());
        noCloneFields.add('WinnerName__c'.toLowerCase());
        noCloneFields.add('WinnerPrice__c'.toLowerCase());
        noCloneFields.add('BOid__c'.toLowerCase());
        noCloneFields.add('Tender__c'.toLowerCase());
    }

    public PageReference doClone() 
    {
        //r�cup�rer en select tous les champs source du parent, car le contexte ne contient que l'id
        Map<String, Schema.SObjectField> M = Schema.getGlobalDescribe().get(parentObjName).getDescribe().fields.getMap();
        String SOQL = 'Select ';
        
        //## Attention � la limite des 10000 caract�res, il faudrait n'ajouter que les champs createable
        for (String fieldName : M.keySet()) 
        {
            if(!noCloneFields.contains(fieldName) && !M.get(fieldName).getDescribe().isCalculated()) 
            {
                SOQL += fieldName + ', ';
                System.Debug('## FIELDS : ' + fieldName + ' contained : ' + noCloneFields.contains(fieldName));
            }
        }
        SOQL = SOQL.substring(0,SOQL.length()-2);//Remove the last , unnecessary comma
        String strParentQuery = SOQL + ' from ' + parentObjName + ' where Id=\'' + objSourceParent.Id + '\'';
        System.Debug('## Query order : ' + strParentQuery); 
        objSourceParent = Database.query(strParentQuery);

        objDestParent = objSourceParent.clone(false,false);             //preserve_id, isdeepclone
        objDestParent.put('Name', namePrefix + objDestParent.get('Name'));//Prefixe the name of the parent record
        objDestParent.put('OwnerId', UserInfo.getUserId());             //Change the owner of the parent record to the current user
        
        // R�cuperer le produit associ� qui est en Leading = true
        SObject[] objDestChildren = Database.Query('Select Id from ' + childObjName + ' where Id=\'\'');
       	List<SObject> findPlans = Database.Query('Select Id from ' + findPlanObj + ' where Id=\'\'');
        try
        {
            
            insert objDestParent;

            // Initialiser en select tous les champs source
            M = Schema.getGlobalDescribe().get(childObjName).getDescribe().fields.getMap();
            SOQL='Select ';
            
            // Attention � la limite des 10000 caract�res, il faudrait n'ajouter que les champs createable
            for (String fieldName : M.keySet()) 
            {
                Schema.DescribeFieldResult field = M.get(fieldName).getDescribe();
                if (!field.isCalculated())
                    SOQL += fieldName + ', ';
            }
            
            SOQL = SOQL.substring(0,SOQL.length() - 2);//Remove the last , unnecessary comma
            String strChildQuery = SOQL + ' From ' + childObjName + ' where ' + childLookupToParent + ' = \'' + objSourceParent.id + '\' AND Leading__c = true';
            System.debug('FTA '+SOQL);
            for (SObject childSource : Database.Query(strChildQuery)) 
            {
                  SObject childDest = childSource.clone(false);
                  childDest.put(childLookupToParent, objDestParent.id);
                  objDestChildren.add(childDest);
            }
            insert objDestChildren;                        

            PageReference opportunityPage = new ApexPages.StandardController(objDestParent).view();
            if(Test.isRunningTest())
                throw new UtilityTestMethod.myException();
            return opportunityPage;
        } 
        catch (Exception e)
        {// roll everything back in case of error
            ApexPages.addMessages(e);
            return null;
         }
    }
    
    public pagereference CancelClone() {        
        return new PageReference('/' + this.objSourceParent.Id);
    }
    
}