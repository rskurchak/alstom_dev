public without sharing class VFC86_NewPxOStandardLine 
{
	public PxOStandard__c pxoStd {get;set;}
	
	public VFC86_NewPxOStandardLine(ApexPages.StandardController stdCtrl)
	{
		this.pxoStd = (PxOStandard__c)stdCtrl.getRecord();
	}
	
	public PageReference createPxOStandardLine()
	{
		// Getting object key prefix
		Schema.DescribeSObjectResult r = PxOStandardLine__c.sObjectType.getDescribe();
		String keyPrefix = r.getKeyPrefix();
		
		// Getting Record Type Id with same name has PxO Standard RT
		Id recTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'PxOStandardLine__c' and DeveloperName = :pxoStd.RecordType.DeveloperName Limit 1].Id;
		String recordTypeId = ApexPages.currentPage().getParameters().get('RecordType');
		
		// Returning new page
		return new PageReference('/' + keyPrefix + '/e?CF' + System.Label.LBL0314 + '=' + EncodingUtil.urlEncode(pxoStd.Name, 'UTF-8') + '&CF' + System.Label.LBL0314 + '_lkid=' + pxoStd.Id + '&RecordType=' + recTypeId + '&retURL=' + pxoStd.Id); 
	}
}