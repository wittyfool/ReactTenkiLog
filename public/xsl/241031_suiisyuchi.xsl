<?xml version="1.0" encoding="UTF-8" ?>

<!--
  ======================================================================
  本スタイルシートは、気象庁防災情報XMLフォーマット形式電文中の全ての情
  報コンテンツを出力するもので、システム処理の動作確認など、電文処理の参
  考資料としてお使い下さい。

  なお、本スタイルシートについては、システムに直接組み込む等の方法でご利
  用になることは避けていただくなど、ご利用に当たっては十分に注意していた
  だきますよう、よろしくお願いいたします。

  Copyright (c) 気象庁 2010,2024 All rights reserved.

　【対象情報】
  水位周知河川に関する情報

  【更新履歴】
  2019年05月29日　オリジナル「190529_kozui.xsl」ver.1.3
  2024年10月31日　Ver.1.0（オリジナルから変更。新電文対応版）
  ======================================================================
-->


<!-- 名前空間の指定 気象庁使用の名前空間 -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:jmx="http://xml.kishou.go.jp/jmaxml1/" exclude-result-prefixes="jmx"
 xmlns:h="http://xml.kishou.go.jp/jmaxml1/informationBasis1/"
 xmlns:b="http://xml.kishou.go.jp/jmaxml1/body/meteorology1/"
 xmlns:e="http://xml.kishou.go.jp/jmaxml1/elementBasis1/"
 >

<!-- 出力文字コード -->
<xsl:output method="html" indent="yes" encoding="utf-8"/>

<!-- メイン -->
<xsl:template match="/">
	<html>
	<head />
	<body>
	<xsl:apply-templates select="jmx:Report" />
	
	<xsl:apply-templates select="jmx:Report/h:Head/h:Headline" />
	
	<xsl:apply-templates select="jmx:Report/b:Body" />
	</body></html>
</xsl:template>

<xsl:template match="b:Body">

	<xsl:apply-templates select="b:Warning[@type='水位周知河川に関する情報（河川）']" mode="Suii_Kasen"/>
	<xsl:apply-templates select="b:Warning[@type='水位周知河川に関する情報（浸水想定地区）']" mode="Suii_Shinsui"/>
	<xsl:apply-templates select="b:AdditionalInfo" />
	<xsl:apply-templates select="b:MeteorologicalInfos" />

	<xsl:apply-templates select="b:OfficeInfo" />

</xsl:template>

