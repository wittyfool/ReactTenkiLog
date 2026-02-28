<?xml version="1.0" encoding="UTF-8" ?>

<!--
   ======================================================================
  本スタイルシートは、気象庁防災情報XMLフォーマット形式電文中の全ての情
  報コンテンツを出力するもので、システム処理の動作確認など、電文処理の参
  考資料としてお使い下さい。

  なお、本スタイルシートについては、システムに直接組み込む等の方法でご利
  用になることは避けていただくなど、ご利用に当たっては十分に注意していた
  だきますよう、よろしくお願いいたします。

  Copyright (c) 気象庁 2018, 2026 All rights reserved.
  
  【対象情報】
  全般海上警報

  【更新履歴】
  2012年03月29日　Ver.1.0
  2018年01月17日　Ver.1.1
  2019年04月24日　Ver.1.2 5月1日より施行される新元号への対応
  2026年01月29日　Ver.1.3 全般海上警報（定時）（Ｒ８）対応
  ======================================================================
-->

<!-- 名前空間の指定 気象庁使用の名前空間 -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:jmx="http://xml.kishou.go.jp/jmaxml1/" exclude-result-prefixes="jmx"
 xmlns:h="http://xml.kishou.go.jp/jmaxml1/informationBasis1/"
 xmlns:b="http://xml.kishou.go.jp/jmaxml1/body/meteorology1/"
 xmlns:jmx_eb="http://xml.kishou.go.jp/jmaxml1/elementBasis1/"
 >

<!-- 出力文字コード -->
<xsl:output method="html" indent="no" encoding="Shift_JIS"/>


<!-- メイン -->
<xsl:template match="/">
	<html>
	<head>
	<title><xsl:if test="jmx:Report/jmx:Control/jmx:Title"><xsl:value-of select="jmx:Report/jmx:Control/jmx:Title"/></xsl:if></title>

	<!--	スタイルシート	-->
	<link rel="stylesheet" href="kaijo.css" type="text/css" />

	</head>
	<body>
			<div id="header">
			<h1><xsl:if test="jmx:Report/jmx:Control/jmx:Title"><xsl:value-of select="jmx:Report/jmx:Control/jmx:Title"/></xsl:if></h1><br />
			<h1>

			<!--	警報の対象日付の出力	-->
			<xsl:apply-templates select="jmx:Report" /><br />
			この警報の対象期間は、
			<xsl:call-template name="hiduke">
				<xsl:with-param name="DATE" select="jmx:Report/h:Head/h:ValidDateTime" />
			</xsl:call-template>
			までです。
			</h1>
			</div>
			
			<!--	ホームページのメイン要素	-->
			<div id="contents">
				
				<!--	警報なし	 -->
				<xsl:apply-templates select="jmx:Report/h:Head/h:Headline/h:Information/h:Item/h:Kind[ h:Code ='00' ]" mode="NASHI"/>
				
				<!--	風関連警報	 -->
				<xsl:apply-templates select="jmx:Report/b:Body/b:MeteorologicalInfos/b:MeteorologicalInfo[ contains( ./b:Item/b:Kind/b:Name, '風警報') ]" mode="KAZE"/>

				<!--	濃霧警報		-->
				<xsl:apply-templates select="jmx:Report/b:Body[b:MeteorologicalInfos/b:MeteorologicalInfo/b:Item/b:Kind/b:Name = '海上濃霧警報']" mode="NOUMU"/>
					
				<!--	着氷警報		-->
				<xsl:apply-templates select="jmx:Report/b:Body[b:MeteorologicalInfos/b:MeteorologicalInfo/b:Item/b:Kind/b:Name = '海上着氷警報']" mode="CHAKUHYOU"/>
				
				<!--	概況	 -->
				<xsl:apply-templates select="jmx:Report/b:Body[b:MeteorologicalInfos/@type = '概況']" mode="GAIKYO"/>
					
				<!--	海上予報	 -->
				<xsl:apply-templates select="jmx:Report/b:Body[b:MeteorologicalInfos/@type = '全般海上予報']" mode="YOHO"/>
				
			</div>
	</body>
	</html>
</xsl:template>

<!--	濃霧警報	-->
<xsl:template match="b:Body" mode="NOUMU">
		
	<!--	警報内容	-->
	<xsl:apply-templates select="b:MeteorologicalInfos/b:MeteorologicalInfo/b:Item[ b:Kind/b:Name = '海上濃霧警報' ]" mode="NOUMU"/>

