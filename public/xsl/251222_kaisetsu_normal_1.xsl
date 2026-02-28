<?xml version="1.0" encoding="UTF-8" ?>

<!--
	======================================================================
	本スタイルシートは、気象庁防災情報XMLフォーマット形式電文中の全ての情
	報コンテンツを出力するもので、システム処理の動作確認など、電文処理の参
	考資料としてお使い下さい。

	なお、本スタイルシートについては、システムに直接組み込む等の方法でご利
	用になることは避けていただくなど、ご利用に当たっては十分に注意していた
	だきますよう、よろしくお願いいたします。

	Copyright (c) 気象庁 2024,2025 All rights reserved.
	
	【対象情報】
	気象解説情報形式（気象防災速報、気象解説情報、気象解説情報（潮位））

	【更新履歴】
	2024年10月31日　Ver.1.0 初版
	2024年12月26日　Ver.1.0_1 不具合改修版
	2025年06月30日　Ver.1.0_2 不具合改修版
	2025年12月22日　Ver.1.0_3 不具合改修版（時間連続要素）
	======================================================================
-->

<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:jmx="http://xml.kishou.go.jp/jmaxml1/"
		xmlns:h="http://xml.kishou.go.jp/jmaxml1/informationBasis1/"
		xmlns:b="http://xml.kishou.go.jp/jmaxml1/body/meteorology1/"
		xmlns:jmx_eb="http://xml.kishou.go.jp/jmaxml1/elementBasis1/">
<xsl:output method="html" indent="yes" encoding="utf-8"/>


<!-- 出力ルート -->

