trigger ProjectProductAfterDelete on ProjectProduct__c (after delete) 
{
  System.debug('## >>> ProjectProduct__c after delete <<< run by ' + UserInfo.getName());  
    
  /**************************************************************************************************************
    AP62ProjectProduct
    - automatically update the related Project: 'Product Lines' summary fields 
  **************************************************************************************************************/
  if(PAD.canTrigger('AP62'))
    AP62ProjectProduct.updateProjectProductLineSummary(Trigger.old);

  /**************************************************************************************************************
    AP63ProjectProduct
    - automatically update the related Project: 'TECH_Platforms1' and 'TECH_Platforms2' summary fields 
  **************************************************************************************************************/
  if(PAD.canTrigger('AP63'))
    AP63ProjectProduct.updateProjectPlatformSummary(trigger.old);
    
  /**************************************************************************************************************
    AP64ProjectProduct
    - automatically update the related Project: Leading Product Line and Leading Platform are blanked if the leading 
    project product is deleted
  **************************************************************************************************************/
  if(PAD.canTrigger('AP64'))
      AP64ProjectProduct.blankProjectProductInfo(trigger.old);
  
  System.debug('## >>> ProjectProduct__c after delete : END <<<');
}