</xsl:template>
	
<!--	着氷警報	-->
<xsl:template match="b:Body" mode="CHAKUHYOU">
	
	<!--	警報内容	-->
	<xsl:apply-templates select="b:MeteorologicalInfos/b:MeteorologicalInfo/b:Item[ b:Kind/b:Name = '海上着氷警報' ]" mode="CHAKUHYOU"/>
	
</xsl:template>


<!--	概況	-->
<xsl:template match="b:Body" mode="GAIKYO">
	
	<xsl:if test="b:MeteorologicalInfos[@type='概況']/b:MeteorologicalInfo/b:Item/b:Kind/b:ClassName = '気圧系'">
		<h3>概況高低気圧</h3>
		<table border="1">
			<tr><th>高低気圧</th><th>日時</th><th>位置</th><th>移動方向</th><th>移動速度</th><th>気圧</th><th>備考</th></tr>
			<xsl:apply-templates select="b:MeteorologicalInfos[@type='概況']/b:MeteorologicalInfo[ b:Item/b:Kind/b:ClassName = '気圧系']/b:Item" mode="GAIKYO_KOTE"/>
		</table>
	</xsl:if>

	<xsl:if test="b:MeteorologicalInfos[@type='概況']/b:MeteorologicalInfo/b:Item/b:Kind/b:ClassName = '前線'">
		<h3>概況前線</h3>
		<table border="1">
			<tr><th>前線</th><th>日時</th><th>位置</th></tr>
			<xsl:apply-templates select="b:MeteorologicalInfos[@type='概況']/b:MeteorologicalInfo[ b:Item/b:Kind/b:ClassName = '前線']/b:Item" mode="GAIKYO_ZENSEN"/>
		</table>
	</xsl:if>
</xsl:template>
	
<!--	全般海上予報	-->
<xsl:template match="b:Body" mode="YOHO">
	<h3>風の海上予報</h3>
	<table border="1">
		<tr>
			<th>地域名</th>
			<th>
			
				<xsl:call-template name="hiduke_dh"><xsl:with-param name="DATE" select="b:MeteorologicalInfos[@type='全般海上予報']/b:MeteorologicalInfo/b:DateTime" /></xsl:call-template>
				から
				<xsl:call-template name="duration"><xsl:with-param name="DUR" select="b:MeteorologicalInfos[@type='全般海上予報']/b:MeteorologicalInfo/b:Duration" /></xsl:call-template>
			</th>
		</tr>
		<tr>
			<xsl:apply-templates select="b:MeteorologicalInfos[@type='全般海上予報']/b:MeteorologicalInfo[b:Item/b:Kind/b:Property/b:Type = '風']/b:Item" mode="YOHO_KAZE"/>
		</tr>
	</table>
		
	<h3>波の海上予報</h3>
	<table border="1">
		<tr>
			<th>地域名</th>
			<th>
				<xsl:call-template name="hiduke_dh"><xsl:with-param name="DATE" select="b:MeteorologicalInfos[@type='全般海上予報']/b:MeteorologicalInfo/b:DateTime" /></xsl:call-template>
				から
				<xsl:call-template name="duration"><xsl:with-param name="DUR" select="b:MeteorologicalInfos[@type='全般海上予報']/b:MeteorologicalInfo/b:Duration" /></xsl:call-template>
			</th>
		</tr>
		<tr>
			<xsl:apply-templates select="b:MeteorologicalInfos[@type='全般海上予報']/b:MeteorologicalInfo[b:Item/b:Kind/b:Property/b:Type = '波']/b:Item" mode="YOHO_NAMI"/>
		</tr>
	</table>
</xsl:template>

