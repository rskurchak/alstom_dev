/**
 * This class contains unit tests for validating the behavior of CurrencyUtility Apex classes
 * and triggers.
 *   ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com
     ~ Date Created    : 19/02/2012
 */
@isTest
private class CurrencyUtility_TEST 
{
	static testMethod void CurrencyUtility_TEST() 
	{
		Set<String> currencyIsoCodes = new Set<String>();
		currencyIsoCodes.add('EUR');
		currencyIsoCodes.add('USD');
		
		
		Test.startTest();
		
		CurrencyUtility cu1 = new CurrencyUtility();
		CurrencyUtility cu2 = new CurrencyUtility(currencyIsoCodes, Date.today(), Date.today());
		Decimal d = cu2.convertToCurrency(10, 'EUR', 'USD', Date.today());
		
		Test.stopTest();
	}
}