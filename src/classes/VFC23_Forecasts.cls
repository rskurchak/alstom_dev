/*********************************************************************
 SANITY CHECK Feb. 2014 - CODE MODIFICATION REQUIRED
 Modify code following instructions below.
 Remove this box once modifications done.
*********************************************************************/

/*********************************************************************
 SANITY CHECK INSTRUCTION: 
   Add more comments
   Add more debug logs
 Remove this box once modification done.
*********************************************************************/

/*
 VFC23_Forecasts
    ~ Created By      : Fabien Taillon ~fabien.taillon@cgi.com
    ~ Date Created    : January 2013
    ~ Description     : Forecast tab
*/
/*
 FEAT#0552
    ~ Modified By     : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
    ~ Date Created    : 31/03/2014 
    ~ Description     : Change of Forecast Snapshot, instead of using Current Forecast Snapshot, we use now the Previous one.
*/
public with sharing class VFC23_Forecasts
{
    public static final String sellingPriceObjHeader = 'Forecasted SP';
    public static final String grossMarginObjHeader = 'FGM (%)';
    public static final Integer defaultOppQueryRecordLimit = 100;
    
    public transient list<list<opportunityLineWrapper>> opportunitiesFullList;
    
    public Integer oppQueryRecordLimit {get;set;}
    public TECH_Object__c oppParams {get;set;}
    public list<ForecastLineWrapper> forecastLines {get;set;}
    public list<selectOption> roleList {get;set;}
    public String selectedRole {get;set;}
    public list<selectOption> globalChildList {get;set;}
    public String selectedGlobalChild {get;set;}
    public map<Id, String> roleMap {get;set;}
    public boolean hasError {get;set;}
    public String forecastTableTitle {get;set;}
    public String selectedTab {get;set;}
    // Tab1
    public String quarterName1 {get;set;}
    public String quarterName2 {get;set;}
    public String quarterName3 {get;set;}
    public String quarterName4 {get;set;}
    // Tab 2
    public String quarterName2_1 {get;set;}
    public String quarterName2_2 {get;set;}
    public String quarterName2_3 {get;set;}
    public String quarterName2_4 {get;set;}
    public String quarterName2_5 {get;set;}
    public String quarterName2_6 {get;set;}
    public String yearName1 {get;set;}
    public String yearName2 {get;set;}
    public String yearName3 {get;set;}
    public String yearName4 {get;set;}
    public Id lastRoleCriteriaUsed {get;set;}
    public String lastProductLineCriteriaUsed {get;set;}
    public String lastPlatformCriteriaUsed {get;set;}
    public String lastRangeUsed {get;set;}
    public String lastForecastCategoryUsed {get;set;}
    public String lastOpportunityFilterUsed {get;set;}
    public String lastGlobalChildUsed {get;set;}
    public boolean opportunitiesTabFirstEnter {get; set;}
    public boolean noRoleFound {get; set;}
    public boolean noForecast {get; set;}
    public boolean noCurrentForecast {get; set;}
    private list<Id> rolesIds;
    private String leadingProductLineLabel;
    private String platformLabel;
    private String forecastCategoryLabel;
    private list<String> forecastCategoryList;
    
    public String oppFilterForecastCategory {get;set;}
    public String oppFilterPeriod {get;set;}
    public list<opportunityLineWrapper> opportunitiesList {get;set;}
    public boolean editMode {get;set;}
    public list<selectOption> quarterRangeList {get;set;}
    public String selectedQuarterRange {get;set;}
    public list<selectOption> yearRangeList {get;set;}
    public String selectedYearRange {get;set;}
    public list<selectOption> oppFilters {get;set;}
    public String selectedoppFilter {get;set;}
    public String opportunityTableTitle {get;set;}
    public String orderBy {get;set;}
    public String lastOpportunitiesQuery {get;set;}
    public String sortDirection {get;set;}
    public list<selectOption> forecastOptionList {get;set;}
    public String selectedForecast {get;set;}
    public Integer page {get;set;}
    public Integer numberOfOpportunities {get;set;}
    public Integer offset {get;set;}
    public boolean saveFailed {get;set;}
    
    public Datetime StartDateCurrentForecast {get;set;}
    
    public list<String> reportsList {get;set;}
    
    public Integer getOppQueryRecordLimit()
    {
        return oppQueryRecordLimit; 
    }
    
    public void initOppQueryRecordLimit()
    {
        // Reseting to default value in Case of missing or invalid value on User
        oppQueryRecordLimit = defaultOppQueryRecordLimit;
        
        for (User u : [Select ForecastOpportunityQueryRecordLimit__c from User where Id = :UserInfo.getUserId() Limit 1])
            if (u.ForecastOpportunityQueryRecordLimit__c != null 
                && (u.ForecastOpportunityQueryRecordLimit__c == 10
                    || u.ForecastOpportunityQueryRecordLimit__c == 25
                    || u.ForecastOpportunityQueryRecordLimit__c == 50
                    || u.ForecastOpportunityQueryRecordLimit__c == 100
                    || u.ForecastOpportunityQueryRecordLimit__c == 200))
                oppQueryRecordLimit = Integer.valueOf(u.ForecastOpportunityQueryRecordLimit__c);
    }
    
    public VFC23_Forecasts()
    {
        oppParams = new TECH_Object__c();
        forecastLines = new list<ForecastLineWrapper>();
        roleList = new list<selectOption>();
        globalChildList = new list<selectOption>();
        selectedGlobalChild = 'All';
        roleMap = new map<Id, String>();
        quarterRangeList = new list<selectOption>();
        selectedQuarterRange = '';
        yearRangeList = new list<selectOption>();
        selectedYearRange = '';
        oppFilters = new list<selectOption>();
        forecastOptionList = new list<selectOption>();
        selectedoppFilter = 'X-X';
        forecastCategoryList = new list<String>();
        hasError = false;
        selectedTab = 'forecastView';
        quarterName1 = '';
        quarterName2 = '';
        quarterName3 = '';
        quarterName4 = '';
        
        quarterName2_1 = '';
        quarterName2_2 = '';
        quarterName2_3 = '';
        quarterName2_4 = '';
        quarterName2_5 = '';
        quarterName2_6 = '';

        yearName1 = '';
        yearName2 = '';
        yearName3 = '';
        yearName4 = '';
        editMode = false;
        opportunityTableTitle = '';
        lastProductLineCriteriaUsed = '';
        lastPlatformCriteriaUsed = '';
        lastGlobalChildUsed = '';
        rolesIds = new list<Id>();
        lastOpportunitiesQuery = '';
        orderBy = 'AdjustedForecastCategory__c';
        sortDirection = 'asc';
        opportunitiesList = new list<opportunityLineWrapper>();
        opportunitiesTabFirstEnter = true;
        noRoleFound = false;
        noForecast = false;
        noCurrentForecast = false;
        reportsList = getReportList();
        page = 1;
        numberOfOpportunities = 0;
        offset = 0;
        initOppQueryRecordLimit();
        
        quarterRangeList.add(new selectOption('--None--', '--None--'));
        quarterRangeList.add(new selectOption('FQ1', 'FQ1'));
        quarterRangeList.add(new selectOption('FQ2', 'FQ2'));
        quarterRangeList.add(new selectOption('FQ3', 'FQ3'));
        quarterRangeList.add(new selectOption('FQ4', 'FQ4'));
        selectedQuarterRange = 'FQ1';
        
        globalChildList.add(new selectOption('All', 'All'));
        globalChildList.add(new selectOption('Global', 'Global'));
        globalChildList.add(new selectOption('Child', 'Child'));
        
        oppFilters.add(new selectOption('X-X', 'All Opportunities'));
        oppFilters.add(new selectOption('100000000-X', 'Opportunities > 100 M€'));
        oppFilters.add(new selectOption('1000000-X', 'Opportunities > 1 M€'));
        oppFilters.add(new selectOption('X-1000000', 'Opportunities < 1 M€'));
        // oppFilters.add(new selectOption('100000000-500000000', '100 M€ < Opportunities < 500 M€'));

        // Getting some Fields label
        leadingProductLineLabel = Schema.Opportunity.fields.LeadingProductLine__c.getDescribe().getLabel();
        platformLabel = Schema.Opportunity.fields.Platform__c.getDescribe().getLabel();
        forecastCategoryLabel = Schema.Opportunity.fields.AdjustedForecastCategory__c.getDescribe().getLabel();
        
        // Getting Forecast Categories 
        Schema.DescribeFieldResult fieldResult = Opportunity.AdjustedForecastCategory__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for (Schema.PicklistEntry f : ple)
        {
            forecastOptionList.add(new selectOption(f.getValue(), f.getValue()));

            // Removing 'Out Of Pipeline'
            if (f.getValue() != System.label.LBL0038)
                forecastCategoryList.add(f.getValue());
                
        }
        
        // Sorting in the right order for Visualforce Page display   
        list<String> forecastCategoryListSorted = new List<String>();
        for (integer i=forecastCategoryList.size()-1; i>=0; i--)
        {
            forecastCategoryListSorted.add(forecastCategoryList[i]);
        }
        forecastCategoryList.clear();
        forecastCategoryList.addAll(forecastCategoryListSorted);
            
        if (UserInfo.getUserRoleId() != null)
        {
            list<UserRole> listRoles = getSubordinatesUserRoles(UserInfo.getUserRoleId());
            listRoles.sort();
            
            Set<Id> userRoleLeavesIds = new Set<Id>();
            for (UserRole ur : getUserRoleLeaves())
                userRoleLeavesIds.add(ur.Id);
                
            // Init Role Pickist
            for (UserRole ur : listRoles)
            {
                // Added only if it's not a leaf role
                if (!userRoleLeavesIds.contains(ur.Id) || ur.Id == UserInfo.getUserRoleId())
                {
                    roleList.add(new selectOption(ur.Id, ur.Name));
                    roleMap.put(ur.Id, ur.Name);
                }
            }
            
            selectedRole = UserInfo.getUserRoleId();
            lastRoleCriteriaUsed = selectedRole;
            
            // Populate Forecast Table
            populateForecastLinesForRoles(listRoles);
        }
        else
        {
            noRoleFound = true;
        }
    }
    
    public void refreshForecastList()
    {
        hasError = false;
        noForecast = false;
        noCurrentForecast = false;
        list<UserRole> rList = getSubordinatesUserRoles(selectedRole);
        populateForecastLinesForRoles(rList);
    }
    
    private list<UserRole> getSubordinatesUserRoles(Id userRoleId)    
    {
        list<UserRole> listRoles = new list<UserRole>();
        
        if (userRoleId != null)
        {
            // Adding the current role of the user
            UserRole u = [SELECT Id, Name FROM UserRole WHERE Id = :userRoleId LIMIT 1];
            listRoles.add(u);
            
            list<Id> idParam = new list<Id>();
            idParam.add(userRoleId);

            listRoles.addAll(getRecursiveRolesHierarchy(idParam));
        }
        else
        {
            noRoleFound = true;
        }
        
        return listRoles;
    }
    
    private list<UserRole> getRecursiveRolesHierarchy(list<Id> parentRoleId)    
    {
        list<Id> idsParam = new list<Id>();
        
        list<UserRole> uRole = [SELECT Id, Name FROM UserRole WHERE ParentRoleId IN :parentRoleId];
        for (UserRole ur : uRole)
            idsParam.add(ur.Id);
        
        if (idsParam.size() > 0)    
            uRole.addAll(getRecursiveRolesHierarchy(idsParam));
        
        return uRole;
    }
    
    private List<UserRole> getUserRoleLeaves()    
    {
        list<Id> parentRolesIds = new list<Id>();
        for (UserRole u : [SELECT ParentRoleId FROM UserRole])
            parentRolesIds.add(u.ParentRoleId);
            
        list<UserRole> leavesIds = [SELECT Id FROM UserRole WHERE Id NOT IN :parentRolesIds];

        return leavesIds;
    }
    
    private void populateForecastLinesForRoles(list<UserRole> roles)    
    {
        forecastLines.clear();
        rolesIds.clear();
        
        for (UserRole u : roles)
            rolesIds.add(u.Id);
                
        list<Forecast_Snapshot__c> currentFS = [Select Id, Snapshot_Start_Quarter__c from Forecast_Snapshot__c where Current__c = true LIMIT 1];
        //FEAT#0552
        list<Forecast_Snapshot__c> previousFS = [Select Id, Snapshot_Start_Quarter__c from Forecast_Snapshot__c where Previous__c = true LIMIT 1];
        
        //if (currentFS.size() > 0 && currentFS.get(0).Snapshot_Start_Quarter__c != null && currentFS.get(0).Snapshot_Start_Quarter__c != '')
        if (currentFS.size() > 0 && currentFS.get(0).Snapshot_Start_Quarter__c != null && currentFS.get(0).Snapshot_Start_Quarter__c != '')
        {
            calculatePeriods(currentFS.get(0).Snapshot_Start_Quarter__c);
            StartDateCurrentForecast = CalculateStartDateQuarter(currentFS.get(0).Snapshot_Start_Quarter__c);
            
            /********** AggregateResult for Snapshot (Sales Objectives) --> Won + Commitment **********/ 
            AggregateResult[] aggregateSalesObjectives;
            AggregateResult[] aggregateCurrentSalesObjectives;
            list<String> categoriesForSalesObjectives = new list<String>();
            categoriesForSalesObjectives.add(System.label.LBL0039);
            categoriesForSalesObjectives.add(System.label.LBL0040);
            
            /********** AggregateResult for Opportunities --> All except Out Of Pipeline **********/ 
            AggregateResult[] aggregateForecastOpp;
            
            //Id forecastSnapshotId = currentFS.get(0).Id;
            Id forecastSnapshotId;
            if (previousFS.size() > 0 && previousFS.get(0).Snapshot_Start_Quarter__c != null && previousFS.get(0).Snapshot_Start_Quarter__c != '')
                forecastSnapshotId = previousFS.get(0).Id;
            if (forecastSnapshotId != null)
                system.debug('test not null');
            else
                system.debug('test null');
            
                
            Id CurrentforecastSnapshotId = currentFS.get(0).Id;
                        
            lastRoleCriteriaUsed = selectedRole;
            lastProductLineCriteriaUsed = oppParams.LeadingProductLine__c;
            lastPlatformCriteriaUsed = oppParams.Platform__c;
        
            if (oppParams.LeadingProductLine__c != null && oppParams.Platform__c != null)
            {
                forecastTableTitle = 'Following Forecast is for Role: <b>'+roleMap.get(selectedRole)+'</b>, '+leadingProductLineLabel+': <b>'+oppParams.LeadingProductLine__c+'</b> and '+platformLabel+': <b>'+oppParams.Platform__c+'</b>';
                
                list<String> listeIdString = new list<String>();
                for(User u : [SELECT Id FROM User WHERE UserRoleId IN :rolesIds])
                    listeIdString.add(u.Id);
                if (forecastSnapshotId != null)
                    aggregateSalesObjectives = [SELECT ForecastedFiscalPeriodRef__c, SUM(AdjustedSellingPrice__c) sellPrice, SUM(TECH_SellingPriceXGrossMargin__c) sellPriceXGrossMargin
                                                FROM Opportunity_Snapshot__c 
                                                WHERE Forecast_Snapshot__c = :forecastSnapshotId 
                                                AND AdjustedForecastCategory__c IN :categoriesForSalesObjectives
                                                AND LeadingProductLine__c = :oppParams.LeadingProductLine__c
                                                AND Platform__c = :oppParams.Platform__c
                                                AND OpportunityOwnerRef__c IN :listeIdString
                                                GROUP BY ForecastedFiscalPeriodRef__c];
                
                aggregateCurrentSalesObjectives = [SELECT ForecastedFiscalPeriodRef__c, SUM(AdjustedSellingPrice__c) sellPrice, SUM(TECH_SellingPriceXGrossMargin__c) sellPriceXGrossMargin
                                            FROM Opportunity_Snapshot__c 
                                            WHERE Forecast_Snapshot__c = :CurrentforecastSnapshotId 
                                            AND AdjustedForecastCategory__c IN :categoriesForSalesObjectives
                                            AND LeadingProductLine__c = :oppParams.LeadingProductLine__c
                                            AND Platform__c = :oppParams.Platform__c
                                            AND OpportunityOwnerRef__c IN :listeIdString
                                            GROUP BY ForecastedFiscalPeriodRef__c];
/*********************************************************************
 SANITY CHECK INSTRUCTION: 
   Query aggregateForecastOpp
   In criteria, replace     
      AND OwnerId IN (SELECT Id FROM User WHERE UserRoleId IN :rolesIds)
          by
      Owner.UserRoleId IN
   => will decrease number of SOQL query and is more efficient.
 Remove this box once modification done.
*********************************************************************/                                    
                aggregateForecastOpp = [SELECT AdjustedForecastCategory__c, TECH_FiscalPeriod__c, SUM(AdjustedSellingPrice__c) sellPrice, SUM(TECH_SellingPriceXGrossMargin__c) sellPriceXGrossMargin
                                        FROM Opportunity
                                        WHERE AdjustedForecastCategory__c != :System.label.LBL0038
                                        AND LeadingProductLine__c = :oppParams.LeadingProductLine__c
                                        AND Platform__c = :oppParams.Platform__c
                                        AND OwnerId IN (SELECT Id FROM User WHERE UserRoleId IN :rolesIds)
                                        GROUP BY AdjustedForecastCategory__c, TECH_FiscalPeriod__c];
            }
            else if (oppParams.LeadingProductLine__c != null)
            {
                forecastTableTitle = 'Following Forecast is for Role: <b>'+roleMap.get(selectedRole)+'</b> and '+leadingProductLineLabel+': <b>'+oppParams.LeadingProductLine__c+'</b>';
                
                list<String> listeIdString = new list<String>();
                for(User u : [SELECT Id FROM User WHERE UserRoleId IN :rolesIds])
                    listeIdString.add(u.Id);
                    
                if (forecastSnapshotId != null)
                    aggregateSalesObjectives = [SELECT ForecastedFiscalPeriodRef__c, SUM(AdjustedSellingPrice__c) sellPrice, SUM(TECH_SellingPriceXGrossMargin__c) sellPriceXGrossMargin
                                                FROM Opportunity_Snapshot__c 
                                                WHERE Forecast_Snapshot__c = :forecastSnapshotId 
                                                AND AdjustedForecastCategory__c IN :categoriesForSalesObjectives
                                                AND LeadingProductLine__c = :oppParams.LeadingProductLine__c
                                                AND OpportunityOwnerRef__c IN :listeIdString
                                                GROUP BY ForecastedFiscalPeriodRef__c];

                aggregateCurrentSalesObjectives = [SELECT ForecastedFiscalPeriodRef__c, SUM(AdjustedSellingPrice__c) sellPrice, SUM(TECH_SellingPriceXGrossMargin__c) sellPriceXGrossMargin
                                            FROM Opportunity_Snapshot__c 
                                            WHERE Forecast_Snapshot__c = :CurrentforecastSnapshotId 
                                            AND AdjustedForecastCategory__c IN :categoriesForSalesObjectives
                                            AND LeadingProductLine__c = :oppParams.LeadingProductLine__c
                                            AND OpportunityOwnerRef__c IN :listeIdString
                                            GROUP BY ForecastedFiscalPeriodRef__c];
                
                // TODO : critere date                                     
                aggregateForecastOpp = [SELECT AdjustedForecastCategory__c, TECH_FiscalPeriod__c, SUM(AdjustedSellingPrice__c) sellPrice, SUM(TECH_SellingPriceXGrossMargin__c) sellPriceXGrossMargin
                                        FROM Opportunity
                                        WHERE AdjustedForecastCategory__c != :System.label.LBL0038
                                        AND LeadingProductLine__c = :oppParams.LeadingProductLine__c
                                        AND OwnerId IN (SELECT Id FROM User WHERE UserRoleId IN :rolesIds)
                                        GROUP BY AdjustedForecastCategory__c, TECH_FiscalPeriod__c];
            }
            else
            {
                // LeadingProductLine__c and Platform__c are dependent, so last case is when both are empty
                forecastTableTitle = 'Following Forecast is for Role: <b>'+roleMap.get(selectedRole)+'</b>';
                
                list<String> listeIdString = new list<String>();
                for(User u : [SELECT Id FROM User WHERE UserRoleId IN :rolesIds])
                    listeIdString.add(u.Id);
                if (forecastSnapshotId != null)
                    aggregateSalesObjectives = [SELECT ForecastedFiscalPeriodRef__c, SUM(AdjustedSellingPrice__c) sellPrice, SUM(TECH_SellingPriceXGrossMargin__c) sellPriceXGrossMargin
                                                FROM Opportunity_Snapshot__c 
                                                WHERE Forecast_Snapshot__c = :forecastSnapshotId 
                                                AND AdjustedForecastCategory__c IN :categoriesForSalesObjectives
                                                AND OpportunityOwnerRef__c IN :listeIdString
                                                GROUP BY ForecastedFiscalPeriodRef__c];

                aggregateCurrentSalesObjectives = [SELECT ForecastedFiscalPeriodRef__c, SUM(AdjustedSellingPrice__c) sellPrice, SUM(TECH_SellingPriceXGrossMargin__c) sellPriceXGrossMargin
                                            FROM Opportunity_Snapshot__c 
                                            WHERE Forecast_Snapshot__c = :CurrentforecastSnapshotId 
                                            AND AdjustedForecastCategory__c IN :categoriesForSalesObjectives
                                            AND OpportunityOwnerRef__c IN :listeIdString
                                            GROUP BY ForecastedFiscalPeriodRef__c];
                                            
                // TODO : critere date                                     
                aggregateForecastOpp = [SELECT AdjustedForecastCategory__c, TECH_FiscalPeriod__c, SUM(AdjustedSellingPrice__c) sellPrice, SUM(TECH_SellingPriceXGrossMargin__c) sellPriceXGrossMargin
                                        FROM Opportunity 
                                        WHERE AdjustedForecastCategory__c != :System.label.LBL0038
                                        AND OwnerId IN (SELECT Id FROM User WHERE UserRoleId IN :rolesIds)
                                        GROUP BY AdjustedForecastCategory__c, TECH_FiscalPeriod__c];
            }
            //if (aggregateSalesObjectives.size() > 0 || aggregateForecastOpp.size() > 0)
            if (aggregateSalesObjectives != null || aggregateForecastOpp.size() > 0)
            {
                /********** Sales Objectives **********/ 
                // A map with the cell Key : ForecastCategory+fiscalPeriod
                map<String, Decimal> fiscalPeriodSalesObjMap = new map<String, Decimal>();
                map<String, Decimal> fiscalPeriodSalesObjYearMap = new map<String, Decimal>();
                map<String, Integer> fiscalPeriodSalesObjGrossMarginMap = new map<String, Integer>();
                
                if (aggregateSalesObjectives != null)
                    for (AggregateResult ar : aggregateSalesObjectives)
                    {
                        fiscalPeriodSalesObjMap.put(String.valueOf(ar.get('ForecastedFiscalPeriodRef__c')), (Decimal)(ar.get('sellPrice')));
                        system.debug('values: ' + String.valueOf(ar.get('ForecastedFiscalPeriodRef__c')) + '---' + (Decimal)(ar.get('sellPrice')));
                        if (Integer.valueOf(ar.get('sellPrice')) != null && Integer.valueOf(ar.get('sellPrice')) != 0)
                        {
                            Decimal sellPriceGM = 0;
                            if (Integer.valueOf(ar.get('sellPriceXGrossMargin')) != null)
                                sellPriceGM = (Decimal)(ar.get('sellPriceXGrossMargin'));
                            fiscalPeriodSalesObjGrossMarginMap.put(String.valueOf(ar.get('ForecastedFiscalPeriodRef__c')), (Integer)(sellPriceGM*100 / (Decimal)(ar.get('sellPrice'))));    
                        }
                        else
                            fiscalPeriodSalesObjGrossMarginMap.put(String.valueOf(ar.get('ForecastedFiscalPeriodRef__c')), 0);
                        
                        String fiscalYearPeriod = String.valueOf(ar.get('ForecastedFiscalPeriodRef__c'));
                        if (fiscalYearPeriod != null && fiscalYearPeriod.length() == 14) // FEAT#0501 changed 18 to 14
                        {
                            String keyYear = String.valueOf(ar.get('ForecastedFiscalPeriodRef__c')).substring(6, 14); // FEAT#0501 changed 18 to 14
                            if (fiscalPeriodSalesObjYearMap.get(keyYear) != null)
                                fiscalPeriodSalesObjYearMap.put(keyYear, fiscalPeriodSalesObjYearMap.get(keyYear) + (Decimal)(ar.get('sellPrice')));
                            else
                                fiscalPeriodSalesObjYearMap.put(keyYear, (Decimal)(ar.get('sellPrice')));
                        }
                    }
                
                // A map with the cell Key : ForecastCategory+fiscalPeriod, CURRENT !!!
                map<String, Decimal> fiscalPeriodSalesObjMapCurrent = new map<String, Decimal>();
                map<String, Decimal> fiscalPeriodSalesObjYearMapCurrent = new map<String, Decimal>();
                map<String, Integer> fiscalPeriodSalesObjGrossMarginMapCurrent = new map<String, Integer>();
                for (AggregateResult arC : aggregateCurrentSalesObjectives)
                {
                    fiscalPeriodSalesObjMapCurrent.put(String.valueOf(arC.get('ForecastedFiscalPeriodRef__c')), (Decimal)(arC.get('sellPrice')));
                    if (Integer.valueOf(arC.get('sellPrice')) != null && Integer.valueOf(arC.get('sellPrice')) != 0)
                    {
                        Decimal sellPriceGM = 0;
                        if (Integer.valueOf(arC.get('sellPriceXGrossMargin')) != null)
                            sellPriceGM = (Decimal)(arC.get('sellPriceXGrossMargin'));
                        fiscalPeriodSalesObjGrossMarginMapCurrent.put(String.valueOf(arC.get('ForecastedFiscalPeriodRef__c')), (Integer)(sellPriceGM*100 / (Decimal)(arC.get('sellPrice'))));    
                    }
                    else
                        fiscalPeriodSalesObjGrossMarginMapCurrent.put(String.valueOf(arC.get('ForecastedFiscalPeriodRef__c')), 0);
                    
                    String fiscalYearPeriod = String.valueOf(arC.get('ForecastedFiscalPeriodRef__c'));
                    if (fiscalYearPeriod != null && fiscalYearPeriod.length() == 14) // FEAT#0501 changed 18 to 14
                    {
                        String keyYear = String.valueOf(arC.get('ForecastedFiscalPeriodRef__c')).substring(6, 14); // FEAT#0501 changed 18 to 14
                        if (fiscalPeriodSalesObjYearMapCurrent.get(keyYear) != null)
                            fiscalPeriodSalesObjYearMapCurrent.put(keyYear, fiscalPeriodSalesObjYearMapCurrent.get(keyYear) + (Decimal)(arC.get('sellPrice')));
                        else
                            fiscalPeriodSalesObjYearMapCurrent.put(keyYear, (Decimal)(arC.get('sellPrice')));
                    }
                }

                // Setting 0 for potential missing cell values
                Decimal quarter1 = (fiscalPeriodSalesObjMap.get(quarterName1)!=null)?fiscalPeriodSalesObjMap.get(quarterName1):0;
                Decimal quarter2 = (fiscalPeriodSalesObjMap.get(quarterName2)!=null)?fiscalPeriodSalesObjMap.get(quarterName2):0;
                Decimal quarter3 = (fiscalPeriodSalesObjMap.get(quarterName3)!=null)?fiscalPeriodSalesObjMap.get(quarterName3):0;
                Decimal quarter4 = (fiscalPeriodSalesObjMap.get(quarterName4)!=null)?fiscalPeriodSalesObjMap.get(quarterName4):0;
                
                //FEAT#0552
                /*
                Decimal quarter2_1 = (fiscalPeriodSalesObjMap.get(quarterName2_1)!=null)?fiscalPeriodSalesObjMap.get(quarterName2_1):0;
                Decimal quarter2_1GM = (fiscalPeriodSalesObjGrossMarginMap.get(quarterName2_1)!=null)?fiscalPeriodSalesObjGrossMarginMap.get(quarterName2_1):0;
                Decimal quarter2_2 = (fiscalPeriodSalesObjMap.get(quarterName2_2)!=null)?fiscalPeriodSalesObjMap.get(quarterName2_2):0;
                Decimal quarter2_2GM = (fiscalPeriodSalesObjGrossMarginMap.get(quarterName2_2)!=null)?fiscalPeriodSalesObjGrossMarginMap.get(quarterName2_2):0;
                Decimal quarter2_3 = (fiscalPeriodSalesObjMap.get(quarterName2_3)!=null)?fiscalPeriodSalesObjMap.get(quarterName2_3):0;
                Decimal quarter2_3GM = (fiscalPeriodSalesObjGrossMarginMap.get(quarterName2_3)!=null)?fiscalPeriodSalesObjGrossMarginMap.get(quarterName2_3):0;
                Decimal quarter2_4 = (fiscalPeriodSalesObjMap.get(quarterName2_4)!=null)?fiscalPeriodSalesObjMap.get(quarterName2_4):0;
                Decimal quarter2_4GM = (fiscalPeriodSalesObjGrossMarginMap.get(quarterName2_4)!=null)?fiscalPeriodSalesObjGrossMarginMap.get(quarterName2_4):0;
                Decimal quarter2_5 = (fiscalPeriodSalesObjMap.get(quarterName2_5)!=null)?fiscalPeriodSalesObjMap.get(quarterName2_5):0;
                Decimal quarter2_5GM = (fiscalPeriodSalesObjGrossMarginMap.get(quarterName2_5)!=null)?fiscalPeriodSalesObjGrossMarginMap.get(quarterName2_5):0;
                Decimal quarter2_6 = (fiscalPeriodSalesObjMap.get(quarterName2_6)!=null)?fiscalPeriodSalesObjMap.get(quarterName2_6):0;
                Decimal quarter2_6GM = (fiscalPeriodSalesObjGrossMarginMap.get(quarterName2_6)!=null)?fiscalPeriodSalesObjGrossMarginMap.get(quarterName2_6):0;
                */
                
                Decimal quarter2_1, quarter2_1GM, quarter2_2, quarter2_2GM, quarter2_3, quarter2_3GM, quarter2_4, quarter2_4GM, quarter2_5, quarter2_5GM, quarter2_6, quarter2_6GM;

                if (CalculateStartDateQuarter(quarterName2_1)< StartDateCurrentForecast){
                    quarter2_1 = (fiscalPeriodSalesObjMap.get(quarterName2_1)!=null)?fiscalPeriodSalesObjMap.get(quarterName2_1):0;
                    quarter2_1GM = (fiscalPeriodSalesObjGrossMarginMap.get(quarterName2_1)!=null)?fiscalPeriodSalesObjGrossMarginMap.get(quarterName2_1):0;
                }else{
                    quarter2_1 = (fiscalPeriodSalesObjMapCurrent.get(quarterName2_1)!=null)?fiscalPeriodSalesObjMapCurrent.get(quarterName2_1):0;
                    quarter2_1GM = (fiscalPeriodSalesObjGrossMarginMapCurrent.get(quarterName2_1)!=null)?fiscalPeriodSalesObjGrossMarginMapCurrent.get(quarterName2_1):0;
                }
                if (CalculateStartDateQuarter(quarterName2_2)< StartDateCurrentForecast){
                    quarter2_2 = (fiscalPeriodSalesObjMap.get(quarterName2_2)!=null)?fiscalPeriodSalesObjMap.get(quarterName2_2):0;
                    quarter2_2GM = (fiscalPeriodSalesObjGrossMarginMap.get(quarterName2_2)!=null)?fiscalPeriodSalesObjGrossMarginMap.get(quarterName2_2):0;
                }else{
                    quarter2_2 = (fiscalPeriodSalesObjMapCurrent.get(quarterName2_2)!=null)?fiscalPeriodSalesObjMapCurrent.get(quarterName2_2):0;
                    quarter2_2GM = (fiscalPeriodSalesObjGrossMarginMapCurrent.get(quarterName2_2)!=null)?fiscalPeriodSalesObjGrossMarginMapCurrent.get(quarterName2_2):0;
                }
                if (CalculateStartDateQuarter(quarterName2_3)< StartDateCurrentForecast){
                    quarter2_3 = (fiscalPeriodSalesObjMap.get(quarterName2_3)!=null)?fiscalPeriodSalesObjMap.get(quarterName2_3):0;
                    quarter2_3GM = (fiscalPeriodSalesObjGrossMarginMap.get(quarterName2_3)!=null)?fiscalPeriodSalesObjGrossMarginMap.get(quarterName2_3):0;
                }else{
                    quarter2_3 = (fiscalPeriodSalesObjMapCurrent.get(quarterName2_3)!=null)?fiscalPeriodSalesObjMapCurrent.get(quarterName2_3):0;
                    quarter2_3GM = (fiscalPeriodSalesObjGrossMarginMapCurrent.get(quarterName2_3)!=null)?fiscalPeriodSalesObjGrossMarginMapCurrent.get(quarterName2_3):0;
                }
                if (CalculateStartDateQuarter(quarterName2_4)< StartDateCurrentForecast){
                    quarter2_4 = (fiscalPeriodSalesObjMap.get(quarterName2_4)!=null)?fiscalPeriodSalesObjMap.get(quarterName2_4):0;
                    quarter2_4GM = (fiscalPeriodSalesObjGrossMarginMap.get(quarterName2_4)!=null)?fiscalPeriodSalesObjGrossMarginMap.get(quarterName2_4):0;
                }else{
                    quarter2_4 = (fiscalPeriodSalesObjMapCurrent.get(quarterName2_4)!=null)?fiscalPeriodSalesObjMapCurrent.get(quarterName2_4):0;
                    quarter2_4GM = (fiscalPeriodSalesObjGrossMarginMapCurrent.get(quarterName2_4)!=null)?fiscalPeriodSalesObjGrossMarginMapCurrent.get(quarterName2_4):0;
                }
                if (CalculateStartDateQuarter(quarterName2_5)< StartDateCurrentForecast){
                    quarter2_5 = (fiscalPeriodSalesObjMap.get(quarterName2_5)!=null)?fiscalPeriodSalesObjMap.get(quarterName2_5):0;
                    quarter2_5GM = (fiscalPeriodSalesObjGrossMarginMap.get(quarterName2_5)!=null)?fiscalPeriodSalesObjGrossMarginMap.get(quarterName2_5):0;
                 }else{
                    quarter2_5 = (fiscalPeriodSalesObjMapCurrent.get(quarterName2_5)!=null)?fiscalPeriodSalesObjMapCurrent.get(quarterName2_5):0;
                    quarter2_5GM = (fiscalPeriodSalesObjGrossMarginMapCurrent.get(quarterName2_5)!=null)?fiscalPeriodSalesObjGrossMarginMapCurrent.get(quarterName2_5):0;
                }
                if (CalculateStartDateQuarter(quarterName2_6)< StartDateCurrentForecast){
                    quarter2_6 = (fiscalPeriodSalesObjMap.get(quarterName2_6)!=null)?fiscalPeriodSalesObjMap.get(quarterName2_6):0;
                    quarter2_6GM = (fiscalPeriodSalesObjGrossMarginMap.get(quarterName2_6)!=null)?fiscalPeriodSalesObjGrossMarginMap.get(quarterName2_6):0;
                }else{
                    quarter2_6 = (fiscalPeriodSalesObjMapCurrent.get(quarterName2_6)!=null)?fiscalPeriodSalesObjMapCurrent.get(quarterName2_6):0;
                    quarter2_6GM = (fiscalPeriodSalesObjGrossMarginMapCurrent.get(quarterName2_6)!=null)?fiscalPeriodSalesObjGrossMarginMapCurrent.get(quarterName2_6):0;
                }

                Decimal year1 = (fiscalPeriodSalesObjYearMap.get(yearName1)!=null)?fiscalPeriodSalesObjYearMap.get(yearName1):0;
                //FEAT#0552
                /*
                Decimal year2 = (fiscalPeriodSalesObjYearMap.get(yearName2)!=null)?fiscalPeriodSalesObjYearMap.get(yearName2):0;
                Decimal year3 = (fiscalPeriodSalesObjYearMap.get(yearName3)!=null)?fiscalPeriodSalesObjYearMap.get(yearName3):0;
                Decimal year4 = (fiscalPeriodSalesObjYearMap.get(yearName4)!=null)?fiscalPeriodSalesObjYearMap.get(yearName4):0;
                */
                Decimal year2 = (fiscalPeriodSalesObjYearMapCurrent.get(yearName2)!=null)?fiscalPeriodSalesObjYearMapCurrent.get(yearName2):0;
                Decimal year3 = (fiscalPeriodSalesObjYearMapCurrent.get(yearName3)!=null)?fiscalPeriodSalesObjYearMapCurrent.get(yearName3):0;
                Decimal year4 = (fiscalPeriodSalesObjYearMapCurrent.get(yearName4)!=null)?fiscalPeriodSalesObjYearMapCurrent.get(yearName4):0;

                forecastLines.add(new ForecastLineWrapper('', sellingPriceObjHeader, sellingPriceObjHeader, sellingPriceObjHeader, sellingPriceObjHeader, sellingPriceObjHeader, grossMarginObjHeader, sellingPriceObjHeader, grossMarginObjHeader, sellingPriceObjHeader, grossMarginObjHeader, sellingPriceObjHeader, grossMarginObjHeader, sellingPriceObjHeader, grossMarginObjHeader, sellingPriceObjHeader, grossMarginObjHeader, sellingPriceObjHeader, grossMarginObjHeader, sellingPriceObjHeader, grossMarginObjHeader));
                forecastLines.add(new ForecastLineWrapper('Orders Objectives', quarter1.format()+' €', quarter2.format()+' €', quarter3.format()+' €', quarter4.format()+' €', quarter2_1.format()+' €', quarter2_1GM.format()+' %', quarter2_2.format()+' €', quarter2_2GM.format()+' %', quarter2_3.format()+' €', quarter2_3GM.format()+' %', quarter2_4.format()+' €', quarter2_4GM.format()+' %', quarter2_5.format()+' €', quarter2_5GM.format()+' %', quarter2_6.format()+' €', quarter2_6GM.format()+' %', year1.format()+' €', year2.format()+' €', year3.format()+' €', year4.format()+' €'));
                
                 
                /********** AggregateResult for Opportunities **********/ 
                // A map with the cell Key : ForecastCategory+fiscalPeriod
                map<String, Decimal> fiscalPeriodForecastMap = new map<String, Decimal>();
                map<String, Decimal> fiscalPeriodForecastYearMap = new map<String, Decimal>();
                map<String, Decimal> fiscalPeriodForecastGrossMarginMap = new map<String, Decimal>();
                for (AggregateResult ar : aggregateForecastOpp)
                {
                    //System.debug('####### AdjustedForecastCategory__c : '+ar.get('AdjustedForecastCategory__c'));
                    //System.debug('####### TECH_FiscalPeriod__c : '+ar.get('TECH_FiscalPeriod__c'));
                    //System.debug('####### sellPrice : '+ar.get('sellPrice'));
                    //System.debug('####### sellPriceXGrossMargin : '+ar.get('sellPriceXGrossMargin'));
                    
                    String key = String.valueOf(ar.get('AdjustedForecastCategory__c')) + String.valueOf(ar.get('TECH_FiscalPeriod__c'));
                    fiscalPeriodForecastMap.put(key, (Decimal)(ar.get('sellPrice')));
                    
                    if (Integer.valueOf(ar.get('sellPrice')) != null && Integer.valueOf(ar.get('sellPrice')) != 0)
                    {
                        Decimal sellPriceGM = 0;
                        if (Integer.valueOf(ar.get('sellPriceXGrossMargin')) != null)
                            sellPriceGM = (Decimal)(ar.get('sellPriceXGrossMargin'));
                        
                        fiscalPeriodForecastGrossMarginMap.put(key, sellPriceGM*100);   
                        //fiscalPeriodForecastGrossMarginMap.put(key, (Integer)(sellPriceGM*100 / (Decimal)(ar.get('sellPrice'))));
                    }
                    else
                        fiscalPeriodForecastGrossMarginMap.put(key, 0);
                    
                    String fiscalYearPeriod = String.valueOf(ar.get('TECH_FiscalPeriod__c'));
                    if (fiscalYearPeriod != null && fiscalYearPeriod.length() == 14) // FEAT#0501 changed 18 to 14
                    {
                        String keyYear = String.valueOf(ar.get('AdjustedForecastCategory__c')) + String.valueOf(ar.get('TECH_FiscalPeriod__c')).substring(6, 14); // FEAT#0501 changed 18 to 14
                        if (fiscalPeriodForecastYearMap.get(keyYear) != null && ar.get('sellPrice') != null)
                            fiscalPeriodForecastYearMap.put(keyYear, fiscalPeriodForecastYearMap.get(keyYear) + (Decimal)(ar.get('sellPrice')));
                        else
                            fiscalPeriodForecastYearMap.put(keyYear, (Decimal)(ar.get('sellPrice')));
                    }
                }
                
                quarter1 = 0;
                quarter2 = 0;
                quarter3 = 0;
                quarter4 = 0;
                
                quarter2_1 = 0;
                quarter2_1GM = 0;
                quarter2_2 = 0;
                quarter2_2GM = 0;
                quarter2_3 = 0;
                quarter2_3GM = 0;
                quarter2_4 = 0;
                quarter2_4GM = 0;
                quarter2_5 = 0;
                quarter2_5GM = 0;
                quarter2_6 = 0;
                quarter2_6GM = 0;
                
                year1 = 0;
                year2 = 0;
                year3 = 0;
                year4 = 0;
                
                Decimal quarter2_1SellPriceXGM = 0;
                Decimal quarter2_2SellPriceXGM = 0;
                Decimal quarter2_3SellPriceXGM = 0;
                Decimal quarter2_4SellPriceXGM = 0;
                Decimal quarter2_5SellPriceXGM = 0;
                Decimal quarter2_6SellPriceXGM = 0;
                
                for (String cat : forecastCategoryList)
                {
                    // Setting 0 for potential missing cell values
                    quarter1 = quarter1 + ((fiscalPeriodForecastMap.get(cat+quarterName1)!= null)?fiscalPeriodForecastMap.get(cat+quarterName1):0);
                    
                    quarter2 = quarter2 + ((fiscalPeriodForecastMap.get(cat+quarterName2)!= null)?fiscalPeriodForecastMap.get(cat+quarterName2):0);
                    
                    quarter3 = quarter3 + ((fiscalPeriodForecastMap.get(cat+quarterName3)!= null)?fiscalPeriodForecastMap.get(cat+quarterName3):0);
                    
                    quarter4 = quarter4 + ((fiscalPeriodForecastMap.get(cat+quarterName4)!= null)?fiscalPeriodForecastMap.get(cat+quarterName4):0);
                        
                    quarter2_1 = quarter2_1 + ((fiscalPeriodForecastMap.get(cat+quarterName2_1)!= null)?fiscalPeriodForecastMap.get(cat+quarterName2_1):0);
                    quarter2_1SellPriceXGM = quarter2_1SellPriceXGM + ((fiscalPeriodForecastGrossMarginMap.get(cat+quarterName2_1)!=null)?fiscalPeriodForecastGrossMarginMap.get(cat+quarterName2_1):0);
                    if (quarter2_1SellPriceXGM != null && quarter2_1 != null && quarter2_1 != 0)
                        quarter2_1GM = (quarter2_1SellPriceXGM/quarter2_1).setScale(2);
                    
                    quarter2_2 = quarter2_2 + ((fiscalPeriodForecastMap.get(cat+quarterName2_2)!= null)?fiscalPeriodForecastMap.get(cat+quarterName2_2):0);
                    quarter2_2SellPriceXGM = quarter2_2SellPriceXGM + ((fiscalPeriodForecastGrossMarginMap.get(cat+quarterName2_2)!=null)?fiscalPeriodForecastGrossMarginMap.get(cat+quarterName2_2):0);
                    if (quarter2_2SellPriceXGM != null && quarter2_2 != null && quarter2_2 != 0)
                        quarter2_2GM = (quarter2_2SellPriceXGM/quarter2_2).setScale(2);
                        
                    quarter2_3 = quarter2_3 + ((fiscalPeriodForecastMap.get(cat+quarterName2_3)!= null)?fiscalPeriodForecastMap.get(cat+quarterName2_3):0);
                    quarter2_3SellPriceXGM = quarter2_3SellPriceXGM + ((fiscalPeriodForecastGrossMarginMap.get(cat+quarterName2_3)!=null)?fiscalPeriodForecastGrossMarginMap.get(cat+quarterName2_3):0);
                    if (quarter2_3SellPriceXGM != null && quarter2_3 != null && quarter2_3 != 0)
                        quarter2_3GM = (quarter2_3SellPriceXGM/quarter2_3).setScale(2);
                    
                    quarter2_4 = quarter2_4 + ((fiscalPeriodForecastMap.get(cat+quarterName2_4)!= null)?fiscalPeriodForecastMap.get(cat+quarterName2_4):0);
                    quarter2_4SellPriceXGM = quarter2_4SellPriceXGM + ((fiscalPeriodForecastGrossMarginMap.get(cat+quarterName2_4)!=null)?fiscalPeriodForecastGrossMarginMap.get(cat+quarterName2_4):0);
                    if (quarter2_4SellPriceXGM != null && quarter2_4 != null && quarter2_4 != 0)
                        quarter2_4GM = (quarter2_4SellPriceXGM/quarter2_4).setScale(2);
                        
                    quarter2_5 = quarter2_5 + ((fiscalPeriodForecastMap.get(cat+quarterName2_5)!= null)?fiscalPeriodForecastMap.get(cat+quarterName2_5):0);
                    quarter2_5SellPriceXGM = quarter2_5SellPriceXGM + ((fiscalPeriodForecastGrossMarginMap.get(cat+quarterName2_5)!=null)?fiscalPeriodForecastGrossMarginMap.get(cat+quarterName2_5):0);
                    if (quarter2_5SellPriceXGM != null && quarter2_5 != null && quarter2_5 != 0)
                        quarter2_5GM = (quarter2_5SellPriceXGM/quarter2_5).setScale(2);
                    
                    quarter2_6 = quarter2_6 + ((fiscalPeriodForecastMap.get(cat+quarterName2_6)!= null)?fiscalPeriodForecastMap.get(cat+quarterName2_6):0);
                    quarter2_6SellPriceXGM = quarter2_6SellPriceXGM + ((fiscalPeriodForecastGrossMarginMap.get(cat+quarterName2_6)!=null)?fiscalPeriodForecastGrossMarginMap.get(cat+quarterName2_6):0);
                    if (quarter2_6SellPriceXGM != null && quarter2_6 != null && quarter2_6 != 0)
                        quarter2_6GM = (quarter2_6SellPriceXGM/quarter2_6).setScale(2);
                    
                    year1 = year1 + ((fiscalPeriodForecastYearMap.get(cat+yearName1)!= null)?fiscalPeriodForecastYearMap.get(cat+yearName1):0);
                    year2 = year2 + ((fiscalPeriodForecastYearMap.get(cat+yearName2)!= null)?fiscalPeriodForecastYearMap.get(cat+yearName2):0);
                    year3 = year3 + ((fiscalPeriodForecastYearMap.get(cat+yearName3)!= null)?fiscalPeriodForecastYearMap.get(cat+yearName3):0);
                    year4 = year4 + ((fiscalPeriodForecastYearMap.get(cat+yearName4)!= null)?fiscalPeriodForecastYearMap.get(cat+yearName4):0);
                    
                    forecastLines.add(new ForecastLineWrapper('<b>'+cat+'</b>', formatSellingPrice(quarter1, cat, quarterName1),  
                                                                                formatSellingPrice(quarter2, cat, quarterName2), 
                                                                                formatSellingPrice(quarter3, cat, quarterName3), 
                                                                                formatSellingPrice(quarter4, cat, quarterName4), 
                                                                                formatSellingPrice(quarter2_1, cat, quarterName2_1), 
                                                                                quarter2_1GM.format()+' %',
                                                                                formatSellingPrice(quarter2_2, cat, quarterName2_2), 
                                                                                quarter2_2GM.format()+' %',
                                                                                formatSellingPrice(quarter2_3, cat, quarterName2_3), 
                                                                                quarter2_3GM.format()+' %',
                                                                                formatSellingPrice(quarter2_4, cat, quarterName2_4), 
                                                                                quarter2_4GM.format()+' %',
                                                                                formatSellingPrice(quarter2_5, cat, quarterName2_5), 
                                                                                quarter2_5GM.format()+' %',
                                                                                formatSellingPrice(quarter2_6, cat, quarterName2_6), 
                                                                                quarter2_6GM.format()+' %',
                                                                                formatSellingPrice(year1, cat, yearName1), 
                                                                                formatSellingPrice(year2, cat, yearName2), 
                                                                                formatSellingPrice(year3, cat, yearName3),
                                                                                formatSellingPrice(year4, cat, yearName4)));
                }
            }
            else
            {
                noForecast = true;
            }
        }
        else
        {
            noCurrentForecast = true;
        }
    }
    
    private void calculatePeriods(String startingPeriod)
    {
        try
        {
            quarterName1 = startingPeriod;
            Datetime datetest = CalculateStartDateQuarter(quarterName1);
            quarterName2 = getNextPeriod(quarterName1);
            datetest = CalculateStartDateQuarter(quarterName2);
            quarterName3 = getNextPeriod(quarterName2);
            datetest = CalculateStartDateQuarter(quarterName3);
            quarterName4 = getNextPeriod(quarterName3);
            datetest = CalculateStartDateQuarter(quarterName4);
            
            quarterName2_1 = getcurrentPeriod();
            quarterName2_2 = getNextPeriod(quarterName2_1);
            quarterName2_3 = getNextPeriod(quarterName2_2);
            quarterName2_4 = getNextPeriod(quarterName2_3);
            quarterName2_5 = getNextPeriod(quarterName2_4);
            quarterName2_6 = getNextPeriod(quarterName2_5);
            
            yearName1 = startingPeriod.substring(6, 14); // FEAT#0501 changed 18 to 14
            yearName2 = getNextYearPeriod(yearName1);
            yearName3 = getNextYearPeriod(yearName2);
            yearName4 = getNextYearPeriod(yearName3);
        }
        catch (Exception e)
        {
            // In case of misformatted Period   
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.label.LBL0041);
            ApexPages.addMessage(myMsg);
            hasError = true;
        }
    }
    
    public String getCurrentPeriod()
    {
        String period = 'FQ';
        Integer year = Date.today().year() - 2000; // FEAT#0501 added minus 2000
        Integer previousYear = year - 1;
        Integer nextYear = year + 1;
        Integer month = Date.today().month();
        
        if (month >= 4 && month < 7)
            period = period + '1 / FY ' + year + '-' + nextYear;
        else if (month >= 7 && month < 10)
            period = period + '2 / FY ' + year + '-' + nextYear;
        else if (month >= 10 && month < 13)
            period = period + '3 / FY ' + year + '-' + nextYear;
        else
            period = period + '4 / FY ' + previousYear + '-' + year;
        
        return period;
    }

    private String getNextPeriod(String startingPeriod)
    {
        String nextPeriod = '';
        
        Integer quarter = Integer.valueOf(startingPeriod.substring(2, 3));
            
        if (quarter == 4)
            nextPeriod = startingPeriod.substring(0, 2) + '1 / ' + getNextYearPeriod(startingPeriod.substring(6, 14)); // FEAT#0501 changed 18 to 14
        else
        {
            quarter ++;
            nextPeriod = startingPeriod.substring(0, 2) + quarter + startingPeriod.substring(3, 14); // FEAT#0501 changed 18 to 14
        }
        
        return nextPeriod;
    }
    
    private String getNextYearPeriod(String startingPeriod)
    {
        String nextYearPeriod = '';
        
        Integer year1 = Integer.valueOf(startingPeriod.substring(3, 5)); // FEAT#0501 changed 7 to 5
        Integer year2 = Integer.valueOf(startingPeriod.substring(6, 8)); // FEAT#0501 changed 8,12 to 6,8
        year1++;
        year2++;
        nextYearPeriod = 'FY ' + year1 + '-' + year2;
        
        return nextYearPeriod;
    }
    
    private String formatSellingPrice(Decimal i, String forecastCat, String period)
    {
        return '<a href=\"javascript:viewOpportunitiesJS(\''+forecastCat+'\', \''+period+'\');\">'+i.format()+' €</a>';
    }
    
    public String formatListForQuery(List<Id> liste)
    {
        String formated = '';
        
        for (Id i:liste)
            formated = formated+'\''+i+'\',';
        
        if (formated.length() > 0)
            formated = formated.substring(0, formated.length()-1);
        
        return formated;
    }
    
    public String formatListForQuery(List<String> liste)
    {
        String formated = '';
        
        for (String s:liste)
            formated = formated+'\''+s+'\',';
        
        if (formated.length() > 0)
            formated = formated.substring(0, formated.length()-1);
        
        return formated;
    }
    
    public void viewOpportunities()
    {
        opportunitiesTabFirstEnter = false;
        numberOfOpportunities = 0;
        page = 1;
        
        if (yearRangeList.size() == 0)
        {
            yearRangeList.add(new selectOption(yearName1, yearName1));
            yearRangeList.add(new selectOption(yearName2, yearName2));
            yearRangeList.add(new selectOption(yearName3, yearName3));
            yearRangeList.add(new selectOption(yearName4, yearName4));
        }
            
        // On first clic
        if (oppFilterForecastCategory == '')
            oppFilterForecastCategory = System.label.LBL0049;
        
        selectedForecast = oppFilterForecastCategory;
        
        if (oppFilterPeriod == '')
            oppFilterPeriod = yearName1;
                    
        list<String> forecastCategoryFilter = getIncludedForecastCategories(oppFilterForecastCategory);
        
        list<String> periodFilter = new list<String>();
        if (oppFilterPeriod != null && oppFilterPeriod.startsWith('FQ'))
        {
            periodFilter.add(oppFilterPeriod);
            if (oppFilterPeriod.length() == 18)
            {
                selectedQuarterRange = oppFilterPeriod.substring(0, 3);
                selectedYearRange = oppFilterPeriod.substring(6, 14); // FEAT#0501 changed 18 to 14
            }
        }
        else
        {
            periodFilter = getQuarterPeriods(oppFilterPeriod);
            selectedQuarterRange = '--None--';
            selectedYearRange = oppFilterPeriod;
        }
        
        //oppParams.AdjustedForecastCategory__c = oppFilterForecastCategory;
        selectedRole = lastRoleCriteriaUsed;        
        selectedOppFilter = 'X-X';
        
        selectedTab = 'opportunitiesTab';
        
        refreshOpportunities();
    }
    
    public void refreshOpportunities()
    {
        opportunitiesList.clear();
        editMode = false;
        offset = 0;
        
        // Use of Database.query because Order by doesn't accept apex variable
        
        // Roles
        list<UserRole> rList = getSubordinatesUserRoles(selectedRole);
        list<Id> rolesIds = new list<Id>();
        for (UserRole u : rList)
            rolesIds.add(u.Id);
        String rolesParam = formatListForQuery(rolesIds);
		/* CR-0734 - Removed GrossMargin__c */
        String query = 'Select Id, Name, BOid__c, CloseDate, SuggestedForecastCategory__c, AdjustedForecastCategory__c, FiscalPeriod__c, ForecastedFiscalPeriod__c, Amount, AdjustedSellingPrice__c, LeadingProductLine__c, Platform__c, Formula_Status__c, AdjustmentComment__c, GlobalEnvironmentRisk__c, Product_Strategy__c, Project_Feasibility__c, ProbP1OfImplementation__c, ProbP2OfWin__c, ATRegion__c, Country__c, Owner.Name, Account.Name, CurrencyIsoCode, ForecastedGrossMargin__c, LastModifiedDate, ATCluster__c, Global_Opportunity__r.Name, Global_Opportunity__c, Global_Child__c FROM Opportunity'; 
        String queryCount = 'Select count() FROM Opportunity';
        String whereClause = ' WHERE OwnerId IN (SELECT Id FROM User WHERE UserRoleId IN ('+rolesParam+'))';    
        
        // Leading Product Line
        if (oppParams.LeadingProductLine__c != null)
            whereClause = whereClause + ' AND LeadingProductLine__c = \''+oppParams.LeadingProductLine__c+'\'';
        
        // Platform 
        if (oppParams.Platform__c != null)
            whereClause = whereClause + ' AND Platform__c = \''+oppParams.Platform__c+'\''; 
            
        // Fiscal Period
        String period;
        if (selectedQuarterRange != '--None--')
        {
            whereClause = whereClause + ' AND TECH_FiscalPeriod__c = \''+selectedQuarterRange+' / '+selectedYearRange+'\''; 
            period = selectedQuarterRange+' / '+selectedYearRange;
        }
        else
        {
            list<String> periods = getQuarterPeriods(selectedYearRange);
            whereClause = whereClause + ' AND TECH_FiscalPeriod__c IN ('+formatListForQuery(periods)+')';   
            period = selectedYearRange;
        }
            
        // Adjusted Forecast Category
        if (selectedForecast != null)
        {
            list<String> forecastCategories = getIncludedForecastCategories(selectedForecast);
            whereClause = whereClause + ' AND AdjustedForecastCategory__c IN ('+formatListForQuery(forecastCategories)+')';
        }   
        
        // Filter by Price
        if (selectedOppFilter != null && selectedOppFilter != 'X-X')
        {
            List<String> priceFilters = selectedOppFilter.split('-');
            
            if (priceFilters.get(0) != 'X')
                whereClause = whereClause + ' AND AdjustedSellingPrice__c > ' + priceFilters.get(0);
                
            if (priceFilters.get(1) != 'X')
                whereClause = whereClause + ' AND AdjustedSellingPrice__c < ' + priceFilters.get(1);
        }
        
        // Global / Child
        if (selectedGlobalChild != null && selectedGlobalChild != '' && selectedGlobalChild != 'All')
            whereClause = whereClause + ' AND Global_Child__c = \'' + selectedGlobalChild + '\'';
            
        query = query + whereClause;
        queryCount = queryCount + whereClause;
        
        // Saving the query for changing Order By later
        lastOpportunitiesQuery = query;
        lastPlatformCriteriaUsed = oppParams.Platform__c;
        lastProductLineCriteriaUsed = oppParams.LeadingProductLine__c;
        lastRangeUsed = period;
        lastForecastCategoryUsed = selectedForecast;
        lastRoleCriteriaUsed = selectedRole;
        lastGlobalChildUsed = selectedGlobalChild;
        for(selectOption so : oppFilters)
            if (so.getValue() == selectedOppFilter)
                lastOpportunityFilterUsed = so.getlabel();
        
        
        System.debug('######## Opportunities Query for Count : '+query+' ########');     

        numberOfOpportunities = Database.countQuery(queryCount); 
        
        System.debug('######## numberOfOpportunities : '+numberOfOpportunities+' ########'); 
        
        String nullsOrder = ' NULLS FIRST ';
        if (sortDirection == 'DESC')
            nullsOrder = ' NULLS LAST ';
        
        if (offset > numberOfOpportunities)
            offset = 0;
            
        // ORDER BY + LIMIT
        query = query + ' ORDER BY ' + orderBy + ' ' + sortDirection + nullsOrder + ' LIMIT '+ oppQueryRecordLimit + ' OFFSET ' + offset;
               
        System.debug('######## Opportunities Query : '+query+' ########'); 
        
        list<Opportunity> listOpp = Database.Query(query);       
        for (Opportunity o : listOpp)
            opportunitiesList.add(new opportunityLineWrapper(o));    
        
        // Setting title and filters
        if (numberOfOpportunities == 1)
            opportunityTableTitle = 'Following Opportunity is for Role: <b>'+roleMap.get(lastRoleCriteriaUsed)+'</b>';
        else
            opportunityTableTitle = 'Following <b>' + numberOfOpportunities + '</b> Opportunities are for Role: <b>'+roleMap.get(lastRoleCriteriaUsed)+'</b>';  
        
        if (lastProductLineCriteriaUsed != null)
        {
            opportunityTableTitle = opportunityTableTitle+', '+leadingProductLineLabel+': <b>'+lastProductLineCriteriaUsed+'</b>';
            oppParams.LeadingProductLine__c = lastProductLineCriteriaUsed;
        }
        
        if (lastPlatformCriteriaUsed != null)
        {
            opportunityTableTitle = opportunityTableTitle+', '+platformLabel+': <b>'+lastPlatformCriteriaUsed+'</b>';
            oppParams.Platform__c = lastPlatformCriteriaUsed;
        }   
        
        if (lastRangeUsed != null)
        {
            opportunityTableTitle = opportunityTableTitle+', Period: <b>'+lastRangeUsed+'</b>';
        }
        
        if (lastForecastCategoryUsed != null)
            opportunityTableTitle = opportunityTableTitle+', '+forecastCategoryLabel+': <b>'+lastForecastCategoryUsed+'</b>';
        
        if (lastOpportunityFilterUsed != null)
            opportunityTableTitle = opportunityTableTitle+', Filter by Price: <b>'+lastOpportunityFilterUsed+'</b>';   
            
        if (lastGlobalChildUsed != null && lastGlobalChildUsed != '')
            opportunityTableTitle = opportunityTableTitle+', Global/Child: <b>'+lastGlobalChildUsed+'</b>';     
    }
    
    public void sortOpportunities()
    {
        opportunitiesList.clear();
        //editMode = false;
        
        String nullsOrder = ' NULLS FIRST ';
        
        if (sortDirection == 'DESC')
            nullsOrder = ' NULLS LAST ';

        String query = lastOpportunitiesQuery + ' order by ' + orderBy + ' ' + sortDirection + nullsOrder + ' LIMIT ' + oppQueryRecordLimit + ' OFFSET ' + offset;
    
        System.debug('######## Opportunities Query : '+query+' ########');     
        
        list<Opportunity> listOpp = Database.Query(query);       
        for (Opportunity o : listOpp)
            opportunitiesList.add(new opportunityLineWrapper(o)); 
    }
    