<!--	概況高低気圧	-->
<xsl:template match="b:Item" mode="GAIKYO_KOTE">
	<tr>
		<td><xsl:value-of select="b:Kind/b:Property/b:Type"/></td>
		<td>
			<xsl:call-template name="hiduke">
				<xsl:with-param name="DATE"><xsl:value-of select="../b:DateTime"/></xsl:with-param>
			</xsl:call-template>
		</td>
		<td><xsl:value-of select="b:Kind/b:Property/b:CenterPart/jmx_eb:Coordinate/@description"/></td>
		<td>
			<xsl:if test="b:Kind/b:Property/b:CenterPart/jmx_eb:Direction/@description">
				<xsl:value-of select="b:Kind/b:Property/b:CenterPart/jmx_eb:Direction/@description"/>
			</xsl:if>
			<xsl:if test="b:Kind/b:Property/b:CenterPart/jmx_eb:Direction/text()">
				<xsl:value-of select="b:Kind/b:Property/b:CenterPart/jmx_eb:Direction/text()"/>
			</xsl:if>
		</td>
		<td><xsl:value-of select="b:Kind/b:Property/b:CenterPart/jmx_eb:Speed/@description"/></td>
		<td><xsl:value-of select="b:Kind/b:Property/b:CenterPart/jmx_eb:Pressure/@description"/></td>
		<td>
			<xsl:choose>
				<xsl:when test="b:Kind/b:Property/b:Text">
					<xsl:value-of select="b:Kind/b:Property/b:Text"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>特になし</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</td>
	</tr>
</xsl:template>

<!--	概況高低気圧	-->
<xsl:template match="b:Item" mode="GAIKYO_ZENSEN">
	<tr>
		<td><xsl:value-of select="b:Kind/b:Property/b:Type"/></td>
		<td>
			<xsl:call-template name="hiduke">
				<xsl:with-param name="DATE"><xsl:value-of select="../b:DateTime"/></xsl:with-param>
			</xsl:call-template>
		</td>
		<td><xsl:value-of select="b:Area/jmx_eb:Line/@description"/></td>
	</tr>
</xsl:template>
	
<!--	風の予報	-->
<xsl:template match="b:Item" mode="YOHO_KAZE">
	<tr>
		<td><xsl:value-of select="b:Area/b:Name"/></td>
		<td>
			<xsl:value-of select="b:Kind/b:Property/b:WindPart/b:Base/jmx_eb:WindDirection"></xsl:value-of><xsl:text>の風　</xsl:text>
			<xsl:value-of select="b:Kind/b:Property/b:WindPart/b:Base/jmx_eb:WindSpeed[@unit='ノット']"></xsl:value-of><xsl:text>ノット</xsl:text>
			<xsl:text>（</xsl:text><xsl:value-of select="b:Kind/b:Property/b:WindPart/b:Base/jmx_eb:WindSpeed[@unit='m/s']"></xsl:value-of><xsl:text>メートル）</xsl:text>
		</td>
	</tr>
</xsl:template>
	
<!--	波の予報	-->
<xsl:template match="b:Item" mode="YOHO_NAMI">
	<tr>
		<td><xsl:value-of select="b:Area/b:Name"/></td>
		<td>
			<xsl:choose>
				<xsl:when test="b:Kind/b:Property/b:WaveHeightPart/b:Base/jmx_eb:WaveHeight/@description='海氷のため予報なし'">
					<xsl:text>海氷のため予報なし</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="b:Kind/b:Property/b:WaveHeightPart/b:Base/jmx_eb:WaveHeight"></xsl:value-of><xsl:text>メートル</xsl:text><br/>
					<xsl:choose>
						<xsl:when test="b:Kind/b:Property/b:WaveHeightPart/b:Base/jmx_eb:WaveHeight/@condition">
							<xsl:value-of select="b:Kind/b:Property/b:WaveHeightPart/b:Base/jmx_eb:WaveHeight/@condition"></xsl:value-of>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>　</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</td>
	</tr>
</xsl:template>

<!--ヘッダー部の記述-->
<xsl:template match="jmx:Report">
	<xsl:call-template name="hiduke">
		<xsl:with-param name="DATE" select="h:Head/h:ReportDateTime" />
	</xsl:call-template>

	<xsl:text>　　</xsl:text><xsl:value-of select="jmx:Control/jmx:PublishingOffice"/><xsl:text>発表</xsl:text>
	<xsl:call-template name="newLine"/>
	
	<xsl:if test="contains(h:Head/h:InfoType,'訂正')">
		<xsl:text>（訂正）</xsl:text>
	</xsl:if>
	<xsl:call-template name="newLine"/>
	
	<!--	6時間ごとに更新	-->
	<xsl:if test="b:Body/b:Notice">
		<xsl:value-of select="b:Body/b:Notice"/>
	</xsl:if>

	<xsl:call-template name="newLine"/>
</xsl:template>


