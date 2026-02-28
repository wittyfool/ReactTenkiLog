<?xml version="1.0" encoding="UTF-8" ?>
<!--
======================================================================
  本スタイルシートは、気象庁防災情報XMLフォーマット形式電文中の全ての情報コンテンツを出力するもので、システム処理の動作確認など、電文処理の参考資料としてお使い下さい。
  なお、本スタイルシートについては、システムに直接組み込む等の方法でご利用になることは避けていただくなど、ご利用に当たっては十分に注意していただきますよう、よろしくお願いいたします。

 Copyright (c) 気象庁 2012 All rights reserved.

  【対象情報】
  全般・地方・府県潮位情報

  【更新履歴】
  2012年03月29日　Ver.1.0 
  2019年04月24日　Ver.1.1 5月1日より施行される新元号への対応
======================================================================
-->

<!-- 名前空間の指定 気象庁使用の名前空間 -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:jmx="http://xml.kishou.go.jp/jmaxml1/" exclude-result-prefixes="jmx"
 xmlns:h="http://xml.kishou.go.jp/jmaxml1/informationBasis1/"
 xmlns:b="http://xml.kishou.go.jp/jmaxml1/body/meteorology1/"
 >

<!-- 出力文字コード -->
<xsl:output method="html" indent="no" encoding="Shift-JIS"/>

<!-- メイン -->
<xsl:template match="/">
	<xsl:apply-templates select="jmx:Report" />
</xsl:template>

<xsl:template match="jmx:Report">

	<xsl:value-of select="h:Head/h:Title" />
	<xsl:call-template name="newLine"/>
	
	<xsl:call-template name="hiduke" />
	<xsl:value-of select="jmx:Control/jmx:PublishingOffice"/><xsl:text>発表</xsl:text>

	<xsl:call-template name="newLine"/>
	<xsl:call-template name="newLine"/>
	<xsl:text>（見出し）</xsl:text>
	<xsl:call-template name="newLine"/>
	<xsl:call-template name="InsertBlank">
		<xsl:with-param name="value" select="h:Head/h:Headline/h:Text"/>
	</xsl:call-template>

	<xsl:call-template name="newLine"/>
	<xsl:call-template name="newLine"/>

	<xsl:text>（本文）</xsl:text>
	<xsl:call-template name="newLine"/>
	<xsl:call-template name="InsertBlank">
		<xsl:with-param name="value" select="b:Body/b:Comment/b:Text"/>
	</xsl:call-template>

</xsl:template>

<xsl:template name="hiduke">
	<xsl:variable name="reportTime" select="h:Head/h:ReportDateTime" />

	<xsl:text>令和</xsl:text>
	<xsl:choose>
		<xsl:when test="substring($reportTime,1,4)='2019'">元</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="translate(substring($reportTime,1,4) - 2018,'0123456789', '０１２３４５６７８９')"/>
		</xsl:otherwise>
    </xsl:choose>
	
	<xsl:text>年</xsl:text>
	<xsl:value-of select="translate(substring($reportTime,6,1),'0123456789', '　１２３４５６７８９')"/>
	<xsl:value-of select="translate(substring($reportTime,7,1),'0123456789', '０１２３４５６７８９')"/>
	<xsl:text>月</xsl:text>
	<xsl:value-of select="translate(substring($reportTime,9,1),'0123456789', '　１２３４５６７８９')"/>
	<xsl:value-of select="translate(substring($reportTime,10,1),'0123456789', '０１２３４５６７８９')"/>
	<xsl:text>日</xsl:text>
	<xsl:value-of select="translate(substring($reportTime,12,2),'0123456789', '０１２３４５６７８９')"/>
	<xsl:text>時</xsl:text>
	<xsl:value-of select="translate(substring($reportTime,15,2),'0123456789', '０１２３４５６７８９')"/>
	<xsl:text>分</xsl:text>
	<xsl:text>　</xsl:text>
</xsl:template>


<xsl:template name="InsertBlank">
	<xsl:param name="value"/>
	<xsl:choose>
		<xsl:when test="contains($value, '&#xA;')">
			<xsl:value-of select="concat('', substring-before($value, '&#xA;'))"/>
			<xsl:call-template name="newLine"/>
			<xsl:call-template name="InsertBlank">
				<xsl:with-param name="value" select="substring-after($value, '&#xA;')"/>
			</xsl:call-template>
		</xsl:when>

		<xsl:otherwise>
			<xsl:value-of select="concat('', $value)"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template name="newLine"><BR/></xsl:template>


</xsl:stylesheet>
