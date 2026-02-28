<?xml version="1.0" encoding="UTF-8"?>

<!--
  ======================================================================
  本スタイルシートは、気象庁防災情報XMLフォーマット形式電文中の全ての情
  報コンテンツを出力するもので、システム処理の動作確認など、電文処理の参
  考資料としてお使い下さい。

  なお、本スタイルシートについては、システムに直接組み込む等の方法でご利
  用になることは避けていただくなど、ご利用に当たっては十分に注意していた
  だきますよう、よろしくお願いいたします。

  Copyright (c) 気象庁 2012 All rights reserved.
  
  【対象情報】
  土砂災害警戒情報

  【更新履歴】
  2012年03月29日　Ver.1.0
  2019年04月24日　Ver.1.1 5月1日より施行される新元号への対応
  ======================================================================
-->

<xsl:stylesheet xmlns:jmx="http://xml.kishou.go.jp/jmaxml1/" xmlns:jmx_ib="http://xml.kishou.go.jp/jmaxml1/informationBasis1/" xmlns:jmx_add="http://xml.kishou.go.jp/jmaxml1/addition1/" xmlns:jmx_eb="http://xml.kishou.go.jp/jmaxml1/elementBasis1/" xmlns:jmx_mete="http://xml.kishou.go.jp/jmaxml1/body/meteorology1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" exclude-result-prefixes="jmx jmx_ib jmx_add jmx_eb jmx_mete">
  <xsl:output method="html" encoding="SHIFT_JIS" />
  <xsl:template match="/">
  
  	<html><head></head><body><pre>
  
    <xsl:apply-templates select="/jmx:Report/jmx_ib:Head" />
    <xsl:apply-templates select="/jmx:Report/jmx:Control/jmx:PublishingOffice" />
    <xsl:apply-templates select="/jmx:Report/jmx_ib:Head/jmx_ib:Headline/jmx_ib:Information" />
    <xsl:apply-templates select="/jmx:Report/jmx_ib:Head/jmx_ib:Headline/jmx_ib:Text" />
    <xsl:apply-templates select="/jmx:Report/jmx_mete:Body/jmx_mete:OfficeInfo" />
	
	
    <xsl:apply-templates select="/jmx:Report/jmx_mete:Body/jmx_mete:Warning" />
	
	
	</pre>
	</body>
	</html>
	
  </xsl:template>
  
  <xsl:template match="/jmx:Report/jmx_mete:Body/jmx_mete:Warning">

		<xsl:text>

市町村一覧</xsl:text>

	<xsl:for-each select="jmx_mete:Item">
		<xsl:text>
　</xsl:text>
		<xsl:value-of select="jmx_mete:Area/jmx_mete:Name"/>
		<xsl:text>　</xsl:text>
		<xsl:value-of select="jmx_mete:Kind/jmx_mete:Name"/>
		<xsl:text>　</xsl:text>
		<xsl:value-of select="jmx_mete:Kind/jmx_mete:Status"/>

	</xsl:for-each>

  </xsl:template>
  
  
  <xsl:template match="/jmx:Report/jmx_ib:Head">
    <xsl:value-of select="./jmx_ib:Title" />
    <xsl:text> 第</xsl:text>
    <xsl:value-of select="./jmx_ib:Serial" />
    <xsl:text>号</xsl:text>
    <xsl:variable name="reportDateTime">
      <xsl:value-of select="./jmx_ib:ReportDateTime" />
    </xsl:variable>
    <xsl:text>
　　　令和</xsl:text>
    <xsl:choose>
     <xsl:when test="substring($reportDateTime,1,4)='2019'">元</xsl:when>
     <xsl:otherwise><xsl:value-of select="format-number(substring($reportDateTime,1,4) - 2018,'#0')" /></xsl:otherwise>
    </xsl:choose>
    <xsl:text>年</xsl:text>
    <xsl:value-of select="format-number(substring($reportDateTime,6,2),'#0')" />
    <xsl:text>月</xsl:text>
    <xsl:value-of select="format-number(substring($reportDateTime,9,2),'#0')" />
    <xsl:text>日　</xsl:text>
    <xsl:value-of select="format-number(substring($reportDateTime,12,2),'#0')" />
    <xsl:text>時</xsl:text>
    <xsl:value-of select="format-number(substring($reportDateTime,15,2),'#0')" />
    <xsl:text>分</xsl:text>
  </xsl:template>
  <xsl:template match="/jmx:Report/jmx:Control/jmx:PublishingOffice">
    <xsl:text>
　　　</xsl:text>
    <xsl:value-of select="substring-before(., ' ')" />
    <xsl:text>　</xsl:text>
    <xsl:value-of select="substring-after(., ' ')" />
    <xsl:text>　共同発表</xsl:text>
  </xsl:template>
  <xsl:template match="/jmx:Report/jmx_ib:Head/jmx_ib:Headline/jmx_ib:Information">
    <xsl:text>