/*********************************************************************
 SANITY CHECK INSTRUCTION: 
   Error handling in setNumberOfRows(): 
   error should at least be logged in debug and preferrably displayed 
   to user so it can be corrected.
   (Example of something that could happen: new VR has been added to 
   user so update cannot be performed).
 Remove this box once modification done.
*********************************************************************/    public void setNumberOfRows()
    {
        // Saving new value selected
        User u = [Select Id, ForecastOpportunityQueryRecordLimit__c from User where Id = :UserInfo.getUserId() Limit 1];
        
        if (u.ForecastOpportunityQueryRecordLimit__c != oppQueryRecordLimit)
        {
            u.ForecastOpportunityQueryRecordLimit__c = oppQueryRecordLimit;
            
            try
            {
                update u;
            }
            catch(Exception e)
            {
                // Do nothing, shouldn't happen
            }
        }
        
        sortOpportunities();
    }
    
    public void previous()
    {
        page--;
        offset = offset - oppQueryRecordLimit;
        sortOpportunities();
    }
    
    public void next()
    {
        page++;
        offset = offset + oppQueryRecordLimit;
        sortOpportunities();
    }
    
    // Used to get all categories for query (ex. "Commitment" must also query "Won" Opportunities)
    private list<String> getIncludedForecastCategories(String fcParam)
    {
        list<String> fcList = new list<String>();
        
        // for Out of Pipeline, just filter on this value
        if (fcParam == System.label.LBL0038)
        {
            fcList.add(fcParam);
        }
        else
        {
            boolean valueFound = false;
            
            list<String> forecastCategoryListSorted = new List<String>();
            for (integer i=forecastCategoryList.size()-1; i>=0; i--)
                forecastCategoryListSorted.add(forecastCategoryList[i]);

            for (String fcReference : forecastCategoryListSorted)
            {
                if (fcReference == fcParam || valueFound)
                {
                    fcList.add(fcReference);
                    valueFound= true;
                }
            }
        }
        
        return fcList;
    }
    
    // Used to get all period for query 
    // (ex. "FY 12-13" must query "FQ1 / FY 12-13", "FQ2 / FY 12-13"... Opportunities)
    // Guess perfs are better than '%FY 12-13'
    private list<String> getQuarterPeriods(String periodParam)
    {
        list<String> listPeriod = new list<String>();
        listPeriod.add('FQ1 / '+periodParam);
        listPeriod.add('FQ2 / '+periodParam);
        listPeriod.add('FQ3 / '+periodParam);
        listPeriod.add('FQ4 / '+periodParam);
        
        return listPeriod;
    }
    
    public void editOpportunities()
    {
        editMode = true;
    }
    
    public void saveOpportunities()
    {
        editMode = false;
        clearOppListErrorMessages();
        
        list<Opportunity> oppToUpdate = new list<Opportunity>();
        map<Id, String> mapOppName = new map<Id, String>();
        
        for (opportunityLineWrapper olw : opportunitiesList)
        {
            if (olw.opp.ForecastedFiscalPeriod__c != olw.oppEdit.ForecastedFiscalPeriod__c
                || olw.opp.AdjustedForecastCategory__c != olw.oppEdit.AdjustedForecastCategory__c
                || olw.opp.AdjustedSellingPrice__c != olw.oppEdit.AdjustedSellingPrice__c
                || olw.opp.ForecastedGrossMargin__c != olw.oppEdit.ForecastedGrossMargin__c
                || olw.opp.AdjustmentComment__c != olw.oppEdit.AdjustmentComment__c)
            {
                // New Opportunity Object, to allow Cancel with previous values from olw.opp
                Opportunity o = new Opportunity(Id = olw.opp.Id);
                
                // To save new values
                copyEditableFields(o, olw.oppEdit);
                
                mapOppName.put(olw.opp.Id, olw.opp.Name);
                oppToUpdate.add(o);
            }
        }
        
        if (oppToUpdate.size() > 0)
        {
            try
            {
                update(oppToUpdate);
                
                for (opportunityLineWrapper olw : opportunitiesList)
                {
                    if (olw.opp.ForecastedFiscalPeriod__c != olw.oppEdit.ForecastedFiscalPeriod__c
                    || olw.opp.AdjustedForecastCategory__c != olw.oppEdit.AdjustedForecastCategory__c
                    || olw.opp.AdjustedSellingPrice__c != olw.oppEdit.AdjustedSellingPrice__c
                    || olw.opp.ForecastedGrossMargin__c != olw.oppEdit.ForecastedGrossMargin__c
                    || olw.opp.AdjustmentComment__c != olw.oppEdit.AdjustmentComment__c)
                    {
                        // To display new values
                        copyEditableFields(olw.opp, olw.oppEdit);
                    }
                }
            }
            catch(DMLException e)
            {
                // Stay in edit mode to display error message
                editMode = true;
                saveFailed = true;
                
                map<Id, String> idsInError = new map<Id, String>();
                
                for (Integer i = 0; i < e.getNumDml(); i++)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getDmlMessage(i)));
                    idsInError.put(e.getDmlId(i), e.getDMLMessage(i));
                }
                
                for (opportunityLineWrapper olw : opportunitiesList)
                    if (idsInError.get(olw.opp.Id) != null)
                        olw.errorMessage = idsInError.get(olw.opp.Id);
            }
        }
    }
    
    public void clearOppListErrorMessages()
    {
        for (opportunityLineWrapper olw : opportunitiesList)
            olw.errorMessage = '';
            
        saveFailed = false;
    }
    
    public void cancelEdit()
    {
        for (opportunityLineWrapper olw : opportunitiesList)
            copyEditableFields(olw.oppEdit, olw.opp);
        
        clearOppListErrorMessages();
        editMode = false;
    }
    
    public void copyEditableFields(Opportunity copyTo, Opportunity copyFrom)
    {
        copyTo.ForecastedFiscalPeriod__c = copyFrom.ForecastedFiscalPeriod__c;
        copyTo.AdjustedForecastCategory__c = copyFrom.AdjustedForecastCategory__c;
        copyTo.AdjustedSellingPrice__c = copyFrom.AdjustedSellingPrice__c;
        copyTo.ForecastedGrossMargin__c = copyFrom.ForecastedGrossMargin__c;
        copyTo.AdjustmentComment__c = copyFrom.AdjustmentComment__c;
    }

