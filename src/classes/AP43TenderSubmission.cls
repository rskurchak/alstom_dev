/*
 AP43TenderSubmission Apex Class
    ~ Author          : Jawad GHOULAM ~ jawad.ghoulam@cgi.com 
    ~ Date Created    : 12/11/2013
    ~ Description     : Method getAmountsInformations: 
              - Populates the rich-text field TenderingAmounts__c with a HTML table where each row comes from 
                an Amounts__c record. This 'snapshots' the Amounts in a static result. Action triggered on demand
                of the user (custom button on Tender Submission layout), or when a Tender Submission record is created.
    ~ Feature Id      : FEAT#0417 & FEAT#0418
*/
public with sharing class AP43TenderSubmission 
{
    public static void getAmountsInformations(List<TenderSubmission__c> listTS) 
    {
        Set<Id> tenderIds = new Set<Id>();
        for (TenderSubmission__c ts : listTS)
            tenderIds.add(ts.Tender__c);
        
        Map<String, String> mapFieldLabel = new Map<String, String>();
        Map<String, Schema.SObjectField> mapFS = Schema.SObjectType.Amounts__c.fields.getMap();
        for (String fieldName : mapFS.keySet())
            mapFieldLabel.put(fieldName.toLowerCase(), mapFS.get(fieldName).getDescribe().getLabel());
        
        map<Id, String> mapTenderIdAmountString = new map<Id, String>();
        for (Amounts__c amount : [Select Name, MinimumSellingPriceMEUR__c, GrossMargin__c, GrossMarginAdjusted__c,
                OperatingMargin__c, NetMargin__c, Contingencies__c, Ambition__c, Tender__c
                from Amounts__c where Tender__c IN : tenderIds ORDER BY Name])
        {
            if (mapTenderIdAmountString.get(amount.Tender__c) != null)
            {
                String amountString = mapTenderIdAmountString.get(amount.Tender__c);
                amountString = amountString + getStringForAmount(amount, mapFieldLabel);
                mapTenderIdAmountString.put(amount.Tender__c, amountString);
            }
            else
                mapTenderIdAmountString.put(amount.Tender__c, getStringForAmount(amount, mapFieldLabel));
        }
        
        for (TenderSubmission__c ts : listTS){
            ts.TenderingAmounts__c = '';
            if (mapTenderIdAmountString.get(ts.Tender__c) != null){
                String amountStringBegin = '<html><body><table border="1" width="100%">';
                amountStringBegin += '<tr>';
                amountStringBegin += '<td width="16%">&nbsp</td>';
                amountStringBegin += '<td style="text-align:center;width:13%;vertical-align:middle;"><b>' + mapFieldLabel.get('minimumsellingpricemeur__c') + '</b></td>';
                amountStringBegin += '<td style="text-align:center;width:12%;vertical-align:middle;"><b>' + mapFieldLabel.get('grossmargin__c') + '</b></td>';
                amountStringBegin += '<td style="text-align:center;width:12%;vertical-align:middle;"><b>' + mapFieldLabel.get('grossmarginadjusted__c') + '</b></td>';
                amountStringBegin += '<td style="text-align:center;width:12%;vertical-align:middle;"><b>' + mapFieldLabel.get('operatingmargin__c') + '</b></td>';
                amountStringBegin += '<td style="text-align:center;width:12%;vertical-align:middle;"><b>' + mapFieldLabel.get('netmargin__c') + '</b></td>';
                amountStringBegin += '<td style="text-align:center;width:12%;vertical-align:middle;"><b>' + mapFieldLabel.get('contingencies__c') + '</b></td>';
                amountStringBegin += '<td style="text-align:center;width:11%;vertical-align:middle;"><b>' + mapFieldLabel.get('ambition__c') + '</b></td>';
                amountStringBegin += '</tr>';
                String amountStringEnd = '</table></body></html>';
                System.debug('## >>> amountStringBegin <<< : ' + amountStringBegin);
                System.debug('## >>> mapTenderIdAmountString.get(ts.Tender__c) <<< : ' + mapTenderIdAmountString.get(ts.Tender__c));
                System.debug('## >>> amountStringEnd <<< : ' + amountStringEnd);
                ts.TenderingAmounts__c = amountStringBegin + mapTenderIdAmountString.get(ts.Tender__c) + amountStringEnd;
            }
        }
    }
    
    public static String getStringForAmount(Amounts__c amount, Map<String, String> mapFieldLabel)
    {
        String amountString = '<tr>';
        amountString += '<td width="16%"><b>' + amount.Name + '</b></td>';
        amountString += '<td style="text-align:right;width:13%;">';
        if (amount.MinimumSellingPriceMEUR__c != null)
            amountString += amount.MinimumSellingPriceMEUR__c.format();
        else amountString += '&nbsp';
        amountString += '</td>';
        
        amountString += '<td style="text-align:right;width:12%;">';
        if (amount.GrossMargin__c != null)
            amountString += amount.GrossMargin__c.format();
        else amountString += '&nbsp';
        amountString += '</td>';
        
        amountString += '<td style="text-align:right;width:12%;">';
        if (amount.GrossMarginAdjusted__c != null)
            amountString += amount.GrossMarginAdjusted__c.format();
        else amountString += '&nbsp';
        amountString += '</td>';
        
        amountString += '<td style="text-align:right;width:12%;">';
        if (amount.OperatingMargin__c != null)
            amountString += amount.OperatingMargin__c.format();
        else amountString += '&nbsp';
        amountString += '</td>';
        
        amountString += '<td style="text-align:right;width:12%;">';
        if (amount.NetMargin__c != null)
            amountString += amount.NetMargin__c.format();
        else amountString += '&nbsp';
        amountString += '</td>';
        
        amountString += '<td style="text-align:right;width:12%;">';
        if (amount.Contingencies__c != null)
            amountString += amount.Contingencies__c.format();
        else amountString += '&nbsp';
        amountString += '</td>';
        
        amountString += '<td style="text-align:right;width:11%;">';
        if (amount.Ambition__c != null)
            amountString += amount.Ambition__c.format();
        else amountString += '&nbsp';
        amountString += '</td></tr>';
        
        return amountString;
    }
}