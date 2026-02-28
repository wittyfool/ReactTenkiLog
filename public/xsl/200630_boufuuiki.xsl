<?xml version="1.0" encoding="utf-8"?>

<!--
  ======================================================================
  本スタイルシートは、気象庁防災情報XMLフォーマット形式電文中の全ての情
  報コンテンツを出力するもので、システム処理の動作確認など、電文処理の参
  考資料としてお使い下さい。

  なお、本スタイルシートについては、システムに直接組み込む等の方法でご利
  用になることは避けていただくなど、ご利用に当たっては十分に注意していた
  だきますよう、よろしくお願いいたします。

  Copyright (c) 気象庁 2020 All rights reserved.
  
  【対象情報】
  台風の暴風域に入る確率

  【更新履歴】
  2020年6月30日　ver.1.0
  ======================================================================
-->

<xsl:stylesheet 
xmlns:jmx="http://xml.kishou.go.jp/jmaxml1/"
xmlns:jmx_ib="http://xml.kishou.go.jp/jmaxml1/informationBasis1/" 
xmlns:jmx_mete="http://xml.kishou.go.jp/jmaxml1/body/meteorology1/" 
xmlns:jmx_eb="http://xml.kishou.go.jp/jmaxml1/elementBasis1/" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" indent="yes" encoding="Shift-JIS"/>
<xsl:template match="/">

	<html><head></head><body>

		<table width="90%">
			<tr><td>
			<!--ヘッダ部-->
				<xsl:apply-templates select="jmx:Report/jmx_ib:Head" />
			
			<!--時系列-->
				<xsl:apply-templates select="jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos" />
		
			</td></tr>
		</table>
		
	</body></html>

</xsl:template>


<!--ヘッダ部-->
	<xsl:template match="jmx_ib:Head">
		<H2>
		<!--発表日時-->
			<xsl:text>令和</xsl:text>
			<xsl:choose>
			<xsl:when test="substring(jmx_ib:ReportDateTime,1,4)='2019'">元</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="translate(substring(jmx_ib:ReportDateTime,1,4) - 2018,'0123456789', '０１２３４５６７８９')"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>年</xsl:text>
			<xsl:value-of select="translate(substring(jmx_ib:ReportDateTime,6,1),'0123456789', '　１２３４５６７８９')"/>
			<xsl:value-of select="translate(substring(jmx_ib:ReportDateTime,7,1),'0123456789', '０１２３４５６７８９')"/>
			<xsl:text>月</xsl:text>
			<xsl:value-of select="translate(substring(jmx_ib:ReportDateTime,9,1),'0123456789', '　１２３４５６７８９')"/>
			<xsl:value-of select="translate(substring(jmx_ib:ReportDateTime,10,1),'0123456789', '０１２３４５６７８９')"/>
			<xsl:text>日</xsl:text>
			<xsl:value-of select="translate(substring(jmx_ib:ReportDateTime,12,2),'0123456789', '０１２３４５６７８９')"/>
			<xsl:text>時</xsl:text>
			<xsl:value-of select="translate(substring(jmx_ib:ReportDateTime,15,2),'0123456789', '０１２３４５６７８９')"/>
			<xsl:text>分</xsl:text>
			<xsl:text>　</xsl:text>
		<!--発表官署-->
			<xsl:value-of select="/jmx:Report/jmx:Control/jmx:PublishingOffice"/>
		<!--発表状況-->
			<xsl:text>発表</xsl:text>
			<xsl:if test="contains(jmx_ib:InfoType,'訂正')">
				<xsl:text>（訂正）</xsl:text>
			</xsl:if>
			
		<!---情報名称-->
			<br/>
			<xsl:value-of select="./jmx_ib:Title"/>
			　第<xsl:value-of select="./jmx_ib:Serial"/>号
		
		<!---台風名称等-->
			<br/>
			<xsl:value-of select="./jmx_ib:EventID"/>　
			<xsl:value-of select="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo[@type='台風呼称']/jmx_mete:Item/jmx_mete:Kind/jmx_mete:Property/jmx_mete:TyphoonNamePart/jmx_mete:NameKana"/>
			（<xsl:value-of select="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo[@type='台風呼称']/jmx_mete:Item/jmx_mete:Kind/jmx_mete:Property/jmx_mete:TyphoonNamePart/jmx_mete:Name"/>）　
			台風番号　
			<xsl:value-of select="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo[@type='台風呼称']/jmx_mete:Item/jmx_mete:Kind/jmx_mete:Property/jmx_mete:TyphoonNamePart/jmx_mete:Number"/>
			<br/>
			解析時刻
			<xsl:value-of select="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo[@type='台風呼称']/jmx_mete:DateTime"/>
		</H2>
	</xsl:template>

