/*
 AP04User apex class
   ~ Author          : Mohamed EL MOUSSAOUI ~ mohamed.el-moussaoui@axoa.fr 
    ~ Date Created    : 21/02/2013 
    ~ Description     : Apex Class 
                        - Auto-follow 'wallCom' user after user creation 
   ~ Author          : Yamyle MERLE-REMOND ~ ymerleremond@deloitte.fr 
    ~ Date Created    : 20/04/2015 
    ~ Description     : Apex Class 
                        - The @future sentence has been retired. Issues with automatic user creation 
                        through Alstom Employee Object.
*/
public class AP04User 
{
    // Auto-follow 'wallCom' user after user creation 
    // context : User After Insert
    
    //@future
    public static void autoFollow(Set<Id> activeUserIds)
    {
        System.debug('## >>> Starting AP04User.autoFollow for ' + activeUserIds.size() + ' users<<<');
        Id wallComUserId = System.Label.LBL0003;
        
        List<EntitySubscription> autoFollowSubscription2Insert = new List<EntitySubscription>(); 
        for(Id userId : activeUserIds)
            autoFollowSubscription2Insert.add(new EntitySubscription(ParentId=wallComUserId, SubscriberId=userId));
            
        if(autoFollowSubscription2Insert.size() > 0)
        {
            try
            {
                insert autoFollowSubscription2Insert;       
            }
            catch(DMLException e)
            {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
        }
        
        System.debug('## >>> End AP04User.autoFollow<<<');
    }
}