public class Share {
	Id recordId;
	Id userId;
	Id shareId;
	String cause;
	String accessLevel;

	public Share( Id recordId, Id userId, String cause, String accessLevel, Id shareId ) {
		this.recordId = recordId;
		this.userId = userId;
		this.cause = cause;
		this.accessLevel = accessLevel;
		this.shareId = shareId;
	}

	public Boolean isCreated(){
		return this.shareId != null;
	}

	public Id getRecordId(){
		return this.recordId;
	}

	public Id getUserId(){
		return this.userId;
	}

	public String getRowCause(){
		if( this.cause != SharingFieldOptionsServices.CAUSE_VALUE_MANUAL ) { // Case RowCause is standard field without '__c'
			return this.cause + '__c';
		} else {
			return this.cause;
		}
	}

	public String getAccessLevel(){
		return this.accessLevel;
	}

	public Id getShareId(){
		return this.shareId;
	}
    
    public Integer hashCode() {
        String s = recordId;
        return s.hashCode();
    }


	public Boolean equals( Object shareReq ){
        if (shareReq instanceOf Share) {
            Share other = (Share) shareReq;
            return this.recordId != null && other != null &&
			   this.recordId == other.recordId && 
			   this.userId == other.userId &&
			   this.cause == other.cause &&
			   this.accessLevel == other.accessLevel &&
			   this.shareId == other.shareId ;
        }
        return false;
        
	}

}