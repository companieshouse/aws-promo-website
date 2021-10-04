<?xml version="1.0" ?>

<!-- Copyright (c) 2004-2005 Companies House -->
                                                                                
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:pt="http://www.xbrl.org/uk/fr/gaap/pt/2004-12-01" xmlns:ae='http://www.companieshouse.gov.uk/ef/xbrl/gaap/ae/2005-06-01' xmlns:xbrli='http://www.xbrl.org/2003/instance' xmlns:iso4217='http://www.xbrl.org/2003/iso4217' xmlns:link='http://www.xbrl.org/2003/linkbase' xmlns:xlink='http://www.w3.org/1999/xlink' xmlns:gc="http://www.xbrl.org/uk/fr/gcd/2004-12-01" xmlns:html="http://www.w3.org/1999/xhtml" exclude-result-prefixes="html pt link xlink iso4217 xbrli ae gc">

  <xsl:output method="xml" indent="yes" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />

  <xsl:variable name="pl_present">0<xsl:if test="//pt:ProfitLossOnOrdinaryActivitiesBeforeTax">1</xsl:if></xsl:variable>
  <!--Version 0.1-->
  <!-- Start by examining the contexts. guessContexts will call main for us. -->
  <xsl:template match="/">
    <xsl:call-template name="guessContexts" />
  </xsl:template>

<!-- The main output routine -->
<xsl:template name="main">
  <xsl:param name="y1" />
  <xsl:param name="y1start" />
  <xsl:param name="y1end" />
  <xsl:param name="y1currency" />
  <xsl:param name="namey1" />
  <xsl:param name="y2" />
  <xsl:param name="y2start" />
  <xsl:param name="y2end" />
  <xsl:param name="y2currency" />
  <xsl:param name="namey2" />

  <!-- Explain how we allocated the contexts, to avoid confusion and ease debug -->
  <xsl:message>The following contexts are in year 1 (<xsl:value-of select="$namey1" />): <xsl:for-each select="$y1 | $y1start | $y1end"> <xsl:value-of select="." /><xsl:text> </xsl:text></xsl:for-each>
  </xsl:message>
  <xsl:message>The following contexts are in year 2 (<xsl:value-of select="$namey2" />): <xsl:for-each select="$y2 | $y2start | $y2end"> <xsl:value-of select="." /><xsl:text> </xsl:text></xsl:for-each>
  </xsl:message>

  <!-- Get currencies for the two years. -->
  <xsl:variable name="currencyUnitY1" select="$y1currency" />
  <xsl:variable name="currencyUnitY2" select="$y2currency" />

  <!-- And get the symbol for the years -->
  <xsl:variable name="currencyY1">
    <xsl:call-template name="getCurrencySymbol">
      <xsl:with-param name="uniqueUnits" select="$currencyUnitY1" />
      <xsl:with-param name="contexts" select="$y1" />
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="currencyY2">
    <xsl:call-template name="getCurrencySymbol">
      <xsl:with-param name="uniqueUnits" select="$currencyUnitY2" />
      <xsl:with-param name="contexts" select="$y2" />
    </xsl:call-template>
  </xsl:variable>
                                                                                
  <!-- HTML header -->
