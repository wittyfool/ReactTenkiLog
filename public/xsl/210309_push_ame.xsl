<?xml version="1.0" encoding="UTF-8" ?>

<!--
  ======================================================================
  本スタイルシートは、気象庁防災情報XMLフォーマット形式電文中の全ての情
  報コンテンツを出力するもので、システム処理の動作確認など、電文処理の参
  考資料としてお使い下さい。

  なお、本スタイルシートについては、システムに直接組み込む等の方法でご利
  用になることは避けていただくなど、ご利用に当たっては十分に注意していた
  だきますよう、よろしくお願いいたします。

  Copyright (c) 気象庁 2019 All rights reserved.
  
  【対象情報】
   大雨危険度通知

  【更新履歴】
  2019年5月22日　Ver.1.0
  2019年6月25日　Ver.1.1 北海道地方及び奄美地方について、一次細分区別の
                         危険度からPrefecture値を削除
  2021年3月9日　Ver.1.2 Area[@codeType="政令指定都市"]の追加に伴う修正
                         
  ======================================================================
-->


<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:jmx="http://xml.kishou.go.jp/jmaxml1/" exclude-result-prefixes="jmx"
    xmlns:h="http://xml.kishou.go.jp/jmaxml1/informationBasis1/"
    xmlns:b="http://xml.kishou.go.jp/jmaxml1/body/meteorology1/"
    xmlns:jmx_eb="http://xml.kishou.go.jp/jmaxml1/elementBasis1/">

<!-- ルート -->

    <xsl:template match="/">
        <html>
            <head>
                <title>大雨危険度通知</title>
                <link
                    rel="stylesheet" type="text/css"
                    href="./style.css" />
            </head>
            <body>
                <xsl:apply-templates select="jmx:Report/h:Head" />
				<xsl:apply-templates select="jmx:Report/b:Body/b:MeteorologicalInfos/b:MeteorologicalInfo" />
                <xsl:apply-templates select="jmx:Report/b:Body/b:MeteorologicalInfos/b:TimeSeriesInfo" />
            </body>
        </html>
    </xsl:template>

<!-- ヘッダ -->

    <xsl:template match="jmx:Report/h:Head">
        <xsl:param name="date" select="h:ReportDateTime" />
        <h1><xsl:value-of select="h:Title" /></h1>
        <p>
            令和 
            <xsl:choose>
             <xsl:when test="substring($date,1,4)='2019'">元</xsl:when>
             <xsl:otherwise>
              <xsl:value-of select="substring($date, 1, 4) - 2018" />
             </xsl:otherwise>
            </xsl:choose> 年
            <xsl:value-of select="substring($date, 6, 2)" /> 月
            <xsl:value-of select="substring($date, 9, 2)" /> 日
            <xsl:value-of select="substring($date, 12, 2)" /> 時
            <xsl:value-of select="../jmx:Control/jmx:PublishingOffice" />発表
            <xsl:if test="contains(h:InfoType, '訂正')">
                （訂正）
            </xsl:if>
        </p>
				
    </xsl:template>

<!-- ボディ -->

