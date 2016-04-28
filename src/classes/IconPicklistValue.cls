/*
 IconPicklistValue
	~ Author            : Adrian Modolea ~ adrian.modolea@axoa.fr
    ~ Date Created    	: 06/02/2012
    ~ Description     	: Apex class to define icons for the CCP08_IconPicklist component 
*/
public class IconPicklistValue 
{
	public String label			{get; set;}
	public String value			{get; set;}
	public String url			{get; set;}
	
	public IconPicklistValue(String label, String value, String url) {
		this.label = label;
		this.value = value;
		this.url = url;
	}
}