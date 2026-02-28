<?xml version="1.0" encoding="UTF-8" ?>

<!--
  ======================================================================
  本スタイルシートは、気象庁防災情報XMLフォーマット形式電文中の全ての情
  報コンテンツを出力するもので、システム処理の動作確認など、電文処理の参
  考資料としてお使い下さい。

  なお、本スタイルシートについては、システムに直接組み込む等の方法でご利
  用になることは避けていただくなど、ご利用に当たっては十分に注意していた
  だきますよう、よろしくお願いいたします。

  Copyright (c) 気象庁 2010 All rights reserved.

　【対象情報】
  指定河川洪水予報

  【更新履歴】
  2012年03月29日　Ver.1.0
  2013年02月01日　Ver.1.1 　体裁等微修正
  2019年04月24日　Ver.1.2 5月1日より施行される新元号への対応
  2019年05月29日　ver.1.3 「はん濫」を「氾濫」に変更したことへの対応
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
<xsl:output method="html" indent="no" encoding="Shift-JIS"/>

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

	<xsl:apply-templates select="b:Warning" />
	<xsl:apply-templates select="b:MeteorologicalInfos" />
	<xsl:apply-templates select="b:OfficeInfo" />
	<xsl:apply-templates select="b:AdditionalInfo" />

</xsl:template>

<xsl:template match="b:AdditionalInfo">

	<br/>

	<xsl:if test="b:FloodForecastAddition">
		<font color="navy" size="+1">
			<xsl:text>参考資料</xsl:text>
		</font>
	</xsl:if>
	<table border="1">
	<tr>
		<td rowspan="2">観測所</td>

	<xsl:for-each select="b:FloodForecastAddition/b:HydrometricStationPart">
		<td><xsl:value-of select="b:Area/b:Name"/></td>
	</xsl:for-each>
	
	</tr><tr>
	
	<xsl:for-each select="b:FloodForecastAddition/b:HydrometricStationPart">
		<td><xsl:value-of select="b:Area/b:Location"/></td>
	</xsl:for-each>

	</tr>

	<xsl:if test="b:FloodForecastAddition/b:HydrometricStationPart/b:Criteria/e:WaterLevel or b:FloodForecastAddition/b:HydrometricStationPart/b:Criteria/e:Discharge">
		<tr><td>氾濫危険水位</td>
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

		<tr><td>避難判断水位</td>
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

		<tr><td>氾濫注意水位</td>
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

		<tr><td>水防団待機水位</td>
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
				<font size="-1"><xsl:value-of select="."/></font>
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
			<td rowspan="2"><xsl:value-of select="@type"/></td>
			<td rowspan="2"><xsl:value-of select="b:Name" /></td>
			<td><xsl:value-of select="b:ContactInfo" /></td>
		</tr>
		<tr><td><xsl:text>ホームページ：</xsl:text><xsl:value-of select="b:URI" /></td></tr>
	</xsl:for-each>
	</table>


</xsl:template>