<xsl:template match="/">
	<html>
	<head>
	<title><xsl:value-of select="jmx:Report/jmx:Control/jmx:Title" /></title>
	<link rel="stylesheet" type="text/css" href="./style.css" />
	</head>
	<body>
	<h1>
		<xsl:value-of select="jmx:Report/h:Head/h:Title" />
		<xsl:if test="jmx:Report/h:Head/h:Serial/text()">
			<xsl:text> 第</xsl:text>
			<xsl:value-of select="jmx:Report/h:Head/h:Serial" />
			<xsl:text>号</xsl:text>
		</xsl:if>
		<br/>
		<xsl:call-template name="DateTimeOutput">
			<xsl:with-param name="tmpDateTime" select="jmx:Report/h:Head/h:ReportDateTime"/>
			<xsl:with-param name="format"></xsl:with-param>
		</xsl:call-template>
		<xsl:text>　</xsl:text>
		<xsl:value-of select="jmx:Report/jmx:Control/jmx:PublishingOffice"  />
		<xsl:text>発表</xsl:text>
	</h1>
	<h2>情報タグ・対象地域</h2>
	<p>
		<xsl:for-each select="jmx:Report/h:Head/h:Headline/h:Information[@type='情報タグ']/h:Item/h:Kind/h:Condition">
			<xsl:value-of select="."/><xsl:text> </xsl:text>
		</xsl:for-each>
		<xsl:text>／ </xsl:text>
		<xsl:for-each select="jmx:Report/h:Head/h:Headline/h:Information[@type='情報タグ']/h:Item/h:Areas/h:Area/h:Name">
			<xsl:value-of select="."/><xsl:text> </xsl:text>
		</xsl:for-each>
	</p>
	<h2>見出し</h2>
	<p>
		<xsl:call-template name="InsertBlank">
			<xsl:with-param name="value" select="jmx:Report/h:Head/h:Headline/h:Text"/>
		</xsl:call-template>
	</p>
	
	<xsl:if test="jmx:Report/jmx:Control/jmx:Title[contains(text(),'防災速報')]">
		<h2>（気象防災速報の観測データ値）</h2>
	</xsl:if>
	
	<h2>本文</h2>
		<!-- 概況部 -->
		<xsl:for-each select="jmx:Report/b:Body/b:MeteorologicalInfos[@type='概況']/b:MeteorologicalInfo/b:Item/b:Kind/b:Property">
			<xsl:call-template name="PlainText">
				<xsl:with-param name="title" select="b:Type"/>
				<xsl:with-param name="plainText" select="b:Text"/>
			</xsl:call-template>
		</xsl:for-each>

		<!-- 観測実況部 -->
		<xsl:for-each select="jmx:Report/b:Body/b:MeteorologicalInfos[@type='観測実況']">
			<xsl:for-each select="b:TimeSeriesInfo/b:TimeDefines/b:TimeDefine">
	<h3>
		<xsl:text>［</xsl:text>
				<xsl:value-of select="../../b:Item[1]/b:Kind[1]/b:Property[1]/b:Type" />
		<xsl:text>］</xsl:text>
	</h3>
				<xsl:call-template name="Observation">
					<xsl:with-param name="timeId" select="@timeId"/>
				</xsl:call-template>
	<br/>
			</xsl:for-each>
			<xsl:for-each select="b:MeteorologicalInfo">
	<h3>
		<xsl:text>［</xsl:text>
				<xsl:value-of select="b:Item[1]/b:Kind[1]/b:Property[1]/b:Type" />
		<xsl:text>］</xsl:text>
	</h3>
				<xsl:call-template name="Observation">
					<xsl:with-param name="timeId">0</xsl:with-param>
				</xsl:call-template>
	<br/>
			</xsl:for-each>
		</xsl:for-each>

		<!-- 予想部 -->
		<xsl:for-each select="jmx:Report/b:Body/b:MeteorologicalInfos[@type='予想']/b:TimeSeriesInfo">
	<h3>
		<xsl:text>［</xsl:text>
			<xsl:value-of select="b:Item[1]/b:Kind[1]/b:Property[1]/b:Type" />
		<xsl:text>］</xsl:text>
	</h3>
			<xsl:choose>
			<xsl:when test=".//b:Sequence">
				<!-- Sequence要素があるときに地点別でSequenceを連続出力させたい場合 -->
				<xsl:apply-templates select="b:Item" mode="SequenceByArea"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- Sequence要素がない場合 -->
				<!-- 解説を出力 -->
				<xsl:if test="b:Item/b:Kind[1]/b:Property[1]/b:Text[@type='解説']/text()">
					<xsl:call-template name="InsertBlank">
						<xsl:with-param name="value" select="b:Item/b:Kind[1]/b:Property[1]/b:Text[@type='解説']/text()"/>
					</xsl:call-template>
					<br/><br/>
				</xsl:if>
				<!-- 時系列部分（予測値）を出力 -->
				<xsl:for-each select="b:TimeDefines/b:TimeDefine">
					<xsl:call-template name="PredictionTimeSeries">
						<xsl:with-param name="timeId" select="@timeId"/>
						<xsl:with-param name="timeText" select="b:Name"/>
					</xsl:call-template>
					<br/>
				</xsl:for-each>
				<!-- 補足を出力 -->
				<xsl:if test="b:Item/b:Kind[1]/b:Property[1]/b:Text[@type='補足']/text()">
					<xsl:call-template name="InsertBlank">
						<xsl:with-param name="value" select="b:Item/b:Kind[1]/b:Property[1]/b:Text[@type='補足']/text()"/>
					</xsl:call-template>
					<br/><br/>
				</xsl:if>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		
		<!-- 防災事項部 -->
		<xsl:for-each select="jmx:Report/b:Body/b:MeteorologicalInfos[@type='防災事項']/b:MeteorologicalInfo/b:Item/b:Kind/b:Property">
			<xsl:call-template name="PlainText">
				<xsl:with-param name="title" select="b:Type"/>
				<xsl:with-param name="plainText" select="b:Text"/>
			</xsl:call-template>
		</xsl:for-each>

		<!-- 付加情報部 -->
		<xsl:for-each select="jmx:Report/b:Body/b:MeteorologicalInfos[@type='付加情報']/b:MeteorologicalInfo/b:Item/b:Kind/b:Property">
			<xsl:call-template name="PlainText">
				<xsl:with-param name="title" select="b:Type"/>
				<xsl:with-param name="plainText" select="b:Text"/>
			</xsl:call-template>
		</xsl:for-each>
		</body>
		</html>
