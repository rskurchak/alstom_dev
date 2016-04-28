/*
 AP61User apex class
   ~ Author          : Yamyle Merle-Rémond ~yamyle.merle-remond@axoa.fr 
    ~ Date Created    : 08/07/2014 
    ~ Description     : Apex Class 
                        - Validate User language for Alstom Internal User.
*/
public class AP61User {
    // context : User Before Update
    public static void validateUserLanguage(List<User> activeUsers)
    {
        System.debug('## >>> Starting AP61User.validateUserLanguage for ' + activeUsers.size() + ' users<<<');
        for(User userlanguage : activeUsers) {
            userlanguage.addError(System.label.LBL0246);
        } 
        System.debug('## >>> End AP61User.validateUserLanguage<<<');
    } 
}