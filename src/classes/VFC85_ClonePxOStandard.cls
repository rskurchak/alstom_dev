public with sharing class VFC85_ClonePxOStandard 
{
	private Id pxoId;
	
	public VFC85_ClonePxOStandard(ApexPages.StandardController stdCtrl)
	{
		pxoId = ApexPages.currentPage().getParameters().get('id');
	}
	
	public PageReference deepClone()
	{
		// Getting fields for PxO Standard
		Map<String, Schema.SObjectField> mapFieldsPxO = Schema.getGlobalDescribe().get('PxOStandard__c').getDescribe().fields.getMap();
        String query = 'Select ';
        for (String fieldName : mapFieldsPxO.keySet()) 
        {
            if(!mapFieldsPxO.get(fieldName).getDescribe().isCalculated()) 
            {
                query += fieldName + ', ';
            }
        }
        
        // // Getting fields for PxO Standard Lines
        Map<String, Schema.SObjectField> mapFieldsPxOLines = Schema.getGlobalDescribe().get('PxOStandardLine__c').getDescribe().fields.getMap();
        query += '(Select ';
        for (String fieldName : mapFieldsPxOLines.keySet()) 
        {
            if(!mapFieldsPxOLines.get(fieldName).getDescribe().isCalculated()) 
            {
                query += fieldName + ', ';
            }
        }
        
        // Remove the 2 last unnecessary characters
        query = query.substring(0, query.length()-2);
        query += ' from PxO_Standard_Lines__r) from PxOStandard__c where Id=\'' + pxoId + '\'';
        System.debug('##### Query: ' + query);
        
        // Querying source records
        PxOStandard__c pxoStandardSource = Database.query(query);

		// Cloning
		// Create a save point in case PxO Standard is created but lines crash
		Savepoint sp = Database.setSavepoint();
		try
		{			
	        PxOStandard__c pxoStandardCloned = pxoStandardSource.clone(false, true); 
	       	insert pxoStandardCloned;
	       	
	       	List<PxOStandardLine__c> pxoStdLinesCloned = new List<PxOStandardLine__c>();
	       	for (PxOStandardLine__c pxoStdline : pxoStandardCloned.PxO_Standard_Lines__r)
	       	{
	       		PxOStandardLine__c clonedPxoStdLine = pxoStdline.clone(false, true);
	       		clonedPxoStdLine.PxOStandard__c = pxoStandardCloned.Id;
	       		pxoStdLinesCloned.add(clonedPxoStdLine);
	       	}
	       	
	       	if (pxoStdLinesCloned.size() > 0)
	       		insert pxoStdLinesCloned;
	       	
	       	return new PageReference('/' + pxoStandardCloned.Id);
		}
		catch (Exception e)
		{
			// Rollback and display error message
			Database.rollback(sp);
			ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, e.getMessage());
	    	ApexPages.addMessage(msg);
			return null;
		}
	}
}