<xsl:template match="b:AdditionalInfo">

	<br/>

	<table border="1">
	<tr>
		<td rowspan="2">観測所名</td>

	<xsl:for-each select="b:FloodForecastAddition/b:HydrometricStationPart">
		<td><xsl:value-of select="b:Area/b:Name"/></td>
	</xsl:for-each>
	
	</tr><tr>
	
	<xsl:for-each select="b:FloodForecastAddition/b:HydrometricStationPart">
		<td><xsl:value-of select="b:Area/b:Location"/></td>
	</xsl:for-each>

	</tr>

	<xsl:if test="b:FloodForecastAddition/b:HydrometricStationPart/b:Criteria/e:WaterLevel or b:FloodForecastAddition/b:HydrometricStationPart/b:Criteria/e:Discharge">
		<tr><td>レベル４水位<br/>氾濫危険水位</td>
		<xsl:for-each select="b:FloodForecastAddition/b:HydrometricStationPart">
			<td>
				<xsl:if test="b:Criteria/e:WaterLevel[@type='レベル４氾濫危険水位' and @condition='有効']">
					<xsl:value-of select="b:Criteria/e:WaterLevel[@type='レベル４氾濫危険水位']"/>
					<xsl:value-of select="b:Criteria/e:WaterLevel/@unit"/>
				</xsl:if>
				<xsl:if test="b:Criteria/e:Discharge[@type='レベル４氾濫危険流量' and @condition='有効']">
					<xsl:value-of select="b:Criteria/e:Discharge[@type='レベル４氾濫危険流量']"/>
					<xsl:value-of select="b:Criteria/e:Discharge/@unit"/>
				</xsl:if>
				<xsl:if test="b:Criteria/e:WaterLevel[@type='氾濫危険水位' and @condition='有効']">
					<xsl:value-of select="b:Criteria/e:WaterLevel[@type='氾濫危険水位']"/>
					<xsl:value-of select="b:Criteria/e:WaterLevel/@unit"/>
				</xsl:if>
				<xsl:if test="b:Criteria/e:Discharge[@type='氾濫危険流量' and @condition='有効']">
					<xsl:value-of select="b:Criteria/e:Discharge[@type='氾濫危険流量']"/>
					<xsl:value-of select="b:Criteria/e:Discharge/@unit"/>
				</xsl:if>
			</td>
		</xsl:for-each>
		</tr>

		<tr><td>レベル３水位<br/>避難判断水位</td>
		<xsl:for-each select="b:FloodForecastAddition/b:HydrometricStationPart">
			<td>
				<xsl:if test="b:Criteria/e:WaterLevel[@type='レベル３避難判断水位' and @condition='有効']">
					<xsl:value-of select="b:Criteria/e:WaterLevel[@type='レベル３避難判断水位']"/>
					<xsl:value-of select="b:Criteria/e:WaterLevel/@unit"/>
				</xsl:if>
				<xsl:if test="b:Criteria/e:Discharge[@type='レベル３避難判断流量' and @condition='有効']">
					<xsl:value-of select="b:Criteria/e:Discharge[@type='レベル３避難判断流量']"/>
					<xsl:value-of select="b:Criteria/e:Discharge/@unit"/>
				</xsl:if>
				<xsl:if test="b:Criteria/e:WaterLevel[@type='避難判断水位' and @condition='有効']">
					<xsl:value-of select="b:Criteria/e:WaterLevel[@type='避難判断水位']"/>
					<xsl:value-of select="b:Criteria/e:WaterLevel/@unit"/>
				</xsl:if>
				<xsl:if test="b:Criteria/e:Discharge[@type='避難判断流量' and @condition='有効']">
					<xsl:value-of select="b:Criteria/e:Discharge[@type='避難判断流量']"/>
					<xsl:value-of select="b:Criteria/e:Discharge/@unit"/>
				</xsl:if>
			</td>
		</xsl:for-each>
		</tr>

		<tr><td>レベル２水位<br/>氾濫注意水位</td>
		<xsl:for-each select="b:FloodForecastAddition/b:HydrometricStationPart">
			<td>
				<xsl:if test="b:Criteria/e:WaterLevel[@type='レベル２氾濫注意水位' and @condition='有効']">
					<xsl:value-of select="b:Criteria/e:WaterLevel[@type='レベル２氾濫注意水位']"/>
					<xsl:value-of select="b:Criteria/e:WaterLevel/@unit"/>
				</xsl:if>
				<xsl:if test="b:Criteria/e:Discharge[@type='レベル２氾濫注意流量' and @condition='有効']">
					<xsl:value-of select="b:Criteria/e:Discharge[@type='レベル２氾濫注意流量']"/>
					<xsl:value-of select="b:Criteria/e:Discharge/@unit"/>
				</xsl:if>
				<xsl:if test="b:Criteria/e:WaterLevel[@type='氾濫注意水位' and @condition='有効']">
					<xsl:value-of select="b:Criteria/e:WaterLevel[@type='氾濫注意水位']"/>
					<xsl:value-of select="b:Criteria/e:WaterLevel/@unit"/>
				</xsl:if>
				<xsl:if test="b:Criteria/e:Discharge[@type='氾濫注意流量' and @condition='有効']">
					<xsl:value-of select="b:Criteria/e:Discharge[@type='氾濫注意流量']"/>
					<xsl:value-of select="b:Criteria/e:Discharge/@unit"/>
				</xsl:if>
			</td>
		</xsl:for-each>
		</tr>

		<tr><td>レベル１水位<br/>水防団待機水位</td>
		<xsl:for-each select="b:FloodForecastAddition/b:HydrometricStationPart">
			<td>
				<xsl:if test="b:Criteria/e:WaterLevel[@type='レベル１水防団待機水位' and @condition='有効']">
					<xsl:value-of select="b:Criteria/e:WaterLevel[@type='レベル１水防団待機水位']"/>
					<xsl:value-of select="b:Criteria/e:WaterLevel/@unit"/>
				</xsl:if>
				<xsl:if test="b:Criteria/e:Discharge[@type='レベル１水防団待機流量' and @condition='有効']">
					<xsl:value-of select="b:Criteria/e:Discharge[@type='レベル１水防団待機流量']"/>
					<xsl:value-of select="b:Criteria/e:Discharge/@unit"/>
				</xsl:if>
				<xsl:if test="b:Criteria/e:WaterLevel[@type='水防団待機水位' and @condition='有効']">
					<xsl:value-of select="b:Criteria/e:WaterLevel[@type='水防団待機水位']"/>
					<xsl:value-of select="b:Criteria/e:WaterLevel/@unit"/>
				</xsl:if>
				<xsl:if test="b:Criteria/e:Discharge[@type='水防団待機流量' and @condition='有効']">
					<xsl:value-of select="b:Criteria/e:Discharge[@type='水防団待機流量']"/>
					<xsl:value-of select="b:Criteria/e:Discharge/@unit"/>
				</xsl:if>
			</td>
		</xsl:for-each>
		</tr>

	</xsl:if>


	<tr><td>受け持ち区間</td>
	<xsl:for-each select="b:FloodForecastAddition/b:HydrometricStationPart">
	<td>
		<table>
			<xsl:for-each select="b:ChargeSection">
			<tr><td>
				<font size="-1">
				<xsl:call-template name="InsertBlank">
				<xsl:with-param name="value" select="."/>
				</xsl:call-template>
				</font>
			</td></tr>
			</xsl:for-each>
		</table>
	</td>
	</xsl:for-each>
	</tr>

	<tr><td>氾濫が発生した場合の浸水想定区域</td>
	<xsl:for-each select="b:FloodForecastAddition/b:HydrometricStationPart">
	<td>
		<font size="-1"><xsl:value-of select="b:Area/b:SubCityList"/></font>
	</td>
	</xsl:for-each>
	</tr>
	</table>