<!--	各警報事項-->
<xsl:template match="b:MeteorologicalInfo" mode="KAZE" >
	
	<!--	発表時間	-->
	<xsl:call-template name="hiduke"><xsl:with-param name="DATE" select="b:DateTime" /></xsl:call-template>
	
	<!--	風関連警報　　	-->
	<xsl:apply-templates select="b:Item" mode="KAZE"/>

</xsl:template>

<!--	緯度経度領域	-->
<xsl:template match="b:Area">
	<xsl:if test="jmx_eb:Polygon/@description">
		<tr><th>緯度経度領域</th><td><xsl:value-of select="jmx_eb:Polygon/@description"/></td></tr>
	</xsl:if>
	<xsl:if test="b:Code">
		<tr><th>海域</th><td><xsl:value-of select="b:Name"/></td></tr>
	</xsl:if>
</xsl:template>

<!--	警報なし	-->
<xsl:template match="h:Kind" mode="NASHI">
		<h3><xsl:value-of select="h:Name"/></h3>
</xsl:template>

<!--	濃霧警報系	-->
<xsl:template match="b:Item" mode="NOUMU">

	<!--	発表時間	-->
	<xsl:call-template name="hiduke"><xsl:with-param name="DATE" select="../b:DateTime" /></xsl:call-template>
	
	<table border="1">
		<!--	警報名-->
		<tr><th>警報名</th><td>	<xsl:value-of select="b:Kind/b:Name"/></td></tr>
		
		<!--	存在海域または緯度経度領域	-->
		<xsl:apply-templates select="b:Area"/>
		
		<!--	警報事項	-->
		<tr>
			<th>警報事項</th>
			<td><xsl:value-of select="b:Kind/b:Property/b:Text"/></td>
		</tr>
	</table>

	<xsl:call-template name="newLine"/>
	
</xsl:template>
	
<!--	着氷警報 -->
<xsl:template match="b:Item" mode="CHAKUHYOU">
	
	<!--	発表時間	-->
	<xsl:call-template name="hiduke"><xsl:with-param name="DATE" select="../b:DateTime" /></xsl:call-template>
	
	<table border="1">
		<!--	警報名-->
		<tr><th>警報名</th><td>	<xsl:value-of select="b:Kind/b:Name"/></td></tr>
		
		<!--	存在海域または緯度経度領域	-->
		<xsl:apply-templates select="b:Area"/>
		
		<!--	警報事項	-->
		<tr>
			<th>警報事項</th>
			<td><xsl:value-of select="b:Kind/b:Property/b:Text"/></td>
		</tr>
	</table>
	
	<xsl:call-template name="newLine"/>
	
</xsl:template>

<!--	じょう乱種類	-->
<xsl:template match="b:Type" mode="JORAN">
	<tr>
		<th>じょう乱種類</th>
		<td>
			<xsl:choose>
				<xsl:when test="../b:ClassPart/jmx_eb:TyphoonClass/text()='台風'">
					<xsl:value-of select="../b:ClassPart/jmx_eb:TyphoonClass/text()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="text()"/>
				</xsl:otherwise>
			</xsl:choose>
		</td>
	</tr>	
</xsl:template>


<!--	風警報系		-->
<xsl:template match="b:Item" mode="KAZE">
	<xsl:if test="b:Kind/b:Property/b:Type='風'">
		<table border="1">
			<!--	警報名-->
			<tr><th>警報名</th><td>	<xsl:value-of select="b:Kind/b:Name"/></td></tr>

			<!--	じょう乱種類-->
			<xsl:apply-templates select="b:Kind/b:Property/b:Type[ ( text() = '低気圧' or text() = '熱帯低気圧' ) and ../../b:DateTime/@type = '実況']" mode="JORAN"/>

			<!--	台風名などの情報		-->
			<xsl:apply-templates select="b:Kind/b:Property/b:TyphoonNamePart"/>

			<!--	発達傾向、中心気圧、存在位置、存在地域-->
			<xsl:apply-templates select="b:Kind/b:DateTime[ @type='実況' ]/../b:Condition"/>
			<xsl:apply-templates select="b:Kind/b:DateTime[ @type='実況' ]/../b:Property[ ./b:Type != '別の低気圧' ]/b:CenterPart"/>
			<xsl:apply-templates select="b:Area"/>

			<!--	強風域、暴風域	-->
			<xsl:apply-templates select="b:Kind/b:Property"/>

			<!--	別低気圧、前線	-->
			<xsl:apply-templates select="b:Kind/b:Property/b:CoordinatePart"/>
			<xsl:apply-templates select="b:Kind/b:DateTime[ @type='実況' ]/../b:Property[ ./b:Type = '別の低気圧' ]/b:CenterPart">
				<xsl:with-param name="TITLE">別の低気圧</xsl:with-param>
			</xsl:apply-templates>
			
			<!--	予報	位置、予報円、中心気圧など	-->
			<xsl:apply-templates select="b:Kind/b:Property/b:CenterPart/b:ProbabilityCircle"/>			
		</table>
	</xsl:if>

	<xsl:call-template name="newLine"/>
	
