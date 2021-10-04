<?xml version="1.0" ?>

<!-- Copyright (c) 2004-2005 Companies House -->
                                                                                
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:pt="http://www.xbrl.org/uk/fr/gaap/pt/2004-12-01" xmlns:ae='http://www.companieshouse.gov.uk/ef/xbrl/uk/fr/gaap/ae/2008-04-06' xmlns:xbrli='http://www.xbrl.org/2003/instance' xmlns:iso4217='http://www.xbrl.org/2003/iso4217' xmlns:link='http://www.xbrl.org/2003/linkbase' xmlns:xlink='http://www.w3.org/1999/xlink' xmlns:gc="http://www.xbrl.org/uk/fr/gcd/2004-12-01" xmlns:html="http://www.w3.org/1999/xhtml" exclude-result-prefixes="html pt link xlink iso4217 xbrli ae gc">

  <xsl:output method="xml" indent="yes" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />

  <xsl:variable name="pl_present">0<xsl:if test="//pt:ProfitLossOnOrdinaryActivitiesBeforeTax">1</xsl:if></xsl:variable>

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

<!-- $Id: CH-AE-dormant-stylesheet.dsl,v 1.49 2006-08-01 10:57:40 gel Exp $ -->

<tr>
  <td align="center">
    <table><tr>
      <td style="whitespace: no-wrap; font-weight: bold;" align="left">
        Registered Number <xsl:call-template name='displayItem'><xsl:with-param name='item' select='//ae:CompaniesHouseRegisteredNumber' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template><br/>
        <h1><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//gc:EntityCurrentLegalName' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></h1>
        <h1>Dormant Accounts</h1>
        <h1><xsl:call-template name="formatDate"><xsl:with-param name="date" select="//gc:BalanceSheetDate" /></xsl:call-template></h1>
      </td>
    </tr></table>
  </td>
</tr>
</table>
<br style="page-break-after: always"/>

<xsl:variable name="fn_accounting_policies">0<xsl:if test="//ae:AccountingPolicy or //ae:AccountsPreparedUnderHistoricalCostConventionInAccordanceWithFRSE or //ae:DepreciationRate">1</xsl:if></xsl:variable>
<xsl:variable name="fn_agency_arrangements">0<xsl:if test="//ae:CompanyHasActedAsAnAgentDuringPeriod">1</xsl:if></xsl:variable>
<xsl:variable name="fn_adjust" select="$fn_accounting_policies + $fn_agency_arrangements"/>
<xsl:variable name="fnn_footnotes" select="$fn_adjust"/>

<!-- dormant footnotes -->
<xsl:variable name="fn_shares">0<xsl:if test="//pt:TotalNumberSharesIssued or //pt:TotalConsideration or //pt:TotalNominalValue">1</xsl:if></xsl:variable>
<xsl:variable name="fn_agent">0<xsl:if test="//ae:CompanyHasActedAsAnAgentDuringPeriod='true'">1</xsl:if></xsl:variable>
<xsl:variable name="fn_exchange_rate">0<xsl:if test="//ae:ForeignExchangeRate">1</xsl:if></xsl:variable>

