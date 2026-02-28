<?xml version="1.0" encoding="UTF-8" ?>

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
  地方海上予報

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
 xmlns:jmx_eb="http://xml.kishou.go.jp/jmaxml1/elementBasis1/"
 >

<!--	データ無し　グローバル変数	-->
<xsl:variable name="NO_DATA" select="'No Data'"/>

<!-- 出力文字コード -->
<xsl:output method="html" indent="no" encoding="Shift-JIS"/>

<!-- メイン -->
<xsl:template match="/">
	<html>
	<head>

		<link rel="stylesheet" href="kaijo.css" type="text/css" />
		<title><xsl:value-of select="jmx:Report/jmx:Control/jmx:Title"/><xsl:text>  </xsl:text><xsl:value-of select="jmx:Report/h:Head/h:Title"/></title>
	</head>
	<body>
		<div id="header">
		<xsl:apply-templates select="jmx:Report" />
		</div>

		<div id="contents">
		
			<!--	気象要因	-->
			<xsl:apply-templates select="jmx:Report/b:Body/b:MeteorologicalInfos[@type='気象要因']/b:MeteorologicalInfo" mode="YOIN"/>
			<xsl:call-template name="newLine"/>

			<!--	観測実況	-->
			<xsl:apply-templates select="jmx:Report/b:Body/b:MeteorologicalInfos[@type='観測実況']/b:MeteorologicalInfo" mode="KANSOKU_JIKYO"/>
			<xsl:call-template name="newLine"/>
			
			<!--	予報		-->
			<xsl:apply-templates select="jmx:Report/b:Body/b:MeteorologicalInfos[@type='地方海域の予報']/b:MeteorologicalInfo[ 1 ]" mode="YOHO"/>
			<xsl:call-template name="newLine"/>
		</div>
		
	</body>
	</html>
</xsl:template>

<!--	ヘッダー	-->
<xsl:template match="jmx:Report">
	<h2>
		<xsl:value-of select="jmx:Control/jmx:Title"/><br />
	</h2>
	<xsl:value-of select="h:Head/h:Title"/><br />

	<xsl:call-template name="hiduke" />
	<xsl:value-of select="jmx:Control/jmx:PublishingOffice"/><xsl:text>発表</xsl:text>

	<xsl:if test="contains(h:Head/h:InfoType,'訂正')">
		<xsl:text>（訂正）</xsl:text>
	</xsl:if>

	<xsl:call-template name="newLine"/>

</xsl:template>