</xsl:template>

<!--	予報位置	-->
<xsl:template match="b:ProbabilityCircle">
	<tr>
		<th><xsl:value-of select="../../../b:DateTime/@type"/>の日時</th>
		<td>
			<xsl:call-template name="hiduke0">
				<xsl:with-param name="DATE"><xsl:value-of select="../../../b:DateTime"/></xsl:with-param>
			</xsl:call-template>
		</td>
	</tr>
	<tr>
		<th><xsl:value-of select="../../../b:DateTime/@type"/>の低気圧位置</th>
		<td><xsl:value-of select="jmx_eb:BasePoint/@description"/></td>
	</tr>

	<!--	やはりやむを得ず最大風速	-->
	<xsl:if test="../../../b:Property/b:WindPart/jmx_eb:WindSpeed/@description">
		<tr>
			<th><xsl:value-of select="../../../b:DateTime/@type"/>の最大風速</th>
			<td><xsl:value-of select="../../../b:Property/b:WindPart/jmx_eb:WindSpeed/@description"/></td>
		</tr>
	</xsl:if>
	
	<!--	やむを得ず中心気圧	-->
	<xsl:if test="../jmx_eb:Pressure/@description">
		<tr><th><xsl:value-of select="../../../b:DateTime/@type"/>の中心気圧</th><td><xsl:value-of select="../jmx_eb:Pressure/text()"/><xsl:value-of select="../jmx_eb:Pressure/@unit"/></td>
		</tr>
	</xsl:if>
	
	<!--	予報円の記述	-->
	<xsl:apply-templates select="jmx_eb:Axes">
		<xsl:with-param name="TITLE">
			<xsl:value-of select="../../../b:DateTime/@type"/><xsl:value-of select="@type"/>
		</xsl:with-param>
	</xsl:apply-templates>
	
	<!--	移動方向	-->
	<xsl:choose>
		<xsl:when test="../jmx_eb:Direction/text()">
			<tr><th><xsl:value-of select="../../../b:DateTime/@type"/>移動方向</th>
			<td><xsl:value-of select="../jmx_eb:Direction/text()"/></td></tr>
		</xsl:when>
		<xsl:when test="../jmx_eb:Direction/@description">
			<tr>
				<th><xsl:value-of select="../../../b:DateTime/@type"/>移動方向</th>
				<td><xsl:value-of select="../jmx_eb:Direction/@description"/></td>
			</tr>
		</xsl:when>
	</xsl:choose>

	<!--	移動速度	-->
	<xsl:if test="../jmx_eb:Speed/@description">
		<tr><th><xsl:value-of select="../../../b:DateTime/@type"/>移動速度</th>
		<td><xsl:value-of select="../jmx_eb:Speed/@description"/></td></tr>
	</xsl:if>

	<!--	その後の見通しなど	-->
	<xsl:if test="../../../b:Status and ../../../b:Condition">
		<tr>
			<th><xsl:value-of select="../../../b:DateTime/@type"/><xsl:value-of select="../../../b:Status"/></th><td><xsl:value-of select="../../../b:Condition"/></td>
		</tr>
	</xsl:if>
	
</xsl:template>


<!--	台風名情報	-->
<xsl:template match="b:TyphoonNamePart">
	<xsl:if test="b:Name">
		<tr>
			<th>台風英名</th>
			<td><xsl:value-of select="b:Name" /></td>
		</tr>
	</xsl:if>
	<xsl:if test="b:NameKana">
		<tr>
			<th>台風和名</th>
			<td><xsl:value-of select="b:NameKana" /></td>
		</tr>
	</xsl:if>
	<xsl:if test="b:Number">
		<tr>
			<th>台風番号</th>
			<td><xsl:value-of select="b:Number" /></td>
		</tr>
	</xsl:if>
</xsl:template>