<xsl:variable name="fnn_shares" select="1"/>
<xsl:variable name="fnn_agent" select="$fnn_shares + $fn_shares"/>
<xsl:variable name="fnn_exchange_rate" select="$fnn_agent + $fn_agent"/>
<table width="100%" class="rnheader">
<tr style="font-weight:bold"><td align="left"><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//gc:EntityCurrentLegalName' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td><td align="right">Registered Number <xsl:call-template name='displayItem'><xsl:with-param name='item' select='//ae:CompaniesHouseRegisteredNumber' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></td></tr>
</table>
<table width="100%" border="0">
<tr><td colspan="8"><h2>Balance Sheet as at <xsl:call-template name="formatDate"><xsl:with-param name="date" select="//gc:BalanceSheetDate"/></xsl:call-template></h2></td></tr>
<tr style="font-weight:bold"><td colspan="3"></td><td width="10%" class="rightalign"><xsl:value-of select="$namey2" /></td><td width="10%" class="rightalign"><xsl:value-of select="$namey1" /></td><td width="1%"> </td><td width="10%"></td><td width="10%"> </td></tr>
<tr style="font-weight:bold"><td colspan="3"></td><td width="10%" class="rightalign"><xsl:value-of select="$currencyY2"/></td><td width="10%" class="rightalign"><xsl:value-of select="$currencyY1"/></td><td width="1%"> </td><td width="10%"></td><td width="10%"> </td></tr>
      <xsl:if test='//pt:CalledUpShareCapitalNotPaidNotExpressedAsCurrentAsset[@contextRef=$y2end] or //pt:CalledUpShareCapitalNotPaidNotExpressedAsCurrentAsset[@contextRef=$y1end]'>
        <tr>
          <td>
<span style="font-weight:bold">Called up share capital not paid</span>
          </td>
          <td>

          </td>
          <td>
<xsl:if test='//link:loc[@xlink:href=concat(&quot;#&quot;, //pt:CalledUpShareCapitalNotPaidNotExpressedAsCurrentAsset[@contextRef=$y2end]/@id)] or //link:loc[@xlink:href=concat(&quot;#&quot;, //pt:CalledUpShareCapitalNotPaidNotExpressedAsCurrentAsset[@contextRef=$y1end]/@id)]'><xsl:call-template name='footnoteLinkFor'><xsl:with-param name='fn_adjust' select='$fnn_footnotes - 1'/><xsl:with-param name='loc' select='//link:loc[@xlink:href=concat(&quot;#&quot;, //pt:CalledUpShareCapitalNotPaidNotExpressedAsCurrentAsset[@contextRef=$y2end]/@id)]'/></xsl:call-template></xsl:if>
          </td>
          <td>
<xsl:if test='//pt:CalledUpShareCapitalNotPaidNotExpressedAsCurrentAsset[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:CalledUpShareCapitalNotPaidNotExpressedAsCurrentAsset[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>
<xsl:if test='//pt:CalledUpShareCapitalNotPaidNotExpressedAsCurrentAsset[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:CalledUpShareCapitalNotPaidNotExpressedAsCurrentAsset[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
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
          <td class=';'>

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
<xsl:if test="//pt:CashBankInHand">

<!--
    Current assets
-->

        <tr>
          <td style='font-weight:bold'>
Current assets
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
<xsl:if test='//link:loc[@xlink:href=concat(&quot;#&quot;, //pt:CashBankInHand[@contextRef=$y2end]/@id)] or //link:loc[@xlink:href=concat(&quot;#&quot;, //pt:CashBankInHand[@contextRef=$y1end]/@id)]'><xsl:call-template name='footnoteLinkFor'><xsl:with-param name='fn_adjust' select='$fnn_footnotes - 1'/><xsl:with-param name='loc' select='//link:loc[@xlink:href=concat(&quot;#&quot;, //pt:CashBankInHand[@contextRef=$y2end]/@id)]'/></xsl:call-template></xsl:if>
          </td>
          <td>
<xsl:if test='//pt:CashBankInHand[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:CashBankInHand[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>
<xsl:if test='//pt:CashBankInHand[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:CashBankInHand[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
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
          <td class=';'>

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
    Net assets
-->

      <xsl:if test='//pt:NetAssetsLiabilitiesIncludingPensionAssetLiability[@contextRef=$y2end] or //pt:NetAssetsLiabilitiesIncludingPensionAssetLiability[@contextRef=$y1end]'>
        <tr>
          <td>
Net assets
          </td>
          <td>

          </td>
          <td>
