/*
 CCC25PublicPortalSparePartsDetail
   ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
    ~ Date Created    : 10/07/2014 
    ~ Description     : Generic controller to retrieve Parts & Repairs information.
*/
public class CCC25PublicPortalSparePartsDetail {
  
    public String SparePartId{
    	get;
		set{
		       SparePartId=value;
		       setRecords=null;
		}
	}

    public String Category{
    	get;
		set{
		       Category=value;
		       setRecords=null;
		}
	}
 
  Public ApexPages.StandardSetController setRecords{
    get{
     if(setRecords == null){
     	List<PartAndRepair__c> sparepartList = new List<PartAndRepair__c>();
     	If (this.SparePartId != null){
     		sparepartList = [SELECT Id, Name, DesignationEN__c, Category__c, ApplicationsEN__c, ApplicationsFR__c, BenefitsEN__c, BenefitsFR__c, ProductLine__c, FeaturesEN__c, FeaturesFR__c, Picture__c, PartRepairNumber__c, Platform__c, Product__c, Type__c FROM PartAndRepair__c where Id = :this.SparePartId]; 
     	} else {
     		sparepartList = [SELECT Id, Name, DesignationEN__c, Category__c, ApplicationsEN__c, ApplicationsFR__c, BenefitsEN__c, BenefitsFR__c, ProductLine__c, FeaturesEN__c, FeaturesFR__c, Picture__c, PartRepairNumber__c, Platform__c, Product__c, Type__c FROM PartAndRepair__c where Category__c = :this.Category];            
     	}
        setRecords = new ApexPages.StandardSetController(sparepartList);
     }  
      return setRecords;
    }
    set;
   }
    
    public List<Attachment> listAttachment {
        get {
            if ( listAttachment == NULL) {
            	listAttachment = [SELECT Id, Name, Body, ContentType FROM Attachment 
             						WHERE Parentid = :this.SparePartId];
        	}
            return listAttachment;
        }
        set;
    }
      

	public List<PartAndRepair__c> listPR 
	{
		get
		{
			return setRecords.getRecords();
		}
		set;
	}
   	
    
}