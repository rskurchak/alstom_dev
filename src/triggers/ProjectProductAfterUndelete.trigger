trigger ProjectProductAfterUndelete on ProjectProduct__c (after undelete) 
{
  System.debug('## >>> ProjectProduct__c after undelete <<< run by ' + UserInfo.getName());
  
  /**************************************************************************************************************
    AP62ProjectProduct
    - automatically update the related Project__c : 'Product Lines' summary fields 
  **************************************************************************************************************/
  if(PAD.canTrigger('AP62'))
     AP62ProjectProduct.updateProjectProductLineSummary(Trigger.new);

  
  /**************************************************************************************************************
    AP63ProjectProduct
    - automatically update the related Project__c : 'TECH_Platforms1' and 'TECH_Platforms2' summary fields 
  **************************************************************************************************************/
  if(PAD.canTrigger('AP63'))
    AP63ProjectProduct.updateProjectPlatformSummary(trigger.new);
  
   /**************************************************************************************************************
    AP64ProjectProduct
    - automatically update the related Project: 'Leading Product Line' and 'Leading Platform' fields 
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
  
  System.debug('## >>> ProjectProduct__c after undelete : END <<<');
}