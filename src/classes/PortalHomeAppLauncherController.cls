/*
 PortalHomeAppLauncherController
    ~ Author          : Roman Skurchak ~ rskurchak@corevalue.net
    ~ Date Created    : 07/03/2016
    ~ Description     : Controller to manage Tiles for App Launcher component
*/
public class PortalHomeAppLauncherController {
    public Integer          countColomuns         {get; set;}
    public Boolean          showEmptyElem         {get; set;}
    public List<Tile__c>    availableTilesForUser {get; set;}

    @testVisible
	private Id userId {
        get{
            if( userId == null ){
                userId = UserInfo.getUserId();
            }
            return userId;
        }
        set;
    }

    public PortalHomeAppLauncherController(){
        availableTilesForUser = TileService.getTilesByUserId( userId );
        Integer countTiles = Math.mod(availableTilesForUser.size(), 6);
        showEmptyElem = Math.mod(availableTilesForUser.size(), 2) == 1? true: false;           
        countColomuns = countTiles == 0? 6: countTiles<3? 4: countTiles<5? 5: 6;
    }

}