<!--Body部-->
	<xsl:template match="jmx_mete:Body/jmx_mete:MeteorologicalInfos">
		<table border="1">
			<th></th>
			<xsl:for-each select="./jmx_mete:TimeSeriesInfo/jmx_mete:TimeDefines/jmx_mete:TimeDefine">
				<!--<th><xsl:value-of select="./jmx_mete:DateTime" /></th>-->
				<th>
					<xsl:value-of select="(@timeId - 1) * 3 " />～<xsl:value-of select="(@timeId) * 3 " />時間
				</th>
			</xsl:for-each>

			<xsl:for-each select="./jmx_mete:MeteorologicalInfo[@type!='台風呼称']">
				<th><xsl:value-of select="./jmx_mete:Name" /></th>
			</xsl:for-each>
		
		<xsl:for-each select="./jmx_mete:TimeSeriesInfo/jmx_mete:Item/jmx_mete:Area/jmx_mete:Name">
			<xsl:variable name="code"><xsl:value-of select="../jmx_mete:Code" /></xsl:variable>
			
			<tr>
				<th><xsl:value-of select="." /></th>
				<xsl:for-each select="../../jmx_mete:Kind/jmx_mete:Property/jmx_mete:FiftyKtWindProbabilityPart/jmx_mete:FiftyKtWindProbability">
					<th><xsl:value-of select="." /></th>
				</xsl:for-each>
				
				<xsl:for-each select="../../../../jmx_mete:MeteorologicalInfo[@type!='台風呼称']/jmx_mete:Item/jmx_mete:Area">
					<xsl:if test="./jmx_mete:Code=$code">
						<th><xsl:value-of select="../jmx_mete:Kind/jmx_mete:Property/jmx_mete:FiftyKtWindProbabilityPart/jmx_mete:FiftyKtWindProbability" /></th>
					</xsl:if >
				
				</xsl:for-each>

			</tr>
			
		</xsl:for-each>
		

		<!--
			<xsl:for-each select="./jmx_mete:TimeSeriesInfo/jmx_mete:Item">
				<tr>
					<th><xsl:value-of select="./jmx_mete:Area/jmx_mete:Name" /></th>
					<xsl:for-each select="jmx_mete:Kind/jmx_mete:Property/jmx_mete:FiftyKtWindProbabilityPart/jmx_mete:FiftyKtWindProbability">
						<th><xsl:value-of select="." /></th>
						<xsl:variable name="name" select="./jmx_mete:Area/jmx_mete:Name" />
						<xsl:for-each select="../../../../../jmx_mete:MeteorologicalInfo/jmx_mete:Item">
							<th><xsl:value-of select="./jmx_mete:Kind/jmx_mete:Property/jmx_mete:FiftyKtWindProbabilityPart/jmx_mete:FiftyKtWindProbability" /></th>
						</xsl:for-each>

					</xsl:for-each>
				
					<xsl:for-each select="../../jmx_mete:MeteorologicalInfo/jmx_mete:Item">
						<th><xsl:value-of select="./jmx_mete:Kind/jmx_mete:Property/jmx_mete:FiftyKtWindProbabilityPart/jmx_mete:FiftyKtWindProbability" /></th>
					</xsl:for-each>
				
				</tr>
			</xsl:for-each>
		-->
		</table>
	</xsl:template>


</xsl:stylesheet>