</xsl:template>

<xsl:template match="b:OfficeInfo">

	<br/>
	<font color="navy" size="+1">
		<xsl:text>問い合わせ先</xsl:text>
	</font>

	<table border="1">
	<xsl:for-each select="b:Office">
		<tr>
			<td><xsl:value-of select="@type"/></td>
			<td><xsl:value-of select="b:Name" /></td>
			<td><xsl:value-of select="b:ContactInfo" /></td>
		</tr>
	</xsl:for-each>
	</table>


</xsl:template>


<xsl:template match="b:MeteorologicalInfos">

	<xsl:if test="@type='雨量情報'">
		<br/>
		<font color="navy" size="+1">
		<xsl:text>（今後の見通し）</xsl:text>
		</font>
		<br/>

		<xsl:call-template name="InsertBlank">
			<xsl:with-param name="value" select="b:MeteorologicalInfo/b:Item/b:Kind/b:Property/b:Text"/>
		</xsl:call-template>
		<br/>

		<xsl:for-each select="b:TimeSeriesInfo">

			<table border="1">
			<tr>
			<td>
				<xsl:if test="b:Item/b:Station/b:Name">
				<xsl:text>観測所</xsl:text>
				</xsl:if>
			</td>

			<xsl:for-each select="b:TimeDefines/b:TimeDefine">
				<td>
				<xsl:value-of select="b:Name"/>
				</td>
			</xsl:for-each>
			</tr>

			<tr>
			<td>
				<xsl:value-of select="b:Item/b:Station/b:Name"/>
			</td>
			<xsl:for-each select="b:Item/b:Kind/b:Property/b:PrecipitationBasedIndexPart/e:PrecipitationBasedIndex">
				<td><xsl:value-of select="@type"/><xsl:value-of select="." /><xsl:value-of select="@unit"/></td>
			</xsl:for-each>

			</tr>
			</table>
			<br/>

		</xsl:for-each>

	</xsl:if>

	<xsl:if test="@type='水位・流量情報'">
	<!-- ない -->
	</xsl:if>

</xsl:template>


<xsl:template match="b:Warning" mode="Suii_Kasen">

	<xsl:for-each select="b:Item">

	<font color="navy" size="+1">
	<xsl:text>（水位の状況）</xsl:text>
	</font>
	<br/>
	<xsl:call-template name="InsertBlank">
		<xsl:with-param name="value" select="b:Kind/b:Property/b:Text"/>
	</xsl:call-template>
	<br/>
	</xsl:for-each>

</xsl:template>

