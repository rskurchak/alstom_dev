/*
 VFC63_FI15_Clone
   ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
    ~ Date Created    : 26/03/2014 
    ~ Description     : Apex Class to Override FI15 Clone Action.
*/
public with sharing class VFC63_FI15_Clone {
    Private String parentObjName        = 'FI15__c'; 
    Public String childObjName          = 'BudgetLine__c';
    Private String childLookupToParent  = 'FI15__c';    
    Private Set<String> noCloneFields   = new set<String>();

    Public SObject objSourceParent;
    Public SObject objDestParent; 

    public VFC63_FI15_Clone(ApexPages.StandardController controller) {
        this.objSourceParent=controller.getRecord();
        initNoCloneFields();
    }
    
    // Provides a list of fields to not clone
    private void initNoCloneFields() {
        /* Fields of FI15 */
        noCloneFields.add('NotificationDate__c'.toLowerCase());
        noCloneFields.add('ApprovalDate__c'.toLowerCase());
        noCloneFields.add('ApprovalStatus__c'.toLowerCase());
        noCloneFields.add('ApprovedAmount__c'.toLowerCase());
    }

    public PageReference doClone() {
        // Getting all fields of the parent object, Because the context contains only the Id.
        system.debug('en DoClone: ' + objSourceParent.Id);
        Map<String, Schema.SObjectField> M = Schema.getGlobalDescribe().get(parentObjName).getDescribe().fields.getMap();
        String SOQL = 'Select ';
        // Attention to the limit of 10,000 characters. Add only createable fields
        for (String fieldName : M.keySet()) 
        {
        	system.debug('fieldName parent: ' + fieldName); 
            if(!noCloneFields.contains(fieldName) && !M.get(fieldName).getDescribe().isCalculated()) 
            {
                SOQL += fieldName + ', ';
            }
        }
        SOQL = SOQL.substring(0,SOQL.length()-2);//Remove the last , unnecessary comma
        String strParentQuery = SOQL + ' from ' + parentObjName + ' where Id=\'' + objSourceParent.Id + '\'';
        objSourceParent = Database.query(strParentQuery);

        objDestParent = objSourceParent.clone(false,true);             //preserve_id, isdeepclone        
        objDestParent.put('ApprovalStatus__c','Not started');
        
        // Getting related children "Budget Lines"
        SObject[] objDestChildren = Database.Query('Select Id from ' + childObjName + ' where Id=\'\'');
        try {
            
            insert objDestParent;

            // Initialize in select all source fields
            M = Schema.getGlobalDescribe().get(childObjName).getDescribe().fields.getMap();
            SOQL='Select ';
            
            // Attention to the limit of 10,000 characters. Add only createable fields
            for (String fieldName : M.keySet()) 
            {
            	system.debug('fieldName: ' + fieldName);
                Schema.DescribeFieldResult field = M.get(fieldName).getDescribe();
                if (!field.isCalculated())
                    SOQL += fieldName + ', ';
            }
            SOQL = SOQL.substring(0,SOQL.length() - 2);//Remove the last , unnecessary comma
            String strChildQuery = SOQL + ' From ' + childObjName + ' where ' + childLookupToParent + ' = \'' + objSourceParent.id + '\'';
            for (SObject childSource : Database.Query(strChildQuery)) {
                  SObject childDest = childSource.clone(false);
                  childDest.put(childLookupToParent, objDestParent.id);
                  objDestChildren.add(childDest);
            }
            insert objDestChildren;

            PageReference FI15Page = new PageReference('/' + objDestParent.Id + '/e?retURL=%2F' + objDestParent.Id);
            if(Test.isRunningTest())
                throw new UtilityTestMethod.myException();
            return FI15Page;
        } catch (Exception e){// roll everything back in case of error
            ApexPages.addMessages(e);
            return null;
         }
    }
}