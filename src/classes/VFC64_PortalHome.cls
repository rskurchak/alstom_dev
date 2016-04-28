/*
     VFC64_PortalHome
       ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
        ~ Date Created    : 17/04/2014 
        ~ Description     : Main Apex Class Base for Communities Portal Home Page components.
    */ 
    public with sharing class VFC64_PortalHome {
        private static String userId = UserInfo.getUserId();
        public User u {get;set;}
        public User uSales {get;set;}
        public String msg {get;set;}
        public String sPrefixStr {get;set;}
        public string strDoc{get;set;}
        public string strDocUrl{get;set;}
        public string MyTrainingSessionListViewURL {get;set;}
        public string MyInstalledBaseRSListViewURL {get;set;}
        public string MyNewsListViewURL {get;set;}
        public string MyTechnicalNewsListViewURL {get;set;}
        public string MyTipsAndTrainingNewsListViewURL {get;set;}
        public List<News__c> newsList {get;set;}

        public Account accWithImg {get;set;}
        
        public List<News__c> technewsList {get;set;}
        public List<News__c> tipsandTutorialsList {get;set;}
        public List<String> FieldList{get;set;} 

        public Map<String, List<SObject>> bulletinAlertMap {get;set;}
        public List<SObject> requestList {get;set;}

        public List<SObject> bulletinList {
            get {
                if( bulletinAlertMap != null ){
                    bulletinList = bulletinAlertMap.get( BulletinServices.BULLETIN_TYPE_BULLETIN );
                }
                return bulletinList;
            }
            set;
        }
        public List<SObject> alertList {
            get {
                if( bulletinAlertMap != null ){
                    alertList = bulletinAlertMap.get( BulletinServices.BULLETIN_TYPE_ALERT );
                }
                return alertList;
            }
            set;
        }

        public Boolean isBulletinAvailable {get;set;}
        public Boolean isCaseAvailable {get;set;}


        
        public List<Case> techrequestList {get;set;}
        public List<InstalledBaseRS__c> instBaseList {get;set;}
        public List<RecentlyViewed> MyDocumentsList {get;set;}
        public List<Case> testList {get;set;} 
        
        public VFC64_PortalHome() {   
            u = [Select ID, Name, LastName, FirstName, Title, SmallPhotoURL, FullPhotoURL, ContactId, CompanyName, Street, PostalCode, City, Country From User Where ID =: UserInfo.getUserID() Limit 1];
            User currUser = [Select ContactId, Contact.AccountId, Contact.OwnerID From User Where id =: u.Id];
            ID contactId = currUser.ContactId;
            ID ownerId = currUser.Contact.OwnerID;
            ID accountId = currUser.Contact.AccountId;

            accWithImg = accountId == null ? null : [SELECT Id, Portal_Home_Page_Img__c, Portal_Home_Page_Text__c FROM Account WHERE Id = : accountId];

            isBulletinAvailable = true;
            isCaseAvailable = true;
            if(contactId !=null){
                // Removing Account filter to also display child accounts installed base
                isBulletinAvailable = ![ SELECT Id FROM TileAssignment__c WHERE Account__c = :accountId AND PermissionSet__c = :TileService.TILE_PERMISSION_SET_BULLETINS ].isEmpty();
                isCaseAvailable = ![ SELECT Id FROM TileAssignment__c WHERE Account__c = :accountId AND PermissionSet__c = :TileService.TILE_PERMISSION_SET_REQUESTS ].isEmpty();
                instBaseList = [SELECT Id,Name,FleetPicture__c, NetworkLineCity__c, TechSupplierCurrentName__c, AlstomProductName__c FROM InstalledBaseRS__c where PortalDisplay__c = true order by Name asc LIMIT 100];
            }
            FieldList = New List<string>();
            String LanguageCodeUser =  '%(' + UserInfo.getLanguage().substring(0,2) + ')%';
            String LanguageCode = LanguageCodeUser != '%(fr)%' ? '%(en)%': LanguageCodeUser;

            newsList = [SELECT id, name, PublicationDate__c, Summary__c, Status__c, Type__c, Image__c, Text__c, Language__c FROM News__c where Type__c = :System.label.LBL0140 and Displayed__c = true and Language__c like :LanguageCodeUser order by PublicationDate__c desc Limit 100];
            technewsList = [SELECT id, name, PublicationDate__c, Summary__c, Image__c, Text__c, Language__c FROM News__c where Type__c = :System.label.LBL0141 and Displayed__c = true and Language__c like :LanguageCode order by PublicationDate__c desc  Limit 100];
            tipsandTutorialsList = [SELECT id, name, PublicationDate__c, Summary__c, Image__c, Text__c, Language__c FROM News__c where Type__c = :System.label.LBL0142 and Displayed__c = true and Language__c like :LanguageCode order by PublicationDate__c desc  Limit 100];

            // Checks if Bulletin__c object is available by PermissionSet for current user        
            if( isBulletinAvailable ) {
                bulletinAlertMap = BulletinServices.getAvailableBulletinsByTypes( ( contactId != null ? languageCode : null ) );
            }
            
            if( isCaseAvailable ){
                requestList = CaseServices.getAvailableCases();
            }
     
            techrequestList = [Select Id, Subject, CaseNumber, toLabel(Type), toLabel(Status), CreatedById, CreatedDate From Case Where Status != :System.label.LBL0170 and Status != :System.label.LBL0171 and Type = :System.label.LBL0204 and CreatedById =: UserInfo.getUserID() Order by CreatedDate Desc Limit 100];
            MyDocumentsList = [SELECT Id, type, Name, LastViewedDate FROM RecentlyViewed where Type = 'ContentDocument' order by LastViewedDate desc limit 3];
            if (contactId == null) {   
                instBaseList = [SELECT Id,Name,FleetPicture__c, NetworkLineCity__c, TechSupplierCurrentName__c, AlstomProductName__c FROM InstalledBaseRS__c where PortalDisplay__c = true order by Name asc LIMIT 100];
            } 
            List<Document> AlstomTrainingDoc = [SELECT Id,Name FROM Document WHERE Name Like :System.label.LBL0201 LIMIT 1];
            if (AlstomTrainingDoc.size()>0) {
                strDoc = '/servlet/servlet.FileDownload?file='+AlstomTrainingDoc[0].Id;
            }
            MyTrainingSessionListViewURL = System.label.LBL0209;
            MyNewsListViewURL = System.label.LBL0210;
            MyTechnicalNewsListViewURL = System.label.LBL0211;
            MyTipsAndTrainingNewsListViewURL = System.label.LBL0212;
            MyInstalledBaseRSListViewURL = System.label.LBL0213; 
        }

        public String getListViewURL(string ListViewName, string ObjectType){
            ApexPages.StandardSetController ts = new ApexPages.StandardSetController(Database.getQueryLocator('SELECT Name FROM ' + ObjectType + ' LIMIT 1'));
            Schema.DescribeSObjectResult tsSObjectSchema = ts.getRecord().getSObjectType().getDescribe();
            String objectIdPrefix = tsSObjectSchema.getKeyPrefix();
            String ListViewId;
            List<SelectOption> ListViews = ts.getListViewOptions();
            for(SelectOption w : ListViews ){
                if(w.getLabel()==ListViewName){
                    ListViewId = w.getValue().left(15);
                }
            }
            String ListViewURL = '/'+objectIdPrefix+'?fcf='+ListViewId;
            return ListViewURL;
        }
        
    }