<xsl:if test='//link:loc[@xlink:href=concat(&quot;#&quot;, //pt:NetAssetsLiabilitiesIncludingPensionAssetLiability[@contextRef=$y2end]/@id)] or //link:loc[@xlink:href=concat(&quot;#&quot;, //pt:NetAssetsLiabilitiesIncludingPensionAssetLiability[@contextRef=$y1end]/@id)]'><xsl:call-template name='footnoteLinkFor'><xsl:with-param name='fn_adjust' select='$fnn_footnotes - 1'/><xsl:with-param name='loc' select='//link:loc[@xlink:href=concat(&quot;#&quot;, //pt:NetAssetsLiabilitiesIncludingPensionAssetLiability[@contextRef=$y2end]/@id)]'/></xsl:call-template></xsl:if>
          </td>
          <td>
<xsl:if test='//pt:NetAssetsLiabilitiesIncludingPensionAssetLiability[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:NetAssetsLiabilitiesIncludingPensionAssetLiability[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>
<xsl:if test='//pt:NetAssetsLiabilitiesIncludingPensionAssetLiability[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:NetAssetsLiabilitiesIncludingPensionAssetLiability[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
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
<xsl:if test="//pt:EquityAuthorisedDetails">

<!--
    Authorised share capital
-->

        <tr>
          <td style='font-weight:bold'>
Authorised share capital
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
<xsl:for-each select="//pt:EquityAuthorisedDetails">
  <xsl:variable name="t" select="." />
  <xsl:variable name="numy2" select="./pt:NumberOrdinarySharesAuthorised[@contextRef=$y2end]"/>
        <tr>
          <td>
<xsl:value-of select="concat($numy2,' ')"/> <xsl:value-of select=".//pt:TypeOrdinaryShare[@contextRef=$y2]"/> of <xsl:value-of select="concat(normalize-space($currencyY2), ./pt:ParValueOrdinaryShare[@contextRef=$y2])"/> each
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
</xsl:if>

<!--
    Issued share capital
-->

        <tr>
          <td style='font-weight:bold'>
Issued share capital
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
<xsl:for-each select="//pt:DetailsOrdinarySharesAllotted">
  <xsl:variable name="t" select="." />
  <xsl:variable name="numy2" select="./pt:NumberOrdinarySharesAllotted[@contextRef=$y2end]"/>
      <xsl:if test='//pt:ValueOrdinarySharesAllotted[..=$t and @contextRef=$y2end] or //pt:ValueOrdinarySharesAllotted[..=$t and @contextRef=$y1end]'>
        <tr>
          <td>
<xsl:value-of select="concat($numy2,' ')"/> <xsl:value-of select=".//pt:TypeOrdinaryShare[@contextRef=$y2]"/> of <xsl:value-of select="concat(normalize-space($currencyY2), ./pt:ParValueOrdinaryShare[@contextRef=$y2])"/> each
          </td>
          <td>

          </td>
          <td>
<xsl:if test='//link:loc[@xlink:href=concat(&quot;#&quot;, //pt:ValueOrdinarySharesAllotted[..=$t and @contextRef=$y2end]/@id)] or //link:loc[@xlink:href=concat(&quot;#&quot;, //pt:ValueOrdinarySharesAllotted[..=$t and @contextRef=$y1end]/@id)]'><xsl:call-template name='footnoteLinkFor'><xsl:with-param name='fn_adjust' select='$fnn_footnotes - 1'/><xsl:with-param name='loc' select='//link:loc[@xlink:href=concat(&quot;#&quot;, //pt:ValueOrdinarySharesAllotted[..=$t and @contextRef=$y2end]/@id)]'/></xsl:call-template></xsl:if>
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

<!--
    Total shareholder funds
-->

      <xsl:if test='//pt:ShareholderFunds[@contextRef=$y2end] or //pt:ShareholderFunds[@contextRef=$y1end]'>
        <tr>
          <td>
Total shareholder funds
          </td>
          <td>

          </td>
          <td>
