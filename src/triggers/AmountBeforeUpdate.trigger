trigger AmountBeforeUpdate on Amounts__c (before update) {
    
     System.debug('## >>> User before Update <<< run by ' + UserInfo.getName());
     /**************************************************************************************************************
		AP70Amounts
		- automatically update the value of the field ExchangeRate
	  **************************************************************************************************************/
     for(Amounts__c amount :Trigger.New){
          if((amount.CurrencyIsoCode != Trigger.oldMap.get(amount.Id).CurrencyIsoCode)
               && (amount.ExchangeRate__c == Trigger.oldMap.get(amount.Id).ExchangeRate__c)
               && PAD.canTrigger('AP70')){
                     // call method of class AP70Amounts to update the value of ExchangeRate.
                    AP70Amounts.updateExchangeRate(Trigger.New);
          }
      }
     System.debug('## >>> Amounts before update END');

}