/*********************************************************************
 SANITY CHECK INSTRUCTION: 
   Error handling in getReportList(): error should at least be logged in debug and 
   preferrably displayed to user so it can be corrected.
 Remove this box once modification done.
*********************************************************************/
    public list<String> getReportList()
    {
        list<String> rList = new list<String>();
        
        try
        {
            list<Id> listeIdsReports = (list<Id>)(System.label.LBL0043.split(';'));
            list<Report> lReport = [Select Id, Name from Report where Id in :listeIdsReports];
            map<Id, Report> mReport = new map<Id, Report>();
            
            // To get them in the order in the custom label
            for (Report r : lReport)
                mReport.put(r.Id, r);
            
            for (Id i : listeIdsReports)
                if (mReport.get(i) != null)
                    rList.add('<li><a href="/'+i+'">'+mReport.get(i).Name+'</a></li>');
        }
        catch (Exception e)
        {
            // In case of invalid Ids in custom label, don't crash, just display nothing in Reports tab
        }
        
        return rlist;
    }
    
    public PageReference exportData()
    {
        PageReference vfp24 = new PageReference('/apex/VFP24_ForecastOpportunitiesExport');
        vfp24.setRedirect(false);
        return vfp24;
    }
    
    public list<list<opportunityLineWrapper>> getOpportunitiesFullList()
    {
        opportunitiesFullList = new list<list<opportunityLineWrapper>>();
        
        String query = lastOpportunitiesQuery + ' order by ' + orderBy + ' ' + sortDirection;
    
        System.debug('######## Opportunities Query : '+query+' ########');     
        
        list<Opportunity> listOpp = Database.Query(query);       
        
        Integer count = 0;
        Integer listIndex = 0;
        for (Opportunity o : listOpp)
        {
            if (count != 0 && opportunitiesFullList.get(listIndex) != null)
            {
                opportunitiesFullList.get(listIndex).add(new opportunityLineWrapper(o));
            }
            else
            {
                list<opportunityLineWrapper> listOppWrap = new list<opportunityLineWrapper>();
                listOppWrap.add(new opportunityLineWrapper(o));
                opportunitiesFullList.add(listOppWrap);
            }
            
            count++;
            if (count == 1000)
            {
                count = 0;
                listIndex++;
            }
        }
        
        return opportunitiesFullList;
    }
    
    //FEAT#0552
    public Datetime CalculateStartDateQuarter(string quarterName)  
    {
        integer QuarterNo = integer.valueof(quarterName.substring(2,3));
        List<String> Years = (quarterName.substring(9,14)).split('-');
        Datetime DateQuarter;
        if (QuarterNo == 1)
            DateQuarter = datetime.newInstance(2000 + integer.valueof(Years[0]),4,1,12,0,0);
        else if (QuarterNo == 2)
            DateQuarter = datetime.newInstance(2000 + integer.valueof(Years[0]),7,1,12,0,0);
        else if (QuarterNo == 3)
            DateQuarter = datetime.newInstance(2000 + integer.valueof(Years[0]),10,1,12,0,0);
        else if (QuarterNo == 4)
            DateQuarter = datetime.newInstance(2000 + integer.valueof(Years[1]),1,1,12,0,0);
        return DateQuarter;
    }
    
    public class forecastLineWrapper
    {
        public String forecastCategory {get;set;}
        public String quarter1 {get;set;}
        public String quarter2 {get;set;}
        public String quarter3 {get;set;}
        public String quarter4 {get;set;}
        
        public String quarter2_1 {get;set;}
        public String quarter2_1GM {get;set;}
        public String quarter2_2 {get;set;}
        public String quarter2_2GM {get;set;}
        public String quarter2_3 {get;set;}
        public String quarter2_3GM {get;set;}
        public String quarter2_4 {get;set;}
        public String quarter2_4GM {get;set;}
        public String quarter2_5 {get;set;}
        public String quarter2_5GM {get;set;}
        public String quarter2_6 {get;set;} 
        public String quarter2_6GM {get;set;}
        
        public String year1 {get;set;}
        public String year2 {get;set;}
        public String year3 {get;set;}
        public String year4 {get;set;}
        
        public forecastLineWrapper(String fc, String q1, String q2, String q3, String q4, String q2_1, String q2_1GM, String q2_2, String q2_2GM, String q2_3, String q2_3GM, String q2_4, String q2_4GM, String q2_5, String q2_5GM, String q2_6, String q2_6GM, String y1, String y2, String y3, String y4)
        {
            forecastCategory = fc;
            quarter1 = q1;
            quarter2 = q2;
            quarter3 = q3;
            quarter4 = q4;
            
            quarter2_1 = q2_1;
            quarter2_1GM = q2_1GM;
            quarter2_2 = q2_2;
            quarter2_2GM = q2_2GM;
            quarter2_3 = q2_3;
            quarter2_3GM = q2_3GM;
            quarter2_4 = q2_4;
            quarter2_4GM = q2_4GM;
            quarter2_5 = q2_5;
            quarter2_5GM = q2_5GM;
            quarter2_6 = q2_6;
            quarter2_6GM = q2_6GM;
            
            year1 = y1;
            year2 = y2;
            year3 = y3;
            year4 = y4;
        }
    }
    
    public class opportunityLineWrapper
    {
        public Opportunity opp {get;set;}
        public Opportunity oppEdit {get;set;}
        public String formatedSellingPrice {get;set;}
        public boolean isModified {get;set;}
        public String errorMessage {get;set;}
        
        public opportunityLineWrapper(Opportunity oppParam)
        {
            opp = oppParam;
            oppEdit = oppParam.clone();
            if (oppParam.Amount != null)
                formatedSellingPrice = String.valueOf(oppParam.Amount.format())+' '+oppParam.CurrencyIsoCode;
            else
                formatedSellingPrice= '';
                
            isModified = false;
            errorMessage = '';
        }
    }
}