<!--	観測実況	-->
<xsl:template match="b:Item" mode="KANSOKU_DATA">
	
	<xsl:if test="b:Kind/b:Condition = '入電なし'">
		<tr>
			<!--	観測地点名	-->
			<td>
				<xsl:choose>
					<xsl:when test="b:Station/b:Name">
						<xsl:value-of select="b:Station/b:Name"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$NO_DATA"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<!--	観測地点コード	-->
			<td>
				<xsl:choose>
					<xsl:when test="b:Station/b:Code">
						<xsl:value-of select="b:Station/b:Code"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$NO_DATA"/>
					</xsl:otherwise>			
				</xsl:choose>
			</td>
			
			<td>入電なし</td><td>入電なし</td>
			<td>入電なし</td><td>入電なし</td><td>入電なし</td><td>入電なし</td>
		</tr>
	</xsl:if>
	
	<xsl:if test="not(b:Kind/b:Condition = '入電なし')">
		<tr>
			<!--	観測地点名	-->
			<td>
				<xsl:choose>
					<xsl:when test="b:Station/b:Name">
						<xsl:value-of select="b:Station/b:Name"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$NO_DATA"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<!--	観測地点コード	-->
			<td>
				<xsl:choose>
					<xsl:when test="b:Station/b:Code">
						<xsl:value-of select="b:Station/b:Code"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$NO_DATA"/>
					</xsl:otherwise>			
				</xsl:choose>
			</td>
			<!--	風向	-->
			<td>
				<xsl:choose>
					<xsl:when test="b:Kind/b:Property/b:WindDirectionPart/jmx_eb:WindDirection/@description">
						<xsl:value-of select="b:Kind/b:Property/b:WindDirectionPart/jmx_eb:WindDirection/@description"/>
					</xsl:when>
					<xsl:when test="b:Kind/b:Property/b:WindDirectionPart/jmx_eb:WindDirection/text()">
						<xsl:value-of select="b:Kind/b:Property/b:WindDirectionPart/jmx_eb:WindDirection/text()"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$NO_DATA"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<!--	風速	-->
			<td>
				<xsl:choose>
					<xsl:when test="b:Kind/b:Property/b:WindSpeedPart/jmx_eb:WindSpeed/@description">
						<xsl:value-of select="b:Kind/b:Property/b:WindSpeedPart/jmx_eb:WindSpeed/@description"/>
					</xsl:when>
					<xsl:when test="b:Kind/b:Property/b:WindSpeedPart/jmx_eb:WindSpeed/text()">
						<xsl:value-of select="b:Kind/b:Property/b:WindSpeedPart/jmx_eb:WindSpeed/text()"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$NO_DATA"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<!--	天気	-->
			<td>
				<xsl:choose>
					<xsl:when test="b:Kind/b:Property/b:WeatherPart/jmx_eb:Weather/@description">
						<xsl:value-of select="b:Kind/b:Property/b:WeatherPart/jmx_eb:Weather/@description"/>
					</xsl:when>
					<xsl:when test="b:Kind/b:Property/b:WeatherPart/jmx_eb:Weather/text()">
						<xsl:value-of select="b:Kind/b:Property/b:WeatherPart/jmx_eb:Weather/text()"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$NO_DATA"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<!--	気圧	-->
			<td>
				<xsl:choose>
					<xsl:when test="b:Kind/b:Property/b:PressurePart/jmx_eb:Pressure/@description">
						<xsl:value-of select="b:Kind/b:Property/b:PressurePart/jmx_eb:Pressure/@description"/>
					</xsl:when>
					<xsl:when test="b:Kind/b:Property/b:PressurePart/jmx_eb:Pressure/text()">
						<xsl:value-of select="b:Kind/b:Property/b:PressurePart/jmx_eb:Pressure/text()"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$NO_DATA"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<!--	気温	-->
			<td>
				<xsl:choose>
					<xsl:when test="b:Kind/b:Property/b:TemperaturePart/jmx_eb:Temperature/@description">
						<xsl:value-of select="b:Kind/b:Property/b:TemperaturePart/jmx_eb:Temperature/@description"/>
					</xsl:when>
					<xsl:when test="b:Kind/b:Property/b:TemperaturePart/jmx_eb:Temperature/text()">
						<xsl:value-of select="b:Kind/b:Property/b:TemperaturePart/jmx_eb:Temperature/text()"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$NO_DATA"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<!--	視程	-->
			<td>
				<xsl:choose>
					<xsl:when test="b:Kind/b:Property/b:VisibilityPart/jmx_eb:Visibility/@description">
						<xsl:value-of select="b:Kind/b:Property/b:VisibilityPart/jmx_eb:Visibility/@description"/>
					</xsl:when>
					<xsl:when test="b:Kind/b:Property/b:VisibilityPart/jmx_eb:Visibility/text()">
						<xsl:value-of select="b:Kind/b:Property/b:VisibilityPart/jmx_eb:Visibility/text()"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$NO_DATA"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:if>
</xsl:template>

<!--	観測実況テンプレート	-->
<xsl:template match="b:MeteorologicalInfo" mode="KANSOKU_JIKYO">
	<h2>
		観測実況
		<xsl:call-template name="hiduke0">
			<xsl:with-param name="DATE" select="b:DateTime"/>
		</xsl:call-template>
	</h2>
	<table border="1">
		<tr>
			<th>観測地点名</th>
			<th>観測地点番号</th>
			<th>風向</th>
			<th>風速</th>
			<th>天気</th>
			<th>気圧</th>
			<th>気温</th>
			<th>視程</th>
		</tr>
		<xsl:apply-templates select="b:Item" mode="KANSOKU_DATA" />
	</table>
</xsl:template>

<!--	気象要因	-->
<xsl:template match="b:MeteorologicalInfo" mode="YOIN">
	
	<xsl:if test="b:Item/b:Kind/b:Property/b:SynopsisPart/jmx_eb:Synopsis/text()">
		<h2>概況</h2>
		<table border="1">
			<tr><th>海域</th><td><xsl:value-of select="b:Item/b:Area/b:Name"/></td></tr>
			<tr><th>海域コード</th><td><xsl:value-of select="b:Item/b:Area/b:Code"/></td></tr>
			<xsl:for-each select="b:Item/b:Kind/b:Property/b:SynopsisPart/jmx_eb:Synopsis">
				<tr><th>気象要因</th><td><xsl:value-of select="."/></td></tr>
			</xsl:for-each>
		</table>
	</xsl:if>
</xsl:template>


<!--	予報	-->
<xsl:template match="b:MeteorologicalInfo" mode="YOHO">
		<xsl:apply-templates select="b:Item" mode="YOHO"/>