<html>
  <head>
    <meta name="generator"><xsl:attribute name="content"><xsl:value-of select="concat('DecisionSoft, using ', system-property('xsl:vendor'),' ',system-property('xsl:version'))" /></xsl:attribute></meta>
    <style type="text/css">
    body { font-family: sans-serif; }
    .rightalign { text-align: right }

    h1 { font-size: 100%; font-weight: bold; color: black; }

    h2 { font-size: 100%; font-weight: bold; margin: 0.25em 0 1em 0; text-align: center; }

    h3 { font-size: 100%; font-weight: bold; margin: 0.5em 0 }
    .nospace { padding-top: 0 }
    

    .rnheader { border: 0; padding: 0.1em 0.5em; margin: 0 0 1em 0; }
    
   a.footnoteLink { text-decoration: none; }

   p { margin: 0.5em 0; }

   hr { background-color:#666666; }

   a { color: black;  }
   a:hover { text-decoration: none; }
    </style>
    <title>Accounts</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  </head>
  <body>

    <table border="0" width="100%">

<xsl:variable name="doc_title"><xsl:choose>
    <xsl:when test="//ae:DateApprovalDirectorsReport">Report and Accounts</xsl:when>
    <xsl:otherwise>Abbreviated Accounts</xsl:otherwise>
  </xsl:choose></xsl:variable>

<tr>
  <td align="center">
    <table><tr>
      <td style="whitespace: no-wrap; font-weight: bold;" align="left">
        Registered Number <xsl:call-template name='displayItem'><xsl:with-param name='item' select='//ae:CompaniesHouseRegisteredNumber' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template><br/>
        <h1><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//gc:EntityCurrentLegalName' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></h1>
        <h1><xsl:value-of select="$doc_title"/></h1>
        <h1><xsl:call-template name="formatDate"><xsl:with-param name="date" select="//gc:BalanceSheetDate" /></xsl:call-template></h1>
      </td>
    </tr></table>
  </td>
</tr>
</table>
<br style="page-break-after: always"/>


<!-- fn_* are the footnote flags, 1=footnote present, 0=not present -->
<!-- fnn_* are the footnote numbers -->
<xsl:variable name="fn_accounting_policies">0<xsl:if test="//ae:AccountingPolicy or //ae:AccountsPreparedUnderHistoricalCostConventionInAccordanceWithFRSE or //ae:DepreciationRate">1</xsl:if></xsl:variable>
<xsl:variable name="fnn_accounting_policies" select="number($fn_accounting_policies)" />

<xsl:variable name="fn_exchange_rates">0<xsl:if test="//ae:ForeignExchangeRate">1</xsl:if></xsl:variable>
<xsl:variable name="fnn_exchange_rates" select="number($fn_exchange_rates + $fnn_accounting_policies)" />

<xsl:variable name="fn_called_up_share_capital_not_paid">0<xsl:if test="//link:loc[@xlink:href=concat(&quot;#&quot;, //pt:CalledUpShareCapitalNotPaidNotExpressedAsCurrentAsset/@id)]">1</xsl:if></xsl:variable>
<xsl:variable name="fnn_called_up_share_capital_not_paid" select="number($fn_called_up_share_capital_not_paid + $fnn_exchange_rates)" />

<xsl:variable name="fn_ifas">0<xsl:if test="//pt:IntangibleFixedAssetsCostOrValuation or //pt:IntangibleFixedAssetsCostOrValuation or //pt:IntangibleFixedAssetsAggregateAmortisationImpairment or //pt:IntangibleFixedAssetsAmortisationChargedInPeriod or //pt:IntangibleFixedAssetsAggregateAmortisationImpairment or //pt:IntangibleFixedAssets or //pt:IntangibleFixedAssets">1</xsl:if></xsl:variable>
<xsl:variable name="fnn_ifas" select="number($fn_ifas + $fnn_called_up_share_capital_not_paid)" />

<xsl:variable name="fn_tfas">0<xsl:if test="//pt:LandBuildingsCostOrValuation or //pt:PlantMachineryCostOrValuation or //pt:FixturesFittingsToolsEquipmentCostOrValuation or //pt:TangibleFixedAssetsCostOrValuation or //pt:LandBuildingsAdditions or //pt:PlantMachineryAdditions or //pt:FixturesFittingsToolsEquipmentAdditions or //pt:TangibleFixedAssetsAdditions or //pt:LandBuildingsDisposals or //pt:PlantMachineryDisposals or //pt:FixturesFittingsToolsEquipmentDisposals or //pt:TangibleFixedAssetsDisposals or //pt:LandBuildingsCostOrValuation or //pt:PlantMachineryCostOrValuation or //pt:FixturesFittingsToolsEquipmentCostOrValuation or //pt:TangibleFixedAssetsCostOrValuation or //pt:LandBuildingsDepreciation or //pt:PlantMachineryDepreciation or //pt:FixturesFittingsToolsEquipmentDepreciation or //pt:TangibleFixedAssetsDepreciation or //pt:LandBuildingsDepreciationChargeForPeriod or //pt:PlantMachineryDepreciationChargeForPeriod or //pt:FixturesFittingsToolsEquipmentDepreciationChargeForPeriod or //pt:TangibleFixedAssetsDepreciationChargeForPeriod or //pt:LandBuildingsDepreciationDisposals or //pt:PlantMachineryDepreciationDisposals or //pt:FixturesFittingsToolsEquipmentDepreciationDisposals or //pt:TangibleFixedAssetsDepreciationDisposals or //pt:LandBuildingsDepreciation or //pt:PlantMachineryDepreciation or //pt:FixturesFittingsToolsEquipmentDepreciation or //pt:TangibleFixedAssetsDepreciation or //pt:LandBuildings or //pt:PlantMachinery or //pt:FixturesFittingsToolsEquipment or //pt:TangibleFixedAssets or //pt:LandBuildings or //pt:PlantMachinery or //pt:FixturesFittingsToolsEquipment or //pt:TangibleFixedAssets">1</xsl:if></xsl:variable>
<xsl:variable name="fnn_tfas" select="number($fn_tfas + $fnn_ifas)" />

<xsl:variable name="fn_investments">0<xsl:if test="//link:loc[@xlink:href=concat(&quot;#&quot;, //pt:TotalInvestmentsFixedAssets/@id)]">1</xsl:if></xsl:variable>
<xsl:variable name="fnn_investments" select="number($fn_investments + $fnn_tfas)" />

<xsl:variable name="fn_fixed_assets">0<xsl:if test="//link:loc[@xlink:href=concat(&quot;#&quot;, //pt:FixedAssets/@id)]">1</xsl:if></xsl:variable>
<xsl:variable name="fnn_fixed_assets" select="number($fn_fixed_assets + $fnn_investments)" />

<xsl:variable name="fn_stocks">0<xsl:if test="//link:loc[@xlink:href=concat(&quot;#&quot;, //pt:StocksInventory/@id)]">1</xsl:if></xsl:variable>
<xsl:variable name="fnn_stocks" select="number($fn_stocks + $fnn_fixed_assets)" />

<xsl:variable name="fn_debtors">0<xsl:if test="//pt:TradeDebtors or //pt:OtherDebtors or //pt:PrepaymentsAccruedIncomeCurrentAsset or //pt:CalledUpShareCapitalNotPaidCurrentAsset">1</xsl:if></xsl:variable>
<xsl:variable name="fnn_debtors" select="number($fn_debtors + $fnn_stocks)" />

<xsl:variable name="fn_investments_ca">0<xsl:if test="//link:loc[@xlink:href=concat(&quot;#&quot;, //pt:InvestmentsCurrentAssets/@id)]">1</xsl:if></xsl:variable>
<xsl:variable name="fnn_investments_ca" select="number($fn_investments_ca + $fnn_debtors)" />

<xsl:variable name="fn_cash_at_bank_in_hand">0<xsl:if test="//link:loc[@xlink:href=concat(&quot;#&quot;, //pt:CashBankInHand/@id)]">1</xsl:if></xsl:variable>
<xsl:variable name="fnn_cash_at_bank_in_hand" select="number($fn_cash_at_bank_in_hand + $fnn_investments_ca)" />

<xsl:variable name="fn_total_current_assets">0<xsl:if test="//link:loc[@xlink:href=concat(&quot;#&quot;, //pt:CurrentAssets/@id)]">1</xsl:if></xsl:variable>
<xsl:variable name="fnn_total_current_assets" select="number($fn_total_current_assets + $fnn_cash_at_bank_in_hand)" />

<xsl:variable name="fn_prepayments_accrued_income">0<xsl:if test="//link:loc[@xlink:href=concat(&quot;#&quot;, //pt:PrepaymentsAccruedIncomeNotExpressedWithinCurrentAssetSub-total/@id)]">1</xsl:if></xsl:variable>
<xsl:variable name="fnn_prepayments_accrued_income" select="number($fn_prepayments_accrued_income + $fnn_total_current_assets)" />

<xsl:variable name="fn_creditors_lt_one_year">0<xsl:if test="//pt:BankLoansOverdraftsWithinOneYear or //pt:TradeCreditorsWithinOneYear or //pt:AccrualsDeferredIncomeWithinOneYear or //pt:OtherCreditorsDueWithinOneYear or //pt:TaxationSocialSecurityDueWithinOneYear">1</xsl:if></xsl:variable>
<xsl:variable name="fnn_creditors_lt_one_year" select="number($fn_creditors_lt_one_year + $fnn_prepayments_accrued_income)" />

<xsl:variable name="fn_net_current_assets">0<xsl:if test="//link:loc[@xlink:href=concat(&quot;#&quot;, //pt:NetCurrentAssetsLiabilities/@id)]">1</xsl:if></xsl:variable>
<xsl:variable name="fnn_net_current_assets" select="number($fn_net_current_assets + $fnn_creditors_lt_one_year)" />

<xsl:variable name="fn_creditors_gt_one_year">0<xsl:if test="//pt:ObligationsUnderFinanceLeaseHirePurchaseContractsAfterOneYear or //pt:BankLoansOverdraftsAfterOneYear">1</xsl:if></xsl:variable>
<xsl:variable name="fnn_creditors_gt_one_year" select="number($fn_creditors_gt_one_year + $fnn_net_current_assets)" />

<xsl:variable name="fn_provisions_liabilities_charges">0<xsl:if test="//link:loc[@xlink:href=concat(&quot;#&quot;, //pt:ProvisionsForLiabilitiesCharges/@id)]">1</xsl:if></xsl:variable>
<xsl:variable name="fnn_provisions_liabilities_charges" select="number($fn_provisions_liabilities_charges + $fnn_creditors_gt_one_year)" />

<xsl:variable name="fn_accruals_deferred_income">0<xsl:if test="//link:loc[@xlink:href=concat(&quot;#&quot;, //pt:AccrualsDeferredIncome/@id)]">1</xsl:if></xsl:variable>
<xsl:variable name="fnn_accruals_deferred_income" select="number($fn_accruals_deferred_income + $fnn_provisions_liabilities_charges)" />

<xsl:variable name="fn_total_net_assets">0<xsl:if test="//link:loc[@xlink:href=concat(&quot;#&quot;, //pt:NetAssetsLiabilitiesIncludingPensionAssetLiability/@id)]">1</xsl:if></xsl:variable>
<xsl:variable name="fnn_total_net_assets" select="number($fn_total_net_assets + $fnn_accruals_deferred_income)" />

<xsl:variable name="fn_capital">0<xsl:if test="//pt:NonEquityAuthorisedDetails or //pt:EquityAuthorisedDetails or //pt:DetailsOrdinarySharesAllotted or //pt:NonEquityAllottedDetails">1</xsl:if></xsl:variable>
<xsl:variable name="fnn_capital" select="number($fn_capital + $fnn_total_net_assets)" />

<xsl:variable name="fn_share_premium_account">0<xsl:if test="//link:loc[@xlink:href=concat(&quot;#&quot;, //pt:SharePremiumAccount/@id)]">1</xsl:if></xsl:variable>
<xsl:variable name="fnn_share_premium_account" select="number($fn_share_premium_account + $fnn_capital)" />

<xsl:variable name="fn_revaluation_reserve">0<xsl:if test="//link:loc[@xlink:href=concat(&quot;#&quot;, //pt:RevaluationReserve/@id)]">1</xsl:if></xsl:variable>
<xsl:variable name="fnn_revaluation_reserve" select="number($fn_revaluation_reserve + $fnn_share_premium_account)" />

<xsl:variable name="fn_other_reserves">0<xsl:if test="//link:loc[@xlink:href=concat(&quot;#&quot;, //pt:OtherAggregateReserves/@id)]">1</xsl:if></xsl:variable>
<xsl:variable name="fnn_other_reserves" select="number($fn_other_reserves + $fnn_revaluation_reserve)" />

<xsl:variable name="fn_profit_and_loss_account">0<xsl:if test="//link:loc[@xlink:href=concat(&quot;#&quot;, //pt:ProfitLossAccountReserve/@id)]">1</xsl:if></xsl:variable>
<xsl:variable name="fnn_profit_and_loss_account" select="number($fn_profit_and_loss_account + $fnn_other_reserves)" />

<xsl:variable name="fn_shareholders_funds">0<xsl:if test="//link:loc[@xlink:href=concat(&quot;#&quot;, //pt:ShareholderFunds/@id)]">1</xsl:if></xsl:variable>
<xsl:variable name="fnn_shareholders_funds" select="number($fn_shareholders_funds + $fnn_profit_and_loss_account)" />

<xsl:variable name="fn_twd">0<xsl:if test="//ae:TransactionsWithDirectors">1</xsl:if></xsl:variable>
<xsl:variable name="fnn_twd" select="number($fn_twd + $fnn_shareholders_funds)" />

<xsl:variable name="fn_rpd">0<xsl:if test="//pt:StatementOnRelatedPartyDisclosure">1</xsl:if></xsl:variable>
<xsl:variable name="fnn_rpd" select="number($fn_rpd + $fnn_twd)" />


<xsl:variable name="fnn_footnotes" select="count(//link:footnoteLink)"/>
<!-- ~fn_* -->

<xsl:if test="//ae:RegisteredOfficeAddress or //ae:BusinessAddress or //ae:ListDirectorsExecutives or //ae:Bankers or //ae:Solicitors">
<table width="100%" class="rnheader">
<tr><td style="font-weight: bold"><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//gc:EntityCurrentLegalName' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td><td align="right" style="font-weight: bold">Registered Number <xsl:call-template name='displayItem'><xsl:with-param name='item' select='//ae:CompaniesHouseRegisteredNumber' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td></tr>
</table>
<table width="100%">
<tr><td colspan="8" align="center"><h2>Company Information</h2></td></tr>
</table>
<br/>
<xsl:if test="//ae:RegisteredOfficeAddress">
<table cellpadding="0" cellspacing="0">
        <tr>
          <td style='font-weight: bold'>
Registered Office:
          </td>
          <td>

          </td>
          <td style='font-weight: bold'>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
        <tr>
          <td>
<xsl:call-template name="address"><xsl:with-param name="address" select="//ae:RegisteredOfficeAddress"/></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
</table>
<br/>
</xsl:if>
<xsl:if test="//ae:BusinessAddress">
<table cellspacing="0" cellpadding="0">
        <tr>
          <td style='font-weight: bold'>
Business Address:
          </td>
          <td>

          </td>
          <td style='font-weight: bold'>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
<tr><td>
<xsl:if test="//ae:DescriptionBusinessAddress"><xsl:value-of select="//ae:DescriptionBusinessAddress"/><br/></xsl:if>
<xsl:call-template name="address"><xsl:with-param name="address" select="//ae:BusinessAddress"/></xsl:call-template>
</td></tr>
</table>
<br/>
</xsl:if>
<br/>
<xsl:if test="//ae:ReportingAccountants">
<table cellspacing="0" cellpadding="0">
        <tr>
          <td style='font-weight: bold'>
Reporting Accountants:
          </td>
          <td>

          </td>
          <td style='font-weight: bold'>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
        <tr>
          <td>
<xsl:if test='//ae:ReportingAccountants//ae:NameAccountants/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//ae:ReportingAccountants//ae:NameAccountants' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
        <tr>
          <td>
<xsl:if test='//ae:ReportingAccountants//ae:DescriptionAccountants/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//ae:ReportingAccountants//ae:DescriptionAccountants' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
        <tr>
          <td>
<xsl:call-template name="address"><xsl:with-param name="address" select="//ae:ReportingAccountants"/></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
</table>
<br/>
</xsl:if>
<xsl:if test="//ae:Bankers">
<table cellspacing="0" cellpadding="0">
        <tr>
          <td style='font-weight:bold'>
Bankers:
          </td>
          <td>

          </td>
          <td style='font-weight:bold'>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
        <tr>
          <td>
<xsl:if test='//ae:Bankers//ae:NameBankers/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//ae:Bankers//ae:NameBankers' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
        <tr>
          <td>
<xsl:call-template name="address"><xsl:with-param name="address" select="//ae:Bankers"/></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
</table>
<br/>
</xsl:if>
<xsl:if test="//ae:Solicitors">
<table cellspacing="0" cellpadding="0" width="25%">
        <tr>
          <td style='font-weight:bold'>
Solicitors:
          </td>
          <td>

          </td>
          <td style='font-weight:bold'>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
        <tr>
          <td>
<xsl:if test='//ae:Solicitors//ae:NameSolicitors/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//ae:Solicitors//ae:NameSolicitors' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
        <tr>
          <td>
<xsl:call-template name="address"><xsl:with-param name="address" select="//ae:Solicitors"/></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
</table>
<br/>
</xsl:if>
<!-- VAT registration number: avoid including empty table -->
<xsl:if test='//ae:VATRegistrationNumber'>
<table width="30%">
<tr><td style="font-weight:bold">VAT registration number</td><td><xsl:value-of select="//ae:VATRegistrationNumber"/></td></tr>
</table>
</xsl:if>
<br style="page-break-after: always" />
</xsl:if>
<xsl:if test="//ae:DateApprovalDirectorsReport">
<xsl:if test="not(//ae:NamePersonApprovingDirectorsReport and //ae:PositionPersonApprovingDirectorsReport)">
	<xsl:message terminate="yes">ae:DateApprovalDirectorsReport is present but ae:NamePersonApprovingDirectorsReport and ae:PositionPersonApprovingDirectorsReport are not</xsl:message>
</xsl:if>
<table width="100%" class="rnheader">
<tr><td style="font-weight: bold"><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//gc:EntityCurrentLegalName' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td><td align="right" style="font-weight: bold">Registered Number <xsl:call-template name='displayItem'><xsl:with-param name='item' select='//ae:CompaniesHouseRegisteredNumber' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td></tr>
</table>
<table width="100%"><tr><td colspan="8" align="center"><h2>Directors' Report</h2></td></tr></table>
<table >
<tr><td colspan="8" >The directors present their report and accounts for the year ended <xsl:call-template name="formatDate"><xsl:with-param name="date" select="//gc:BalanceSheetDate" /></xsl:call-template></td></tr>
<tr><td colspan="8"><h3>Principal Activity</h3></td></tr>
<tr><td colspan="8"><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//gc:EntityBusinessDescription' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td></tr>
<xsl:if test="//ae:CompanyNon-trading = 'true'"><tr><td colspan="8" style="font-weight: bold">The company did not trade during the year.</td></tr></xsl:if>
<xsl:if test="//ae:DirectorsReportGeneralText">
<tr><td colspan="8" ></td></tr>
<tr><td colspan="8"><xsl:value-of select="//ae:DirectorsReportGeneralText" /></td></tr>
</xsl:if>
<xsl:if test="//ae:PoliticalCharitableDonationsText">
<tr><td colspan="8"><h3>Political And Charitable Donations</h3><p><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//ae:PoliticalCharitableDonationsText' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></p></td></tr>
</xsl:if>

</table>
<table>
<xsl:for-each select="//ae:ListDirectorsExecutives">
        <tr>
          <td style='font-weight:bold; padding-left: 5px;vertical-align:top'>
<xsl:if test="position()=1">Directors:</xsl:if>
          </td>
          <td>

          </td>
          <td style='font-weight:bold; padding-left: 5px;vertical-align:top'>

          </td>
          <td style='font-weight:bold; padding-left: 5px;vertical-align:top'>
<xsl:value-of select=".//pt:DirectorOrExecutivesName"/>
          </td>
          <td style='font-weight:bold; padding-left: 5px;vertical-align:top'>
<span style="font-weight:normal"><xsl:if test=".//pt:DateAssumedPosition">Appointed <xsl:call-template name="formatDate"><xsl:with-param name="date" select=".//pt:DateAssumedPosition" /></xsl:call-template></xsl:if><xsl:if test=".//pt:DateAssumedPosition and .//ae:DateResignation"><br/></xsl:if> <xsl:if test=".//ae:DateResignation">Resigned <xsl:call-template name="formatDate"><xsl:with-param name="date" select=".//ae:DateResignation" /></xsl:call-template></xsl:if></span>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
</xsl:for-each>
      <xsl:if test='//ae:CompanySecretarysName'>
        <tr>
          <td style='font-weight:bold; padding-left: 5px'>
Secretary:
          </td>
          <td>

          </td>
          <td style='font-weight:bold; padding-left: 5px'>

          </td>
          <td style='font-weight:bold; padding-left: 5px'>
<xsl:if test='//ae:CompanySecretarysName/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//ae:CompanySecretarysName' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
      </xsl:if>
        <tr>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
</table>

<table>
        <tr>
          <td>
The following directors who served during the year and their interests in the share capital of the Company:
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
</table>
<br/>
<table>
<tr style="font-weight: bold">
	<td> </td>
	<td> </td>
	<td><div style="width:25px"> </div></td>
	<td><xsl:value-of select="$namey2"/></td>
	<td><div style="width:25px"> </div></td>
	<td><xsl:value-of select="$namey1"/></td>
</tr>
<xsl:for-each select="//ae:DirectorShareholding">
        <xsl:variable name="name" select="pt:DirectorOrExecutivesName"/>
        <xsl:for-each select="ae:Shareholding">
                <xsl:variable name="desc" select="./pt:DescriptionSharesOrDebentures"/>
                <!-- The following line selects all Shareholdings which either have a matching description, or no description, depending
                     on whether the current Shareholding has a description or not. -->
                <xsl:variable name="matchingDescriptions" select="../ae:Shareholding[(not($desc) and not(pt:DescriptionSharesOrDebentures)) or pt:DescriptionSharesOrDebentures=$desc]"/>
                <!-- The following condition performs an intersection of two node-sets by taking each node in the first set in turn, and performing a union of
                     it and the second set, and then seeing if the count of the resulting set is the same as the count of the vanilla second set. -->
                <xsl:if test="not(preceding-sibling::ae:Shareholding[count(.|$matchingDescriptions) = count($matchingDescriptions)])">
                     <tr>
                          <td><xsl:if test="position()=1"><xsl:value-of select="$name" /></xsl:if> </td>
                          <td><xsl:if test="$desc">(<xsl:value-of select="$desc" />)</xsl:if></td>
                          <td> </td>
                          <td><xsl:value-of select="$matchingDescriptions/pt:SharesDirectorOrExecutive[@contextRef=$y2end]" /></td>
                          <td> </td>
    	                  <td><xsl:value-of select="$matchingDescriptions/pt:SharesDirectorOrExecutive[@contextRef=$y1end]" /></td>
                     </tr>
                </xsl:if>
	</xsl:for-each>
</xsl:for-each>
</table>
<xsl:if test="//ae:AccountsInAccordanceWithPartVIICompaniesActRelatingToSmallCompanies = 'true'"><p>The Directors' Report has been prepared in accordance with the special provisions in Part VII of the Companies Act 1985 relating to small companies</p></xsl:if>
<p>This report was approved by the board on <xsl:call-template name="formatDate"><xsl:with-param name="date" select="//ae:DateApprovalDirectorsReport"/></xsl:call-template></p><p>And signed on their behalf by:<br/>
<xsl:for-each select="//ae:ApprovalDirectorsReport">
<span style="padding: 0 0 0 1em; font-weight:bold"><xsl:value-of select="./ae:NamePersonApprovingDirectorsReport"/>, <xsl:value-of select="./ae:PositionPersonApprovingDirectorsReport"/></span><br/>
</xsl:for-each></p><br/>
<p style="font-weight: bold">This document was delivered using electronic communications and authenticated in accordance with section 707B(2) of the Companies Act 1985.</p>
<br style="page-break-after: always" />
</xsl:if>
<xsl:if test="$pl_present = 1">
<table width="100%" class="rnheader">
<tr><td style="font-weight: bold" align="left"><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//gc:EntityCurrentLegalName' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td><td style="font-weight: bold" align="right">Registered Number <xsl:call-template name='displayItem'><xsl:with-param name='item' select='//ae:CompaniesHouseRegisteredNumber' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td></tr>
</table>

<br style="page-break-after: always" />
</xsl:if>
<table width="100%" class="rnheader">
<tr><td style="font-weight: bold" align="left"><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//gc:EntityCurrentLegalName' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td><td style="font-weight: bold" align="right">Registered Number <xsl:call-template name='displayItem'><xsl:with-param name='item' select='//ae:CompaniesHouseRegisteredNumber' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td></tr>
</table>

<table width="100%">
<tr><td colspan="8" align="center"><h3>Balance Sheet as at <xsl:call-template name="formatDate"><xsl:with-param name="date" select="//gc:BalanceSheetDate"/></xsl:call-template></h3></td></tr>
<tr><td width="51%"> </td><td width="1%"> </td><td width="7%">Notes</td><td width="10%" style="font-weight:bold" align="right"><xsl:value-of select="$namey2" /></td><td width="10%"> </td><td width="1%"> </td><td width="10%" style="font-weight:bold" align="right"><xsl:value-of select="$namey1" /></td><td width="10%"> </td></tr>
        <tr>
          <td>

          </td>
          <td>

          </td>
          <td style='font-weight: bold;text-align:right'>
<xsl:if test="$fn_exchange_rates = 1"><div style="text-align:left"><a href="#fn_exchange_rates" style="font-weight:normal" class="footnoteLink"><xsl:value-of select="$fnn_exchange_rates" /></a></div></xsl:if>

          </td>
          <td style='font-weight: bold;text-align:right'>
<xsl:value-of select="$currencyY2"/>
          </td>
          <td style='font-weight: bold;text-align:right'>
<xsl:value-of select="$currencyY2"/>
          </td>
          <td>

          </td>
          <td style='font-weight: bold;text-align:right'>
<xsl:value-of select="$currencyY1"/>
          </td>
          <td style='font-weight: bold;text-align:right'>
<xsl:value-of select="$currencyY1"/>
          </td>
        </tr>


<!--
    Called up share capital not paid
-->

      <xsl:if test='//pt:CalledUpShareCapitalNotPaidNotExpressedAsCurrentAsset[@contextRef=$y2end] or //pt:CalledUpShareCapitalNotPaidNotExpressedAsCurrentAsset[@contextRef=$y1end]'>
        <tr>
          <td>
Called up share capital not paid
          </td>
          <td>

          </td>
          <td>
<xsl:if test="$fn_called_up_share_capital_not_paid = 1"><div style="text-align:left"><a href="#fn_called_up_share_capital_not_paid" style="font-weight:normal" class="footnoteLink"><xsl:value-of select="$fnn_called_up_share_capital_not_paid" /></a></div></xsl:if>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:CalledUpShareCapitalNotPaidNotExpressedAsCurrentAsset[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:CalledUpShareCapitalNotPaidNotExpressedAsCurrentAsset[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:CalledUpShareCapitalNotPaidNotExpressedAsCurrentAsset[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:CalledUpShareCapitalNotPaidNotExpressedAsCurrentAsset[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
        </tr>
      </xsl:if>
<xsl:if test="//pt:IntangibleFixedAssets or //pt:TangibleFixedAssets or //pt:TotalInvestmentsFixedAssets or //pt:FixedAssets">

<!--
    Fixed assets
-->

        <tr>
          <td style='font-weight: bold'>
Fixed assets
          </td>
          <td>

          </td>
          <td style='font-weight: bold'>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>

<!--
    Intangible
-->

      <xsl:if test='//pt:IntangibleFixedAssets[@contextRef=$y2end] or //pt:IntangibleFixedAssets[@contextRef=$y1end]'>
        <tr>
          <td>
Intangible
          </td>
          <td>

          </td>
          <td>
<xsl:if test="$fn_ifas = 1"><div style="text-align:left"><a href="#fn_ifas" style="font-weight:normal" class="footnoteLink"><xsl:value-of select="$fnn_ifas" /></a></div></xsl:if>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:IntangibleFixedAssets[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:IntangibleFixedAssets[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:IntangibleFixedAssets[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:IntangibleFixedAssets[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
        </tr>
      </xsl:if>

<!--
    Tangible
-->

      <xsl:if test='//pt:TangibleFixedAssets[@contextRef=$y2end] or //pt:TangibleFixedAssets[@contextRef=$y1end]'>
        <tr>
          <td>
Tangible
          </td>
          <td>

          </td>
          <td>
<xsl:if test="$fn_tfas = 1"><div style="text-align:left"><a href="#fn_tfas" style="font-weight:normal" class="footnoteLink"><xsl:value-of select="$fnn_tfas" /></a></div></xsl:if>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:TangibleFixedAssets[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:TangibleFixedAssets[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:TangibleFixedAssets[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:TangibleFixedAssets[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
        </tr>
      </xsl:if>

<!--
    Investments
-->

      <xsl:if test='//pt:TotalInvestmentsFixedAssets[@contextRef=$y2end] or //pt:TotalInvestmentsFixedAssets[@contextRef=$y1end]'>
        <tr>
          <td>
Investments
          </td>
          <td>

          </td>
          <td>
<xsl:if test="$fn_investments = 1"><div style="text-align:left"><a href="#fn_investments" style="font-weight:normal" class="footnoteLink"><xsl:value-of select="$fnn_investments" /></a></div></xsl:if>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:TotalInvestmentsFixedAssets[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:TotalInvestmentsFixedAssets[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:TotalInvestmentsFixedAssets[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:TotalInvestmentsFixedAssets[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
        </tr>
      </xsl:if>

<!--
    Total fixed assets
-->

      <xsl:if test='//pt:FixedAssets[@contextRef=$y2end] or //pt:FixedAssets[@contextRef=$y1end]'>
        <tr>
          <td>
Total fixed assets
          </td>
          <td>

          </td>
          <td>
<xsl:if test="$fn_fixed_assets = 1"><div style="text-align:left"><a href="#fn_fixed_assets" style="font-weight:normal" class="footnoteLink"><xsl:value-of select="$fnn_fixed_assets" /></a></div></xsl:if>

          </td>
          <td>

          </td>
          <td style='border-top: solid medium black;'>
<xsl:if test='//pt:FixedAssets[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:FixedAssets[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td style='border-top: solid medium black;'>
<xsl:if test='//pt:FixedAssets[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:FixedAssets[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
        </tr>
      </xsl:if>
        <tr>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
</xsl:if> 
<xsl:if test="//pt:StocksInventory or //pt:Debtors or //pt:InvestmentsCurrentAssets or //pt:CashBankInHand or //pt:CurrentAssets">

<!--
    Current assets
-->

        <tr>
          <td style='font-weight: bold'>
Current assets
          </td>
          <td>

          </td>
          <td style='font-weight: bold'>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>

<!--
    Stock
-->

      <xsl:if test='//pt:StocksInventory[@contextRef=$y2end] or //pt:StocksInventory[@contextRef=$y1end]'>
        <tr>
          <td>
Stocks
          </td>
          <td>

          </td>
          <td>
<xsl:if test="$fn_stocks = 1"><div style="text-align:left"><a href="#fn_stocks" style="font-weight:normal" class="footnoteLink"><xsl:value-of select="$fnn_stocks" /></a></div></xsl:if>

          </td>
          <td>
<xsl:if test='//pt:StocksInventory[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:StocksInventory[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:StocksInventory[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:StocksInventory[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
        </tr>
      </xsl:if>

<!--
    Debtors
-->

      <xsl:if test='//pt:Debtors[@contextRef=$y2end] or //pt:Debtors[@contextRef=$y1end]'>
        <tr>
          <td>
Debtors
          </td>
          <td>

          </td>
          <td>
<xsl:if test="$fn_debtors = 1"><div style="text-align:left"><a href="#fn_debtors" style="font-weight:normal" class="footnoteLink"><xsl:value-of select="$fnn_debtors" /></a></div></xsl:if>

          </td>
          <td>
<xsl:if test='//pt:Debtors[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:Debtors[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:Debtors[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:Debtors[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
        </tr>
      </xsl:if>

<!--
    Investments
-->

      <xsl:if test='//pt:InvestmentsCurrentAssets[@contextRef=$y2end] or //pt:InvestmentsCurrentAssets[@contextRef=$y1end]'>
        <tr>
          <td>
Investments
          </td>
          <td>

          </td>
          <td>
<xsl:if test="$fn_investments_ca = 1"><div style="text-align:left"><a href="#fn_investments_ca" style="font-weight:normal" class="footnoteLink"><xsl:value-of select="$fnn_investments_ca" /></a></div></xsl:if>

          </td>
          <td>
<xsl:if test='//pt:InvestmentsCurrentAssets[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:InvestmentsCurrentAssets[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:InvestmentsCurrentAssets[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:InvestmentsCurrentAssets[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
        </tr>
      </xsl:if>

<!--
    Cash at bank and in hand
-->

      <xsl:if test='//pt:CashBankInHand[@contextRef=$y2end] or //pt:CashBankInHand[@contextRef=$y1end]'>
        <tr>
          <td>
Cash at bank and in hand
          </td>
          <td>

          </td>
          <td>
<xsl:if test="$fn_cash_at_bank_in_hand = 1"><div style="text-align:left"><a href="#fn_cash_at_bank_in_hand" style="font-weight:normal" class="footnoteLink"><xsl:value-of select="$fnn_cash_at_bank_in_hand" /></a></div></xsl:if>

          </td>
          <td>
<xsl:if test='//pt:CashBankInHand[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:CashBankInHand[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:CashBankInHand[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:CashBankInHand[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
        </tr>
      </xsl:if>
        <tr>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>

<!--
    Total current assets
-->

      <xsl:if test='//pt:CurrentAssets[@contextRef=$y2end] or //pt:CurrentAssets[@contextRef=$y1end]'>
        <tr>
          <td>
Total current assets
          </td>
          <td>

          </td>
          <td>
<xsl:if test="$fn_total_current_assets = 1"><div style="text-align:left"><a href="#fn_total_current_assets" style="font-weight:normal" class="footnoteLink"><xsl:value-of select="$fnn_total_current_assets" /></a></div></xsl:if>

          </td>
          <td style='border-top: solid thin black; border-bottom: solid thin black;'>
<xsl:if test='//pt:CurrentAssets[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:CurrentAssets[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td style='border-top: solid thin black; border-bottom: solid thin black;'>
<xsl:if test='//pt:CurrentAssets[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:CurrentAssets[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
        </tr>
      </xsl:if>
        <tr>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
</xsl:if>
      <xsl:if test='//pt:PrepaymentsAccruedIncomeNotExpressedWithinCurrentAssetSub-total[@contextRef=$y2end] or //pt:PrepaymentsAccruedIncomeNotExpressedWithinCurrentAssetSub-total[@contextRef=$y1end]'>
        <tr>
          <td>
Prepayments and accrued income (not expressed within current asset sub-total)
          </td>
          <td>

          </td>
          <td>
<xsl:if test="$fn_prepayments_accrued_income = 1"><div style="text-align:left"><a href="#fn_prepayments_accrued_income" style="font-weight:normal" class="footnoteLink"><xsl:value-of select="$fnn_prepayments_accrued_income" /></a></div></xsl:if>

          </td>
          <td>
<xsl:if test='//pt:PrepaymentsAccruedIncomeNotExpressedWithinCurrentAssetSub-total[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:PrepaymentsAccruedIncomeNotExpressedWithinCurrentAssetSub-total[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:PrepaymentsAccruedIncomeNotExpressedWithinCurrentAssetSub-total[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:PrepaymentsAccruedIncomeNotExpressedWithinCurrentAssetSub-total[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
        </tr>
      </xsl:if>

        <tr>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
      <xsl:if test='//pt:CreditorsDueWithinOneYearTotalCurrentLiabilities[@contextRef=$y2end] or //pt:CreditorsDueWithinOneYearTotalCurrentLiabilities[@contextRef=$y1end]'>
        <tr>
          <td>
<b>Creditors: amounts falling due within one year</b>
          </td>
          <td>

          </td>
          <td>
<xsl:if test="$fn_creditors_lt_one_year = 1"><div style="text-align:left"><a href="#fn_creditors_lt_one_year" style="font-weight:normal" class="footnoteLink"><xsl:value-of select="$fnn_creditors_lt_one_year" /></a></div></xsl:if>

          </td>
          <td>
<xsl:if test='//pt:CreditorsDueWithinOneYearTotalCurrentLiabilities[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:CreditorsDueWithinOneYearTotalCurrentLiabilities[@contextRef=$y2end]' /><xsl:with-param name='flipSign'>(</xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:CreditorsDueWithinOneYearTotalCurrentLiabilities[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:CreditorsDueWithinOneYearTotalCurrentLiabilities[@contextRef=$y1end]' /><xsl:with-param name='flipSign'>(</xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
        </tr>
      </xsl:if>

        <tr>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
        <tr>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
      <xsl:if test='//pt:NetCurrentAssetsLiabilities[@contextRef=$y2end] or //pt:NetCurrentAssetsLiabilities[@contextRef=$y1end]'>
        <tr>
          <td>
<span style="font-weight: bold">Net current assets</span>
          </td>
          <td>

          </td>
          <td>
<xsl:if test="$fn_net_current_assets = 1"><div style="text-align:left"><a href="#fn_net_current_assets" style="font-weight:normal" class="footnoteLink"><xsl:value-of select="$fnn_net_current_assets" /></a></div></xsl:if>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:NetCurrentAssetsLiabilities[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:NetCurrentAssetsLiabilities[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:NetCurrentAssetsLiabilities[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:NetCurrentAssetsLiabilities[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
        </tr>
      </xsl:if>

        <tr>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
      <xsl:if test='//pt:TotalAssetsLessCurrentLiabilities[@contextRef=$y2end] or //pt:TotalAssetsLessCurrentLiabilities[@contextRef=$y1end]'>
        <tr>
          <td>
<span style="font-weight: bold">Total assets less current liabilities</span> 
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td style=' border-top: medium solid black;border-bottom: medium solid black'>
<xsl:if test='//pt:TotalAssetsLessCurrentLiabilities[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:TotalAssetsLessCurrentLiabilities[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td style=' border-top: medium solid black;border-bottom: medium solid black'>
<xsl:if test='//pt:TotalAssetsLessCurrentLiabilities[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:TotalAssetsLessCurrentLiabilities[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
        </tr>
      </xsl:if>

        <tr>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
        <tr>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
      <xsl:if test='//pt:CreditorsDueAfterOneYearTotalNoncurrentLiabilities[@contextRef=$y2end] or //pt:CreditorsDueAfterOneYearTotalNoncurrentLiabilities[@contextRef=$y1end]'>
        <tr>
          <td>
<span style="font-weight: bold">Creditors: amounts falling due after one year</span>
          </td>
          <td>

          </td>
          <td>
<xsl:if test="$fn_creditors_gt_one_year = 1"><div style="text-align:left"><a href="#fn_creditors_gt_one_year" style="font-weight:normal" class="footnoteLink"><xsl:value-of select="$fnn_creditors_gt_one_year" /></a></div></xsl:if>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:CreditorsDueAfterOneYearTotalNoncurrentLiabilities[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:CreditorsDueAfterOneYearTotalNoncurrentLiabilities[@contextRef=$y2end]' /><xsl:with-param name='flipSign'>(</xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:CreditorsDueAfterOneYearTotalNoncurrentLiabilities[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:CreditorsDueAfterOneYearTotalNoncurrentLiabilities[@contextRef=$y1end]' /><xsl:with-param name='flipSign'>(</xsl:with-param></xsl:call-template>
          </td>
        </tr>
      </xsl:if>

        <tr>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
      <xsl:if test='//pt:ProvisionsForLiabilitiesCharges[@contextRef=$y2end] or //pt:ProvisionsForLiabilitiesCharges[@contextRef=$y1end]'>
        <tr>
          <td>
<span style="font-weight: bold">Provisions for liabilities and charges</span>
          </td>
          <td>

          </td>
          <td>
<xsl:if test="$fn_provisions_liabilities_charges = 1"><div style="text-align:left"><a href="#fn_provisions_liabilities_charges" style="font-weight:normal" class="footnoteLink"><xsl:value-of select="$fnn_provisions_liabilities_charges" /></a></div></xsl:if>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:ProvisionsForLiabilitiesCharges[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:ProvisionsForLiabilitiesCharges[@contextRef=$y2end]' /><xsl:with-param name='flipSign'>(</xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:ProvisionsForLiabilitiesCharges[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:ProvisionsForLiabilitiesCharges[@contextRef=$y1end]' /><xsl:with-param name='flipSign'>(</xsl:with-param></xsl:call-template>
          </td>
        </tr>
      </xsl:if>

        <tr>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
      <xsl:if test='//pt:AccrualsDeferredIncome[@contextRef=$y2end] or //pt:AccrualsDeferredIncome[@contextRef=$y1end]'>
        <tr>
          <td>
<span style="font-weight: bold">Accruals and deferred income</span>
          </td>
          <td>

          </td>
          <td>
<xsl:if test="$fn_accruals_deferred_income = 1"><div style="text-align:left"><a href="#fn_accruals_deferred_income" style="font-weight:normal" class="footnoteLink"><xsl:value-of select="$fnn_accruals_deferred_income" /></a></div></xsl:if>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:AccrualsDeferredIncome[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:AccrualsDeferredIncome[@contextRef=$y2end]' /><xsl:with-param name='flipSign'>(</xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:AccrualsDeferredIncome[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:AccrualsDeferredIncome[@contextRef=$y1end]' /><xsl:with-param name='flipSign'>(</xsl:with-param></xsl:call-template>
          </td>
        </tr>
      </xsl:if>

        <tr>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
      <xsl:if test='//pt:NetAssetsLiabilitiesIncludingPensionAssetLiability[@contextRef=$y2end] or //pt:NetAssetsLiabilitiesIncludingPensionAssetLiability[@contextRef=$y1end]'>
        <tr>
          <td>
<span style="font-weight: bold">Total net Assets (liabilities)</span>
          </td>
          <td>

          </td>
          <td>
<xsl:if test="$fn_total_net_assets = 1"><div style="text-align:left"><a href="#fn_total_net_assets" style="font-weight:normal" class="footnoteLink"><xsl:value-of select="$fnn_total_net_assets" /></a></div></xsl:if>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:NetAssetsLiabilitiesIncludingPensionAssetLiability[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:NetAssetsLiabilitiesIncludingPensionAssetLiability[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:NetAssetsLiabilitiesIncludingPensionAssetLiability[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:NetAssetsLiabilitiesIncludingPensionAssetLiability[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
        </tr>
      </xsl:if>

        <tr>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>

<!--
    Capital and reserves
-->

        <tr>
          <td style=' font-weight: bold'>
Capital and reserves
          </td>
          <td>

          </td>
          <td style=' font-weight: bold'>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>

<!--
    Called up share capital
-->

      <xsl:if test='//pt:CalledUpShareCapital[@contextRef=$y2end] or //pt:CalledUpShareCapital[@contextRef=$y1end]'>
        <tr>
          <td>
Called up share capital
          </td>
          <td>

          </td>
          <td>
<xsl:if test="$fn_capital = 1"><div style="text-align:left"><a href="#fn_capital" style="font-weight:normal" class="footnoteLink"><xsl:value-of select="$fnn_capital" /></a></div></xsl:if>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:CalledUpShareCapital[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:CalledUpShareCapital[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:CalledUpShareCapital[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:CalledUpShareCapital[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
        </tr>
      </xsl:if>

<!--
    Share premium account
-->

      <xsl:if test='//pt:SharePremiumAccount[@contextRef=$y2end] or //pt:SharePremiumAccount[@contextRef=$y1end]'>
        <tr>
          <td>
Share premium account
          </td>
          <td>

          </td>
          <td>
<xsl:if test="$fn_share_premium_account = 1"><div style="text-align:left"><a href="#fn_share_premium_account" style="font-weight:normal" class="footnoteLink"><xsl:value-of select="$fnn_share_premium_account" /></a></div></xsl:if>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:SharePremiumAccount[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:SharePremiumAccount[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:SharePremiumAccount[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:SharePremiumAccount[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
        </tr>
      </xsl:if>

<!--
    Revaluation reserve
-->

      <xsl:if test='//pt:RevaluationReserve[@contextRef=$y2end] or //pt:RevaluationReserve[@contextRef=$y1end]'>
        <tr>
          <td>
Revaluation reserve
          </td>
          <td>

          </td>
          <td>
<xsl:if test="$fn_revaluation_reserve = 1"><div style="text-align:left"><a href="#fn_revaluation_reserve" style="font-weight:normal" class="footnoteLink"><xsl:value-of select="$fnn_revaluation_reserve" /></a></div></xsl:if>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:RevaluationReserve[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:RevaluationReserve[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:RevaluationReserve[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:RevaluationReserve[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
        </tr>
      </xsl:if>

<!--
    Other reserves
-->

      <xsl:if test='//pt:OtherAggregateReserves[@contextRef=$y2end] or //pt:OtherAggregateReserves[@contextRef=$y1end]'>
        <tr>
          <td>
Other reserves
          </td>
          <td>

          </td>
          <td>
<xsl:if test="$fn_other_reserves = 1"><div style="text-align:left"><a href="#fn_other_reserves" style="font-weight:normal" class="footnoteLink"><xsl:value-of select="$fnn_other_reserves" /></a></div></xsl:if>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:OtherAggregateReserves[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:OtherAggregateReserves[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:OtherAggregateReserves[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:OtherAggregateReserves[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
        </tr>
      </xsl:if>

<!--
    Profit and loss account
-->

      <xsl:if test='//pt:ProfitLossAccountReserve[@contextRef=$y2end] or //pt:ProfitLossAccountReserve[@contextRef=$y1end]'>
        <tr>
          <td>
Profit and loss account
          </td>
          <td>

          </td>
          <td>
<xsl:if test="$fn_profit_and_loss_account = 1"><div style="text-align:left"><a href="#fn_profit_and_loss_account" style="font-weight:normal" class="footnoteLink"><xsl:value-of select="$fnn_profit_and_loss_account" /></a></div></xsl:if>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:ProfitLossAccountReserve[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:ProfitLossAccountReserve[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:ProfitLossAccountReserve[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:ProfitLossAccountReserve[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
        </tr>
      </xsl:if>


      <xsl:if test='//pt:ShareholderFunds[@contextRef=$y2end] or //pt:ShareholderFunds[@contextRef=$y1end]'>
        <tr>
          <td>
<span style="font-weight:bold">Shareholders funds</span>
          </td>
          <td>

          </td>
          <td>
<xsl:if test="$fn_shareholders_funds = 1"><div style="text-align:left"><a href="#fn_shareholders_funds" style="font-weight:normal" class="footnoteLink"><xsl:value-of select="$fnn_shareholders_funds" /></a></div></xsl:if>

          </td>
          <td>

          </td>
          <td style='border-top: solid thin black; border-bottom: solid thin black;'>
<xsl:if test='//pt:ShareholderFunds[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:ShareholderFunds[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td style='border-top: solid thin black; border-bottom: solid thin black;'>
<xsl:if test='//pt:ShareholderFunds[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:ShareholderFunds[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
        </tr>
      </xsl:if>

<!--
    Equity shareholders funds
-->

      <xsl:if test='//pt:EquityShareholdersFunds[@contextRef=$y2end] or //pt:EquityShareholdersFunds[@contextRef=$y1end]'>
        <tr>
          <td>
Equity shareholders funds
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:EquityShareholdersFunds[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:EquityShareholdersFunds[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:EquityShareholdersFunds[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:EquityShareholdersFunds[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test='//pt:NonEquityShareholdersFunds[@contextRef=$y2end] or //pt:NonEquityShareholdersFunds[@contextRef=$y1end]'>
        <tr>
          <td>
Non-equity shareholders funds
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:NonEquityShareholdersFunds[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:NonEquityShareholdersFunds[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:NonEquityShareholdersFunds[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:NonEquityShareholdersFunds[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
        </tr>
      </xsl:if>
        <tr>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>

</table>
<table width="100%" style="page-break-inside: avoid">
<tr><td colspan="8" >
<ol type="a"	>
<xsl:if test="//ae:CompanyEntitledToExemptionUnderSection249A1CompaniesAct1985 = 'true'"><li>For the year ending <xsl:call-template name="formatDate"><xsl:with-param name="date" select="//gc:BalanceSheetDate"/></xsl:call-template> the company was entitled to exemption under section 249A(1) of the Companies Act 1985.</li></xsl:if>
<xsl:if test="//ae:MembersHaveNotRequiredCompanyToObtainAnAudit = 'true'"><li>Members have not required the company to obtain an audit in accordance with section 249B(2) of the Companies Act 1985</li></xsl:if>
<xsl:if test="//ae:DirectorsAcknowledgeTheirResponsibilitiesUnderCompaniesAct = 'true'"><li>The directors acknowledge their responsibility for:
<ol type="i"><li>ensuring the company keeps  accounting records which comply with Section 221; and</li>
<li>preparing accounts which give a true and fair view of the state of affairs of the company as at the end of the financial year, and of its profit or loss for the financial year, in accordance with the requirements of section 226, and which otherwise comply with the requirements of the Companies Act relating to accounts, so far as is applicable to the company.</li></ol></li></xsl:if>
<xsl:if test="//ae:AccountsAreInAccordanceWithSpecialProvisionsCompaniesActRelatingToSmallCompanies = 'true'"><li>The accounts have been prepared in accordance with the special provisions in Part VII of the Companies Act 1985 relating to small companies</li></xsl:if></ol>
<p>Approved by the board on <xsl:call-template name="formatDate"><xsl:with-param name="date" select="//pt:DateApproval"/></xsl:call-template></p>
<p>And signed on their behalf by:<br/>
<span style="padding: 0 0 0 1em; font-weight: bold"><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:NameApprovingDirector' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>, Director</span><br />
<xsl:for-each select="//pt:AdditionalApprovingPerson">
<span style="padding: 0 0 0 1em; font-weight: bold"><xsl:value-of select="./pt:NameAdditionalApprovingPerson"/>, <xsl:value-of select="./pt:PositionAdditionalApprovingPerson"/></span><br />
</xsl:for-each>
</p>
<p style="font-weight: bold">This document was delivered using electronic communications and authenticated in accordance with section 707B(2) of the Companies Act 1985.</p>
</td></tr>


</table>
<br style="page-break-after: always" />


<table width="100%" class="rnheader">
<tr><td style="font-weight: bold" align="left"><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//gc:EntityCurrentLegalName' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td><td style="font-weight: bold" align="right">Registered Number <xsl:call-template name='displayItem'><xsl:with-param name='item' select='//ae:CompaniesHouseRegisteredNumber' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td></tr>
</table>
<table border="0" width="100%">
<tr><td colspan="7" align="center"><h2>Notes to the <xsl:if test="not(//ae:DateApprovalDirectorsReport)">abbreviated </xsl:if>accounts</h2></td></tr>
<tr><td width="2%"></td><td>For the year ending <xsl:call-template name="formatDate"><xsl:with-param name="date" select="//gc:BalanceSheetDate" /></xsl:call-template></td></tr>












<!-- footnote: Profit and Loss Account -->



  <!-- footnote: accounting_policies -->
  <xsl:if test="$fn_accounting_policies=1" >
    <tr><td><xsl:value-of select="$fnn_accounting_policies"/></td><td><h3 class="nospace" style="page-break-avoid: begin">Accounting policies</h3></td></tr>
<tr><td></td><td colspan="4">

<xsl:if test="//ae:AccountsPreparedUnderHistoricalCostConventionInAccordanceWithFRSE = 'true'">
<p>The accounts have been prepared under the historical cost convention and in accordance with the Financial Reporting Standards for Small Entities (effective June 2002)</p>
</xsl:if>

<xsl:for-each select="//ae:AccountingPolicy">
  <p>
  <xsl:if test=".//ae:TitleAccountingPolicy">
    <b><xsl:value-of select=".//ae:TitleAccountingPolicy" /></b><br/>
  </xsl:if>
  <xsl:value-of select=".//ae:ContentAccountingPolicy" /></p>
</xsl:for-each>

<xsl:if test="//ae:DepreciationRate">
  <p><b>Depreciation</b></p>
  <p>Depreciation has been provided at the following rates in order to write off the assets over their estimated useful lives.</p>
  <table>
  <xsl:for-each select="//ae:DepreciationRate">
    <tr>
      <td><xsl:value-of select=".//ae:CategoryItem" /></td>
      <td style="padding-left: 40px"><xsl:value-of select=".//ae:RateDepreciation" />%</td>
      <td><xsl:value-of select=".//ae:TypeDepreciation" /></td>
    </tr>
  </xsl:for-each>
  </table><span style="page-break-avoid: end"/>
</xsl:if>
</td></tr>

  </xsl:if>
  <!-- ~footnote: accounting_policies -->


  <!-- footnote: exchange_rates -->
  <xsl:if test="$fn_exchange_rates=1" >
    <tr><td><a name="fn_exchange_rates"/><xsl:value-of select="$fnn_exchange_rates"/></td><td><h3 class="nospace" style="page-break-avoid: begin">Exchange rates</h3></td></tr>
<tr><td></td><td><p>
  <xsl:for-each select="//ae:ForeignExchangeRate">
    <xsl:value-of select="."/><br/>
  </xsl:for-each>
  </p><span style="page-break-avoid: end"/>
</td></tr>

  </xsl:if>
  <!-- ~footnote: exchange_rates -->


  <!-- footnote: called_up_share_capital_not_paid -->
  <xsl:if test="$fn_called_up_share_capital_not_paid=1" >
    <xsl:for-each select="//link:footnote[../link:loc[@xlink:href=concat(&quot;#&quot;, //pt:CalledUpShareCapitalNotPaidNotExpressedAsCurrentAsset/@id)]]">
    <tr><td>
        <xsl:value-of select='$fnn_called_up_share_capital_not_paid' />
      </td>
      <td colspan="5">
        <h3 class="nospace" style="page-break-avoid: begin"><xsl:value-of select='../@xlink:title' /></h3>
      </td>
      <td>
        <a name="fn_called_up_share_capital_not_paid" />
      </td>
    </tr>
    <tr>
    <td></td>
    <td>
        <xsl:copy-of select='./node()' /><span style="page-break-avoid: end" />
      </td>
    </tr>
    </xsl:for-each>

  </xsl:if>
  <!-- ~footnote: called_up_share_capital_not_paid -->

  <!-- footnote: ifas -->
  <xsl:if test="$fn_ifas=1" >
    	<tr><td><xsl:value-of select="$fnn_ifas"/></td><td><a name="fn_ifas"/><h3 class="nospace" style="page-break-avoid: begin">Intangible fixed assets</h3></td></tr>
	<tr><td></td><td colspan="6">
		<table width="100%">
			<xsl:variable name="ifa_s1" select="//pt:IntangibleFixedAssetsCostOrValuation[@contextRef=$y1end] or //pt:IntangibleFixedAssetsCostOrValuation[@contextRef=$y2end]"/>
			<xsl:variable name="ifa_s2" select="//pt:IntangibleFixedAssetsAggregateAmortisationImpairment[@contextRef=$y1end] or //pt:IntangibleFixedAssetsAmortisationChargedInPeriod[@contextRef=$y2] or //pt:IntangibleFixedAssetsAggregateAmortisationImpairment[@contextRef=$y2end]"/>

			<tr>
				<td align="left" width="39%"><xsl:if test="$ifa_s1">Cost Or Valuation</xsl:if></td>
				<th align="right" width="15%"><xsl:value-of select="$currencyY2"/></th>
				<td width="46%" rowspan="10"></td>
			</tr>
			<xsl:if test="//pt:IntangibleFixedAssetsCostOrValuation[@contextRef=$y1end]">
			<tr>
				<td align="left">At <xsl:call-template name="formatDate"><xsl:with-param name="date" select="//xbrli:context[@id=$y1end]//xbrli:instant" /></xsl:call-template></td>
				<td align="right"><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:IntangibleFixedAssetsCostOrValuation[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
			</tr>
			</xsl:if>
			<xsl:if test="//pt:IntangibleFixedAssetsCostOrValuation[@contextRef=$y2end]">
			<tr>
				<td align="left">At <xsl:call-template name="formatDate"><xsl:with-param name="date" select="//xbrli:context[@id=$y2end]//xbrli:instant" /></xsl:call-template></td>
				<td align="right" style="border-bottom: solid medium black"><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:IntangibleFixedAssetsCostOrValuation[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
			</tr>
			</xsl:if>
			<xsl:if test="$ifa_s2">
			<tr>
				<td colspan="2"><xsl:if test="$ifa_s1"><br/></xsl:if>Depreciation</td>
			</tr>
			</xsl:if>
			<xsl:if test="//pt:IntangibleFixedAssetsAggregateAmortisationImpairment[@contextRef=$y1end]">
			<tr>
				<td align="left">At <xsl:call-template name="formatDate"><xsl:with-param name="date" select="//xbrli:context[@id=$y1end]//xbrli:instant" /></xsl:call-template></td>
				<td align="right"><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:IntangibleFixedAssetsAggregateAmortisationImpairment[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
			</tr>
			</xsl:if>
			<xsl:if test="//pt:IntangibleFixedAssetsAmortisationChargedInPeriod[@contextRef=$y2]">
			<tr>
				<td>Charge for year</td>
				<td align="right"><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:IntangibleFixedAssetsAmortisationChargedInPeriod[@contextRef=$y2]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
			</tr>
			</xsl:if>
			<xsl:if test="//pt:IntangibleFixedAssetsAggregateAmortisationImpairment[@contextRef=$y2end]">
			<tr>
				<td align="left">At <xsl:call-template name="formatDate"><xsl:with-param name="date" select="//xbrli:context[@id=$y2end]//xbrli:instant" /></xsl:call-template></td>
				<td align="right" style="border-bottom: solid medium black"><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:IntangibleFixedAssetsAggregateAmortisationImpairment[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
			</tr>
			</xsl:if>
			<xsl:if test="//pt:IntangibleFixedAssets">
			<tr>
				<td colspan="2"><xsl:if test="$ifa_s2"><br/></xsl:if>Net Book Value</td>
			</tr>
			</xsl:if>
			<xsl:if test="//pt:IntangibleFixedAssets[@contextRef=$y1end]">
			<tr>
				<td align="left">At <xsl:call-template name="formatDate"><xsl:with-param name="date" select="//xbrli:context[@id=$y1end]//xbrli:instant" /></xsl:call-template></td>
				<td align="right"><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:IntangibleFixedAssets[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
			</tr>
			</xsl:if>
			<xsl:if test="//pt:IntangibleFixedAssets[@contextRef=$y2end]">
			<tr>
				<td align="left">At <xsl:call-template name="formatDate"><xsl:with-param name="date" select="//xbrli:context[@id=$y2end]//xbrli:instant" /></xsl:call-template></td>
				<td align="right" style="border-bottom: solid medium black"><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:IntangibleFixedAssets[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
			</tr>
			</xsl:if>

		</table><span style="page-break-avoid: end"/>
	</td></tr>

  </xsl:if>
  <!-- ~footnote: ifas -->


  <!-- footnote: tfas -->
  <xsl:if test="$fn_tfas=1" >
    	<xsl:variable name="needCol_LandBuildings">0<xsl:if test="//pt:LandBuildingsCostOrValuation[@contextRef=$y1end] or //pt:LandBuildingsAdditions or //pt:LandBuildingsDisposals or //pt:LandBuildingsCostOrValuation[@contextRef=$y2end] or //pt:LandBuildingsDepreciation[@contextRef=$y1end] or //pt:LandBuildingsDepreciationChargeForPeriod or //pt:LandBuildingsDepreciationDisposals or //pt:LandBuildingsDepreciation[@contextRef=$y2end] or //pt:LandBuildings[@contextRef=$y1end] or //pt:LandBuildings[@contextRef=$y2end]">1</xsl:if></xsl:variable>
	<xsl:variable name="needCol_PlantMachinery">0<xsl:if test="//pt:PlantMachineryCostOrValuation[@contextRef=$y1end] or //pt:PlantMachineryAdditions or //pt:PlantMachineryDisposals or //pt:PlantMachineryCostOrValuation[@contextRef=$y2end] or //pt:PlantMachineryDepreciation[@contextRef=$y1end] or //pt:PlantMachineryDepreciationChargeForPeriod or //pt:PlantMachineryDepreciationDisposals or //pt:PlantMachineryDepreciation[@contextRef=$y2end] or //pt:PlantMachinery[@contextRef=$y1end] or //pt:PlantMachinery[@contextRef=$y2end]">1</xsl:if></xsl:variable>
	<xsl:variable name="needCol_FixturesFittings">0<xsl:if test="//pt:FixturesFittingsToolsEquipmentCostOrValuation[@contextRef=$y1end] or //pt:FixturesFittingsToolsEquipmentAdditions or //pt:FixturesFittingsToolsEquipmentDisposals or //pt:FixturesFittingsToolsEquipmentCostOrValuation[@contextRef=$y2end] or //pt:FixturesFittingsToolsEquipmentDepreciation[@contextRef=$y1end] or //pt:FixturesFittingsToolsEquipmentDepreciationChargeForPeriod or //pt:FixturesFittingsToolsEquipmentDepreciationDisposals or //pt:FixturesFittingsToolsEquipmentDepreciation[@contextRef=$y2end] or //pt:FixturesFittingsToolsEquipment[@contextRef=$y1end] or //pt:FixturesFittingsToolsEquipment[@contextRef=$y2end]">1</xsl:if></xsl:variable>
	<tr><td><a name="fn_tfas"/><xsl:value-of select="$fnn_tfas"/></td><td><h3 class="nospace" style="page-break-avoid: begin">Tangible fixed assets</h3></td></tr>
	<tr><td></td><td colspan="7">
		<table width="100%" style="text-align: right">
			<tr>
        <!-- 
          Columns in this table are a fixed width of 14%.  Adjust the size of
          the first column to match. 
        -->
        <xsl:variable name="tfa_number_columns" select="1 + $needCol_LandBuildings + $needCol_PlantMachinery + $needCol_FixturesFittings + count(//ae:OtherTypeTangibleFixedAsset-Analysis)" />
        <xsl:if test="tfa_number_columns > 5">
				<xsl:message terminate="yes">REJECTION - Only 4 different types of Tangible Assets are allowed plus the total column - REJECTION </xsl:message>
		</xsl:if>
				<td width="{100 - $tfa_number_columns * 14}%"></td>
        <xsl:choose>
            <xsl:when test="$needCol_LandBuildings = 1">
              <th align="right" width="14%">Land &amp; Buildings</th>
            </xsl:when>
            <xsl:otherwise>
              <th width="0"></th>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="$needCol_PlantMachinery = 1">
              <th align="right" width="14%">Plant &amp; Machinery</th>
            </xsl:when>
            <xsl:otherwise>
              <th width="0"></th>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="$needCol_FixturesFittings = 1">
              <th align="right" width="14%">Fixtures &amp; Fittings</th>
            </xsl:when>
            <xsl:otherwise>
              <th width="0"></th>
            </xsl:otherwise>
        </xsl:choose>
				<xsl:for-each select="//ae:OtherTypeTangibleFixedAsset-Analysis">
					<th align="right" width="14%"><xsl:value-of select=".//ae:NameTypeTangibleFixedAsset" /></th>
				</xsl:for-each>
				<th align="right" width="14%">Total</th>
			</tr>

			<xsl:variable name="tfa_s1" select="//pt:LandBuildingsCostOrValuation[@contextRef=$y1end] or //pt:PlantMachineryCostOrValuation[@contextRef=$y1end] or //pt:FixturesFittingsToolsEquipmentCostOrValuation[@contextRef=$y1end] or //ae:OtherTangibleFixedAssetCostOrValuation[@contextRef=$y1end] or //pt:TangibleFixedAssetsCostOrValuation[@contextRef=$y1end]" />
			<xsl:variable name="tfa_s2" select="//pt:LandBuildingsAdditions or //pt:PlantMachineryAdditions or //pt:FixturesFittingsToolsEquipmentAdditions or //ae:OtherTangibleFixedAssetAdditions or //pt:TangibleFixedAssetsAdditions" />
			<xsl:variable name="tfa_s3" select="//pt:LandBuildingsDisposals or //pt:PlantMachineryDisposals or //pt:FixturesFittingsToolsEquipmentDisposals or //ae:OtherTangibleFixedAssetDisposals or //pt:TangibleFixedAssetsDisposals" />
			<xsl:variable name="tfa_s4" select="//pt:LandBuildingsCostOrValuation[@contextRef=$y2end] or //pt:PlantMachineryCostOrValuation[@contextRef=$y2end] or //pt:FixturesFittingsToolsEquipmentCostOrValuation[@contextRef=$y2end] or //ae:OtherTangibleFixedAssetCostOrValuation[@contextRef=$y2end] or //pt:TangibleFixedAssetsCostOrValuation[@contextRef=$y2end]" />

			<tr>
				<td align="left"><xsl:if test="$tfa_s1 or $tfa_s2 or $tfa_s3 or $tfa_s4">Cost</xsl:if></td>
				<th align="right">
					<xsl:if test="$needCol_LandBuildings = 1"><xsl:value-of select="$currencyY2"/></xsl:if>
				</th>
				<th align="right">
					<xsl:if test="$needCol_PlantMachinery = 1"><xsl:value-of select="$currencyY2"/></xsl:if>
				</th>
				<th align="right">
					<xsl:if test="$needCol_FixturesFittings = 1"><xsl:value-of select="$currencyY2"/></xsl:if>
				</th>
				<xsl:for-each select="//ae:OtherTypeTangibleFixedAsset-Analysis">
					<th align="right"><xsl:value-of select="$currencyY2"/></th>
				</xsl:for-each>
				<th align="right"><xsl:value-of select="$currencyY2"/></th>
			</tr>

			<xsl:if test="$tfa_s1">
			<tr>
				<td align="left">At <xsl:call-template name="formatDate"><xsl:with-param name="date" select="//xbrli:context[@id=$y1end]//xbrli:instant" /></xsl:call-template></td>
				<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:LandBuildingsCostOrValuation[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:PlantMachineryCostOrValuation[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:FixturesFittingsToolsEquipmentCostOrValuation[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				<xsl:for-each select="//ae:OtherTypeTangibleFixedAsset-Analysis">
					<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='.//ae:OtherTangibleFixedAssetCostOrValuation[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				</xsl:for-each>
				<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:TangibleFixedAssetsCostOrValuation[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
			</tr>
			</xsl:if>

			<xsl:if test="$tfa_s2">
			<tr>
				<td align="left">additions</td>
				<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:LandBuildingsAdditions' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:PlantMachineryAdditions' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:FixturesFittingsToolsEquipmentAdditions' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				<xsl:for-each select="//ae:OtherTypeTangibleFixedAsset-Analysis">
					<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='.//ae:OtherTangibleFixedAssetAdditions' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				</xsl:for-each>
				<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:TangibleFixedAssetsAdditions' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
			</tr>
			</xsl:if>

			<xsl:if test="$tfa_s3">
			<tr>
				<td align="left">disposals</td>
				<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:LandBuildingsDisposals' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:PlantMachineryDisposals' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:FixturesFittingsToolsEquipmentDisposals' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				<xsl:for-each select="//ae:OtherTypeTangibleFixedAsset-Analysis">
					<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='.//ae:OtherTangibleFixedAssetDisposals' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				</xsl:for-each>
				<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:TangibleFixedAssetsDisposals' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
			</tr>
			</xsl:if>

			<xsl:if test="$tfa_s4">
			<tr>
				<td align="left">At <xsl:call-template name="formatDate"><xsl:with-param name="date" select="//xbrli:context[@id=$y2end]//xbrli:instant" /></xsl:call-template></td>
				<td style="border-top: solid thin black; border-bottom: solid medium black"><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:LandBuildingsCostOrValuation[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				<td style="border-top: solid thin black; border-bottom: solid medium black"><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:PlantMachineryCostOrValuation[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				<td style="border-top: solid thin black; border-bottom: solid medium black"><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:FixturesFittingsToolsEquipmentCostOrValuation[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				<xsl:for-each select="//ae:OtherTypeTangibleFixedAsset-Analysis">
					<td style="border-top: solid thin black; border-bottom: solid medium black"><xsl:call-template name='displayItem'><xsl:with-param name='item' select='.//ae:OtherTangibleFixedAssetCostOrValuation[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
        </xsl:for-each>
        <td style="border-top: solid thin black; border-bottom: solid medium black; padding-left: 5px"><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:TangibleFixedAssetsCostOrValuation[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
			</tr>
			</xsl:if>

			<xsl:variable name="tfa_s5" select="//pt:LandBuildingsDepreciation[@contextRef=$y1end] or //pt:PlantMachineryDepreciation[@contextRef=$y1end] or //pt:FixturesFittingsToolsEquipmentDepreciation[@contextRef=$y1end] or //ae:OtherTangibleFixedAssetDepreciation[@contextRef=$y1end] or //pt:TangibleFixedAssetsDepreciation[@contextRef=$y1end]"/>
			<xsl:variable name="tfa_s6" select="//pt:LandBuildingsDepreciationChargeForPeriod or //pt:PlantMachineryDepreciationChargeForPeriod or //pt:FixturesFittingsToolsEquipmentDepreciationChargeForPeriod or //ae:OtherTangibleFixedAssetDepreciationChargeForPeriod or //pt:TangibleFixedAssetsDepreciationChargeForPeriod"/>
			<xsl:variable name="tfa_s7" select="//pt:LandBuildingsDepreciationDisposals or //pt:PlantMachineryDepreciationDisposals or //pt:FixturesFittingsToolsEquipmentDepreciationDisposals or //ae:OtherTangibleFixedAssetDepreciationDisposals or //pt:TangibleFixedAssetsDepreciationDisposals"/>
			<xsl:variable name="tfa_s8" select="//pt:LandBuildingsDepreciation[@contextRef=$y2end] or //pt:PlantMachineryDepreciation[@contextRef=$y2end] or //pt:FixturesFittingsToolsEquipmentDepreciation[@contextRef=$y2end] or //ae:OtherTangibleFixedAssetDepreciation[@contextRef=$y2end] or //pt:TangibleFixedAssetsDepreciation[@contextRef=$y2end]"/>

			<xsl:if test="$tfa_s5 or $tfa_s6 or $tfa_s7 or $tfa_s8">
			<tr>
				<td align="left" colspan="5"><xsl:if test="$tfa_s1 or $tfa_s2 or $tfa_s3 or $tfa_s4"><br/></xsl:if>Depreciation</td>
			</tr>
			</xsl:if>

			<xsl:if test="$tfa_s5">
			<tr>
				<td align="left">At <xsl:call-template name="formatDate"><xsl:with-param name="date" select="//xbrli:context[@id=$y1end]//xbrli:instant" /></xsl:call-template></td>
				<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:LandBuildingsDepreciation[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:PlantMachineryDepreciation[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:FixturesFittingsToolsEquipmentDepreciation[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				<xsl:for-each select="//ae:OtherTypeTangibleFixedAsset-Analysis">
					<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='.//ae:OtherTangibleFixedAssetDepreciation[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				</xsl:for-each>
				<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:TangibleFixedAssetsDepreciation[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
			</tr>
			</xsl:if>

			<xsl:if test="$tfa_s6">
			<tr>
				<td align="left">Charge for year</td>
				<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:LandBuildingsDepreciationChargeForPeriod' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:PlantMachineryDepreciationChargeForPeriod' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:FixturesFittingsToolsEquipmentDepreciationChargeForPeriod' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				<xsl:for-each select="//ae:OtherTypeTangibleFixedAsset-Analysis">
					<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='.//ae:OtherTangibleFixedAssetDepreciationChargeForPeriod' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				</xsl:for-each>
				<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:TangibleFixedAssetsDepreciationChargeForPeriod' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
			</tr>
			</xsl:if>

			<xsl:if test="$tfa_s7">
			<tr>
				<td align="left">on disposals</td>
				<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:LandBuildingsDepreciationDisposals' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:PlantMachineryDepreciationDisposals' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:FixturesFittingsToolsEquipmentDepreciationDisposals' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				<xsl:for-each select="//ae:OtherTypeTangibleFixedAsset-Analysis">
					<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='.//ae:OtherTangibleFixedAssetDepreciationDisposals' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				</xsl:for-each>
				<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:TangibleFixedAssetsDepreciationDisposals' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
			</tr>
			</xsl:if>


			<xsl:if test="$tfa_s8">
			<tr>
				<td align="left">At <xsl:call-template name="formatDate"><xsl:with-param name="date" select="//xbrli:context[@id=$y2end]//xbrli:instant" /></xsl:call-template></td>
				<td style="border-top: solid thin black; border-bottom: solid medium black"><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:LandBuildingsDepreciation[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				<td style="border-top: solid thin black; border-bottom: solid medium black"><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:PlantMachineryDepreciation[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				<td style="border-top: solid thin black; border-bottom: solid medium black"><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:FixturesFittingsToolsEquipmentDepreciation[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				<xsl:for-each select="//ae:OtherTypeTangibleFixedAsset-Analysis">
					<td style="border-top: solid thin black; border-bottom: solid medium black"><xsl:call-template name='displayItem'><xsl:with-param name='item' select='.//ae:OtherTangibleFixedAssetDepreciation[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				</xsl:for-each>
				<td style="border-top: solid thin black; border-bottom: solid medium black"><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:TangibleFixedAssetsDepreciation[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
			</tr>
			</xsl:if>

			<xsl:variable name="tfa_s9" select="//pt:LandBuildings[@contextRef=$y1end] or //pt:PlantMachinery[@contextRef=$y1end] or //pt:FixturesFittingsToolsEquipment[@contextRef=$y1end] or //ae:OtherTangibleFixedAsset[@contextRef=$y2start] or //pt:TangibleFixedAssets[@contextRef=$y1end]"/>
			<xsl:variable name="tfa_s10" select="//pt:LandBuildings[@contextRef=$y2end] or //pt:PlantMachinery[@contextRef=$y2end] or //pt:FixturesFittingsToolsEquipment[@contextRef=$y2end] or //ae:OtherTangibleFixedAsset[@contextRef=$y2end] or //pt:TangibleFixedAssets[@contextRef=$y2end]"/>

			<xsl:if test="$tfa_s9 or $tfa_s10">
			<tr>
				<td align="left" colspan="5"><xsl:if test="$tfa_s5 or $tfa_s6 or $tfa_s7 or $tfa_s8"><br/></xsl:if>Net Book Value</td>
			</tr>
			</xsl:if>

			<xsl:if test="$tfa_s9">
			<tr>
				<td align="left">At <xsl:call-template name="formatDate"><xsl:with-param name="date" select="//xbrli:context[@id=$y1end]//xbrli:instant" /></xsl:call-template></td>
				<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:LandBuildings[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:PlantMachinery[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:FixturesFittingsToolsEquipment[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				<xsl:for-each select="//ae:OtherTypeTangibleFixedAsset-Analysis">
					<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='.//ae:OtherTangibleFixedAsset[@contextRef=$y2start]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				</xsl:for-each>
				<td><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:TangibleFixedAssets[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
			</tr>
			</xsl:if>

			<xsl:if test="$tfa_s10">
			<tr>
				<td align="left">At <xsl:call-template name="formatDate"><xsl:with-param name="date" select="//xbrli:context[@id=$y2end]//xbrli:instant" /></xsl:call-template></td>
				<td style="border-bottom: solid medium black"><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:LandBuildings[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				<td style="border-bottom: solid medium black"><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:PlantMachinery[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				<td style="border-bottom: solid medium black"><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:FixturesFittingsToolsEquipment[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				<xsl:for-each select="//ae:OtherTypeTangibleFixedAsset-Analysis">
					<td style="border-bottom: solid medium black"><xsl:call-template name='displayItem'><xsl:with-param name='item' select='.//ae:OtherTangibleFixedAsset[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
				</xsl:for-each>
				<td style="border-bottom: solid medium black"><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:TangibleFixedAssets[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td>
			</tr>
			</xsl:if>
		</table><span style="page-break-avoid: end" />
	</td></tr>

  </xsl:if>
  <!-- ~footnote: tfas -->


  <!-- footnote: investments -->
  <xsl:if test="$fn_investments=1" >
    <xsl:for-each select="//link:footnote[../link:loc[@xlink:href=concat(&quot;#&quot;, //pt:TotalInvestmentsFixedAssets/@id)]]">
    <tr><td>
        <xsl:value-of select='$fnn_investments' />
      </td>
      <td colspan="5">
        <h3 class="nospace" style="page-break-avoid: begin"><xsl:value-of select='../@xlink:title' /></h3>
      </td>
      <td>
        <a name="fn_investments" />
      </td>
    </tr>
    <tr>
    <td></td>
    <td>
        <xsl:copy-of select='./node()' /><span style="page-break-avoid: end" />
      </td>
    </tr>
    </xsl:for-each>

  </xsl:if>
  <!-- ~footnote: investments -->

  <!-- footnote: fixed_assets -->
  <xsl:if test="$fn_fixed_assets=1" >
    <xsl:for-each select="//link:footnote[../link:loc[@xlink:href=concat(&quot;#&quot;, //pt:FixedAssets/@id)]]">
    <tr><td>
        <xsl:value-of select='$fnn_fixed_assets' />
      </td>
      <td colspan="5">
        <h3 class="nospace" style="page-break-avoid: begin"><xsl:value-of select='../@xlink:title' /></h3>
      </td>
      <td>
        <a name="fn_fixed_assets" />
      </td>
    </tr>
    <tr>
    <td></td>
    <td>
        <xsl:copy-of select='./node()' /><span style="page-break-avoid: end" />
      </td>
    </tr>
    </xsl:for-each>

  </xsl:if>
  <!-- ~footnote: fixed_assets -->

  <!-- footnote: stocks -->
  <xsl:if test="$fn_stocks=1" >
    <xsl:for-each select="//link:footnote[../link:loc[@xlink:href=concat(&quot;#&quot;, //pt:StocksInventory/@id)]]">
    <tr><td>
        <xsl:value-of select='$fnn_stocks' />
      </td>
      <td colspan="5">
        <h3 class="nospace" style="page-break-avoid: begin"><xsl:value-of select='../@xlink:title' /></h3>
      </td>
      <td>
        <a name="fn_stocks" />
      </td>
    </tr>
    <tr>
    <td></td>
    <td>
        <xsl:copy-of select='./node()' /><span style="page-break-avoid: end" />
      </td>
    </tr>
    </xsl:for-each>

  </xsl:if>
  <!-- ~footnote: stocks -->

  <!-- footnote: debtors -->
  <xsl:if test="$fn_debtors=1" >
    	<tr>
		<td><xsl:value-of select="$fnn_debtors"/></td><td><a name="fn_debtors"/><h3 class="nospace" style="page-break-avoid: begin">Debtors</h3></td>
	</tr>
	<tr><td></td><td width="50%" colspan="2"></td><th align="right" width="15%"><xsl:value-of select="$namey2" /></th><th align="right" width="15%"><xsl:value-of select="$namey1" /></th><td colspan="3" width="1%"></td></tr>
<tr style="font-weight: bold">
  <td></td>
  <td></td>
  <td></td>
  <td class="rightalign"><xsl:value-of select="$currencyY2"/></td>
  <td class="rightalign"><xsl:value-of select="$currencyY1"/></td>
</tr>
<xsl:if test="//pt:TradeDebtors">

<!--
    Trade debtors
-->

      <xsl:if test='//pt:TradeDebtors[@contextRef=$y2end] or //pt:TradeDebtors[@contextRef=$y1end]'>
        <tr>
          <td>

          </td>
          <td>
Trade debtors
          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:TradeDebtors[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:TradeDebtors[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>
<xsl:if test='//pt:TradeDebtors[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:TradeDebtors[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
      </xsl:if>
</xsl:if>
<xsl:if test="//pt:OtherDebtors">

<!--
    Other debtors
-->

      <xsl:if test='//pt:OtherDebtors[@contextRef=$y2end] or //pt:OtherDebtors[@contextRef=$y1end]'>
        <tr>
          <td>

          </td>
          <td>
Other debtors
          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:OtherDebtors[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:OtherDebtors[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>
<xsl:if test='//pt:OtherDebtors[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:OtherDebtors[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
      </xsl:if>
</xsl:if>
<xsl:if test="//pt:PrepaymentsAccruedIncomeCurrentAsset">

<!--
    Prepayments and accrued income
-->

      <xsl:if test='//pt:PrepaymentsAccruedIncomeCurrentAsset[@contextRef=$y2end] or //pt:PrepaymentsAccruedIncomeCurrentAsset[@contextRef=$y1end]'>
        <tr>
          <td>

          </td>
          <td>
Prepayments and accrued income
          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:PrepaymentsAccruedIncomeCurrentAsset[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:PrepaymentsAccruedIncomeCurrentAsset[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>
<xsl:if test='//pt:PrepaymentsAccruedIncomeCurrentAsset[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:PrepaymentsAccruedIncomeCurrentAsset[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
      </xsl:if>
</xsl:if>
<xsl:if test="//pt:CalledUpShareCapitalNotPaidCurrentAsset">

<!--
    Called up share capital not paid (Current Asset)
-->

      <xsl:if test='//pt:CalledUpShareCapitalNotPaidCurrentAsset[@contextRef=$y2end] or //pt:CalledUpShareCapitalNotPaidCurrentAsset[@contextRef=$y1end]'>
        <tr>
          <td>

          </td>
          <td>
Called up share capital not paid (Current Asset)
          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:CalledUpShareCapitalNotPaidCurrentAsset[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:CalledUpShareCapitalNotPaidCurrentAsset[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>
<xsl:if test='//pt:CalledUpShareCapitalNotPaidCurrentAsset[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:CalledUpShareCapitalNotPaidCurrentAsset[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
      </xsl:if>
</xsl:if>
<xsl:variable name="debtors_total_row_title">
	<xsl:if test="not(//pt:TradeDebtors or //pt:OtherDebtors or //pt:PrepaymentsAccruedIncomeCurrentAsset or //pt:CalledUpShareCapitalNotPaidCurrentAsset)">Total</xsl:if>
</xsl:variable>
      <xsl:if test='//pt:Debtors[@contextRef=$y2end] or //pt:Debtors[@contextRef=$y1end]'>
        <tr>
          <td>

          </td>
          <td>
<xsl:value-of select="$debtors_total_row_title"/>
          </td>
          <td>

          </td>
          <td style='border-top: solid thin black'>
<xsl:if test='//pt:Debtors[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:Debtors[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td style='border-top: solid thin black'>
<xsl:if test='//pt:Debtors[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:Debtors[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
      </xsl:if>
<tr><td colspan="7"><span style="page-break-avoid: end" /></td></tr>

  </xsl:if>
  <!-- ~footnote: debtors -->


  <!-- footnote: investments_ca -->
  <xsl:if test="$fn_investments_ca=1" >
    <xsl:for-each select="//link:footnote[../link:loc[@xlink:href=concat(&quot;#&quot;, //pt:InvestmentsCurrentAssets/@id)]]">
    <tr><td>
        <xsl:value-of select='$fnn_investments_ca' />
      </td>
      <td colspan="5">
        <h3 class="nospace" style="page-break-avoid: begin"><xsl:value-of select='../@xlink:title' /></h3>
      </td>
      <td>
        <a name="fn_investments_ca" />
      </td>
    </tr>
    <tr>
    <td></td>
    <td>
        <xsl:copy-of select='./node()' /><span style="page-break-avoid: end" />
      </td>
    </tr>
    </xsl:for-each>

  </xsl:if>
  <!-- ~footnote: investments_ca -->

  <!-- footnote: cash_at_bank_in_hand -->
  <xsl:if test="$fn_cash_at_bank_in_hand=1" >
    <xsl:for-each select="//link:footnote[../link:loc[@xlink:href=concat(&quot;#&quot;, //pt:CashBankInHand/@id)]]">
    <tr><td>
        <xsl:value-of select='$fnn_cash_at_bank_in_hand' />
      </td>
      <td colspan="5">
        <h3 class="nospace" style="page-break-avoid: begin"><xsl:value-of select='../@xlink:title' /></h3>
      </td>
      <td>
        <a name="fn_cash_at_bank_in_hand" />
      </td>
    </tr>
    <tr>
    <td></td>
    <td>
        <xsl:copy-of select='./node()' /><span style="page-break-avoid: end" />
      </td>
    </tr>
    </xsl:for-each>

  </xsl:if>
  <!-- ~footnote: cash_at_bank_in_hand -->

  <!-- footnote: total_current_assets -->
  <xsl:if test="$fn_total_current_assets=1" >
    <xsl:for-each select="//link:footnote[../link:loc[@xlink:href=concat(&quot;#&quot;, //pt:CurrentAssets/@id)]]">
    <tr><td>
        <xsl:value-of select='$fnn_total_current_assets' />
      </td>
      <td colspan="5">
        <h3 class="nospace" style="page-break-avoid: begin"><xsl:value-of select='../@xlink:title' /></h3>
      </td>
      <td>
        <a name="fn_total_current_assets" />
      </td>
    </tr>
    <tr>
    <td></td>
    <td>
        <xsl:copy-of select='./node()' /><span style="page-break-avoid: end" />
      </td>
    </tr>
    </xsl:for-each>

  </xsl:if>
  <!-- ~footnote: total_current_assets -->

  <!-- footnote: prepayments_accrued_income -->
  <xsl:if test="$fn_prepayments_accrued_income=1" >
    <xsl:for-each select="//link:footnote[../link:loc[@xlink:href=concat(&quot;#&quot;, //pt:PrepaymentsAccruedIncomeNotExpressedWithinCurrentAssetSub-total/@id)]]">
    <tr><td>
        <xsl:value-of select='$fnn_prepayments_accrued_income' />
      </td>
      <td colspan="5">
        <h3 class="nospace" style="page-break-avoid: begin"><xsl:value-of select='../@xlink:title' /></h3>
      </td>
      <td>
        <a name="fn_prepayments_accrued_income" />
      </td>
    </tr>
    <tr>
    <td></td>
    <td>
        <xsl:copy-of select='./node()' /><span style="page-break-avoid: end" />
      </td>
    </tr>
    </xsl:for-each>

  </xsl:if>
  <!-- ~footnote: prepayments_accrued_income -->

  <!-- footnote: creditors_lt_one_year -->
  <xsl:if test="$fn_creditors_lt_one_year=1" >
    	<tr>
		<td><xsl:value-of select="$fnn_creditors_lt_one_year"/></td><td colspan="6"><a name="fn_creditors_lt_one_year"/><h3 class="nospace" style="page-break-avoid: begin">Creditors: amounts falling due within one year</h3></td>
	</tr>
	<tr><td></td><td width="50%" colspan="2"></td><th align="right" width="15%"><xsl:value-of select="$namey2" /></th><th align="right" width="15%"><xsl:value-of select="$namey1" /></th><td colspan="3" width="1%"></td></tr>
<tr style="font-weight: bold">
  <td></td>
  <td></td>
  <td></td>
  <td class="rightalign"><xsl:value-of select="$currencyY2"/></td>
  <td class="rightalign"><xsl:value-of select="$currencyY1"/></td>
</tr>
<xsl:if test="//pt:BankLoansOverdraftsWithinOneYear">

<!--
    Bank loans
-->

      <xsl:if test='//pt:BankLoansOverdraftsWithinOneYear[@contextRef=$y2end] or //pt:BankLoansOverdraftsWithinOneYear[@contextRef=$y1end]'>
        <tr>
          <td>

          </td>
          <td>
Bank loans
          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:BankLoansOverdraftsWithinOneYear[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:BankLoansOverdraftsWithinOneYear[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>
<xsl:if test='//pt:BankLoansOverdraftsWithinOneYear[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:BankLoansOverdraftsWithinOneYear[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
      </xsl:if>
</xsl:if>
<xsl:if test="//pt:TradeCreditorsWithinOneYear">

<!--
    Trade creditors
-->

      <xsl:if test='//pt:TradeCreditorsWithinOneYear[@contextRef=$y2end] or //pt:TradeCreditorsWithinOneYear[@contextRef=$y1end]'>
        <tr>
          <td>

          </td>
          <td>
Trade creditors
          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:TradeCreditorsWithinOneYear[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:TradeCreditorsWithinOneYear[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>
<xsl:if test='//pt:TradeCreditorsWithinOneYear[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:TradeCreditorsWithinOneYear[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
      </xsl:if>
</xsl:if>
<xsl:if test="//pt:AccrualsDeferredIncomeWithinOneYear">

<!--
    Accruals and deferred income
-->

      <xsl:if test='//pt:AccrualsDeferredIncomeWithinOneYear[@contextRef=$y2end] or //pt:AccrualsDeferredIncomeWithinOneYear[@contextRef=$y1end]'>
        <tr>
          <td>

          </td>
          <td>
Accruals and deferred income
          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:AccrualsDeferredIncomeWithinOneYear[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:AccrualsDeferredIncomeWithinOneYear[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>
<xsl:if test='//pt:AccrualsDeferredIncomeWithinOneYear[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:AccrualsDeferredIncomeWithinOneYear[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
      </xsl:if>
</xsl:if>
<xsl:if test="//pt:OtherCreditorsDueWithinOneYear">

<!--
    Other creditors
-->

      <xsl:if test='//pt:OtherCreditorsDueWithinOneYear[@contextRef=$y2end] or //pt:OtherCreditorsDueWithinOneYear[@contextRef=$y1end]'>
        <tr>
          <td>

          </td>
          <td>
Other creditors
          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:OtherCreditorsDueWithinOneYear[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:OtherCreditorsDueWithinOneYear[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>
<xsl:if test='//pt:OtherCreditorsDueWithinOneYear[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:OtherCreditorsDueWithinOneYear[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
      </xsl:if>
</xsl:if>
<xsl:if test="//pt:TaxationSocialSecurityDueWithinOneYear">

<!--
    Taxation and Social Security
-->

      <xsl:if test='//pt:TaxationSocialSecurityDueWithinOneYear[@contextRef=$y2end] or //pt:TaxationSocialSecurityDueWithinOneYear[@contextRef=$y1end]'>
        <tr>
          <td>

          </td>
          <td>
Taxation and Social Security
          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:TaxationSocialSecurityDueWithinOneYear[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:TaxationSocialSecurityDueWithinOneYear[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>
<xsl:if test='//pt:TaxationSocialSecurityDueWithinOneYear[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:TaxationSocialSecurityDueWithinOneYear[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
      </xsl:if>
</xsl:if>
      <xsl:if test='//pt:CreditorsDueWithinOneYearTotalCurrentLiabilities[@contextRef=$y2end] or //pt:CreditorsDueWithinOneYearTotalCurrentLiabilities[@contextRef=$y1end]'>
        <tr>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td style='border-top: solid thin black'>
<xsl:if test='//pt:CreditorsDueWithinOneYearTotalCurrentLiabilities[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:CreditorsDueWithinOneYearTotalCurrentLiabilities[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td style='border-top: solid thin black'>
<xsl:if test='//pt:CreditorsDueWithinOneYearTotalCurrentLiabilities[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:CreditorsDueWithinOneYearTotalCurrentLiabilities[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
      </xsl:if>
<tr><td colspan="7"><span style="page-break-avoid: end" /></td></tr>

  </xsl:if>
  <!-- ~footnote: creditors_lt_one_year -->


  <!-- footnote: net_current_assets -->
  <xsl:if test="$fn_net_current_assets=1" >
    <xsl:for-each select="//link:footnote[../link:loc[@xlink:href=concat(&quot;#&quot;, //pt:NetCurrentAssetsLiabilities/@id)]]">
    <tr><td>
        <xsl:value-of select='$fnn_net_current_assets' />
      </td>
      <td colspan="5">
        <h3 class="nospace" style="page-break-avoid: begin"><xsl:value-of select='../@xlink:title' /></h3>
      </td>
      <td>
        <a name="fn_net_current_assets" />
      </td>
    </tr>
    <tr>
    <td></td>
    <td>
        <xsl:copy-of select='./node()' /><span style="page-break-avoid: end" />
      </td>
    </tr>
    </xsl:for-each>

  </xsl:if>
  <!-- ~footnote: net_current_assets -->

  <!-- footnote: creditors_gt_one_year -->
  <xsl:if test="$fn_creditors_gt_one_year=1" >
    	<tr>
		<td><xsl:value-of select="$fnn_creditors_gt_one_year"/></td><td colspan="6"><a name="fn_creditors_gt_one_year"/><h3 class="nospace" style="page-break-avoid: begin">Creditors amounts falling due after one year</h3></td>
	</tr>
	<tr><td></td><td width="50%" colspan="2"></td><th align="right" width="15%"><xsl:value-of select="$namey2" /></th><th align="right" width="15%"><xsl:value-of select="$namey1" /></th><td colspan="3" width="1%"></td></tr>
<tr style="font-weight: bold">
  <td></td>
  <td></td>
  <td></td>
  <td class="rightalign"><xsl:value-of select="$currencyY2"/></td>
  <td class="rightalign"><xsl:value-of select="$currencyY1"/></td>
</tr>

<!--
    Bank loans and overdrafts
-->

      <xsl:if test='//pt:BankLoansOverdraftsAfterOneYear[@contextRef=$y2end] or //pt:BankLoansOverdraftsAfterOneYear[@contextRef=$y1end]'>
        <tr>
          <td>

          </td>
          <td>
Bank loans and overdrafts
          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:BankLoansOverdraftsAfterOneYear[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:BankLoansOverdraftsAfterOneYear[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>
<xsl:if test='//pt:BankLoansOverdraftsAfterOneYear[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:BankLoansOverdraftsAfterOneYear[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
      </xsl:if>

<!--
    Obligations under finance leases
-->

      <xsl:if test='//pt:ObligationsUnderFinanceLeaseHirePurchaseContractsAfterOneYear[@contextRef=$y2end] or //pt:ObligationsUnderFinanceLeaseHirePurchaseContractsAfterOneYear[@contextRef=$y1end]'>
        <tr>
          <td>

          </td>
          <td>
Obligations under finance leases
          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:ObligationsUnderFinanceLeaseHirePurchaseContractsAfterOneYear[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:ObligationsUnderFinanceLeaseHirePurchaseContractsAfterOneYear[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>
<xsl:if test='//pt:ObligationsUnderFinanceLeaseHirePurchaseContractsAfterOneYear[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:ObligationsUnderFinanceLeaseHirePurchaseContractsAfterOneYear[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
      </xsl:if>
      <xsl:if test='//pt:CreditorsDueAfterOneYearTotalNoncurrentLiabilities[@contextRef=$y2end] or //pt:CreditorsDueAfterOneYearTotalNoncurrentLiabilities[@contextRef=$y1end]'>
        <tr>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td style='border-top: solid thin black'>
<xsl:if test='//pt:CreditorsDueAfterOneYearTotalNoncurrentLiabilities[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:CreditorsDueAfterOneYearTotalNoncurrentLiabilities[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td style='border-top: solid thin black'>
<xsl:if test='//pt:CreditorsDueAfterOneYearTotalNoncurrentLiabilities[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:CreditorsDueAfterOneYearTotalNoncurrentLiabilities[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
      </xsl:if>
<tr><td colspan="7"><span style="page-break-avoid: end" /></td></tr>

  </xsl:if>
  <!-- ~footnote: creditors_gt_one_year -->


  <!-- footnote: provisions_liabilities_charges -->
  <xsl:if test="$fn_provisions_liabilities_charges=1" >
    <xsl:for-each select="//link:footnote[../link:loc[@xlink:href=concat(&quot;#&quot;, //pt:ProvisionsForLiabilitiesCharges/@id)]]">
    <tr><td>
        <xsl:value-of select='$fnn_provisions_liabilities_charges' />
      </td>
      <td colspan="5">
        <h3 class="nospace" style="page-break-avoid: begin"><xsl:value-of select='../@xlink:title' /></h3>
      </td>
      <td>
        <a name="fn_provisions_liabilities_charges" />
      </td>
    </tr>
    <tr>
    <td></td>
    <td>
        <xsl:copy-of select='./node()' /><span style="page-break-avoid: end" />
      </td>
    </tr>
    </xsl:for-each>

  </xsl:if>
  <!-- ~footnote: provisions_liabilities_charges -->

  <!-- footnote: accruals_deferred_income -->
  <xsl:if test="$fn_accruals_deferred_income=1" >
    <xsl:for-each select="//link:footnote[../link:loc[@xlink:href=concat(&quot;#&quot;, //pt:AccrualsDeferredIncome/@id)]]">
    <tr><td>
        <xsl:value-of select='$fnn_accruals_deferred_income' />
      </td>
      <td colspan="5">
        <h3 class="nospace" style="page-break-avoid: begin"><xsl:value-of select='../@xlink:title' /></h3>
      </td>
      <td>
        <a name="fn_accruals_deferred_income" />
      </td>
    </tr>
    <tr>
    <td></td>
    <td>
        <xsl:copy-of select='./node()' /><span style="page-break-avoid: end" />
      </td>
    </tr>
    </xsl:for-each>

  </xsl:if>
  <!-- ~footnote: accruals_deferred_income -->

  <!-- footnote: total_net_assets -->
  <xsl:if test="$fn_total_net_assets=1" >
    <xsl:for-each select="//link:footnote[../link:loc[@xlink:href=concat(&quot;#&quot;, //pt:NetAssetsLiabilitiesIncludingPensionAssetLiability/@id)]]">
    <tr><td>
        <xsl:value-of select='$fnn_total_net_assets' />
      </td>
      <td colspan="5">
        <h3 class="nospace" style="page-break-avoid: begin"><xsl:value-of select='../@xlink:title' /></h3>
      </td>
      <td>
        <a name="fn_total_net_assets" />
      </td>
    </tr>
    <tr>
    <td></td>
    <td>
        <xsl:copy-of select='./node()' /><span style="page-break-avoid: end" />
      </td>
    </tr>
    </xsl:for-each>

  </xsl:if>
  <!-- ~footnote: total_net_assets -->

  <!-- footnote: capital -->
  <xsl:if test="$fn_capital=1" >
    	<tr>
		<td><xsl:value-of select="$fnn_capital"/></td><td><a name="fn_capital"/><h3 class="nospace" style="page-break-avoid: begin">Share capital</h3></td>
	</tr>
	<tr><td></td><td width="50%" colspan="2"></td><th align="right" width="15%"><xsl:value-of select="$namey2" /></th><th align="right" width="15%"><xsl:value-of select="$namey1" /></th><td colspan="3" width="1%"></td></tr>
<tr style="font-weight: bold">
  <td></td>
  <td></td>
  <td></td>
  <td class="rightalign"><xsl:value-of select="$currencyY2"/></td>
  <td class="rightalign"><xsl:value-of select="$currencyY1"/></td>
</tr>
        <tr>
          <td>

          </td>
          <td>
Authorised share capital:
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>

<xsl:for-each select="//pt:EquityAuthorisedDetails">
  <xsl:variable name="t" select="." />
  <xsl:variable name="numy2" select="./pt:NumberOrdinarySharesAuthorised[@contextRef=$y2end]"/>
  <xsl:variable name="numy1" select="./pt:NumberOrdinarySharesAuthorised[@contextRef=$y1end]"/>
      <xsl:if test='//pt:ValueOrdinarySharesAuthorised[..=$t and @contextRef=$y2end] or //pt:ValueOrdinarySharesAuthorised[..=$t and @contextRef=$y1end]'>
        <tr>
          <td>

          </td>
          <td>
<xsl:value-of select="concat($numy2,' ')"/> <xsl:value-of select=".//pt:TypeOrdinaryShare[@contextRef=$y2]"/> of <xsl:value-of select="concat(normalize-space($currencyY2), ./pt:ParValueOrdinaryShare[@contextRef=$y2])"/> each
          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:ValueOrdinarySharesAuthorised[..=$t and @contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:ValueOrdinarySharesAuthorised[..=$t and @contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>
<xsl:if test='//pt:ValueOrdinarySharesAuthorised[..=$t and @contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:ValueOrdinarySharesAuthorised[..=$t and @contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
      </xsl:if>
</xsl:for-each>

<xsl:for-each select="//pt:NonEquityAuthorisedDetails">
  <xsl:variable name="t" select="." />
  <xsl:variable name="numy2" select="./pt:NumberNonEquitySharesAuthorised[@contextRef=$y2end]"/>
  <xsl:variable name="numy1" select="./pt:NumberNonEquitySharesAuthorised[@contextRef=$y1end]"/>
      <xsl:if test='//pt:ValueNonEquitySharesAuthorised[..=$t and @contextRef=$y2end] or //pt:ValueNonEquitySharesAuthorised[..=$t and @contextRef=$y1end]'>
        <tr>
          <td>

          </td>
          <td>
<xsl:value-of select="concat($numy2,' ')"/> <xsl:value-of select=".//pt:TypeNonEquityShare[@contextRef=$y2]"/> of <xsl:value-of select="concat(normalize-space($currencyY2), ./pt:ParValueNonEquityShare[@contextRef=$y2])"/> each
          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:ValueNonEquitySharesAuthorised[..=$t and @contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:ValueNonEquitySharesAuthorised[..=$t and @contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>
<xsl:if test='//pt:ValueNonEquitySharesAuthorised[..=$t and @contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:ValueNonEquitySharesAuthorised[..=$t and @contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
      </xsl:if>
</xsl:for-each>
        <tr>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>

        <tr>
          <td>

          </td>
          <td>
Allotted, called up and fully paid:
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
<xsl:for-each select="//pt:DetailsOrdinarySharesAllotted">
  <xsl:variable name="t" select="." />
  <xsl:variable name="numy2" select="./pt:NumberOrdinarySharesAllotted[@contextRef=$y2end]"/>
  <xsl:variable name="numy1" select="./pt:NumberOrdinarySharesAllotted[@contextRef=$y1end]"/>
      <xsl:if test='//pt:ValueOrdinarySharesAllotted[..=$t and @contextRef=$y2end] or //pt:ValueOrdinarySharesAllotted[..=$t and @contextRef=$y1end]'>
        <tr>
          <td>

          </td>
          <td>
<xsl:value-of select="concat($numy2,' ')"/> <xsl:value-of select=".//pt:TypeOrdinaryShare[@contextRef=$y2]"/> of <xsl:value-of select="concat(normalize-space($currencyY2), ./pt:ParValueOrdinaryShare[@contextRef=$y2])"/> each
          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:ValueOrdinarySharesAllotted[..=$t and @contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:ValueOrdinarySharesAllotted[..=$t and @contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>
<xsl:if test='//pt:ValueOrdinarySharesAllotted[..=$t and @contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:ValueOrdinarySharesAllotted[..=$t and @contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
      </xsl:if>
</xsl:for-each>

<xsl:for-each select="//pt:NonEquityAllottedDetails">
  <xsl:variable name="t" select="." />
  <xsl:variable name="numy2" select="./pt:NumberNonEquitySharesAllotted[@contextRef=$y2end]"/>
  <xsl:variable name="numy1" select="./pt:NumberNonEquitySharesAllotted[@contextRef=$y1end]"/>
      <xsl:if test='//pt:ValueNonEquitySharesAllotted[..=$t and @contextRef=$y2end] or //pt:ValueNonEquitySharesAllotted[..=$t and @contextRef=$y1end]'>
        <tr>
          <td>

          </td>
          <td>
<xsl:value-of select="concat($numy2,' ')"/><xsl:value-of select="./pt:TypeNonEquityShare[@contextRef=$y2]"/> of <xsl:value-of select="concat(normalize-space($currencyY2), ./pt:ParValueNonEquityShare[@contextRef=$y2])"/> each
          </td>
          <td>

          </td>
          <td>
<xsl:if test='//pt:ValueNonEquitySharesAllotted[..=$t and @contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:ValueNonEquitySharesAllotted[..=$t and @contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>
<xsl:if test='//pt:ValueNonEquitySharesAllotted[..=$t and @contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:ValueNonEquitySharesAllotted[..=$t and @contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
      </xsl:if>
</xsl:for-each>

        <tr>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
<xsl:if test="//pt:OrdinarySharesIssuedInPeriod-Details">
        <tr>
          <td>

          </td>
          <td>
Ordinary shares issued in the year:
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
</xsl:if>
<xsl:for-each select="//pt:OrdinarySharesIssuedInPeriod-Details">
  <xsl:variable name="t" select="." />
<tr><td></td><td colspan="7">
<xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:TotalNumberSharesIssued[@contextRef=$y2]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template><xsl:value-of select="' '"/><xsl:value-of select=".//pt:TypeOrdinaryShare[@contextRef=$y2]"/> of <xsl:value-of select="normalize-space($currencyY2)" /><xsl:value-of select="./pt:ParValueOrdinaryShare[@contextRef=$y2]" /> each were issued in the year with a nominal value
of <xsl:value-of select="normalize-space($currencyY2)" /><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:TotalNominalValue[@contextRef=$y2]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>,
for a consideration of <xsl:value-of select="normalize-space($currencyY2)" /><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:TotalConsideration[@contextRef=$y2]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
</td></tr>
</xsl:for-each>

        <tr>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
<xsl:if test="//pt:NonEquitySharesDetailsAllotmentsDuringPeriod">
        <tr>
          <td>

          </td>
          <td>
Non-equity shares issued in the year:
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
</xsl:if>
<xsl:for-each select="//pt:NonEquitySharesDetailsAllotmentsDuringPeriod">
  <xsl:variable name="t" select="." />

<tr><td></td><td colspan="7">
<xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:NumberNonEquitySharesAllottedInPeriod[.=$t//* and @contextRef=$y2]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
<xsl:text> </xsl:text>
<xsl:value-of select="./pt:TypeNonEquityShare[@contextRef=$y2]"/> of <xsl:value-of select="concat(normalize-space($currencyY2), ./pt:ParValueNonEquityShare[@contextRef=$y2])" /> each were issued in the year with a nominal value
of <xsl:value-of select="concat(normalize-space($currencyY2), .//pt:ValueNonEquitySharesAllottedInPeriod[@contextRef=$y2])" />,
for a consideration of <xsl:value-of select="concat(normalize-space($currencyY2), .//pt:ConsiderationForNonEquitySharesAllottedInPeriod[@contextRef=$y2])" />
</td></tr>

</xsl:for-each>
<tr><td colspan="7"><span style="page-break-avoid: end" /></td></tr>

  </xsl:if>
  <!-- ~footnote: capital -->


  <!-- footnote: share_premium_account -->
  <xsl:if test="$fn_share_premium_account=1" >
    <xsl:for-each select="//link:footnote[../link:loc[@xlink:href=concat(&quot;#&quot;, //pt:SharePremiumAccount/@id)]]">
    <tr><td>
        <xsl:value-of select='$fnn_share_premium_account' />
      </td>
      <td colspan="5">
        <h3 class="nospace" style="page-break-avoid: begin"><xsl:value-of select='../@xlink:title' /></h3>
      </td>
      <td>
        <a name="fn_share_premium_account" />
      </td>
    </tr>
    <tr>
    <td></td>
    <td>
        <xsl:copy-of select='./node()' /><span style="page-break-avoid: end" />
      </td>
    </tr>
    </xsl:for-each>

  </xsl:if>
  <!-- ~footnote: share_premium_account -->

  <!-- footnote: revaluation_reserve -->
  <xsl:if test="$fn_revaluation_reserve=1" >
    <xsl:for-each select="//link:footnote[../link:loc[@xlink:href=concat(&quot;#&quot;, //pt:RevaluationReserve/@id)]]">
    <tr><td>
        <xsl:value-of select='$fnn_revaluation_reserve' />
      </td>
      <td colspan="5">
        <h3 class="nospace" style="page-break-avoid: begin"><xsl:value-of select='../@xlink:title' /></h3>
      </td>
      <td>
        <a name="fn_revaluation_reserve" />
      </td>
    </tr>
    <tr>
    <td></td>
    <td>
        <xsl:copy-of select='./node()' /><span style="page-break-avoid: end" />
      </td>
    </tr>
    </xsl:for-each>

  </xsl:if>
  <!-- ~footnote: revaluation_reserve -->

  <!-- footnote: other_reserves -->
  <xsl:if test="$fn_other_reserves=1" >
    <xsl:for-each select="//link:footnote[../link:loc[@xlink:href=concat(&quot;#&quot;, //pt:OtherAggregateReserves/@id)]]">
    <tr><td>
        <xsl:value-of select='$fnn_other_reserves' />
      </td>
      <td colspan="5">
        <h3 class="nospace" style="page-break-avoid: begin"><xsl:value-of select='../@xlink:title' /></h3>
      </td>
      <td>
        <a name="fn_other_reserves" />
      </td>
    </tr>
    <tr>
    <td></td>
    <td>
        <xsl:copy-of select='./node()' /><span style="page-break-avoid: end" />
      </td>
    </tr>
    </xsl:for-each>

  </xsl:if>
  <!-- ~footnote: other_reserves -->

  <!-- footnote: profit_and_loss_account -->
  <xsl:if test="$fn_profit_and_loss_account=1" >
   <xsl:for-each select="//link:footnote[../link:loc[@xlink:href=concat(&quot;#&quot;, //pt:ProfitLossAccountReserve/@id)]]">
    <tr><td>
        <xsl:value-of select='$fnn_profit_and_loss_account' />
      </td>
      <td colspan="5">
        <h3 class="nospace" style="page-break-avoid: begin"><xsl:value-of select='../@xlink:title' /></h3>
      </td>
      <td>
        <a name="fn_profit_and_loss_account" />
      </td>
    </tr>
    <tr>
    <td></td>
    <td>
        <xsl:copy-of select='./node()' /><span style="page-break-avoid: end" />
      </td>
    </tr>
    </xsl:for-each>
   
   </xsl:if>

  <!-- ~footnote: profit_and_loss_account -->


  <!-- footnote: shareholders_funds -->
  <xsl:if test="$fn_shareholders_funds=1" >
    <xsl:for-each select="//link:footnote[../link:loc[@xlink:href=concat(&quot;#&quot;, //pt:ShareholderFunds/@id)]]">
    <tr><td>
        <xsl:value-of select='$fnn_shareholders_funds' />
      </td>
      <td colspan="5">
        <h3 class="nospace" style="page-break-avoid: begin"><xsl:value-of select='../@xlink:title' /></h3>
      </td>
      <td>
        <a name="fn_shareholders_funds" />
      </td>
    </tr>
    <tr>
    <td></td>
    <td>
        <xsl:copy-of select='./node()' /><span style="page-break-avoid: end" />
      </td>
    </tr>
    </xsl:for-each>

  </xsl:if>
  <!-- ~footnote: shareholders_funds -->

  <!-- footnote: twd -->
  <xsl:if test="$fn_twd=1" >
    	<tr>
		<td><xsl:value-of select="$fnn_twd"/></td><td><h3 class="nospace" style="page-break-avoid: begin">Transactions with directors</h3></td>
	</tr>
	<tr>
		<td></td>
		<td colspan="3">
			<xsl:call-template name='displayItem'><xsl:with-param name='item' select='//ae:TransactionsWithDirectors' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template><span style="page-break-avoid: end" />
		</td>
	</tr>

  </xsl:if>
  <!-- ~footnote: twd -->


  <!-- footnote: rpd -->
  <xsl:if test="$fn_rpd=1" >
    	<tr>
		<td><xsl:value-of select="$fnn_rpd"/></td><td><h3 class="nospace" style="page-break-avoid: begin">Related party disclosures</h3></td>
	</tr>
	<tr>
		<td></td>
		<td colspan="3">
			<xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:StatementOnRelatedPartyDisclosure' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template><span style="page-break-avoid: end" />
		</td>
	</tr>

  </xsl:if>
  <!-- ~footnote: rpd -->


</table>

  <xsl:if test="//gc:BalanceSheetDate != //xbrli:context[@id=$y2end]//xbrli:instant">
    <h1 style="color: red">Warnings</h1>
    <xsl:message>BalanceSheetDate does not equal the Y2 context end date</xsl:message>
    <p style="color: red">BalanceSheetDate does not equal the Y2 context end date (BalanceSheetDate = <xsl:call-template name="formatDate"><xsl:with-param name="date" select="//gc:BalanceSheetDate" /></xsl:call-template>, Y2 context end = <xsl:call-template name="formatDate"><xsl:with-param name="date" select="//xbrli:context[@id=$y2end]//xbrli:instant" /></xsl:call-template>)</p>
  </xsl:if>

    <xsl:call-template name="printUnusedElements" />
    <xsl:call-template name="printDuplicateElements" />

  </body>
</html>

</xsl:template>

  <!-- Display numbered footnotes.
       @param fn_adjust Numbering starts at this value +1
  -->
  <xsl:template name='showFootnotes'>
    <xsl:param name='fn_adjust' />
    <xsl:for-each select='//link:footnote'>
      <tr><td>
          <xsl:value-of select='position() + $fn_adjust' />
        </td>
        <td colspan="5">
          <h3 class="nospace" style="page-break-avoid: begin"><xsl:value-of select='../@xlink:title' /></h3>
        </td>
        <td>
          <a><xsl:attribute name='name'><xsl:value-of select='@xlink:label' /></xsl:attribute></a>
        </td>
      </tr>
      <tr>
      <td></td>
      <td>
          <xsl:copy-of select='./node()' /><span style="page-break-avoid: end" />
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>

  <!-- Displays an XBRL item value.
       @param item Item whose value to display
       @param flipSign If this is (, negate the value
  -->
  <xsl:template name="displayItem">
    <xsl:param name="item" />
    <xsl:param name="flipSign" />
    <xsl:for-each select="$item">
      <xsl:choose>
        <!-- If it contains HTML, display as-is -->
        <xsl:when test="./html:*"><xsl:copy-of select="." /></xsl:when>
        <!-- If there is no unitRef, this must be a string item -->
        <xsl:when test="not(./@unitRef)"><xsl:value-of select="." /></xsl:when>
        <!-- If it doesn't look like a number, treat it as a string -->
        <xsl:when test="string(number(.)) = 'NaN'"><xsl:value-of select="." /></xsl:when>
        <!-- If we were expecting a bracketed number and the XBRL contains a
             negative number, print the number without brackets -->
        <xsl:when test="$flipSign='(' and . &lt; 0"><xsl:number value="0-." grouping-separator="," grouping-size="3" /></xsl:when>
        <!-- If we were expecting a positive number, and the XBRL contains a
             negative one, print the number with brackets -->
        <xsl:when test=". &lt; 0">(<xsl:number value="0-." grouping-separator="," grouping-size="3" />)</xsl:when>
        <!-- If we were expecting a bracketed number, and the XBRL contains a
             positive one, print the number with brackets -->
        <xsl:when test="$flipSign='('">(<xsl:number value="." grouping-separator="," grouping-size="3" />)</xsl:when>
        <!-- Otherwise is must be a positive number where we expect a positive
             number, so print as is -->
        <xsl:otherwise><xsl:number value="number(.)" grouping-separator="," grouping-size="3"/></xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

<!-- Displays a footnote.
     @param fn_adjust Added on to the footnote number to adjust for fixed footnotes
     @param loc The link:loc tag for this footnote
-->
  <xsl:template name='footnoteLinkFor'>
    <xsl:param name='fn_adjust' />
    <xsl:param name='loc' />
    <xsl:param name='footnoteNum' select='0' />
    <xsl:variable name='footnoteName' select='
  //link:footnoteArc[
    @xlink:from = $loc/@xlink:label
  ]/@xlink:to
  ' />
    <xsl:for-each select='//link:footnote'>
      <xsl:if test='@xlink:label=$footnoteName'>
        <xsl:element name='a'>
          <xsl:attribute name='href'>#<xsl:value-of select='$footnoteName' /></xsl:attribute>
          <xsl:attribute name='class'>footnoteLink</xsl:attribute>
          <xsl:value-of select='position()+$fn_adjust' />
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

<!-- Determine which contexts exist in the instance.
-->
  <xsl:template name="guessContexts">
		<!-- determine number of periods in the instance by counting pt:NetAssetsLiabilitiesIncludingPensionAssetLiability -->
		<xsl:choose>
			<xsl:when test="count(//pt:NetAssetsLiabilitiesIncludingPensionAssetLiability)=1">
				<!-- one period -->

    				<xsl:if test="count(//xbrli:unit[not(.//xbrli:measure=preceding::xbrli:unit//xbrli:measure) and @id=//*/@unitRef and starts-with(.//xbrli:measure, 'iso4217')]) != 1">
					<xsl:message terminate="yes">
						There must be one currency used.
					</xsl:message>
				</xsl:if>

				<xsl:variable name="numDurationContexts" select="count(//xbrli:context[.//xbrli:startDate and //*/@xbrli:contextRef=./@id])" />
				<xsl:if test="$numDurationContexts &gt; 1">
					<xsl:message terminate="yes">
					There must be zero or one duration contexts (found <xsl:value-of select="$numDurationContexts"/>)
					</xsl:message>
				</xsl:if>

				<xsl:if test="$numDurationContexts = 1">
					<xsl:for-each select="//xbrli:context[xbrli:period/xbrli:instant and @id = //*/@contextRef]">
				      <xsl:variable name="c1" select="." />
				      <xsl:variable name="c1pp">
							<xsl:call-template name="datePlusOne">
								<xsl:with-param name="date" select="translate($c1/xbrli:period/xbrli:instant,'-T:','')" />
							</xsl:call-template>
				      </xsl:variable>
						<xsl:if test="not(//xbrli:context[xbrli:period/xbrli:startDate and translate(xbrli:period/xbrli:startDate,'-T:','') &lt;= $c1pp and translate(xbrli:period/xbrli:endDate,'-T:','') &gt;= translate($c1/xbrli:period/xbrli:instant,'-T:','')])">
							<xsl:message terminate="yes">
		Could not match up the instant context <xsl:value-of select="@id" />
		to a suitable period context.
				        </xsl:message>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>

				<!-- take y2end from NetAssets context -->
 				<xsl:variable name="y2end" select="//pt:NetAssetsLiabilitiesIncludingPensionAssetLiability/@contextRef" />
				<!-- the remaining instant context must be the start of the period -->
				<xsl:variable name="y1end" select="//xbrli:context/@id[(./xbrli:period/xbrli:instant) and (@id != $y2end)]" />

				<!-- take y2 from the only duration context -->
				<xsl:variable name="y2" select="//xbrli:context/@id[./xbrli:period/xbrli:startDate]" />

				<xsl:call-template name="main">
					<xsl:with-param name="y2" select="//xbrli:context[(//*/@contextRef = @id) and .//xbrli:startDate]/@id" />
					<xsl:with-param name="y2start" select="/.." />
					<xsl:with-param name="y2end" select="//pt:NetAssetsLiabilitiesIncludingPensionAssetLiability/@contextRef" />
					<xsl:with-param name="y2currency" select="//xbrli:unit[@id=//pt:NetAssetsLiabilitiesIncludingPensionAssetLiability/@unitRef]/xbrli:measure" />
					<xsl:with-param name="namey2"><xsl:value-of select="substring(normalize-space(//xbrli:context[@id=$y2end]//xbrli:instant),1,4)" /></xsl:with-param>

					<xsl:with-param name="y1" select="/.." />
					<xsl:with-param name="y1start" select="/.." />
					<xsl:with-param name="y1end" select="/.." />
					<xsl:with-param name="y1currency" select="/.." />
					<xsl:with-param name="namey1" select="/.." />
				</xsl:call-template>
			</xsl:when>

			<xsl:when test="count(//pt:NetAssetsLiabilitiesIncludingPensionAssetLiability)=2">
				<!-- two of NetAssets -->

				<!-- The ID of the first NetAssets context -->
				<xsl:variable name="cr1id"><xsl:for-each select="//xbrli:context[@id = //pt:NetAssetsLiabilitiesIncludingPensionAssetLiability/@contextRef]"><xsl:sort select=".//xbrli:instant" /><xsl:if test="position()=1"><xsl:value-of select="@id" /></xsl:if></xsl:for-each></xsl:variable>

				<!-- The contexts used by the two periods NetAssets -->
				<xsl:variable name="cr1" select="//xbrli:context[@id=$cr1id]" />
				<xsl:variable name="cr2" select="//xbrli:context[@id=//pt:NetAssetsLiabilitiesIncludingPensionAssetLiability/@contextRef and @id!=$cr1id]" />

				<!-- Check that there aren't too many currencies -->
  				<xsl:if test="count(//xbrli:unit[not(.//xbrli:measure=preceding::xbrli:unit//xbrli:measure) and @id=//*/@unitRef and starts-with(.//xbrli:measure, 'iso4217')]) > 2">
					<xsl:message terminate="yes">
					There must be one or two currencies used.
					</xsl:message>
				</xsl:if>

				<!-- Build up a colon-seperated list of context IDs in period 2,
						whilst checking that there are no instants after period 2 -->
				<xsl:variable name="y2ids">
				<xsl:for-each select="//xbrli:context[@id = //*/@contextRef]">
					<xsl:choose>
						<xsl:when test=".//xbrli:instant">
							<xsl:if test="translate(.//xbrli:instant,'-T:','') &gt; translate($cr2//xbrli:instant,'-T:','')">
								<xsl:message terminate="yes">
All instant contexts must be before or at the end of period 2.
								</xsl:message>
							</xsl:if>
							<xsl:if test="translate(.//xbrli:instant,'-T:','') &gt;= translate($cr1//xbrli:instant,'-T:','')">
								:<xsl:value-of select="@id" />:
							</xsl:if>
						</xsl:when>
						<xsl:when test=".//xbrli:endDate">
							<xsl:if test="translate(.//xbrli:endDate,'-T:','') &gt; translate($cr2//xbrli:instant,'-T:','')">
								<xsl:message terminate="yes">
All duration contexts must end before or at the end of period 2.
								</xsl:message>
							</xsl:if>
							<xsl:if test="translate(.//xbrli:startDate,'-T:','') &gt; translate($cr1//xbrli:instant,'-T:','')">
								:<xsl:value-of select="@id" />:
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
Cannot handle context <xsl:value-of select="./@id" />.
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				</xsl:variable>

				<!-- Get the colon-seperated list of context IDs in period 1 -->
				<xsl:variable name="y1ids">
				<xsl:for-each select="//xbrli:context[@id = //*/@contextRef]">
					<xsl:choose>
						<xsl:when test=".//xbrli:instant">
							<xsl:if test="translate(.//xbrli:instant,'-T:','') &lt;= translate($cr1//xbrli:instant,'-T:','')">
								:<xsl:value-of select="@id" />:
							</xsl:if>
						</xsl:when>
						<xsl:when test=".//xbrli:endDate">
							<xsl:if test="translate(.//xbrli:startDate,'-T:','') &lt;= translate($cr1//xbrli:instant,'-T:','')">
								:<xsl:value-of select="@id" />:
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
Cannot handle context <xsl:value-of select="./@id" />.
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				</xsl:variable>

				<!-- Turn the lists above into a nodeset of IDs -->
				<xsl:variable name="y2" select="//xbrli:context[contains($y2ids, concat(':',@id,':'))]/@id" />
				<xsl:variable name="y1" select="//xbrli:context[contains($y1ids, concat(':',@id,':'))]/@id" />

				<!-- Pick out the start and end contexts based on the context lists
					and the contexts used on NetAssets -->
				<xsl:variable name="y1end" select="//xbrli:context[@id=$y1 and .//xbrli:instant=$cr1//xbrli:instant]/@id" />
				<xsl:variable name="y2end" select="//xbrli:context[@id=$y2 and .//xbrli:instant=$cr2//xbrli:instant]/@id" />
				<xsl:variable name="y1start" select="//xbrli:context[@id=$y1 and .//xbrli:instant and not (.//xbrli:instant=$cr1//xbrli:instant)]/@id" />
				<xsl:variable name="y2start" select="//xbrli:context[@id=$y2 and .//xbrli:instant and not (.//xbrli:instant=$cr2//xbrli:instant)]/@id" />
				
		<!-- Amended Date if 2 year contexts are the same-->
				
				<xsl:variable name="y1Year" select="substring(normalize-space($cr1//xbrli:instant),1,4)"/>
				<xsl:variable name="y2Year" select="substring(normalize-space($cr2//xbrli:instant),1,4)"/>
				<xsl:variable name="y2Month" select="substring(normalize-space($cr2//xbrli:instant),6,2)"/>
				<xsl:variable name="y2Day" select="substring(normalize-space($cr2//xbrli:instant),9,2)"/>
         		<xsl:variable name="y2Full"><xsl:value-of select="concat($y2Day,'/')"/> <xsl:value-of select="concat($y2Month,'/')"/><xsl:value-of select="$y2Year"/></xsl:variable>				
				
				<xsl:variable name="ColumnHeading2">
					<xsl:choose>
					<xsl:when test="$y2Year = $y1Year">
						<xsl:value-of select="$y2Full"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$y2Year"/>
					</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				
				<xsl:variable name="y1Month" select="substring(normalize-space($cr1//xbrli:instant),6,2)"/>
				<xsl:variable name="y1Day" select="substring(normalize-space($cr1//xbrli:instant),9,2)"/>
         		<xsl:variable name="y1Full"><xsl:value-of select="concat($y1Day,'/')"/> <xsl:value-of select="concat($y1Month,'/')"/><xsl:value-of select="$y1Year"/></xsl:variable>
						
				
				<xsl:variable name="ColumnHeading1">
					<xsl:choose>
					<xsl:when test="$y2Year = $y1Year">
						<xsl:value-of select="$y1Full"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$y1Year"/>
					</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>						
				
				
				<!-- Call main using this information. The currency per period
					is that that NetAssets is quoted in -->
				<xsl:call-template name="main">
					<xsl:with-param name="y2" select="//xbrli:context[@id=$y2 and .//xbrli:startDate]/@id" />
					<xsl:with-param name="y1" select="//xbrli:context[@id=$y1 and .//xbrli:startDate]/@id" />
					<xsl:with-param name="y2start" select="$y2start" />
					<xsl:with-param name="y1start" select="$y1start" />
					<xsl:with-param name="y2end" select="$y2end" />
					<xsl:with-param name="y1end" select="$y1end" />
					<!--<xsl:with-param name="namey2" select="substring(normalize-space($cr2//xbrli:instant),1,4)" />
					<xsl:with-param name="namey1" select="substring(normalize-space($cr1//xbrli:instant),1,4)" />-->
					<xsl:with-param name="namey2" select="$ColumnHeading2" />
					<xsl:with-param name="namey1" select="$ColumnHeading1" />
					<xsl:with-param name="y1currency" select="//xbrli:unit[@id = //pt:NetAssetsLiabilitiesIncludingPensionAssetLiability[@contextRef=$cr1/@id]/@unitRef]//xbrli:measure" />
					<xsl:with-param name="y2currency" select="//xbrli:unit[@id = //pt:NetAssetsLiabilitiesIncludingPensionAssetLiability[@contextRef=$cr2/@id]/@unitRef]//xbrli:measure" />
				</xsl:call-template>
			</xsl:when>

			<!-- The number of NetAssets is wrong -->
			<xsl:otherwise>
				<xsl:message terminate="yes">
					Found <xsl:value-of select="count(//pt:NetAssetsLiabilitiesIncludingPensionAssetLiability)"/>, instance must have either one or two of pt:NetAssetsLiabilitiesIncludingPensionAssetLiability
				</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
  </xsl:template>

<!-- Displays a date formatted as eg 29 February 2004.
     @param date Date to write
-->
  <xsl:template name='formatDate'>
    <xsl:param name='date' />
    <xsl:choose>
      <!-- Debug option: dumps contents of tag unaltered if content starts with lt -->
      <xsl:when test="starts-with($date, '&lt;')">
        <xsl:value-of select="$date" />
      </xsl:when>
      <!-- Formats date -->
      <xsl:otherwise>
        <xsl:value-of select="concat(substring($date, 9, 2), ' ')" />
        <xsl:choose>
          <xsl:when test="substring($date, 6, 2)='01'">January</xsl:when>
          <xsl:when test="substring($date, 6, 2)='02'">February</xsl:when>
          <xsl:when test="substring($date, 6, 2)='03'">March</xsl:when>
          <xsl:when test="substring($date, 6, 2)='04'">April</xsl:when>
          <xsl:when test="substring($date, 6, 2)='05'">May</xsl:when>
          <xsl:when test="substring($date, 6, 2)='06'">June</xsl:when>
          <xsl:when test="substring($date, 6, 2)='07'">July</xsl:when>
          <xsl:when test="substring($date, 6, 2)='08'">August</xsl:when>
          <xsl:when test="substring($date, 6, 2)='09'">September</xsl:when>
          <xsl:when test="substring($date, 6, 2)='10'">October</xsl:when>
          <xsl:when test="substring($date, 6, 2)='11'">November</xsl:when>
          <xsl:when test="substring($date, 6, 2)='12'">December</xsl:when>
        </xsl:choose>
        <xsl:value-of select="concat(' ', substring($date, 1, 4))" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
<!-- Display existing lines of an address tuple with line breaks.
     @param address Address to write
-->
  <xsl:template name='address'>
    <xsl:param name='address' />
    <xsl:if test='$address/ae:AddressCH'>
      <xsl:for-each select='$address/ae:AddressCH'>
        <xsl:if test='gc:AddressLine1'>
          <xsl:value-of select='gc:AddressLine1' />
          <br />
        </xsl:if>
        <xsl:if test='gc:AddressLine2'>
          <xsl:value-of select='gc:AddressLine2' />
          <br />
        </xsl:if>
        <xsl:if test='gc:AddressLine3'>
          <xsl:value-of select='gc:AddressLine3' />
          <br />
        </xsl:if>
        <xsl:if test='gc:CityOrTown'>
          <xsl:value-of select='gc:CityOrTown' />
          <br />
        </xsl:if>
        <xsl:if test='gc:County'>
          <xsl:value-of select='gc:County' />
          <br />
        </xsl:if>
        <xsl:if test='gc:Country'>
          <xsl:value-of select='gc:Country' />
          <br />
        </xsl:if>
        <xsl:if test='gc:Postcode'>
          <xsl:value-of select='gc:Postcode' />
          <br />
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <!-- Get the sign associated with a particular unit -->
  <xsl:template name="getCurrencySymbol">
    <xsl:param name="uniqueUnits" />
    <xsl:param name="contexts" />

    <xsl:choose>
      <!-- GBP -->
      <xsl:when test="$uniqueUnits = 'iso4217:GBP'">
        £
      </xsl:when>
      <!-- USD -->
      <xsl:when test="$uniqueUnits = 'iso4217:USD'">
        $
      </xsl:when>
      <!-- Euros -->
      <xsl:when test="$uniqueUnits = 'iso4217:EUR'">
        €
      </xsl:when>
      <!-- Other ISO units (XBRL uses ISO units with an iso4217: prefix) -->
      <xsl:when test="starts-with($uniqueUnits, 'iso4217:')">
        <xsl:value-of select="substring-after($uniqueUnits,'iso4217:')" />
      </xsl:when>
      <!-- Use the unit unprocessed -->
      <xsl:otherwise>
        <xsl:value-of select="$uniqueUnits" />
      </xsl:otherwise>
    </xsl:choose>

    <!--NOTE-This has been commented out due to Validation already within the Form-->
    
    <!--<xsl:if test="($uniqueUnits != 'iso4217:GBP')">  this currency isn't GBP
      <xsl:if test="not(//ae:ForeignExchangeRate[@contextRef=$contexts])">  there're no exchange rate footnote/s 
        <xsl:message terminate="yes">Non-GBP currency used but no exchange rate footnote/s provided</xsl:message>
      </xsl:if>
    </xsl:if>-->
    
  </xsl:template>
  <!-- Report any unused elements in the instance. Note that this must be the last
       template -->
  <xsl:template name="printUnusedElements">
  <xsl:variable name="usedNodes" select="//pt:TotalInvestmentsFixedAssets | //ae:DirectorsAcknowledgeTheirResponsibilitiesUnderCompaniesAct | //pt:TypeNonEquityShare | //ae:AccountingPolicy | //pt:TangibleFixedAssetsAdditions | //pt:PositionAdditionalApprovingPerson | //ae:VATRegistrationNumber | //pt:Debtors | //ae:TypeDepreciation | //pt:TotalNumberSharesIssued | //pt:NonEquityShareholdersFunds | //pt:AccrualsDeferredIncome | //gc:EntityBusinessDescription | //pt:ValueOrdinarySharesAuthorised | //pt:LandBuildings | //gc:Postcode | //pt:NonEquityAllotedDetails | //pt:ProfitLossOnOrdinaryActivitiesBeforeTax | //pt:FixturesFittingsToolsEquipmentDepreciation | //ae:OtherTangibleFixedAssetDepreciationDisposals | //ae:TitleAccountingPolicy | //pt:InvestmentsCurrentAssets | //pt:LandBuildingsDepreciationDisposals | //pt:NameAdditionalApprovingPerson | //pt:ValueOrdinarySharesAllotted | //ae:ListDirectorsExecutives | //pt:ParValueNonEquityShare | //pt:TotalConsideration | //pt:SharePremiumAccount | //pt:OtherAggregateReserves | //pt:TangibleFixedAssetsCostOrValuation | //pt:DescriptionSharesOrDebentures | //pt:EquityShareholdersFunds | //pt:PlantMachinery | //ae:ReportingAccountants | //pt:CashBankInHand | //pt:OrdinarySharesIssuedInPeriod-Details | //pt:NonEquityAuthorisedDetails | //pt:SharesDirectorOrExecutive | //pt:NetAssetsLiabilitiesIncludingPensionAssetLiability | //pt:CreditorsDueAfterOneYearTotalNoncurrentLiabilities | //pt:TotalAssetsLessCurrentLiabilities | //ae:CompaniesHouseRegisteredNumber | //ae:AddressCH | //pt:ValueNonEquitySharesAllottedInPeriod | //pt:TangibleFixedAssetsDisposals | //ae:OtherTangibleFixedAsset | //pt:DetailsOrdinarySharesAllotted | //pt:PlantMachineryCostOrValuation | //pt:LandBuildingsDepreciationChargeForPeriod | //pt:FixturesFittingsToolsEquipment | //ae:OtherTypeTangibleFixedAsset-Analysis | //pt:CalledUpShareCapital | //pt:OtherDebtors | //pt:FixedAssets | //pt:StatementOnRelatedPartyDisclosure | //ae:AccountsPreparedUnderHistoricalCostConventionInAccordanceWithFRSE | //ae:DateApprovalDirectorsReport | //gc:AddressLine1 | //pt:PlantMachineryDepreciation | //pt:ObligationsUnderFinanceLeaseHirePurchaseContractsAfterOneYear | //ae:AccountsAreInAccordanceWithSpecialProvisionsCompaniesActRelatingToSmallCompanies | //pt:OtherCreditorsDueWithinOneYear | //pt:BankLoansOverdraftsAfterOneYear | //gc:AddressLine3 | //pt:LandBuildingsDepreciation | //ae:ApprovalDirectorsReport | //ae:MembersHaveNotRequiredCompanyToObtainAnAudit | //ae:Shareholding | //pt:TypeOrdinaryShare | //ae:PositionPersonApprovingDirectorsReport | //ae:NameBankers | //ae:Bankers | //pt:StocksInventory | //pt:FixturesFittingsToolsEquipmentAdditions | //pt:ValueNonEquitySharesAllotted | //pt:FixturesFittingsToolsEquipmentCostOrValuation | //pt:PlantMachineryAdditions | //pt:TangibleFixedAssetsDepreciationChargeForPeriod | //gc:CityOrTown | //pt:TradeCreditorsWithinOneYear | //pt:TangibleFixedAssets | //ae:NameSolicitors | //ae:CategoryItem | //gc:EntityCurrentLegalName | //ae:OtherTangibleFixedAssetDisposals | //pt:TangibleFixedAssetsDepreciationDisposals | //gc:BalanceSheetDate | //ae:ContentAccountingPolicy | //pt:ConsiderationForNonEquitySharesAllottedInPeriod | //pt:TotalNominalValue | //ae:DescriptionAccountants | //pt:ProfitLossAccountReserve | //ae:OtherTangibleFixedAssetCostOrValuation | //pt:NumberNonEquitySharesAllottedInPeriod | //pt:NumberNonEquitySharesAllotted | //pt:BankLoansOverdraftsWithinOneYear | //gc:Country | //pt:ValueNonEquitySharesAuthorised | //pt:PlantMachineryDisposals | //pt:NetCurrentAssetsLiabilities | //pt:DateAssumedPosition | //pt:CreditorsDueWithinOneYearTotalCurrentLiabilities | //pt:CalledUpShareCapitalNotPaidCurrentAsset | //pt:IntangibleFixedAssetsCostOrValuation | //pt:PlantMachineryDepreciationDisposals | //ae:NamePersonApprovingDirectorsReport | //ae:RateDepreciation | //pt:NumberNonEquitySharesAuthorised | //ae:OtherTangibleFixedAssetDepreciationChargeForPeriod | //ae:NameAccountants | //pt:TradeDebtors | //pt:PrepaymentsAccruedIncomeNotExpressedWithinCurrentAssetSub-total | //pt:LandBuildingsDisposals | //pt:FixturesFittingsToolsEquipmentDepreciationDisposals | //pt:RevaluationReserve | //ae:OtherTangibleFixedAssetDepreciation | //ae:BusinessAddress | //ae:CompanyNon-trading | //pt:TangibleFixedAssetsDepreciation | //pt:LandBuildingsCostOrValuation | //pt:NonEquitySharesDetailsAllotmentsDuringPeriod | //ae:DateResignation | //pt:NumberOrdinarySharesAuthorised | //pt:DateApproval | //pt:ParValueOrdinaryShare | //ae:CompanyEntitledToExemptionUnderSection249A1CompaniesAct1985 | //pt:FixturesFittingsToolsEquipmentDisposals | //ae:DescriptionBusinessAddress | //pt:IntangibleFixedAssets | //pt:LandBuildingsAdditions | //pt:AdditionalApprovingPerson | //ae:NameTypeTangibleFixedAsset | //pt:CurrentAssets | //pt:CalledUpShareCapitalNotPaidNotExpressedAsCurrentAsset | //ae:Solicitors | //ae:ForeignExchangeRate | //ae:RegisteredOfficeAddress | //pt:ProvisionsForLiabilitiesCharges | //pt:DirectorOrExecutivesName | //pt:NonEquityAllottedDetails | //pt:RetainedProfitLossForFinancialYearTransferredToReserves | //pt:ShareholderFunds | //ae:DirectorsReportGeneralText | //ae:DirectorShareholding | //pt:PlantMachineryDepreciationChargeForPeriod | //pt:AccrualsDeferredIncomeWithinOneYear | //ae:TransactionsWithDirectors | //ae:OtherTangibleFixedAssetAdditions | //pt:IntangibleFixedAssetsAmortisationChargedInPeriod | //ae:DepreciationRate | //ae:PoliticalCharitableDonationsText | //gc:AddressLine2 | //pt:FixturesFittingsToolsEquipmentDepreciationChargeForPeriod | //pt:IntangibleFixedAssetsAggregateAmortisationImpairment | //ae:CompanySecretarysName | //pt:TaxationSocialSecurityDueWithinOneYear | //pt:NameApprovingDirector | //pt:NumberOrdinarySharesAllotted | //pt:EquityAuthorisedDetails | //gc:County | //ae:AccountsInAccordanceWithPartVIICompaniesActRelatingToSmallCompanies | //pt:PrepaymentsAccruedIncomeCurrentAsset | //ae:CompanyDormant | //ae:CompanyNotDormant | //ae:CompaniesHouseDocumentAuthentication" />
  <xsl:variable name="usedNodeList">
    <xsl:for-each select="$usedNodes">
      :<xsl:value-of select="name(.)" />:
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="unusedNodes" select="//ae:*[@contextRef and not(contains($usedNodeList, concat(':',name(.),':'))) and not(child::*)] | //gc:*[@contextRef and not(contains($usedNodeList, concat(':',name(.),':'))) and not(child::*)] | //pt:*[@contextRef and not(contains($usedNodeList, concat(':',name(.),':'))) and not(child::*)]" />
  <xsl:if test="$unusedNodes">
    <h1 style="color: red">Unused Elements</h1>
    <xsl:message>Unused elements found.</xsl:message>
  <table style="border: none">
    <xsl:for-each select="$unusedNodes">
      <tr>
        <td style="color:red">
          <xsl:value-of select="local-name()" />
        </td>
        <td style="color:red">
          <xsl:value-of select="." />
        </td>
        <td style="color:red">
          <xsl:value-of select="@contextRef" />
        </td>
      </tr>
    </xsl:for-each>
  </table>
  </xsl:if>

  </xsl:template>
  <xsl:template name="printDuplicateElements">
  <xsl:variable name="duplicates">
    <xsl:for-each select="(//ae:* | //gc:* | //pt:*)[@contextRef]">
      <xsl:variable name="curNode" select="self::node()" />
      <xsl:variable name="curName" select="name(.)" />
      <xsl:variable name="curCon" select="./@contextRef" />
      <xsl:if test="following-sibling::*[(name() = $curName) and (./@contextRef = $curCon)]">
	Element:'<xsl:value-of select="$curName"/>' with value: '<xsl:value-of select="."/>' in context '<xsl:value-of select="./@contextRef"/>'.</xsl:if>
    </xsl:for-each>
  </xsl:variable>

  <xsl:if test="$duplicates != ''">
    <xsl:message terminate="yes">Duplicate elements found.<xsl:value-of select="$duplicates"/></xsl:message>
  </xsl:if>

  <xsl:variable name="instantContexts" select="//xbrli:context[.//xbrli:instant]" />
  <xsl:variable name="iduplicates">
    <xsl:for-each select="(//ae:* | //gc:* | //pt:*)[@contextRef]">
      <xsl:variable name="contextRef" select="./@contextRef" />
      <xsl:variable name="icontext" select="$instantContexts[@id = $contextRef]" />
      <xsl:if test="$icontext"> <!-- is it in an instant context? -->
        <xsl:variable name="cdate" select="$icontext//xbrli:instant" /> <!-- context date -->
        <xsl:variable name="name" select="name()" /> <!-- qname of the item -->
        <xsl:for-each select="following-sibling::*[name() = $name]">
        	<xsl:variable name="duplicate_contextRef" select="./@contextRef" /> 
        	<xsl:variable name="duplicate_date" select="$instantContexts[@id = $duplicate_contextRef]//xbrli:instant" />
          <xsl:if test="$duplicate_date = $cdate">
            Element: '<xsl:value-of select="name()" />' with value '<xsl:value-of select="."/>'.
          </xsl:if>
        </xsl:for-each>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>

  <xsl:if test="$iduplicates != ''">
    <xsl:message terminate="yes">Duplicate (different context, but same instant date) elements found.<xsl:value-of select="$iduplicates"/></xsl:message>
  </xsl:if>


  </xsl:template>


  <xsl:template name="datePlusOne">
    <xsl:param name="date" /> <!-- Must be in format yyyymmdd -->
    <xsl:if test="string-length($date) != 8">
      <xsl:message terminate="yes">
        Cannot increment date <xsl:value-of select="$date" />.
      </xsl:message>
    </xsl:if>

    <xsl:variable name="monthday" select="substring($date,5,4)" />
    <xsl:variable name="year" select="substring($date,1,4)" />

    <xsl:choose>
      <!-- If the end of a month, wrap around -->
      <xsl:when test="$monthday = '0131'"><xsl:value-of select="$year" />0201</xsl:when>
      <xsl:when test="$monthday = '0228'"><xsl:value-of select="$year" />0301</xsl:when>
      <xsl:when test="$monthday = '0229'"><xsl:value-of select="$year" />0301</xsl:when>
      <xsl:when test="$monthday = '0331'"><xsl:value-of select="$year" />0401</xsl:when>
      <xsl:when test="$monthday = '0430'"><xsl:value-of select="$year" />0501</xsl:when>
      <xsl:when test="$monthday = '0531'"><xsl:value-of select="$year" />0601</xsl:when>
      <xsl:when test="$monthday = '0630'"><xsl:value-of select="$year" />0701</xsl:when>
      <xsl:when test="$monthday = '0731'"><xsl:value-of select="$year" />0801</xsl:when>
      <xsl:when test="$monthday = '0831'"><xsl:value-of select="$year" />0901</xsl:when>
      <xsl:when test="$monthday = '0930'"><xsl:value-of select="$year" />1001</xsl:when>
      <xsl:when test="$monthday = '1031'"><xsl:value-of select="$year" />1101</xsl:when>
      <xsl:when test="$monthday = '1130'"><xsl:value-of select="$year" />1201</xsl:when>
      <xsl:when test="$monthday = '1231'"><xsl:value-of select="1+$year" />0101</xsl:when>
      <xsl:otherwise><xsl:value-of select="$date + 1" /></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