</xsl:template>

<!-- 実況値出力を呼び出す -->
<xsl:template name="Observation">
	<xsl:param name="timeId"/>
	<xsl:for-each select="../../b:Item"> <!-- TimeSeriesInfoから呼ばれる場合 -->
		<xsl:call-template name="ObservationOutput">
			<xsl:with-param name="timeId" select="$timeId"/>
		</xsl:call-template>
	</xsl:for-each>
	<xsl:for-each select="b:Item"> <!-- MeteorologicalInfoから呼ばれる場合 -->
		<xsl:call-template name="ObservationOutput">
			<xsl:with-param name="timeId" select="$timeId"/>
		</xsl:call-template>
	</xsl:for-each>
</xsl:template>

<!-- 実況値出力 -->
<xsl:template name="ObservationOutput">
	<xsl:param name="timeId"/>
	<xsl:choose>
	<xsl:when test="b:Kind[1]/b:Property[1]/b:Text">
		<!-- Text要素が含まれるItem部 -->
		<!-- 解説を出力 -->
		<xsl:if test="b:Kind[1]/b:Property[1]/b:Text[@type='解説']/text()">
			<xsl:call-template name="InsertBlank">
				<xsl:with-param name="value" select="b:Kind[1]/b:Property[1]/b:Text[@type='解説']/text()"/>
			</xsl:call-template>
			<br/><br/>
		</xsl:if>
		<!-- 時系列解説/本文/時系列補足としてrefIDが一致するものを出力 -->
		<xsl:if test="b:Kind[1]/b:Property[1]/b:Text[@refID=$timeId]/text()">
			<xsl:call-template name="InsertBlank">
				<xsl:with-param name="value" select="b:Kind[1]/b:Property[1]/b:Text[@refID=$timeId]/text()"/>
			</xsl:call-template>
			<br/>
		</xsl:if>
		<!-- (refID属性を持たない)本文を出力 Ver.1.0_3-->
		<xsl:if test="b:Kind[1]/b:Property[1]/b:Text[@type='本文' and $timeId=0]/text()">
			<xsl:call-template name="InsertBlank">
				<xsl:with-param name="value" select="./b:Kind[1]/b:Property[1]/b:Text[@type='本文']/text()" />
			</xsl:call-template>
			<br/>
		</xsl:if>
		<!-- 補足を出力 -->
		<xsl:if test="b:Kind[1]/b:Property[1]/b:Text[@type='補足']/text()">
			<xsl:call-template name="InsertBlank">
				<xsl:with-param name="value" select="b:Kind[1]/b:Property[1]/b:Text[@type='補足']/text()"/>
			</xsl:call-template>
			<br/>
		</xsl:if>
	</xsl:when>
	<xsl:otherwise>
		<!-- Text要素でない場合は実況値を出力 -->
		<xsl:choose>
		<!-- 実況値のうち特殊なものは特殊処理 -->
		<xsl:when test="b:Kind/b:Property/b:WindDirectionPart or b:Kind/b:Property/b:WindSpeedPart or b:Kind/b:Property/b:WindPart">
			<!-- 風処理 -->
			<xsl:if test=".//*[(@refID=$timeId or $timeId=0) and .=text()]">
				<xsl:call-template name="AreaStationName"/>
				<xsl:for-each select="b:Kind/b:Property//jmx_eb:WindSpeed[(@refID=$timeId or $timeId=0)]">
				<br/>
				<xsl:text>　</xsl:text>
					<xsl:call-template name="FixedLength">
						<xsl:with-param name="text" select="@type"/>
						<xsl:with-param name="length">7</xsl:with-param>
					</xsl:call-template>
					<xsl:choose>
					<xsl:when test="../b:Sentence">
						<xsl:value-of select="../b:Sentence" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@description" />
						<xsl:text>　</xsl:text>
						<xsl:call-template name="FixedLength">
							<xsl:with-param name="text" select="../jmx_eb:WindDirection/@description"/>
							<xsl:with-param name="length">4</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="OutputWithPrePost">
							<xsl:with-param name="outText">
								<xsl:call-template name="DateTimeOutput">
									<xsl:with-param name="tmpDateTime" select="../b:Time"/>
									<xsl:with-param name="format">DHM</xsl:with-param>
								</xsl:call-template>
								<xsl:text>　</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="OutputWithPrePost">
							<xsl:with-param name="outText" select="../b:Remark"/>
							<xsl:with-param name="preText">　※</xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			<br/>
			</xsl:if>
		</xsl:when>
		<xsl:otherwise>
			<!-- 実況値の一般処理 -->
			<xsl:if test=".//*[(@refID=$timeId or $timeId=0) and .=text()]">
				<xsl:call-template name="AreaStationName"/>
				<xsl:text>　</xsl:text>
				<xsl:choose>
				<xsl:when test="b:Kind/b:Property//*[(@refID=$timeId or $timeId=0)]/../b:Sentence">
					<!--実況値の文章形式表現を出力 -->
					<xsl:value-of select="b:Kind/b:Property//*[(@refID=$timeId or $timeId=0)]/../b:Sentence" />
				</xsl:when>
				<xsl:otherwise>
					<!-- 実況値の文字列表現を出力 -->
					<xsl:for-each select="b:Kind/b:Property//*[(@refID=$timeId or $timeId=0)]">
						<xsl:call-template name="OutputWithPrePost">
							<xsl:with-param name="outText">
								<xsl:value-of select="./@description"/> <!-- 要素の種別 （<xsl:value-of select="./@type"/>） -->
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
					<!-- 実況値の起時があれば出力 -->
					<xsl:call-template name="OutputWithPrePost">
						<xsl:with-param name="outText" >
							<xsl:call-template name="DateTimeOutput">
								<xsl:with-param name="tmpDateTime" select="b:Kind/b:Property//*[(@refID=$timeId or $timeId=0)]/../b:Time"/>
								<xsl:with-param name="format">DHM</xsl:with-param>
							</xsl:call-template>
						</xsl:with-param>
						<xsl:with-param name="preText">（起時：</xsl:with-param>
						<xsl:with-param name="postText">）</xsl:with-param>
					</xsl:call-template>
					<!-- 実況値の注意事項・付加事項があれば出力 -->
					<xsl:call-template name="OutputWithPrePost">
						<xsl:with-param name="outText" select="b:Kind/b:Property//*[(@refID=$timeId or $timeId=0)]/../b:Remark"/>
						<xsl:with-param name="preText">　※</xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
				</xsl:choose>
			<br/>
			</xsl:if>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- 量予想を時間順に出力する -->