<xsl:if test='//link:loc[@xlink:href=concat(&quot;#&quot;, //pt:ShareholderFunds[@contextRef=$y2end]/@id)] or //link:loc[@xlink:href=concat(&quot;#&quot;, //pt:ShareholderFunds[@contextRef=$y1end]/@id)]'><xsl:call-template name='footnoteLinkFor'><xsl:with-param name='fn_adjust' select='$fnn_footnotes - 1'/><xsl:with-param name='loc' select='//link:loc[@xlink:href=concat(&quot;#&quot;, //pt:ShareholderFunds[@contextRef=$y2end]/@id)]'/></xsl:call-template></xsl:if>
          </td>
          <td>
<xsl:if test='//pt:ShareholderFunds[@contextRef=$y2end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:ShareholderFunds[@contextRef=$y2end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>
<xsl:if test='//pt:ShareholderFunds[@contextRef=$y1end]/@unitRef'><xsl:attribute name='class'>rightalign</xsl:attribute></xsl:if><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:ShareholderFunds[@contextRef=$y1end]' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>
          </td>
          <td>

          </td>
          <td>

          </td>
          <td>

          </td>
        </tr>
      </xsl:if>
</table>
<table>
<tr><td colspan="8">
<xsl:if test="$fn_shares=1 or $fn_agent=1 or //ae:ForeignExchangeRate">
<p style="font-weight:bold">NOTES</p>
<ol type="1">
<xsl:if test="$fn_shares=1"><li>During the year the company allotted <xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:TotalNumberSharesIssued' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template> ordinary shares with an aggregate nominal value of <xsl:value-of select="$currencyY2" /><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:TotalNominalValue' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>, the consideration received by the company was <xsl:value-of select="$currencyY2" /><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:TotalConsideration' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template></li></xsl:if>

<xsl:if test="$fn_agent=1"><li>During the year the company acted as an agent for a person</li></xsl:if>
<xsl:if test="//ae:ForeignExchangeRate"><li><a name="fn_exchange_rate"/>
  <xsl:for-each select="//ae:ForeignExchangeRate">
    <xsl:value-of select="."/><br/>
  </xsl:for-each>
</li></xsl:if>
</ol>
</xsl:if>
<p style="font-weight:bold">STATEMENTS</p>
<ol type="a">
<xsl:if test="//ae:CompanyEntitledToExemptionUnderSection249AA1CompaniesAct1985='true'"><li>For the year ending <xsl:call-template name="formatDate"><xsl:with-param name="date" select="//gc:BalanceSheetDate" /></xsl:call-template> the company was entitled to exemption under section 249AA(1) of the Companies Act 1985.</li></xsl:if>
<xsl:if test="//ae:CompanyEntitledToExemptionUnderSection480CompaniesAct2006='true'"><li>For the year ending <xsl:call-template name="formatDate"><xsl:with-param name="date" select="//gc:BalanceSheetDate" /></xsl:call-template> the company was entitled to exemption under section 480 of the Companies Act 2006.</li></xsl:if>
<xsl:choose>
<xsl:when test="(number(translate(//xbrli:context[@id=$y2]/xbrli:period/xbrli:startDate,'-:T', '')) &lt; number('20080406'))">
<xsl:if test="//ae:MembersHaveNotRequiredCompanyToObtainAnAudit='true'"><li>The members have not required the company to obtain an audit in accordance with section 249B(2) of the Companies Act 1985.</li></xsl:if>
<xsl:if test="//ae:DirectorsAcknowledgeTheirResponsibilitiesUnderCompaniesAct='true'"><li>The directors acknowledge their responsibility for:
<ol type="i"><li>ensuring the company keeps accounting records which comply with Section 221; and</li>
<li>preparing accounts which give a true and fair view of the state of affairs of the company as at the end of the financial year, and of its profit or loss for the financial year, in accordance with the requirements of section 226, and which otherwise comply with the requirements of the Companies Act relating to accounts, so far as is applicable to the company.</li></ol></li></xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test="//ae:MembersHaveNotRequiredCompanyToObtainAnAudit='true'"><li>The members have not required the company to obtain an audit in accordance with section 476 of the Companies Act 2006.</li></xsl:if>
<xsl:if test="//ae:DirectorsAcknowledgeTheirResponsibilitiesUnderCompaniesAct='true'"><li>The directors acknowledge their responsibility for:
<ol type="i"><li>ensuring the company keeps accounting records which comply with Section 386; and</li>
<li>preparing accounts which give a true and fair view of the state of affairs of the company as at the end of the financial year, and of its profit or loss for the financial year, in accordance with the requirements of section 393, and which otherwise comply with the requirements of the Companies Act relating to accounts, so far as is applicable to the company.</li></ol></li></xsl:if>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="//ae:AccountsAreInAccordanceWithSpecialProvisionsCompaniesActRelatingToSmallCompanies='true'"><li>These accounts have been prepared in accordance with the provisions applicable to companies subject to the small companies regime.</li></xsl:if>
</ol>
<p>Approved by the Board on <xsl:call-template name="formatDate"><xsl:with-param name="date" select="//pt:DateApproval"/></xsl:call-template></p>
<p>And signed on their behalf by:<br/>
<span style="padding: 0 0 0 1em; font-weight: bold"><xsl:call-template name='displayItem'><xsl:with-param name='item' select='//pt:NameApprovingDirector' /><xsl:with-param name='flipSign'></xsl:with-param></xsl:call-template>, Director</span><br />
<xsl:for-each select="//pt:AdditionalApprovingPerson">
<span style="padding: 0 0 0 1em; font-weight: bold"><xsl:value-of select="./pt:NameAdditionalApprovingPerson"/>, <xsl:value-of select="./pt:PositionAdditionalApprovingPerson"/></span><br />
</xsl:for-each>
</p><br />

