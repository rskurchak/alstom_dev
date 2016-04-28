public with sharing class SharingFieldOptionsServices {
	public static final String RAW_CAUSE_FIELD = 'RowCause';
	public static final String ACCESS_LEVEL_FIELD = 'AccessLevel';

	public static final String ACCESS_LEVEL_VALUE_READ = 'Read';

	public static final String CAUSE_VALUE_MANUAL = 'Manual';
	public static final String CAUSE_VALUE_GLOBAL_ACCOUNT = 'GlobalAccount';

	public static Map<String, Map<String, String>> getFieldOptionsForObject( String objectName ){
		Map<String, Map<String, String>> fieldOptions = new Map<String, Map<String, String>>();

		for( SharingFieldOptionsMetadata__mdt csItem : [ Select DeveloperName, RowCause__c, AccessLevel__c, MasterLabel 
													  	 From SharingFieldOptionsMetadata__mdt 
													  	 Where ObjectName__c = :objectName ] ){
			if( !fieldOptions.containsKey( csItem.MasterLabel ) ){
				fieldOptions.put( csItem.MasterLabel, new Map<String, String>() );
			}
			fieldOptions.get( csItem.MasterLabel ).put( RAW_CAUSE_FIELD, csItem.RowCause__c );
			fieldOptions.get( csItem.MasterLabel ).put( ACCESS_LEVEL_FIELD, csItem.AccessLevel__c );
		}

		return fieldOptions;
	}

}