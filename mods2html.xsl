<xsl:stylesheet xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="mods" version="1.0">
<xsl:output indent="yes" method="html"/>
<xsl:variable name="dictionary" select="document('http://www.loc.gov/standards/mods/modsDictionary.xml')/dictionary"/>

<xsl:template match="/">
<html>
<head>
<style type="text/css">
.modsLabelTop {
  font-weight:bold;
}

.modsLabelLevel2 {
  font-weight:bold;
}

.modsLabelLevel3 {
  font-weight:bold;
}

.modsLabelLevel4 {
  font-weight:bold;
}

.modsValueTop {
}

.modsValueLevel2 {
}

.modsValueLevel3 {
}

.label {
  text-align:right;
  padding-right:10px;
}

</style>
</head>
<body>
  <xsl:choose>
    <xsl:when test="mods:modsCollection">
      <xsl:apply-templates select="mods:modsCollection"/>
    </xsl:when>
    <xsl:when test="mods:mods">
      <xsl:apply-templates select="mods:mods"/>
    </xsl:when>
  </xsl:choose>
</body>
</html>
</xsl:template>

<xsl:template match="mods:modsCollection">
  <xsl:apply-templates select="mods:mods"/>
</xsl:template>

<xsl:template match="mods:mods">
  <table class="modsContainer">
  <tr><th colspan="2"><h3 class="islandora-obj-details-metadata-title">Metadata <span class="islandora-obj-details-dsid">(MODS)</span></h3></th></tr>
  <xsl:apply-templates/>
  </table>
</xsl:template>

<xsl:variable name="vLower" select="'abcdefghijklmnopqrstuvwxyz'"/>
<xsl:variable name="vUpper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

<xsl:template match="*">
  <xsl:choose>
    <xsl:when test="child::*">
      <xsl:apply-templates mode="level2"/>
    </xsl:when>
    <xsl:otherwise>
      <tr><td class="label">
      <span class="modsLabelTop">
      <xsl:call-template name="longName">
        <xsl:with-param name="name">
          <xsl:value-of select="concat(translate(substring(local-name(), 1, 1), $vLower, $vUpper), substring(local-name(), 2), substring(' ', 1 div not (position()=last())))"/>
        </xsl:with-param>
      </xsl:call-template>
      </span>
      </td><td>
      <span class="modsValueTop">
      <xsl:call-template name="formatValue"/>
      </span>
      </td></tr>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="formatValue">
  <xsl:choose>
    <xsl:when test="@type='uri'">
      <a href="{text()}" class="modsLink">
      <xsl:value-of select="text()"/>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="text()"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="level2">
  <xsl:choose>
    <xsl:when test="child::*">
      <xsl:apply-templates mode="level3"/>
    </xsl:when>
    <xsl:otherwise>
      <tr><td class="label">
      <span class="modsLabelLevel2">
      <xsl:call-template name="longName">
        <xsl:with-param name="name">
          <xsl:value-of select="concat(translate(substring(local-name(), 1, 1), $vLower, $vUpper), substring(local-name(), 2), substring(' ', 1 div not (position()=last())))"/>
        </xsl:with-param>
      </xsl:call-template>
      </span>
      </td><td>
      <span class="modsValueLevel2">
      <xsl:call-template name="formatValue"/>
      </span>
      </td></tr>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="level3">
  <xsl:choose>
    <xsl:when test="child::*">
      <xsl:apply-templates mode="level4"/>
    </xsl:when>
    <xsl:otherwise>
      <tr><td class="label">
      <span class="modsLabelLevel3">
      <xsl:call-template name="longName">
        <xsl:with-param name="name">
          <xsl:value-of select="concat(translate(substring(local-name(), 1, 1), $vLower, $vUpper), substring(local-name(), 2), substring(' ', 1 div not (position()=last())))"/>
        </xsl:with-param>
      </xsl:call-template>
      </span>
      </td><td>
      <span class="modsValueLevel3">
      <xsl:call-template name="formatValue"/>
      </span>
      </td></tr>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="level4">
  <tr><td class="label">
  <span class="modsLabelLevel4">
  <xsl:call-template name="longName">
    <xsl:with-param name="name">
      <xsl:value-of select="concat(translate(substring(local-name(), 1, 1), $vLower, $vUpper), substring(local-name(), 2), substring(' ', 1 div not (position()=last())))"/>
    </xsl:with-param>
  </xsl:call-template>
  </span>
  </td><td>
  <span class="modsValueLevel4">
  <xsl:value-of select="text()"/>
  </span>
  </td></tr>