<!--Following removed for  CR55782 and following lines included - Jan 09 for implementation in Oct09 with CAP09 
<xsl:choose>
<xsl:when test="(number(translate(//xbrli:context[@id=$y2]/xbrli:period/xbrli:startDate,'-:T', '')) >= number('20080406')) and number(translate(//ae:DateAccountsReceived, '-:T', '')) >= number('20081001')">
<p style="font-weight: bold">This document was delivered using electronic communications and authenticated in accordance with the registrar's rules relating to electronic form, authentication and manner of delivery under section 1072 of the Companies Act 2006.</p>
</xsl:when>
<xsl:otherwise>
<p style="font-weight: bold">This document was delivered using electronic communications and authenticated in accordance with section 707B(2) of the Companies Act 1985.</p>
</xsl:otherwise>
</xsl:choose>
-->

<!--comment line - Output appropriate 'Received' message depending on which ACT applies 
comment line - Only output message for accounts received by CH ie DateAccountsReceived (inserted by XML2TAG) present
-->

<!--Statements swapped around as a result of: P8454 -->
<xsl:choose>
    <xsl:when test="//ae:DateAccountsReceived">
         <xsl:choose>
             <xsl:when test="(number(translate(//xbrli:context[@id=$y2]/xbrli:period/xbrli:startDate,'-:T', '')) &lt; number('20080406'))">
                 <p style="font-weight: bold">This document was delivered using electronic communications and authenticated in accordance with section 707B(2) of the Companies Act 1985.</p>
             </xsl:when>
             <xsl:otherwise>
              <p style="font-weight: bold">This document was delivered using electronic communications and authenticated in accordance with the registrar's rules relating to electronic form, authentication and manner of delivery under section 1068 of the Companies Act 2006.</p>
                             </xsl:otherwise>
         </xsl:choose>
     </xsl:when>
</xsl:choose>


</td></tr>
<xsl:if test="//link:footnoteLink">
  <xsl:message terminate="yes">
    Footnotes should not be present in dormant accounts
  </xsl:message>