<!-- 危険度一覧 -->
	<xsl:template match="b:MeteorologicalInfo">
		<table border="1">
		<xsl:if test="position()='1'">
			<span style="font-size:18pt; font-weigh:bold;">府県予報区別の危険度</span>
			<tr><th>府県予報区</th><th>大雨危険度</th><th>土砂災害危険度</th><th>浸水害危険度</th><th>洪水害危険度</th></tr>
		</xsl:if>
		<xsl:if test="position()='2'">
			<span style="font-size:18pt; font-weigh:bold;">府県予報区別の危険度分布</span>
			<tr><th>府県予報区</th><th>土砂災害危険度</th><th>浸水害危険度</th><th>洪水害危険度</th></tr>
		</xsl:if>
		<xsl:if test="position()='3'">
			<span style="font-size:18pt; font-weigh:bold;">一次細分区別の危険度</span>
			<tr><th>一次細分区</th><th>大雨危険度</th><th>土砂災害危険度</th><th>浸水害危険度</th><th>洪水害危険度</th></tr>
		</xsl:if>
		<xsl:if test="position()='4'">
			<span style="font-size:18pt; font-weigh:bold;">一次細分区別の危険度分布</span>
			<tr><th>一次細分区</th><th>土砂災害危険度</th><th>浸水害危険度</th><th>洪水害危険度</th></tr>
		</xsl:if>
		<xsl:if test="position()='5'">
			<span style="font-size:18pt; font-weigh:bold;">市町村等をまとめた地域別の危険度</span>
			<tr><th>市町村等をまとめた地域</th><th>大雨危険度</th><th>土砂災害危険度</th><th>浸水害危険度</th><th>洪水害危険度</th></tr>
		</xsl:if>
		<xsl:if test="position()='6'">
			<span style="font-size:18pt; font-weigh:bold;">市町村等をまとめた地域別の危険度分布</span>
			<tr><th>市町村等をまとめた地域</th><th>土砂災害危険度</th><th>浸水害危険度</th><th>洪水害危険度</th></tr>
		</xsl:if>
		<xsl:if test="position()='7'">
			<span style="font-size:18pt; font-weigh:bold;">二次細分区及びさらに詳細な区域別の危険度</span>
			<tr><th>二次細分区（又はさらに詳細な区域）</th><th>大雨危険度</th><th>土砂災害危険度</th><th>浸水害危険度</th><th>洪水害危険度</th></tr>
		</xsl:if>
		<xsl:if test="position()='8'">
			<span style="font-size:18pt; font-weigh:bold;">二次細分区及びさらに詳細な区域別の危険度分布</span>
			<tr><th>二次細分区（又はさらに詳細な区域）</th><th>土砂災害危険度</th><th>浸水害危険度</th><th>洪水害危険度</th></tr>
		</xsl:if>

	
		<xsl:for-each select="b:Item">
			<tr>
				<td>
					<xsl:choose>
						<xsl:when test="b:Area/@codeType='土砂災害警戒情報'">　　【土砂災害警戒情報】</xsl:when>
						<xsl:when test="b:Area/@codeType='政令指定都市'">　　【政令指定都市】</xsl:when>
					</xsl:choose>
					
					<xsl:choose>
						<xsl:when test="b:Area/b:PrefectureCode='011000'"><xsl:value-of select="b:Area/b:Name" /></xsl:when>
						<xsl:when test="b:Area/b:PrefectureCode='012000'"><xsl:value-of select="b:Area/b:Name" /></xsl:when>
						<xsl:when test="b:Area/b:PrefectureCode='013000'"><xsl:value-of select="b:Area/b:Name" /></xsl:when>
						<xsl:when test="b:Area/b:PrefectureCode='014100'"><xsl:value-of select="b:Area/b:Name" /></xsl:when>
						<xsl:when test="b:Area/b:PrefectureCode='014030'"><xsl:value-of select="b:Area/b:Name" /></xsl:when>
						<xsl:when test="b:Area/b:PrefectureCode='015000'"><xsl:value-of select="b:Area/b:Name" /></xsl:when>
						<xsl:when test="b:Area/b:PrefectureCode='016000'"><xsl:value-of select="b:Area/b:Name" /></xsl:when>
						<xsl:when test="b:Area/b:PrefectureCode='017000'"><xsl:value-of select="b:Area/b:Name" /></xsl:when>
						<xsl:when test="b:Area/b:PrefectureCode='460040'"><xsl:value-of select="b:Area/b:Name" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="b:Area/b:Prefecture" /><xsl:value-of select="b:Area/b:Name" /></xsl:otherwise>
					</xsl:choose>
				</td>
			
			<xsl:if test="(b:Kind/b:Property/b:Type='危険度') and (b:Area/@codeType='土砂災害警戒情報')"><td></td></xsl:if>
			<xsl:for-each select="b:Kind/b:Property/b:SignificancyPart/b:Base/b:Significancy">
				<td><xsl:value-of select="b:Name" /></td>
			</xsl:for-each>
			
			</tr>
			
			
			
		</xsl:for-each>
		</table>
		<br/>
	</xsl:template>

</xsl:stylesheet>
