/*
 AP59InstalledBaseInfra apex class
   ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
    ~ Date Created    : 26/02/2014 
    ~ Description     : Apex Class 
    				- Update the Record type value based on Equipment class selected when changed.
*/
public with sharing class AP59InstalledBaseInfra {
	public static void syncRecordTypeEquipmentClass(List<InstalledBaseInfra__c> InstalledBaseInfras)
	{
		System.debug('## >>> Starting AP59InstalledBaseInfra.syncRecordTypeEquipmentClass <<<');
    	map<String, RecordType> IBIRectypeMap = new map<String, RecordType>();
    	list<RecordType> rtList = [SELECT Id, Name FROM RecordType WHERE SObjectType='InstalledBaseInfra__c'];
		for(RecordType rt : rtList)
			IBIRectypeMap.put(rt.Name, rt);    			
		for(InstalledBaseInfra__c IBI : InstalledBaseInfras)
			IBI.RecordTypeId = IBIRectypeMap.get(IBI.EquipmentClass__c).Id;
		System.debug('## >>> AP59InstalledBaseInfra.syncRecordTypeEquipmentClass END <<<');		
	}
}