<xsl:template name="PredictionTimeSeries">
	<xsl:param name="timeId"/>
	<xsl:param name="timeText"/>
	<xsl:for-each select="../../b:Item">
		<xsl:choose>
		<xsl:when test="b:Kind[1]/b:Property[1]/b:Text[@refID=$timeId]">
			<!-- 時系列解説としてrefIDが一致するものを出力 -->
			<xsl:choose>
			<xsl:when test="b:Kind[1]/b:Property[1]/b:Text[@refID=$timeId]/text()">
				<xsl:value-of select="b:Kind[1]/b:Property[1]/b:Text[@refID=$timeId]/text()" /><br/>
			</xsl:when>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<!-- そうでない場合は予想値を出力 -->
			<xsl:choose>
			<!-- 予想値のうち特殊なものは特殊処理 -->
			<xsl:when test="b:Kind/b:Property/b:WindDirectionPart or b:Kind/b:Property/b:WindSpeedPart or b:Kind/b:Property/b:WindPart">
				<!-- 風処理 -->
				<xsl:if test=".//*[@refID=$timeId]/text()">
					<xsl:call-template name="AreaStationName"/>
					<xsl:choose>
					<xsl:when test=".//*[(@refID=$timeId or $timeId=0)]/../b:Sentence">
						<xsl:value-of select=".//*[(@refID=$timeId or $timeId=0)]/../b:Sentence" />
					</xsl:when>
					<xsl:otherwise>
						<!-- 風向処理 -->
						<xsl:value-of select="b:Kind/b:Property/*/b:Base/b:Local/jmx_eb:WindDirection[@refID=$timeId]/@description" />
						<xsl:value-of select="b:Kind/b:Property/*/b:Base/jmx_eb:WindDirection[@refID=$timeId]/@description" />
						<xsl:if test="b:Kind/b:Property/*/b:Becoming[1]//jmx_eb:WindDirection[@refID=$timeId]/text()">
							<xsl:value-of select="b:Kind/b:Property/*/b:Becoming[1]/b:TimeModifier" />
							<xsl:value-of select="b:Kind/b:Property/*/b:Becoming[1]/b:Local/jmx_eb:WindDirection[@refID=$timeId]/@description" />
							<xsl:value-of select="b:Kind/b:Property/*/b:Becoming[1]/jmx_eb:WindDirection[@refID=$timeId]/@description" />
						</xsl:if>
						<xsl:if test="b:Kind/b:Property//jmx_eb:WindDirection[@refID=$timeId]/text()" >
							<xsl:text>　</xsl:text>
						</xsl:if>
						<!-- 風速処理 -->
						<xsl:value-of select="b:Kind/b:Property//jmx_eb:WindSpeed[@refID=$timeId and @type='最大風速']/@description" />
						<xsl:call-template name="OutputWithPrePost">
							<xsl:with-param name="outText" select=".//jmx_eb:WindSpeed[@refID=$timeId and @type='最大瞬間風速']/@description"/>
							<xsl:with-param name="preText">（</xsl:with-param>
							<xsl:with-param name="postText">）</xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
					</xsl:choose>
					<br/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<!-- 予想値の一般処理 -->
				<xsl:if test=".//*[@refID=$timeId and(@description or (@condition!='' and @condition!='値なし'))]">
					<!-- 気象要素値と@refIDが同じ要素の場合 -->
					<xsl:call-template name="AreaStationName"/>
					<xsl:choose>
					<xsl:when test=".//*[(@refID=$timeId or $timeId=0)]/../b:Sentence">
						<!--予想値の文章形式表現を出力 -->
						<xsl:value-of select=".//*[(@refID=$timeId or $timeId=0)]/../b:Sentence" />
					</xsl:when>
					<xsl:otherwise>
						<!--予想値の文字列表現を出力 -->
						<xsl:for-each select="b:Kind/b:Property//*[@refID=$timeId]">
							<xsl:call-template name="OutputWithPrePost">
								<xsl:with-param name="outText">
									<xsl:value-of select="./@description"/> <!-- 要素の種別 （<xsl:value-of select="./@type"/>） -->
								</xsl:with-param>
								<xsl:with-param name="postText">　</xsl:with-param>
							</xsl:call-template>
						</xsl:for-each>
					</xsl:otherwise>
					</xsl:choose>
				<br/>
				</xsl:if>
				<xsl:choose>
				<xsl:when test=".//*[@refID=$timeId]/b:Sentence">
					<!-- 表示用Sentence要素が@refID要素の子要素の場合 -->
					<xsl:call-template name="AreaStationName"/>
					<!--予想値の文章形式表現を出力 -->
					<xsl:for-each select="b:Kind/b:Property//*[@refID=$timeId]/b:Sentence">
						<xsl:value-of select="." />
						<xsl:text>　</xsl:text>
					</xsl:for-each>
					<br/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test=".//*[@refID=$timeId]/*[(@description or (@condition!='' and @condition!='値なし'))]">
						<!-- 気象要素値が@refID要素の子要素の場合 -->
						<xsl:call-template name="AreaStationName"/>
						<xsl:for-each select="b:Kind/b:Property//*[@refID=$timeId]/*[@description or @condition]">
							<!-- 予想値の起時があれば出力 -->
							<xsl:call-template name="DateTimeOutput">
								<xsl:with-param name="tmpDateTime" select="../b:Time"/>
								<xsl:with-param name="format">DHM</xsl:with-param>
							</xsl:call-template>
							<xsl:text>　</xsl:text>
							<!--予想値の文字列表現を出力 -->
							<xsl:value-of select="./@description" />
							<xsl:text>　</xsl:text> <!-- 要素の種別 （<xsl:value-of select="./@type"/>） -->
						</xsl:for-each>
						<br/>
					</xsl:if>
				</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