</xsl:if>

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
        <xsl:when test="$flipSign='(' and . &lt;= 0"><xsl:number value="0-." grouping-separator="," grouping-size="3" /></xsl:when>
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
    <xsl:param name='extra_fn' />
    <xsl:param name='fn_adjust' />
    <xsl:param name='loc' />
    <xsl:param name='footnoteNum' select='0' />
    <xsl:variable name='footnoteName' select='
  //link:footnoteArc[
    @xlink:from = $loc/@xlink:label
  ]/@xlink:to
  ' />
    <xsl:variable name="first_fn" select="//link:footnote[@xlink:label=$footnoteName and (position() = 1)]"/>
    <xsl:for-each select='//link:footnote'>
      <xsl:if test='@xlink:label=$footnoteName'>
        <xsl:if test="not(. | $first_fn) or ($extra_fn and (. | $first_fn))">, </xsl:if>
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

				<xsl:variable name="numDurationContexts" select="count(//xbrli:context[.//xbrli:startDate and //*/@contextRef=./@id])" />
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

        <!--Code added to display full date if the current period year and previous period year are the same-->
          <xsl:variable name='y1Year' select='substring(normalize-space($cr1//xbrli:instant),1,4)'></xsl:variable>
          <xsl:variable name='y2Year' select='substring(normalize-space($cr2//xbrli:instant),1,4)'></xsl:variable>
          <xsl:variable name='y2Month' select='substring(normalize-space($cr2//xbrli:instant),6,2)'></xsl:variable>
          <xsl:variable name='y2Day' select='substring(normalize-space($cr2//xbrli:instant),9,2)'></xsl:variable>
          <xsl:variable name='y2Full'>
            <xsl:value-of select="concat($y2Day,'/')"></xsl:value-of>
            <xsl:value-of select="concat($y2Month,'/')"></xsl:value-of>
            <xsl:value-of select='$y2Year'></xsl:value-of>
          </xsl:variable>
          <xsl:variable name='ColumnHeading2'>
            <xsl:choose>
              <xsl:when test='$y2Year = $y1Year'>
                <xsl:value-of select='$y2Full'></xsl:value-of>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select='$y2Year'></xsl:value-of>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name='y1Month' select='substring(normalize-space($cr1//xbrli:instant),6,2)'></xsl:variable>
          <xsl:variable name='y1Day' select='substring(normalize-space($cr1//xbrli:instant),9,2)'></xsl:variable>
          <xsl:variable name='y1Full'>
            <xsl:value-of select="concat($y1Day,'/')"></xsl:value-of>
            <xsl:value-of select="concat($y1Month,'/')"></xsl:value-of>
            <xsl:value-of select='$y1Year'></xsl:value-of>
          </xsl:variable>
          <xsl:variable name='ColumnHeading1'>
            <xsl:choose>
              <xsl:when test='$y2Year = $y1Year'>
                <xsl:value-of select='$y1Full'></xsl:value-of>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select='$y1Year'></xsl:value-of>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
        <!-- End of Code added-->

				
				<!-- Call main using this information. The currency per period
					is that that NetAssets is quoted in -->
				<xsl:call-template name="main">
					<xsl:with-param name="y2" select="//xbrli:context[@id=$y2 and .//xbrli:startDate]/@id" />
					<xsl:with-param name="y1" select="//xbrli:context[@id=$y1 and .//xbrli:startDate]/@id" />
					<xsl:with-param name="y2start" select="$y2start" />
					<xsl:with-param name="y1start" select="$y1start" />
					<xsl:with-param name="y2end" select="$y2end" />
					<xsl:with-param name="y1end" select="$y1end" />
<!--					<xsl:with-param name="namey2" select="substring(normalize-space($cr2//xbrli:instant),1,4)" />
					<xsl:with-param name="namey1" select="substring(normalize-space($cr1//xbrli:instant),1,4)" /> -->

          <!-- Added by CH -->
          <xsl:with-param name='namey2' select='$ColumnHeading2'></xsl:with-param>
          <xsl:with-param name='namey1' select='$ColumnHeading1'></xsl:with-param>
          <!-- ~Added by CH -->

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
 <!-- <xsl:if test="($uniqueUnits != 'iso4217:GBP')">--> <!-- this currency isn't GBP -->
