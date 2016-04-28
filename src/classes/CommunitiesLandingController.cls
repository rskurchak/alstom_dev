/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
public with sharing class CommunitiesLandingController {
    
    // Code we will invoke on page load.
    public PageReference forwardToStartPage() {
    	String pageURL = ApexPages.currentPage().getHeaders().get('Referer');
    	if (pageURL !=null && pageURL.contains('logout'))
    		return new PageReference(System.Label.LBL0318);
    	else
        	return Network.communitiesLanding();
    }
    
    public CommunitiesLandingController() {}
}