</xsl:template>

<!-- 時間連続要素を時系列優先出力する -->
<xsl:template match="b:Item" mode="SequenceByArea">
	<xsl:variable name="itemNum" select="position()"/>
	<xsl:choose>
	<xsl:when test="b:Kind[1]/b:Property[1]/b:Text">
		<!-- Text要素が含まれる場合は1つ目だけを代表で出力 -->
		<xsl:if test="b:Kind[1]/b:Property[1]/b:Text[@type='気象要素' or @type='解説' or @type='補足']/text()"> <!-- Ver1.0_3 -->
			<xsl:call-template name="InsertBlank">
				<xsl:with-param name="value" select="b:Kind[1]/b:Property[1]/b:Text[@type='気象要素' or @type='解説' or @type='補足']/text()"/> <!-- Ver1.0_3 -->
			</xsl:call-template>
			<br/><br/>
		</xsl:if>
	</xsl:when>
	<xsl:otherwise>
		<!-- 予想値の一般処理 -->
		<xsl:call-template name="AreaStationName"/>
		<br/>
		<xsl:for-each select="../b:TimeDefines/b:TimeDefine">
			<xsl:variable name="timeNum" select="position()"/>
			<xsl:if test="../../b:Item[$itemNum]/b:Kind/b:Property//b:Sequence[@refID=$timeNum]/*[@description or @condition]"> <!-- Ver1.0_3 -->
				<xsl:value-of select="b:Name" />
				<xsl:text>　</xsl:text>
			<xsl:for-each select="../../b:Item[$itemNum]/b:Kind/b:Property//b:Sequence[@refID=$timeNum]/*[@description or @condition]">
				<xsl:choose>
				<xsl:when test="../b:Sentence/text()">
					<!--予想値の文章形式表現を出力 -->
					<xsl:value-of select="../b:Sentence" />
					<xsl:text>　</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<!-- 予想値の起時があれば出力 -->
					<xsl:call-template name="DateTimeOutput">
						<xsl:with-param name="tmpDateTime" select="../b:Time"/>
						<xsl:with-param name="format">DHM</xsl:with-param>
					</xsl:call-template>
					<xsl:text>　</xsl:text>
					<xsl:value-of select="./@description" />
					<xsl:text>　</xsl:text> <!-- 要素の種別（<xsl:value-of select="./@type"/>） -->
				</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			<br/>
			</xsl:if> <!-- Ver1.0_3 -->
		</xsl:for-each>
		<br/>
	</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- 共通テンプレート -->
