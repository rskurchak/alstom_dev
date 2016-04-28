trigger LeadBeforeUpdate on Lead (before update) {
  System.debug('## >>> Lead Before Update <<< run by ' + UserInfo.getName());
  
  /****************************************************************************************
    AP03ATRegion - Update ATRegion when the Country changes
  *****************************************************************************************/
  if(PAD.canTrigger('AP03'))
  {
    List<Lead> ap03Leads = new List<Lead>();
    for(Lead lead : Trigger.new) 
      if(lead.Country__c != Trigger.oldMap.get(lead.Id).Country__c) 
        ap03Leads.add(lead);

    if(ap03Leads.size() > 0)
      AP03ATRegion.updateSObjectATRegion(ap03Leads);
  }//bypass
  
  System.debug('## >>> Lead Before Update END');
}