<!--  <xsl:if test="not(//ae:ForeignExchangeRate[@contextRef=$contexts])"> --> <!-- there're no exchange rate footnote/s -->
 <!-- <xsl:message terminate="yes">Non-GBP currency used but no exchange rate footnote/s provided</xsl:message>
      </xsl:if>
    </xsl:if>-->
  </xsl:template>
  <!-- Report any unused elements in the instance. Note that this must be the last
       template -->
  <xsl:template name="printUnusedElements">
  <xsl:variable name="usedNodes" select="//pt:NetAssetsLiabilitiesIncludingPensionAssetLiability | //ae:DirectorsAcknowledgeTheirResponsibilitiesUnderCompaniesAct | //gc:CityOrTown | //pt:AdditionalApprovingPerson | //ae:CompaniesHouseRegisteredNumber | //ae:AddressCH | //ae:DateAccountsReceived | //ae:AccountingPolicy | //pt:PositionAdditionalApprovingPerson | //gc:EntityCurrentLegalName | //pt:CalledUpShareCapitalNotPaidNotExpressedAsCurrentAsset | //ae:CompanyHasActedAsAnAgentDuringPeriod | //pt:DetailsOrdinarySharesAllotted | //gc:BalanceSheetDate | //pt:TotalNumberSharesIssued | //pt:TotalNominalValue | //ae:ForeignExchangeRate | //gc:Postcode | //ae:AccountsPreparedUnderHistoricalCostConventionInAccordanceWithFRSE | //pt:ProfitLossOnOrdinaryActivitiesBeforeTax | //gc:Country | //pt:ShareholderFunds | //pt:NameAdditionalApprovingPerson | //pt:ValueOrdinarySharesAllotted | //gc:AddressLine1 | //ae:AccountsAreInAccordanceWithSpecialProvisionsCompaniesActRelatingToSmallCompanies | //ae:DepreciationRate | //gc:AddressLine3 | //pt:TotalConsideration | //ae:CompanyEntitledToExemptionUnderSection249AA1CompaniesAct1985 | //ae:MembersHaveNotRequiredCompanyToObtainAnAudit | //gc:AddressLine2 | //pt:TypeOrdinaryShare | //ae:CompanyEntitledToExemptionUnderSection480CompaniesAct2006 | //pt:NameApprovingDirector | //pt:NumberOrdinarySharesAllotted | //pt:EquityAuthorisedDetails | //pt:NumberOrdinarySharesAuthorised | //pt:CashBankInHand | //gc:County | //pt:DateApproval | //pt:ParValueOrdinaryShare | //ae:CompanyDormant | //ae:CompanyNotDormant | //ae:CompaniesHouseDocumentAuthentication" />
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
      <xsl:variable name="curUnit" select="./@unitRef" />
      <xsl:if test="following-sibling::*[(name() = $curName) and (./@contextRef = $curCon) and (./@unitRef = $curUnit)]">
	Element:'<xsl:value-of select="$curName"/>' with value: '<xsl:value-of select="."/>' in context '<xsl:value-of select="./@contextRef"/>' with unitRef '<xsl:value-of select="./@unitRef"/>'.</xsl:if>
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
        <xsl:variable name="unit" select="@unitRef" /> <!-- qname of the item -->
        <xsl:for-each select="following-sibling::*[(name() = $name) and (@unitRef = $unit)]">
        	<xsl:variable name="duplicate_contextRef" select="./@contextRef" /> 
        	<xsl:variable name="duplicate_date" select="$instantContexts[@id = $duplicate_contextRef]//xbrli:instant" />
          <xsl:if test="$duplicate_date = $cdate">
            Element: '<xsl:value-of select="name()" />' with value '<xsl:value-of select="."/>' and unitRef '<xsl:value-of select="./@unitRef"/>'.
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