<xsl:template match="b:MeteorologicalInfos">

	<xsl:if test="@type='氾濫水の予報'">
		<br/>
		<font color="navy" size="+1">
			<xsl:value-of select="@type" />
		</font>
		<br/>
		<xsl:value-of select="b:MeteorologicalInfo/b:Item/b:Kind/b:Property/b:Text" />
		<br/>
		
		<table border="1">
		<tr><td>浸水想定箇所</td><td>想定到達時刻＊</td><td>想定最大浸水深</td><td>浸水最深時刻＊</td></tr>
		
		<xsl:for-each select="b:MeteorologicalInfo/b:Item/b:Kind/b:Property/b:FloodAssumptionTable/b:FloodAssumptionPart">
		<tr>
			<td><xsl:value-of select="b:FloodAssumptionArea"/></td>
			<td><xsl:value-of select="b:AttainmentTime/@description"/>
				<xsl:text>（</xsl:text>
				<xsl:call-template name="hiduke00">
					<xsl:with-param name="value" select="b:AttainmentTime" />
				</xsl:call-template>
				<xsl:value-of select="b:AttainmentTime/@dubious"/>
				<xsl:text>）</xsl:text>
			</td>
			
			<td>
				<xsl:if test="e:FloodDepth[@bound='以上']">
					<xsl:value-of select="e:FloodDepth[@bound='以上']"/><xsl:text>以上</xsl:text>
				</xsl:if>
				<xsl:if test="e:FloodDepth[@bound='未満']">
					<xsl:value-of select="e:FloodDepth[@bound='未満']"/><xsl:text>未満</xsl:text>
				</xsl:if>
			</td>
			
			<td><xsl:value-of select="b:AttainmentDeepestTime/@description"/>
				<xsl:text>（</xsl:text>
				<xsl:call-template name="hiduke00">
					<xsl:with-param name="value" select="b:AttainmentDeepestTime" />
				</xsl:call-template>
				<xsl:value-of select="b:AttainmentDeepestTime/@dubious"/>
				<xsl:text>）</xsl:text>
			</td>


		</tr>
		</xsl:for-each>
		</table>
		<xsl:text>＊氾濫発生からの時間を示しています。</xsl:text>
		<br/>
	</xsl:if>


	<xsl:if test="@type='雨量情報'">
		<br/>
		<font color="navy" size="+1">
			<xsl:value-of select="@type" />
		</font>
		<br/>

		<xsl:value-of select="b:MeteorologicalInfo/b:Item/b:Kind/b:Property/b:Text" />

		<xsl:for-each select="b:TimeSeriesInfo">

			<table border="1">
			<tr>
			<td>
				<xsl:if test="b:Item/b:Area/b:Name">
				<xsl:text>流域</xsl:text>
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
				<xsl:if test="b:Item/b:Area/b:Name">
				<xsl:value-of select="b:Item/b:Area/b:Name"/>
				</xsl:if>
			</td>
			<xsl:for-each select="b:Item/b:Kind/b:Property/b:PrecipitationPart/e:Precipitation">
				<td><xsl:value-of select="@type"/><xsl:value-of select="." /><xsl:value-of select="@unit"/></td>
			</xsl:for-each>

			</tr>
			</table>
			<br/>

		</xsl:for-each>

	</xsl:if>

	<xsl:if test="@type='水位・流量情報'">
		<br/>
		<font color="navy" size="+1">
			<xsl:value-of select="@type" />
		</font>
		<br/>

		<xsl:value-of select="b:MeteorologicalInfo/b:Item/b:Kind/b:Property/b:Text" />

		<table border="1">
		<tr>
		<td>
			<xsl:if test="b:TimeSeriesInfo/b:Item/b:Station/b:Name">
			<xsl:text>観測所</xsl:text>
			</xsl:if>
		</td>

		<xsl:for-each select="b:TimeSeriesInfo/b:TimeDefines/b:TimeDefine">
			<td colspan="2">
			<xsl:value-of select="b:Name"/>
			</td>
		</xsl:for-each>

		</tr>

		<xsl:for-each select="b:TimeSeriesInfo/b:Item">

			<tr>
			<td>
				<xsl:value-of select="b:Station/b:Name"/>
			</td>

			<xsl:for-each select="b:Kind/b:Property/b:WaterLevelPart/e:WaterLevel">
				<td>
					<xsl:if test="@type='水位' or @type='流量'">
						<xsl:if test="@condition='未計算'">
							<xsl:text>未計算</xsl:text>
						</xsl:if>
						<xsl:if test="@condition!='未計算'">
							<xsl:value-of select="@type"/>
							<xsl:value-of select="."/>
							<xsl:value-of select="@unit"/>
							<xsl:if test="@condition!='正常'">
								<xsl:text>（</xsl:text><xsl:value-of select="@condition"/><xsl:text>）</xsl:text>
							</xsl:if>
						</xsl:if>
					</xsl:if>
					<xsl:if test="@type='レベル'">
						<xsl:value-of select="@type"/>
						<xsl:value-of select="."/>
					</xsl:if>
				</td>
			</xsl:for-each>

			<xsl:for-each select="b:Kind/b:Property/b:DischargePart/e:Discharge">
				<td>
					<xsl:if test="@type='水位' or @type='流量'">
						<xsl:if test="@condition='未計算'">
							<xsl:text>未計算</xsl:text>
						</xsl:if>
						<xsl:if test="@condition!='未計算'">
							<xsl:value-of select="@type"/>
							<xsl:value-of select="."/>
							<xsl:value-of select="@unit"/>
							<xsl:if test="@condition!='正常'">
								<xsl:text>（</xsl:text><xsl:value-of select="@condition"/><xsl:text>）</xsl:text>
							</xsl:if>
						</xsl:if>
					</xsl:if>
					<xsl:if test="@type='レベル'">
						<xsl:value-of select="@type"/>
						<xsl:value-of select="."/>
					</xsl:if>
				</td>
			</xsl:for-each>
			</tr>

		</xsl:for-each>
		</table>
	</xsl:if>