<!-- 地域地点名出力テンプレート -->
<xsl:template name="AreaStationName">
	<!-- 地域の場合 -->
	<xsl:if test="b:Area/b:Name">
		<xsl:value-of select="b:Area/b:Name" />
		<!-- 一致する細分区のコード <xsl:value-of select="b:Area/b:Code" /> -->
		<!-- 範囲を含む細分区のコードリスト <xsl:value-of select="b:Area/b:CodeList" /> -->
		<xsl:call-template name="OutputWithPrePost">
			<xsl:with-param name="outText" select="b:Area/b:Status"/>
			<xsl:with-param name="preText">（</xsl:with-param>
			<xsl:with-param name="postText">）</xsl:with-param>
		</xsl:call-template>
		<xsl:text>　</xsl:text>
	</xsl:if>
	<!-- 地点の場合 -->
	<xsl:if test="b:Station/b:Name">
		<xsl:value-of select="b:Station/b:Name" />
		<!-- 対象地点のコード <xsl:value-of select="b:Station/b:Code" /> -->
		<xsl:call-template name="OutputWithPrePost">
			<xsl:with-param name="outText" select="b:Station/b:Status"/>
			<xsl:with-param name="preText">（</xsl:with-param>
			<xsl:with-param name="postText">）</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="OutputWithPrePost">
			<xsl:with-param name="outText" select="b:Station/b:Location"/>
			<xsl:with-param name="preText">（</xsl:with-param>
			<xsl:with-param name="postText">）</xsl:with-param>
		</xsl:call-template>
	</xsl:if>
