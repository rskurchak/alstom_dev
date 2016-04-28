@isTest
private class WebPortalLoginController_TEST 
{
    static testMethod void WebPortalLoginController_TEST() 
    {
    	// Instantiate a new controller with all parameters in the page
        WebPortalLoginController controller = new WebPortalLoginController ();
        controller.username = 'test@salesforce.com';
        controller.password = '123456'; 
        
        PageReference loginPage = new PageReference('/login');
        System.assertEquals(controller.login(), loginPage.getUrl());
    }
}