/*
 VFP61_InstalledBaseInfra_New
   ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
    ~ Date Created    : 27/02/2014 
    ~ Description     : Apex Class to override the new action and save the record after Recordtype is selected.
    					The new record is opened in mode edit.
   ~ Author          : Tiantian HE ~ tiantian.he@cgi.com 
    ~ Date Created    : 23/02/2015 
    ~ Description     : CR-0665 Use dependent picklists Equipment Category and Equipment Class to select RecordType.
*/
public with sharing class VFC61_InstalledBaseInfra_New {

    public static Map<String, Id> mapRecordTypeId;
    Public SObject IBI;

    public VFC61_InstalledBaseInfra_New(ApexPages.StandardController controller) {
        this.IBI=controller.getRecord();
    }
    public PageReference doSave() {
        try {
            insert IBI;
            //PageReference InstalledBaseInfraPage = new ApexPages.StandardController(IBI).Edit();
            String UrlIBI = '/' + IBI.Id + '/e?retURL=%2F' + IBI.Id;
            PageReference InstalledBaseInfraPage = new PageReference(UrlIBI);
            if(Test.isRunningTest())
                throw new UtilityTestMethod.myException();
            return InstalledBaseInfraPage;
        } catch (Exception e){// roll everything back in case of error
            ApexPages.addMessages(e);
            return null;
         }
    }
    
    /**
     * Equipment Class picklist onChange action.
     * Set the record type according to the selected Equipment Class.
     */
    public void changeRecordType() {
    	String equipmentClass = String.valueOf(IBI.get('EquipmentClass__c'));
    	// initialize the map of record types of InstalledBaseInfra__c if necessary
        if (mapRecordTypeId == null) {
        	initMapRecordTypeId();
        }
        // set the record type according to the selected Equipment Class
    	if (equipmentClass != null
    		&& mapRecordTypeId.keySet().contains(equipmentClass)) {
    		IBI.put('recordTypeId', mapRecordTypeId.get(equipmentClass));
    	}
    }
    
    private void initMapRecordTypeId() {
    	mapRecordTypeId = new Map<String, Id>();
    	for (RecordType recType: [SELECT Name, Id FROM RecordType WHERE sObjectType = 'InstalledBaseInfra__c']) {
    		mapRecordTypeId.put(recType.Name, recType.Id);
    	}
    }
}