</xsl:template>

<!-- 文字列の整形出力テンプレート -->
<xsl:template name="OutputWithPrePost" >
	<xsl:param name="outText"/>
	<xsl:param name="postText"/>
	<xsl:param name="preText"/>
	<xsl:param name="newLine"/>
	<!-- 文字列がない場合は何も出力しない -->
	<xsl:if test="$outText and not($outText='')">
		<xsl:value-of select="$preText" />
		<xsl:value-of select="$outText" />
		<xsl:value-of select="$postText" />
		<xsl:if test="$newLine='true'"><br/></xsl:if>
	</xsl:if>
</xsl:template>

<!-- 本文の平文部分を出力するテンプレート -->
<xsl:template name="PlainText">
	<xsl:param name="title"/>
	<xsl:param name="plainText"/>
	<h3>［<xsl:value-of select="$title" />］</h3>
	<p>
	<xsl:call-template name="InsertBlank">
		<xsl:with-param name="value" select="$plainText"/>
	</xsl:call-template>
	</p>
</xsl:template>

<!-- 固定長文字列出力テンプレート（空白パディング） -->
<xsl:template name="FixedLength">
	<xsl:param name="text"/>
	<xsl:param name="length"/>
	<xsl:value-of select="concat($text,substring('　　　　　　　　　　　　　　　　　',1,$length - string-length($text)))" />
</xsl:template>

<!-- 年月日分を整形出力するテンプレート -->
<xsl:template name="DateTimeOutput">
	<xsl:param name="tmpDateTime"/>
	<xsl:param name="format"/>
	<!-- 日時分フォーマット指定がない場合は年月を出力 -->
	<xsl:if test="$format != 'DHM'">
		<xsl:text>令和</xsl:text>
		<xsl:choose>
			<xsl:when test="substring($tmpDateTime,1,4)='2019'"><xsl:text>元</xsl:text></xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="number(substring($tmpDateTime,1,4)) - 2018"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>年</xsl:text>
		<xsl:value-of select="substring($tmpDateTime,6,2)"/>
		<xsl:text>月</xsl:text>
	</xsl:if>
	<xsl:value-of select="substring($tmpDateTime,9,2)"/>
	<xsl:text>日</xsl:text>
	<xsl:value-of select="substring($tmpDateTime,12,2)"/>
	<xsl:text>時</xsl:text>
	<xsl:value-of select="substring($tmpDateTime,15,2)"/>
	<xsl:text>分</xsl:text>
</xsl:template>

<!-- 改行コードを<br/>に置き換えるテンプレート -->
<xsl:template name="InsertBlank">
	<xsl:param name="value"/>
	<xsl:choose>
	<xsl:when test="contains($value, '&#xA;')">
		<!--	<xsl:value-of select="concat('　', substring-before($value, '&#xA;'))"/>	-->
		<xsl:value-of select="substring-before($value, '&#xA;')"/>
		<xsl:call-template name="newLine"/>
		<xsl:call-template name="InsertBlank">
			<xsl:with-param name="value" select="substring-after($value, '&#xA;')"/>
		</xsl:call-template>
	</xsl:when>
	<xsl:otherwise>
		<xsl:value-of select="$value"/>
	</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- <br/>を出力するテンプレート -->
<xsl:template name="newLine"><br/></xsl:template>

</xsl:stylesheet>


