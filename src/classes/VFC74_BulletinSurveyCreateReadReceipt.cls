public class VFC74_BulletinSurveyCreateReadReceipt {
	public ApexPages.StandardController con {get; set;}

	public VFC74_BulletinSurveyCreateReadReceipt(ApexPages.StandardController controller) {
		con = controller;
	}

	public PageReference save(){
		PageReference page = new PageReference('/apex/VFP64_PortalHome');
		page.setRedirect(true);
		try{		
			ReadReceipt__c receipt = (ReadReceipt__c)con.getRecord();
			upsert receipt;
		}catch(Exception e){		
			ApexPages.addMessages(e);
			return null;
		}
		return page;
	}
}