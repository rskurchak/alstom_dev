public with sharing class Total {
    
    public Decimal actuals = 0;
    public Decimal budget = 0;
    public Decimal authorization = 0;
    public Decimal forecast = 0;
    
    private String currencyIso = Userinfo.getDefaultCurrency();

    public String getActualsFormatted() {
        return currencyIso + ' ' + actuals.format();
    }

    public String getBudgetFormatted() {
        return currencyIso + ' ' + budget.format();
    }

    public String getAuthorizationFormatted() {
        return currencyIso + ' ' + authorization.format();
    }

    public String getForecastFormatted() {
        return currencyIso + ' ' + forecast.format();
    }

}