<xsl:template match="b:Warning" mode="Suii_Shinsui">

	<xsl:if test="b:Item/b:Kind/b:Property/b:Type='浸水想定地区'">

	<br/>
	<xsl:text>浸水想定地区</xsl:text>
	<br/>
	<table border="1">
	<tr>
	<td><xsl:text>観測所名</xsl:text></td>
	<td><xsl:text>二次細分区</xsl:text></td>
	<td><xsl:text>都道府県</xsl:text></td>
	<td><xsl:text>市町村</xsl:text></td>
	<td><xsl:text>地区</xsl:text></td>
	</tr>
	
	<xsl:for-each select="b:Item">
		<xsl:if test="b:Kind/b:Property/b:Type='浸水想定地区'">
			<xsl:variable name="rowspan" select="count(b:Areas/b:Area)"/>
			<xsl:for-each select="b:Areas/b:Area">
			<tr>
				<xsl:if test="position()='1'">
					<xsl:element name="td">
						<xsl:attribute name="rowspan"><xsl:value-of select="$rowspan"/></xsl:attribute>
						<xsl:value-of select="../../b:Stations/b:Station/b:Name"/>
					</xsl:element>
				</xsl:if>
				<td><xsl:value-of select="b:Name"/></td>
				<td><xsl:value-of select="b:Prefecture"/></td>
				<td><xsl:value-of select="b:City"/></td>
				<td><xsl:value-of select="b:SubCityList"/></td>
			</tr>
			</xsl:for-each>
		</xsl:if>
	</xsl:for-each>
	</table>
	<font size="-1">
	<xsl:text>※氾濫による浸水が想定される地区については、一定の条件下に基づく計算結果での推定です。気象条件や堤防の決壊の状況によっては、この地区以外でも氾濫による浸水がおこる可能性があります。</xsl:text>
	</font>
	<br/>

	</xsl:if>

	<xsl:if test="b:Item/b:Kind/b:Property/b:Type='浸水想定地区（氾濫発生情報）'">

	<br/>
	<xsl:text>浸水想定地区（氾濫発生情報）</xsl:text>
	<br/>
	<table border="1">
	<tr>
	<td><xsl:text>二次細分区</xsl:text></td>
	<td><xsl:text>都道府県</xsl:text></td>
	<td><xsl:text>市町村</xsl:text></td>
	<td><xsl:text>地区</xsl:text></td>
	</tr>

	<xsl:for-each select="b:Item">

		<xsl:if test="b:Kind/b:Property/b:Type='浸水想定地区（氾濫発生情報）'">
			<xsl:for-each select="b:Areas/b:Area">
			<tr>
				<td><xsl:value-of select="b:Name"/></td>
				<td><xsl:value-of select="b:Prefecture"/></td>
				<td><xsl:value-of select="b:City"/></td>
				<td><xsl:value-of select="b:SubCityList"/></td>
			</tr>
			</xsl:for-each>
		</xsl:if>
	</xsl:for-each>
	</table>
	<font size="-1">
		<xsl:text>※氾濫による浸水が想定される地区については、一定の条件下に基づく計算結果での推定です。気象条件や堤防の決壊の状況によっては、この地区以外でも氾濫による浸水がおこる可能性があります。</xsl:text>
	</font>
	<br/>
	</xsl:if>

</xsl:template>

<xsl:template match="h:Headline">
	<font color="navy" size="+1">
	<xsl:text>（見出し）</xsl:text>
	</font><br/>
	<b><font size="+1">
	<xsl:call-template name="InsertBlank">
		<xsl:with-param name="value" select="h:Text"/>
	</xsl:call-template>
	</font></b>
	<xsl:call-template name="newLine"/>
	<xsl:call-template name="newLine"/>

	<xsl:for-each select="h:Information">
		<xsl:value-of select="@type" />
		<xsl:call-template name="newLine"/>

		<xsl:text>　</xsl:text>
		<xsl:value-of select="h:Item/h:Kind/h:Name" />
		<xsl:text>　（</xsl:text>
		<xsl:value-of select="h:Item/h:Kind/h:Condition" />
		<xsl:text>）</xsl:text>
		
		<xsl:for-each select="h:Item/h:Areas/h:Area">
			<xsl:text>　</xsl:text>
			<xsl:value-of select="h:Name" />
		</xsl:for-each>

		<xsl:call-template name="newLine"/>
		<xsl:call-template name="newLine"/>
	</xsl:for-each>


</xsl:template>


<xsl:template match="jmx:Report">

	<xsl:call-template name="newLine" />

	<h2>
		<xsl:text>【</xsl:text>
		<xsl:value-of select="jmx:Control/jmx:Status"/>
		<xsl:text>】</xsl:text>

		<xsl:value-of select="h:Head/h:Title" />
	</h2>
	
	<p align="right">

		<xsl:call-template name="hiduke" />
		<br />
		<xsl:value-of select="jmx:Control/jmx:PublishingOffice"/><xsl:text>発表</xsl:text>

		<br />
		<xsl:if test="contains(h:Head/h:InfoType,'訂正')">
			<xsl:text>（訂正）</xsl:text>
		</xsl:if>
		<xsl:text>（第</xsl:text><xsl:value-of select="h:Head/h:Serial" /><xsl:text>号）</xsl:text>
	</p>

	<xsl:call-template name="newLine"/>

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


<xsl:template name="newLine"><BR/></xsl:template>

<xsl:template name="hiduke00">
	<xsl:param name="value" />
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
</xsl:template>
</xsl:stylesheet>