<!--低気圧記述テンプレート-->
<xsl:template match="b:CenterPart">
	<xsl:param name="TITLE"></xsl:param>

	<!--	中心気圧	-->
	<xsl:if test="jmx_eb:Pressure/@type" >
		<tr><th ><xsl:value-of select="$TITLE"/>中心気圧</th><td><xsl:value-of select="jmx_eb:Pressure" /><xsl:value-of select="jmx_eb:Pressure/@unit" /></td></tr>
	</xsl:if>
	
	<!--	中心位置	-->
	<xsl:if test="jmx_eb:Coordinate/@description">
		<tr><th ><xsl:value-of select="$TITLE"/>中心位置</th><td><xsl:value-of select="jmx_eb:Coordinate/@description" /></td></tr>
	</xsl:if>

	<!--	中心位置精度		-->
	<xsl:if test="jmx_eb:Coordinate/@condition">
		<tr><th ><xsl:value-of select="$TITLE"/>中心精度</th><td><xsl:value-of select="jmx_eb:Coordinate/@condition" /></td></tr>
	</xsl:if>
	
	<!--	移動方向	-->
	<xsl:choose>
		<xsl:when test="jmx_eb:Direction/text()">
			<tr><th><xsl:value-of select="$TITLE"/>移動方向</th><td><xsl:value-of select="jmx_eb:Direction/text()"/></td></tr>
		</xsl:when>
		<xsl:when test="jmx_eb:Direction/@description">
			<tr>
				<th><xsl:value-of select="$TITLE"/>移動方向</th>
				<td><xsl:value-of select="jmx_eb:Direction/@description"/></td>
			</tr>
		</xsl:when>
	</xsl:choose>

	<!--	移動速度	-->
	<xsl:if test="jmx_eb:Speed/@description">
		<tr><th><xsl:value-of select="$TITLE"/>移動速度</th><td><xsl:value-of select="jmx_eb:Speed/@description"/></td></tr>
	</xsl:if>
	
	<!--	存在海域	-->
	<xsl:if test="b:Location">
		<tr><th ><xsl:value-of select="$TITLE"/>海域</th><td><xsl:value-of select="b:Location"/></td></tr>
	</xsl:if>
	
</xsl:template>


<!--	中心気圧	-->
<xsl:template match="jmx_eb:Pressure">
	<xsl:if test="@type" >
		<tr>
			<th >中心気圧</th><td><xsl:value-of select="@description" /><xsl:value-of select="@unit" /></td>
		</tr>
	</xsl:if>
</xsl:template>


<!--	中心位置	-->
<xsl:template match="jmx_eb:Coordinate">
	<tr><th >中心位置</th><td><xsl:value-of select="@description" /></td></tr>
</xsl:template>


<!--	移動方向	-->
<xsl:template match="jmx_eb:Direction">
	<tr><th>移動方向</th><td><xsl:value-of select="text()"/></td></tr>
</xsl:template>


<!--	移動速度	-->
<xsl:template match="jmx_eb:Speed">
	<xsl:if test="@description">
		<tr><th>移動速度</th><td><xsl:value-of select="@description"/></td></tr>
	</xsl:if>
</xsl:template>


<!--	発達傾向	-->
<xsl:template match="b:Condition">
	<tr><th>発達傾向</th><td><xsl:value-of select="text()"/></td></tr>
</xsl:template>

<!--	前線記述テンプレート	-->
<xsl:template match="b:CoordinatePart">
	<tr>
		<th><xsl:value-of select="../b:Type"/></th><td><xsl:value-of select="jmx_eb:Line/@description"/></td>
	</tr>
</xsl:template>


