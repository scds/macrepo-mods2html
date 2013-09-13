<xsl:stylesheet xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="mods" version="1.0">
  <xsl:output indent="yes" method="html"/>
  <xsl:variable name="dictionary" select="document('http://www.loc.gov/standards/mods/modsDictionary.xml')/dictionary"/>

  <!-- main template -->
  <xsl:template match="/">
    <html>
      <head>
        <style>
          div.container {
            width: 500px;
            float: left;
          }
          div.row {
            float: left;
            clear: left;
            width: 100%;
          }
          div.heading {
            font-variant: small-caps;
            font-size: small;
            padding-left: 10px;
          }
          div.label {
            text-align: right;
            font-weight: bold;
            float: left;
            width: 200px;
          }
          div.value {
            float: left;
            padding-left: 10px;
          }
          div.shadedBlock {
            border-left: 1px solid #DDD;
            background: #F8F8F8;
          }
        </style>
      </head>
      <body>
        <div id="container">
          <xsl:apply-templates />
        </div>
      </body>
    </html>
  </xsl:template>

  <!-- apply templates to mods:modsCollection root -->
  <xsl:template match="mods:modsCollection">
    <xsl:apply-templates select="mods:modsCollection" />
  </xsl:template>

  <!-- apply templates to mods:mods root -->
  <xsl:template match="mods:mods">
    <xsl:apply-templates />
  </xsl:template>

  <!-- process each top-level child of mods:mods -->
  <xsl:template match="mods:*">
    <xsl:choose>
      <xsl:when test="*">
        <div class="row">
          <div class="heading">
            <xsl:call-template name="longName">
              <xsl:with-param name="name">
                <xsl:value-of select="local-name()" />
              </xsl:with-param>
            </xsl:call-template>
          </div>
          <!-- apply custom templates, or default to applying this template recursively -->
          <xsl:apply-templates />
        </div>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="createRow" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- format mods:titleInfo elements -->
  <xsl:template match="mods:titleInfo">
    <div class="row">
      <div class="label">
        <xsl:text>Title</xsl:text>
      </div>
      <div class="value">
        <xsl:value-of select="mods:nonSort" />
        <xsl:value-of select="mods:title" />
      </div>
    </div>
  </xsl:template>
  
  <!-- format mods:originInfo elements -->
  <xsl:template match="mods:originInfo">
    <xsl:for-each select="mods:place">
      <xsl:if test="mods:placeTerm[@type = 'text']">
        <div class="row">
          <div class="label">
            <xsl:text>Place of origin</xsl:text>
          </div>
          <div class="value">
            <xsl:value-of select="." />
          </div>
        </div>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
  <!-- format mods:language elements -->
  <xsl:template match="mods:language">
    <div class="row">
      <div class="label">
        <xsl:text>Language</xsl:text>
      </div>
      <div class="value">
        <xsl:value-of select="mods:languageTerm" />
      </div>
    </div>
  </xsl:template>
  
  <!-- format mods:physicalDescription elements -->
  <xsl:template match="mods:physicalDescription">
    <xsl:apply-templates />
  </xsl:template>
  
  <!-- format mods:note elements -->
  <xsl:template match="mods:note">
    <div class="row">
      <div class="label">
        <xsl:text>Note</xsl:text>
        <xsl:if test="@type">
          <xsl:text> (</xsl:text>
          <xsl:value-of select="@type" />
          <xsl:text>)</xsl:text>
        </xsl:if>
      </div>
      <div class="value">
        <xsl:value-of select="text()" />
      </div>
    </div>
  </xsl:template>
  
  <!-- format mods:relatedItem elements -->
  <xsl:template match="mods:relatedItem">
    <div class="row shadedBlock">
      <div class="heading">
        <xsl:call-template name="longName">
          <xsl:with-param name="name">
            <xsl:value-of select="local-name()" />
          </xsl:with-param>
        </xsl:call-template>
        <xsl:if test="@displayLabel">
          <xsl:text> (</xsl:text>
          <xsl:value-of select="@displayLabel" />
          <xsl:text>)</xsl:text>
        </xsl:if>
      </div>
      <xsl:apply-templates />
    </div>
  </xsl:template>
  
  <!-- format mods:url elements -->
  <xsl:template match="mods:url">
    <div class="row">
      <div class="label">
        <xsl:text>URL</xsl:text>
        <xsl:if test="@note">
          <xsl:text> (</xsl:text>
          <xsl:value-of select="@note" />
          <xsl:text>)</xsl:text>
        </xsl:if>
      </div>
      <div class="value">
        <xsl:value-of select="text()" />
      </div>
    </div>
  </xsl:template>
  
  <!-- format mods:subject elements -->
  <xsl:template match="mods:subject">
    <div class="row shadedBlock">
      <div class="heading">
        <xsl:call-template name="longName">
          <xsl:with-param name="name">
            <xsl:value-of select="local-name()" />
          </xsl:with-param>
        </xsl:call-template>
      </div>
      <xsl:apply-templates />
    </div>
  </xsl:template>
  
  <!-- format mods:hierarchicalGeographic elements -->
  <xsl:template match="mods:hierarchicalGeographic">
    <xsl:for-each select="*">
      <xsl:call-template name="createRow" />
    </xsl:for-each>
  </xsl:template>
  
  <!-- format mods:name elements -->
  <xsl:template match="mods:name">
    <div class="row">
      <div class="label">
        <xsl:text>Name</xsl:text>
      </div>
      <div class="value">
        <xsl:for-each select="mods:namePart">
          <xsl:choose>
            <xsl:when test="@type = 'date'">
              <xsl:text> [</xsl:text>
              <xsl:value-of select="." />
              <xsl:text>]</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="." />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
        <xsl:text> (</xsl:text>
        <xsl:value-of select="mods:role/mods:roleTerm" />
        <xsl:text>)</xsl:text>
      </div>
    </div>
  </xsl:template>
  
  <!-- format mods:identifier elements -->
  <xsl:template match="mods:identifier">
    <div class="row">
      <div class="label">
        <xsl:choose>
          <xsl:when test="@type = 'local'">
              <xsl:text>Local Identifier</xsl:text>
          </xsl:when>
          <xsl:when test="@type = 'lccn'">
              <xsl:text>LCCN Identifier</xsl:text>
          </xsl:when>
          <xsl:otherwise>
              <xsl:text>Identifier</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </div>
      <div class="value">
        <xsl:value-of select="." />
      </div>
    </div>
  </xsl:template>
  
  <!-- format mods:recordInfo elements -->
  <xsl:template match="mods:recordInfo">
    <xsl:apply-templates />
  </xsl:template>
  
  <!-- format mods:classification elements -->
  <xsl:template match="mods:classification">
    <div class="row">
      <div class="label">
        <xsl:text>Classification</xsl:text>
        <xsl:if test="@authority">
          <xsl:text> (</xsl:text>
          <xsl:value-of select="@authority" />
          <xsl:text>)</xsl:text>
        </xsl:if>
      </div>
      <div class="value">
        <xsl:value-of select="." />
      </div>
    </div>
  </xsl:template>
  
  <!-- create a label/value row -->
  <xsl:template name="createRow">
    <div class="row">
      <div class="label">
        <xsl:call-template name="longName">
          <xsl:with-param name="name">
            <xsl:value-of select="local-name()" />
          </xsl:with-param>
        </xsl:call-template>
      </div>
      <div class="value">
        <xsl:call-template name="formatValue" />
      </div>
    </div>
  </xsl:template>

  <!-- Turns URIs into clickable links -->
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
  
  <!-- expand MODS labels -->
  <xsl:template name="longName">
    <xsl:param name="name" />
    <xsl:choose>
      <xsl:when test="$dictionary/entry[@key=$name]">
        <xsl:value-of select="$dictionary/entry[@key=$name]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$name"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