</xsl:template>


<xsl:template match="b:Warning">

	<!--
	<font color="navy" size="+1">
	<xsl:text>＜</xsl:text>
	<xsl:value-of select="@type" />
	<xsl:text>＞</xsl:text>
	</font>

	<br/>
	-->

	<font color="navy" size="+1">
		<xsl:value-of select="b:Item/b:Kind/b:Property/b:Type"/><br/>
	</font>

	<xsl:for-each select="b:Item">

		<xsl:value-of select="b:Kind/b:Property/b:Text"/><br/>
		
		<xsl:if test="b:Kind/b:Property/b:Type='浸水想定地区'">

			<table border="1">

			<xsl:for-each select="b:Areas/b:Area">
			<tr>
				<td>
				<xsl:value-of select="b:Name"/>
				<!-- <xsl:value-of select="b:Code"/> -->
				</td>
				<td>
				<xsl:value-of select="b:Prefecture"/>
				</td>
				<td>
				<xsl:value-of select="b:City"/>
				</td>
				<td>
				<xsl:value-of select="b:SubCityList"/>
				</td>
			</tr>
			</xsl:for-each>
			</table>
			<font size="-1">
				<xsl:text>※氾濫による浸水が想定される地区については、一定の条件下に基づく計算結果での推定です。気象条件や堤防の決壊の状況によっては、この地区以外でも氾濫による浸水がおこる可能性があります。</xsl:text>
			</font>
		</xsl:if>

		<xsl:if test="b:Kind/b:Property/b:Type='浸水想定地区（氾濫発生情報）'">

			<table border="1">

			<xsl:for-each select="b:Areas/b:Area">
			<tr>
				<td>
				<xsl:value-of select="b:Prefecture"/>
				</td>
				<td>
				<xsl:value-of select="b:City"/>
				</td>
				<td>
				<xsl:value-of select="b:SubCityList"/>
				</td>
			</tr>
			</xsl:for-each>
			</table>
			<font size="-1">
				<xsl:text>※氾濫による浸水が想定される地区については、一定の条件下に基づく計算結果での推定です。気象条件や堤防の決壊の状況によっては、この地区以外でも氾濫による浸水がおこる可能性があります。</xsl:text>
			</font>
		</xsl:if>

	<br/>

	</xsl:for-each>

</xsl:template>


<xsl:template match="h:Headline">
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
		<xsl:text>　</xsl:text>
		<xsl:value-of select="h:Item/h:Kind/h:Condition" />
		
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
		<xsl:for-each select="h:Head/h:Headline/h:Information">
			<xsl:if test="@type='指定河川洪水予報（予報区域）'">
				<xsl:value-of select="h:Item/h:Areas/h:Area/h:Name" /><xsl:text>洪水予報</xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:text>　第</xsl:text><xsl:value-of select="h:Head/h:Serial" /><xsl:text>号</xsl:text>
		<br />
		<xsl:for-each select="h:Head/h:Headline/h:Information">
			<xsl:if test="@type='指定河川洪水予報（予報区域）'">
				<xsl:value-of select="h:Item/h:Kind/h:Condition" />
				<br />
			</xsl:if>
		</xsl:for-each>

		<xsl:call-template name="hiduke" />
		<br />
		<xsl:value-of select="jmx:Control/jmx:PublishingOffice"/><xsl:text>　共同発表</xsl:text>

		<xsl:if test="contains(h:Head/h:InfoType,'訂正')">
			<br />
			<xsl:text>（訂正）</xsl:text>
		</xsl:if>
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
