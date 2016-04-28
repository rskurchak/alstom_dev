/*
 PAD apex class
    ~ Author          : Jean-Luc Antoine for Areva T&D in 2008-2010, 
                        modified by Adrian Modolea ~ adrian.modolea@axoa.fr (POC Alstom Transport june 2011) 
    ~ Date Created    : 29/06/2011 
    ~ Description     : Apex Class to retrieve the triggers that can be bypassed by the current user
*/
public class PAD 
{
    /************************************
        V.A.R.I.A.B.L.E.S.
    *************************************/
    public static final String bypassTrigger;   //List of triggers that can be bypassed
    public static final String userRoleName;    //User Role Name
    public static final String userProfileName; //User Profile Name
    public static final Id     userProfileId;   //User Profile Id

    /************************************
        C.O.N.S.T.R.U.C.T.O.R.
    *************************************/  
    static {
        System.Debug('## >>> PAD constructor :BEGIN <<< run by ' + UserInfo.getName());
        User user = [SELECT BypassAppexTriggers__c, UserRole.Name, Profile.Name, Profile.Id  FROM User WHERE Id =:UserInfo.getUserId()];
        bypassTrigger = ';' + user.BypassAppexTriggers__c + ';';
        userRoleName= user.UserRole.Name;
        userProfileName = user.Profile.Name;
        userProfileId = user.Profile.Id;
        System.Debug('## >>> PAD constructor : END <<<');
    }

    /************************************
        M.E.T.H.O.D.S.
    *************************************/      
    public static boolean canTrigger(String apexName)
    {
        // Returns true or false whether the current user can bypass the class apexName 
        return(bypassTrigger.indexOf(';'+apexName+';') == -1);
    }
    
}