【警戒対象地域】
　　</xsl:text>
    <xsl:call-template name="areaName">
      <xsl:with-param name="text">
        <xsl:for-each select="/jmx:Report/jmx_ib:Head/jmx_ib:Headline/jmx_ib:Information/jmx_ib:Item[jmx_ib:Kind/jmx_ib:Condition='発表']">
          <xsl:for-each select="./jmx_ib:Areas/jmx_ib:Area">
            <xsl:text>　</xsl:text>
            <xsl:value-of select="./jmx_ib:Name" />
            <xsl:text>*</xsl:text>
          </xsl:for-each>
        </xsl:for-each>
        <xsl:for-each select="/jmx:Report/jmx_ib:Head/jmx_ib:Headline/jmx_ib:Information/jmx_ib:Item[jmx_ib:Kind/jmx_ib:Condition='継続']">
          <xsl:for-each select="./jmx_ib:Areas/jmx_ib:Area">
            <xsl:text>　</xsl:text>
            <xsl:value-of select="./jmx_ib:Name" />
          </xsl:for-each>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:text>

【警戒解除地域】
　　</xsl:text>
    <xsl:call-template name="areaName">
      <xsl:with-param name="text">
        <xsl:for-each select="/jmx:Report/jmx_ib:Head/jmx_ib:Headline/jmx_ib:Information/jmx_ib:Item[jmx_ib:Kind/jmx_ib:Condition='解除']">
          <xsl:for-each select="./jmx_ib:Areas/jmx_ib:Area">
            <xsl:text>　</xsl:text>
            <xsl:value-of select="./jmx_ib:Name" />
          </xsl:for-each>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="/jmx:Report/jmx_ib:Head/jmx_ib:Headline/jmx_ib:Text">
    <xsl:text>

　　　*印は、新たに警戒対象となった市町村を示します。

【警戒文】
　　　</xsl:text>

    <xsl:call-template name="headline">
      <xsl:with-param name="text"><xsl:value-of select="."/></xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="areaName">
    <xsl:param name="text"></xsl:param>
    <xsl:variable name="tmpText"><xsl:value-of select="$text"/></xsl:variable>
    <xsl:if test="string-length($tmpText) &gt; 31">
      <xsl:call-template name="findSpace">
        <xsl:with-param name="text"><xsl:value-of select="$text"/></xsl:with-param>
        <xsl:with-param name="position" select="30"></xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="string-length($tmpText) &lt;= 31">
      <xsl:value-of select="$tmpText"/>
    </xsl:if>
  </xsl:template>
  <xsl:template name="findSpace">
    <xsl:param name="text"></xsl:param>
    <xsl:param name="position"></xsl:param>
    <xsl:variable name="tmpText"><xsl:value-of select="$text"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="substring($tmpText, $position, 1) = '　'">
        <xsl:call-template name="cutAreaName">
          <xsl:with-param name="text"><xsl:value-of select="$tmpText"/></xsl:with-param>
          <xsl:with-param name="position" select="$position - 1"></xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="findSpace">
          <xsl:with-param name="text"><xsl:value-of select="$text"/></xsl:with-param>
          <xsl:with-param name="position" select="$position - 1"></xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="cutAreaName">
    <xsl:param name="text"></xsl:param>
    <xsl:param name="position"></xsl:param>
    <xsl:variable name="tmpText"><xsl:value-of select="$text"/></xsl:variable>
    <xsl:value-of select="substring($tmpText, 1, $position)"/>
    <xsl:text>
　　</xsl:text>
    <xsl:call-template name="areaName">
      <xsl:with-param name="text"><xsl:value-of select="substring($tmpText, $position + 1, string-length($tmpText))"/></xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="headline">
    <xsl:param name="text"></xsl:param>
    <xsl:variable name="tmpText"><xsl:value-of select="$text"/></xsl:variable>
    <xsl:if test="string-length($tmpText) &gt; 31">
      <xsl:choose >
        <xsl:when test="contains(substring($tmpText, 1, 31),'&#x0A;')">
          <xsl:value-of select="substring-before($tmpText,'&#x0A;')"/>
          <xsl:text>
　　　</xsl:text>
          <xsl:call-template name="headline">
            <xsl:with-param name="text"><xsl:value-of select="substring-after($tmpText,'&#x0A;')"/></xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise >
          <xsl:value-of select="substring($tmpText, 1, 31)"/>
          <xsl:text>
　　　</xsl:text>
          <xsl:call-template name="headline">
            <xsl:with-param name="text"><xsl:value-of select="substring($tmpText, 32, string-length($tmpText))"/></xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:if test="string-length($tmpText) &lt;= 31">
      <xsl:value-of select="$tmpText"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="/jmx:Report/jmx_mete:Body/jmx_mete:OfficeInfo">
    <xsl:text>

問い合わせ先</xsl:text>
    <xsl:for-each select="./jmx_mete:Office">
      <xsl:text>
　　　</xsl:text>
      <xsl:value-of select="./jmx_mete:ContactInfo" />
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>