<!--	範囲円描画	-->
<xsl:template match="jmx_eb:Axes">
	<xsl:param name="TITLE">円</xsl:param>

	<!--全域の記述-->
	<xsl:if test="jmx_eb:Axis/jmx_eb:Direction/@description='全域'">
		<tr>
			<th><xsl:value-of select="$TITLE"/>の方向</th>
			<td><xsl:value-of select="jmx_eb:Axis/jmx_eb:Direction/@description" /></td>
		</tr>
		<tr>
			<th><xsl:value-of select="$TITLE"/>の半径</th>
			<td><xsl:value-of select="jmx_eb:Axis/jmx_eb:Radius/@description" /></td>
		</tr>
	</xsl:if>
	
	<!--	二方向	-->
	<xsl:if test="jmx_eb:Axis[ 2 ]">
		<xsl:choose>
			<xsl:when test="jmx_eb:Axis[ 1 ]/jmx_eb:Radius &gt; jmx_eb:Axis[ 2 ]/jmx_eb:Radius">
				<tr>
					<th><xsl:value-of select="$TITLE"/>の長径方向</th>
					<td><xsl:value-of select="jmx_eb:Axis[ 1 ]/jmx_eb:Direction" /></td>
				</tr>
				<tr>
					<th><xsl:value-of select="$TITLE"/>の短径方向</th>
					<td><xsl:value-of select="jmx_eb:Axis[ 2 ]/jmx_eb:Direction" /></td>
				</tr>
				<tr>
					<th><xsl:value-of select="$TITLE"/>の長径</th>
					<td><xsl:value-of select="jmx_eb:Axis[ 1 ]/jmx_eb:Radius/@description" /></td>
				</tr>
				<tr>
					<th><xsl:value-of select="$TITLE"/>の短径</th>
					<td><xsl:value-of select="jmx_eb:Axis[ 2 ]/jmx_eb:Radius/@description" /></td>
				</tr>
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<th><xsl:value-of select="$TITLE"/>の長径方向</th>
					<td><xsl:value-of select="jmx_eb:Axis[ 2 ]/jmx_eb:Direction" /></td>
				</tr>
				<tr>
					<th><xsl:value-of select="$TITLE"/>の短径方向</th>
					<td><xsl:value-of select="jmx_eb:Axis[ 1 ]/jmx_eb:Direction" /></td>
				</tr>
				<tr>
					<th><xsl:value-of select="$TITLE"/>の長径</th>
					<td><xsl:value-of select="jmx_eb:Axis[ 2 ]/jmx_eb:Radius/@description" /></td>
				</tr>
				<tr>
					<th><xsl:value-of select="$TITLE"/>の短径</th>
					<td><xsl:value-of select="jmx_eb:Axis[ 1 ]/jmx_eb:Radius/@description" /></td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
</xsl:template>


<!--	風向テンプレート	-->
<xsl:template match="jmx_eb:WindDirection">
	<tr>
		<th>風向</th>
		<td>
			<xsl:value-of select="../jmx_eb:WindDirection[ 1 ]"/>
			<xsl:if test="../jmx_eb:WindDirection[ 2 ]">
				または<xsl:value-of select="../jmx_eb:WindDirection[ 2 ]"/>
			</xsl:if>
		</td>
	</tr>
</xsl:template>

<!--	強風域、暴風域	-->
<xsl:template match="b:Property">

	<!--	予報時間、最大風速	-->
	<xsl:apply-templates select="b:WindPart" mode="JIKKYO"/>

	<!--	強風域、暴風域の風速、長径方向、長径、短径	-->
	<xsl:apply-templates select="b:WarningAreaPart"/>

</xsl:template>


<!--	風関連警報内容	-->
<xsl:template match="b:WindPart" mode="JIKKYO">
	
	<xsl:if test="not(../../b:DateTime) or ../../b:DateTime/@type='実況'">
		<xsl:choose>		
			<xsl:when test="b:Becoming/b:TimeModifier">
				<tr><th>予報時間</th><td><xsl:value-of select="b:Becoming/b:TimeModifier"/></td></tr>
			</xsl:when>
			
			<xsl:when test="../../b:DateTime/@type">
				<tr><th>予報時間</th><td><xsl:value-of select="../../b:DateTime/@type"/></td></tr>
			</xsl:when>
			
			<xsl:when test="jmx_eb:WindSpeed">
				<tr><th>予報時間</th><td>実況</td></tr>
			</xsl:when>
			
			<xsl:otherwise>
				<tr><th>予報時間</th><td>指定なし</td></tr>
			</xsl:otherwise>
		</xsl:choose>
		
		
		<xsl:choose>		
			<xsl:when test="b:Becoming">
				<!--風向-->
				<xsl:apply-templates select="b:Becoming/jmx_eb:WindDirection[ 1 ]"/>
				<!--風速-->
				<xsl:apply-templates select="b:Becoming/jmx_eb:WindSpeed[ 1 ]"/>
				<!--最大風速-->
				<xsl:apply-templates select="b:Becoming/jmx_eb:WindSpeed[ 2 ]"/>
			</xsl:when>
			<xsl:otherwise>
				<!--風向-->
				<xsl:apply-templates select="jmx_eb:WindDirection[ 1 ]"/>
				<!--風速-->
				<xsl:apply-templates select="jmx_eb:WindSpeed[ 1 ]"/>
				<!--最大風速-->
				<xsl:apply-templates select="jmx_eb:WindSpeed[ 2 ]"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
	
