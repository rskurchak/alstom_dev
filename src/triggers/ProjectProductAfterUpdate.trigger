trigger ProjectProductAfterUpdate on ProjectProduct__c (after update) 
{
  System.debug('## >>> ProjectProduct__c after update <<< run by ' + UserInfo.getName());
  
  /**************************************************************************************************************
    AP62ProjectProduct
    - automatically update the related Project: 'Product Line' summary fields 
  **************************************************************************************************************/
  if(PAD.canTrigger('AP62'))
  {
    list<ProjectProduct__c> ap62ProjectProducts = new list<ProjectProduct__c>();
    for (ProjectProduct__c prd : Trigger.new)
      ap62ProjectProducts.add(prd);
    
     if(ap62ProjectProducts.size() > 0)
       AP62ProjectProduct.updateProjectProductLineSummary(ap62ProjectProducts);
  }
  
  /**************************************************************************************************************
    AP63ProjectProduct
    - automatically update the related Project: 'TECH_Platforms1' and 'TECH_Platforms2' summary fields 
  **************************************************************************************************************/
  if(PAD.canTrigger('AP63'))
  {
    list<ProjectProduct__c> ap63ProjectProducts = new list<ProjectProduct__c>();
    for (ProjectProduct__c prd : Trigger.new)
      ap63ProjectProducts.add(prd);
      
    if(ap63ProjectProducts.size() > 0)
      AP63ProjectProduct.updateProjectPlatformSummary(ap63ProjectProducts);
  }
  
  /**************************************************************************************************************
    AP64ProjectProduct
    - automatically update the related Project: 'Product Line' and 'Platform' fields 
    when the Leading product is changed
  **************************************************************************************************************/
  if(PAD.canTrigger('AP64'))
  {
    List<ProjectProduct__c> ap64ProjectProducts = new List<ProjectProduct__c>();
    for(ProjectProduct__c prd : Trigger.new)
      if(prd.Leading__c)
        ap64ProjectProducts.add(prd);
     
     if(ap64ProjectProducts.size() > 0)
       AP64ProjectProduct.updateProjectProductInfo(ap64ProjectProducts);
  }//bypass
  
  System.debug('## >>> ProjectProduct__c after update : END <<<');
}