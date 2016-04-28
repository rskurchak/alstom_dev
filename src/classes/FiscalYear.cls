public with sharing class FiscalYear {
    public String name {get; set;}
    public Boolean current {get; set;}
    
    public FiscalYear(String name, Boolean current) {
        this.name = name;
        this.current = current;
    }
    
    public Integer hashCode() {
        return name.hashCode();
    }
    
    public Boolean equals(Object obj) {
        if (obj instanceof FiscalYear) {
            return name.equals(((FiscalYear) obj).name);
        }
        return false;
    }
}