/*
 VFC70_PortalComponentPagination
   ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
    ~ Date Created    : 17/04/2014 
    ~ Description     : Generic controller to manage pagination of List Objects.
*/

public with sharing class VFC70_PortalComponentPagination {

public List<sObject> idList{get;set;}
public List<String> SobjFieldList{get;set;}
public Integer pagesize{get;set;}
public String relatedlistname{get;set;}

  
  Public ApexPages.StandardSetController setRecords{
    get{
     if(setRecords == null){
        setRecords = new ApexPages.StandardSetController(getIdListRecrds());
        setRecords.setPageSize(getPageSize());
     }  
      return setRecords;
    }set;
   }
   
   Public List<SObjectWrapper> getSObjectRecs(){
        List<SObjectWrapper> sObjList = New List<SObjectWrapper>();
        if(idList == null){ return sObjList; }
        for(sObject SObj :(List<sObject>)setRecords.getRecords())
        {
            sObjList.add(new SObjectWrapper(SObj,relatedlistname)); 
        }
        return sObjList;   
   }
   

   Public List<String> FieldList{
       get{
       List<String> FieldList = New List<string>();
       FieldList = getSobjtFieldList();
       return FieldList;
       }set;
   } 
   
    public List<sObject> getIdListRecrds() {
       List<sObject> IdListRecrds =idList;
       return IdListRecrds;
    }
    
    public List<string> getSobjtFieldList() {
       List<String> FieldList = SobjFieldList;
       return FieldList ;
    }

    public Integer getPagesize() {
       Integer pgsize = pagesize;
       return pgsize;
    }
    
    public string getrelatedlistname() {
       string relatedlist = relatedlistname;
       return relatedlist;
    }

    public class SObjectWrapper
    {
        public sObject sObjectRec {get;set;}
        public String longText {get;set;}
        public boolean isRead {get;set;}
        public string imageurl {get;set;}
        
        public SObjectWrapper(sObject so, string RelatedListName)
        {
            sObjectRec = so;
            
            // Case
            if (so.getSObjectType() == Case.sObjectType)
            {
                longText = '';
            }
            else if (so.getSObjectType() == InstalledBaseRS__c.sObjectType)
            {
              if (so.get('FleetPicture__c') != null)
              {
                imageurl = (String)so.get('FleetPicture__c');
                if (imageurl.lastIndexOf('/servlet')!=-1 ) 
                {                  
                  // Change for Winter15 : adding "support" of style instead of width
                  Integer lastpos = (imageurl.lastIndexOf('" style')!=-1 ? imageurl.lastIndexOf('" style') : imageurl.lastIndexOf('">'));

                  if (lastpos == -1)
                    lastpos = (imageurl.lastIndexOf('" width')!=-1 ? imageurl.lastIndexOf('" width') : imageurl.lastIndexOf('">'));

                  if (lastpos != -1)
                  {
                    imageurl = imageurl.substring(imageurl.lastIndexOf('/servlet'),lastpos).replace('&amp;','&');
                  }
                  imageurl = '<img src="' + imageurl + '" />';
                }
              }
            }
            else if (so.get('Text__c') != null)
            {
                Integer maxLength = Integer.valueOf(System.Label.LBL0192);
                
                longText = (String)so.get('Text__c');
                if (longText != null) {
                    longText = longText.replaceAll('<[^>]*>','');
                }
                if (longText.length() > maxLength)
                    longText = longText.substring(0, maxLength-3) + '...';
            }
            
            if (RelatedListName != '')
                isRead = (so.getSobjects(RelatedListName) != null); 
            
            if (so.getSObjectType() == News__c.sObjectType) {  
                if (so.get('Image__c') != null)
                {
                    imageurl = (String)so.get('Image__c');
                    if(imageurl.lastIndexOf('/servlet')!=-1 ){
                        Integer lastpos = (imageurl.lastIndexOf('" width')!=-1 ? imageurl.lastIndexOf('" width') : imageurl.lastIndexOf('">'));
                  // Change for Winter15 : adding "support" of style instead of width
                  lastpos = (imageurl.lastIndexOf('" style')!=-1 ? imageurl.lastIndexOf('" style') : imageurl.lastIndexOf('">'));
                        imageurl = imageurl.substring(imageurl.lastIndexOf('/servlet'),lastpos).replace('&amp;','&');
                    }
                } 
            }
        }
    }
}