</xsl:template>

<!--	予報	-->
<xsl:template match="b:Item" mode="YOHO">

    <xsl:param name="test" select="position()" />
	<xsl:variable name="UMI_CODE" select="b:Area/b:Code"/>

	<h2>予報</h2>
	<table border="1">
	<tr>
		<th>海域名</th>
		<td><xsl:value-of select="b:Area/b:Name"/></td>
	</tr>
	<tr>
		<th>海域コード</th>
		<td><xsl:value-of select="$UMI_CODE"/></td>
	</tr>

	<xsl:if test="../../../b:Warning/b:Item/b:Area/b:Code[ .= $UMI_CODE ]/../../b:Kind/b:Name[ .!='']">
		<tr>
			<th>警報</th>
			<td>
				<xsl:for-each select="../../../b:Warning/b:Item/b:Area/b:Code[ .= $UMI_CODE ]/../../b:Kind/b:Name[ .!='']">
					<xsl:value-of select="."/><xsl:text>  </xsl:text>
				</xsl:for-each>
			</td>
		</tr>
	</xsl:if>

	<xsl:for-each select="../../b:MeteorologicalInfo">
		<tr>
			<th>予報対象期間</th><td><xsl:value-of select="b:Name"/></td>
		</tr>

		<xsl:for-each select="b:Item[ $test ]/b:Kind/b:Property/b:Type">
			<tr>
				<th><xsl:value-of select="."/></th>
				<td>
				<xsl:value-of select="../../b:Property//b:Sentence"/>				
				</td>
			</tr>
		</xsl:for-each>
	</xsl:for-each>

	</table>
	<br/>
</xsl:template>

<xsl:template name="hiduke0">

	<xsl:param name="DATE"></xsl:param>

	<xsl:value-of select="translate(substring($DATE,1,4),'0123456789', '０１２３４５６７８９')"/>
	<xsl:text>年</xsl:text>
	<xsl:value-of select="translate(substring($DATE,6,1),'0123456789', '　１２３４５６７８９')"/>
	<xsl:value-of select="translate(substring($DATE,7,1),'0123456789', '０１２３４５６７８９')"/>
	<xsl:text>月</xsl:text>
	<xsl:value-of select="translate(substring($DATE,9,1),'0123456789', '　１２３４５６７８９')"/>
	<xsl:value-of select="translate(substring($DATE,10,1),'0123456789', '０１２３４５６７８９')"/>
	<xsl:text>日</xsl:text>
	<xsl:value-of select="translate(substring($DATE,12,2),'0123456789', '０１２３４５６７８９')"/>
	<xsl:text>時</xsl:text>
	<xsl:text>　</xsl:text>

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

<xsl:template name="hiduke00">
	<xsl:param name="value"/>
	<xsl:text>令和</xsl:text>
	<xsl:value-of select="translate(substring($value,1,4) - 2018,'0123456789', '０１２３４５６７８９')"/>
	<xsl:text>年</xsl:text>
	<xsl:value-of select="translate(substring($value,6,1),'0123456789', '　１２３４５６７８９')"/>
	<xsl:value-of select="translate(substring($value,7,1),'0123456789', '０１２３４５６７８９')"/>
	<xsl:text>月</xsl:text>
	<xsl:value-of select="translate(substring($value,9,1),'0123456789', '　１２３４５６７８９')"/>
	<xsl:value-of select="translate(substring($value,10,1),'0123456789', '０１２３４５６７８９')"/>
	<xsl:text>日</xsl:text>
	<xsl:value-of select="translate(substring($value,12,2),'0123456789', '０１２３４５６７８９')"/>
	<xsl:text>時</xsl:text>
	<xsl:value-of select="translate(substring($value,15,2),'0123456789', '０１２３４５６７８９')"/>
	<xsl:text>分</xsl:text>
	<xsl:text>　</xsl:text>
</xsl:template>



<xsl:template name="InsertBlank">
	<xsl:param name="value"/>
	<xsl:choose>
		<xsl:when test="contains($value, '&#xA;')">
			<xsl:value-of select="concat('　', substring-before($value, '&#xA;'))"/>
			<xsl:call-template name="newLine"/>
			<xsl:call-template name="InsertBlank">
				<xsl:with-param name="value" select="substring-after($value, '&#xA;')"/>
			</xsl:call-template>
		</xsl:when>

		<xsl:otherwise>
			<xsl:value-of select="concat('　', $value)"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template name="newLine"><br/></xsl:template>


</xsl:stylesheet>
