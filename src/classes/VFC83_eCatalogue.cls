public with sharing class VFC83_eCatalogue 
{
	public String eCatalogueUrl{get;private set;}
	
	public VFC83_eCatalogue()
	{
		User u = [Select Id, eCatalogueLogin__c, eCataloguePassword__c from User where Id = :UserInfo.getUserId()];
		String eCatalogueMdpMD5 = '';
		if (u.eCataloguePassword__c != null && u.eCataloguePassword__c != '')
			eCatalogueMdpMD5 = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(u.eCataloguePassword__c)));
		
		eCatalogueUrl = System.Label.LBL0229;
		eCatalogueUrl += '?mail=' + u.eCatalogueLogin__c;
		eCatalogueUrl += '&password=' + eCatalogueMdpMD5;
	}
}