</xsl:template>

<xsl:template name="longName">
  <xsl:param name="name"/>
  <xsl:choose>
    <xsl:when test="$dictionary/entry[@key=$name]">
      <xsl:value-of select="$dictionary/entry[@key=$name]"/>
    </xsl:when>
    <xsl:otherwise>
      <!-- This can't be the best way to do this... -->
      <xsl:choose>
        <xsl:when test="contains($name, 'TitleInfo')">
          <xsl:value-of select="string('Title info')" />
        </xsl:when>
        <xsl:when test="contains($name, 'OriginInfo')">
          <xsl:value-of select="string('Origin info')" />
        </xsl:when>
        <xsl:when test="contains($name, 'PhysicalDescription')">
          <xsl:value-of select="string('Physical description')" />
        </xsl:when>
        <xsl:when test="contains($name, 'RelatedItem')">
          <xsl:value-of select="string('Related item')" />
        </xsl:when>
        <xsl:when test="contains($name, 'DigitalOrigin')">
          <xsl:value-of select="string('Digital origin')" />
        </xsl:when>
        <xsl:when test="contains($name, 'HierarchicalGeographic')">
          <xsl:value-of select="string('Hierarchical geographic')" />
        </xsl:when>
        <xsl:when test="contains($name, 'CitySection')">
          <xsl:value-of select="string('City section')" />
        </xsl:when>
        <xsl:when test="contains($name, 'TypeOfResource')">
          <xsl:value-of select="string('Type of resource')" />
        </xsl:when>
        <xsl:when test="contains($name, 'DateCreated')">
          <xsl:value-of select="string('Date created')" />
        </xsl:when>
        <xsl:when test="contains($name, 'DateOther')">
          <xsl:value-of select="string('Date other')" />
        </xsl:when>
        <xsl:when test="contains($name, 'RoleTerm')">
          <xsl:value-of select="string('Role term')" />
        </xsl:when>
        <xsl:when test="contains($name, 'LanguageTerm')">
          <xsl:value-of select="string('Language term')" />
        </xsl:when>
        <xsl:when test="contains($name, 'InternetMediaType')">
          <xsl:value-of select="string('Internet media type')" />
        </xsl:when>
        <xsl:when test="contains($name, 'PhysicalLocation')">
          <xsl:value-of select="string('Physical location')" />
        </xsl:when>
        <xsl:when test="contains($name, 'AccessCondition')">
          <xsl:value-of select="string('Access condition')" />
        </xsl:when>
        <xsl:when test="contains($name, 'PlaceTerm')">
          <xsl:value-of select="string('Place term')" />
        </xsl:when>
        <xsl:when test="contains($name, 'NamePart')">
          <xsl:value-of select="string('Name part')" />
        </xsl:when>
        <xsl:when test="contains($name, 'RecordInfo')">
          <xsl:value-of select="string('Record info')" />
        </xsl:when>
        <xsl:when test="contains($name, 'RecordContentSource')">
          <xsl:value-of select="string('Record content source')" />
        </xsl:when>
        <xsl:when test="contains($name, 'RecordCreationDate')">
          <xsl:value-of select="string('Record creation date')" />
        </xsl:when>
        <xsl:when test="contains($name, 'RecordChangeDate')">
          <xsl:value-of select="string('Record change date')" />
        </xsl:when>
        <xsl:when test="contains($name, 'RecordIdentifier')">
          <xsl:value-of select="string('Record identifier')" />
        </xsl:when>
        <xsl:when test="contains($name, 'DateIssued')">
          <xsl:value-of select="string('Date issued')" />
        </xsl:when>
        <xsl:when test="contains($name, 'GeographicCode')">
          <xsl:value-of select="string('Geographic code')" />
        </xsl:when>
        <xsl:when test="contains($name, 'TableOfContents ')">
          <xsl:value-of select="string('Table of contents')" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
</xsl:stylesheet>
