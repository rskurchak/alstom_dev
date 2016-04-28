/*
 AP60InstalledBaseInfra apex class
   ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
    ~ Date Created    : 28/02/2014 
    ~ Description     : Apex Class 
    				- Prepare the Installed base infra Record with default values based on 
    				  Record type chosen.
*/
public with sharing class AP60InstalledBaseInfra {
    public static void SetSubsystemsSpecificInformationRichText(List<InstalledBaseInfra__c> InstalledBaseInfras) {
        // Getting needed Template informations on EmailTemplate
    	map<Id, RecordType> IBIRectypeMapId = new map<Id, RecordType>();
    	map<String, RecordType> IBIRectypeMapName = new map<String, RecordType>();
    	list<RecordType> rtList = [SELECT Id, Name FROM RecordType WHERE SObjectType='InstalledBaseInfra__c'];
		for(RecordType rt : rtList){
			IBIRectypeMapId.put(rt.Id, rt);
			IBIRectypeMapName.put(rt.Name, rt);
		}        
    	map<String, EmailTemplate> IBItemplate = new map<String, EmailTemplate>();
    	list<EmailTemplate> etList = [select Id, DeveloperName, Body, HtmlValue from EmailTemplate where DeveloperName IN (:System.label.LBL0129, :System.label.LBL0130, :System.label.LBL0131)];
		for(EmailTemplate et : etList)
			IBItemplate.put(et.DeveloperName, et);        
        RecordType RecTypeBallastTrack = IBIRectypeMapName.get('Ballast track');
        RecordType RecTypeConcreteTrack = IBIRectypeMapName.get('Concrete track');
        RecordType RecTypeHVIntakeSubstation = IBIRectypeMapName.get('HV Intake Substation');
        RecordType RecTypeTractionSubstation = IBIRectypeMapName.get('Traction Substation');
        RecordType RecTypeReturnCurrentSystem = IBIRectypeMapName.get('Return Current System');

        for(InstalledBaseInfra__c IBI : InstalledBaseInfras) {
        	if (IBI.EquipmentClass__c == null) {
        		IBI.EquipmentClass__c =  IBIRectypeMapId.get(IBI.RecordTypeId).Name;
	        	IBI.Name = System.label.LBL0132;
        	}
        	else { 
        		IBI.RecordTypeId =  IBIRectypeMapName.get(IBI.EquipmentClass__c).Id;
        	}
            // Set Subsystems specific information field of Installed Base Infra from HTML value of EmailTemplate
            if (IBI.RecordTypeId == RecTypeBallastTrack.Id || IBI.RecordTypeId == RecTypeConcreteTrack.Id)
        		IBI.SubsystemsSpecificInformation__c = IBItemplate.get(System.label.LBL0129).HtmlValue;
          	if (IBI.RecordTypeId == RecTypeHVIntakeSubstation.Id || IBI.RecordTypeId == RecTypeTractionSubstation.Id) 
        		IBI.SubsystemsSpecificInformation__c = IBItemplate.get(System.label.LBL0130).HtmlValue;
           	if (IBI.RecordTypeId == RecTypeReturnCurrentSystem.Id)          	
        		IBI.SubsystemsSpecificInformation__c = IBItemplate.get(System.label.LBL0131).HtmlValue;
        	System.debug('## >>> AP60InstalledBaseInfra.SetSubsystemsSpecificInformationRichText values: ' + IBI.RecordTypeid + ' - ' + IBI.Name);		
        }
    }
}