</xsl:template>

<!--	最大風速　　-->
<xsl:template match="jmx_eb:WindSpeed">
		<tr>
			<th>風速</th>
			<td>
				<xsl:value-of select="@description"/>
			</td>
		</tr>
</xsl:template>


<!--	暴風域　強風域の記述	-->
<xsl:template match="b:WarningAreaPart">
	<xsl:if test="jmx_eb:WindSpeed/@description">
		<tr>
			<th><xsl:value-of select="@type"/>の風速</th>
			<td><xsl:value-of select="jmx_eb:WindSpeed/@description"/></td>
		</tr>
	</xsl:if>
	<xsl:apply-templates select="jmx_eb:Circle/jmx_eb:Axes">
		<xsl:with-param name="TITLE"><xsl:value-of select="@type"/></xsl:with-param>
	</xsl:apply-templates>
</xsl:template>

<!--
	日付フォーマット
-->
<xsl:template name="hiduke0">
	<xsl:param name="DATE">""</xsl:param>

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
	<xsl:text>(JST)</xsl:text>
</xsl:template>


<xsl:template name="hiduke">
	<xsl:param name="DATE">""</xsl:param>
	
	<xsl:text>令和</xsl:text>
	<xsl:choose>
     <xsl:when test="substring($DATE,1,4)='2019'">元</xsl:when>
     <xsl:otherwise>
      <xsl:value-of select="translate(substring($DATE,1,4) - 2018,'0123456789', '０１２３４５６７８９')"/>
     </xsl:otherwise>
    </xsl:choose>
	<xsl:text>年</xsl:text>
	<xsl:value-of select="translate(substring($DATE,6,1),'0123456789', '　１２３４５６７８９')"/>
	<xsl:value-of select="translate(substring($DATE,7,1),'0123456789', '０１２３４５６７８９')"/>
	<xsl:text>月</xsl:text>
	<xsl:value-of select="translate(substring($DATE,9,1),'0123456789', '　１２３４５６７８９')"/>
	<xsl:value-of select="translate(substring($DATE,10,1),'0123456789', '０１２３４５６７８９')"/>
	<xsl:text>日</xsl:text>
	<xsl:value-of select="translate(substring($DATE,12,2),'0123456789', '０１２３４５６７８９')"/>
	<xsl:text>時</xsl:text>
	<xsl:value-of select="translate(substring($DATE,15,2),'0123456789', '０１２３４５６７８９')"/>
	<xsl:text>分</xsl:text>
	<xsl:text>(JST)</xsl:text>
</xsl:template>
	
<xsl:template name="hiduke_dh">
	<!-- 日値と時値のみを表示 -->
	<xsl:param name="DATE"></xsl:param>
	<xsl:value-of select="translate(substring($DATE,9,1),'0123456789', '　１２３４５６７８９')"/>
	<xsl:value-of select="translate(substring($DATE,10,1),'0123456789', '０１２３４５６７８９')"/>
	<xsl:text>日</xsl:text>
	<xsl:value-of select="translate(substring($DATE,12,2),'0123456789', '０１２３４５６７８９')"/>
	<xsl:text>時</xsl:text>
	<xsl:text>(JST)</xsl:text>
</xsl:template>

<xsl:template name="duration">
	<!-- 値が"P...D"または"PT...H"のパターンが前提 -->
	<xsl:param name="DUR"></xsl:param>
	<xsl:choose>
		<xsl:when test="substring($DUR,string-length($DUR))='D'">
			<xsl:value-of select="translate(substring($DUR,2,string-length($DUR)-2),'0123456789', '０１２３４５６７８９')"/>
			<xsl:text>日間</xsl:text>
		</xsl:when>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test="substring($DUR,string-length($DUR))='H'">
			<xsl:value-of select="translate(substring($DUR,3,string-length($DUR)-3),'0123456789', '０１２３４５６７８９')"/>
			<xsl:text>時間</xsl:text>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<!--	改行	-->
<xsl:template name="newLine"><BR/></xsl:template>

</xsl:stylesheet>
