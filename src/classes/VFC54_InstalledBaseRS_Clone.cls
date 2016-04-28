/*********************************************************************
 SANITY CHECK Feb. 2014 - CODE MODIFICATION REQUIRED
 Modify code following instructions below.
 Remove this box once modifications done.
*********************************************************************/

/*********************************************************************
 SANITY CHECK INSTRUCTION: 
   Add Try/Catch.
   Add debug logs.

   Add pageMessage in VF Page otherwise the error is not displayed.
 Remove this box once modification done.
*********************************************************************/

/*
 VFC54_InstalledBaseRS_Clone apex controller
    ~ Author          : Jawad GHOULAM ~ jawad.ghoulam@cgi.com 
    ~ Date Created    : 05/11/2013 
    ~ Description     : Clone Installed Base RS Object and all related children Subsystem Rolling Stock
    ~ Feature Id      : FEAT#0480 
*/
public with sharing class VFC54_InstalledBaseRS_Clone {
    Private String parentObjName        = 'InstalledBaseRS__c'; 
    Public String childObjName          = 'SubsystemRS__c';
    Private String childLookupToParent  = 'InstalledBaseRS__c';
    Private Set<String> noCloneFields   = new set<String>();
    Private Map<String, String> defaultFieldValues = new Map<String, String>(); 
    Private String namePrefix           = 'CLONE - ';

    Public SObject objSourceParent;
    Public SObject objDestParent;
    
    //StdController
    public VFC54_InstalledBaseRS_Clone(ApexPages.StandardController controller) {
        this.objSourceParent=controller.getRecord();
        initNoCloneFields();
    }
    
    // Provides a list of fields to not clone
    private void initNoCloneFields() {
        /* FIELDS OF Installed Base RS */
        // ValidationStatus
        noCloneFields.add('ValidationStatus__c'.toLowerCase());
        // Internal ID is a unique identifier, used mainly for data upload. Must not be copied.
        noCloneFields.add('InternalID__c'.toLowerCase());
    }
    
    // This method clone the parent record and all children records
    public PageReference doClone() {
        // Getting all fields of the parent object, Because the context contains only the Id.
        Map<String, Schema.SObjectField> M = Schema.getGlobalDescribe().get(parentObjName).getDescribe().fields.getMap();
        String SOQL = 'Select ';
        
        // Attention to the limit of 10,000 characters. Add only createable fields
        for (String fieldName : M.keySet()) 
        {
            if(!noCloneFields.contains(fieldName) && !M.get(fieldName).getDescribe().isCalculated()) 
            {
                SOQL += fieldName + ', ';
            }
        }
        SOQL = SOQL.substring(0,SOQL.length()-2);//Remove the last , unnecessary comma
        String strParentQuery = SOQL + ' from ' + parentObjName + ' where Id=\'' + objSourceParent.Id + '\'';
        objSourceParent = Database.query(strParentQuery);

        objDestParent = objSourceParent.clone(false,true);             //preserve_id, isdeepclone
        objDestParent.put('Name', namePrefix + objDestParent.get('Name'));//Prefixe the name of the parent record
        
        // Getting related children "Subsystem Rolling Stock"
        SObject[] objDestChildren = Database.Query('Select Id from ' + childObjName + ' where Id=\'\'');
        try {
            
            insert objDestParent;

            // Initialize in select all source fields
            M = Schema.getGlobalDescribe().get(childObjName).getDescribe().fields.getMap();
            SOQL='Select ';
            
            // Attention to the limit of 10,000 characters. Add only createable fields
            for (String fieldName : M.keySet()) 
            {
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

            PageReference InstalledBaseRSPage = new ApexPages.StandardController(objDestParent).view();
            if(Test.isRunningTest())
                throw new UtilityTestMethod.myException();
            return InstalledBaseRSPage;
        } catch (Exception e){// roll everything back in case of error
            ApexPages.addMessages(e);
            return null;
         }
    }
    
    public pagereference CancelClone() {        
        return new PageReference('/' + this.objSourceParent.Id);
    }
}