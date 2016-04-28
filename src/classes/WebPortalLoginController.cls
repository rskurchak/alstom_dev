global class WebPortalLoginController 
{
	global String username {get; set;}
    global String password {get; set;}
    global String homeURL {get;set;}

    global String login() 
    {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        System.PageReference homeURL = Site.login(username, password, startUrl);
        if (homeURL != null)
        {
			return homeURL.getUrl();
        }
       	else
        {
            PageReference loginPage = new PageReference('/login');
            return loginPage.getUrl();
        }
    }
    
   	global WebPortalLoginController() 
   	{
   		homeURL = Url.getSalesforceBaseUrl().toExternalForm();
   	}
}