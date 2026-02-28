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
  府県週間天気予報

  【更新履歴】
  2012年03月29日　Ver.1.0
  2019年04月24日　Ver.1.1 5月1日より施行される新元号への対応
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
                <title>週間天気予報</title>
                <link
                    rel="stylesheet" type="text/css"
                    href="style.css" />
            </head>
            <body>
                <xsl:apply-templates select="jmx:Report/h:Head" />
                <xsl:apply-templates
                    select="jmx:Report/b:Body/b:MeteorologicalInfos/
                        b:TimeSeriesInfo" />
                <xsl:apply-templates
                    select="jmx:Report/b:Body/b:MeteorologicalInfos/
                        b:MeteorologicalInfo" />
            </body>
        </html>
    </xsl:template>

<!-- ヘッダ -->

    <xsl:template match="jmx:Report/h:Head">
        <xsl:param name="date" select="h:ReportDateTime" />
        <h1><xsl:value-of select="h:Title" /></h1>
        <p align="right">
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

    <xsl:template match="b:TimeSeriesInfo">
        <xsl:choose>
        <xsl:when test="position()='1'">
            <h2>天気（テロップ）・降水確率・信頼度（ A - C ）</h2>
            <table border="1">
                <tr>
                    <th></th>
                    <xsl:apply-templates select="b:TimeDefines/b:TimeDefine" />
                </tr>
                <xsl:apply-templates select="b:Item" mode="weather" />
            </table>
        </xsl:when>
        <xsl:when test="position()='2'">
            <h2>最低最高気温（予測範囲）</h2>
            <table border="1">
                <tr>
                    <th></th>
                    <xsl:apply-templates select="b:TimeDefines/b:TimeDefine" />
                </tr>
                <xsl:apply-templates select="b:Item" mode="temp" />
            </table>
        </xsl:when>
        <xsl:when test="position()='3'">
            <h2>最低最高気温平年値</h2>
            <table border="1">
                <tr>
                    <th></th>
                    <xsl:apply-templates select="b:TimeDefines/b:TimeDefine" />
                </tr>
                <xsl:apply-templates select="b:Item" mode="average" />
            </table>
        </xsl:when>
        </xsl:choose>
    </xsl:template>

<!-- 時刻行 -->

    <xsl:template match="b:TimeDefine">
        <th><xsl:value-of select="substring(b:DateTime, 9, 2)" /> 日</th>
    </xsl:template>

<!-- 天気・降水確率・信頼度 -->

    <xsl:template match="b:Item" mode="weather">
        <tr>
            <th><xsl:value-of select="b:Area/b:Name" /></th>
            <xsl:apply-templates
                select="b:Kind/b:Property/b:WeatherPart/jmx_eb:Weather" />
        </tr>
    </xsl:template>

    <xsl:template match="jmx_eb:Weather">
        <xsl:param name="day" select="position()" />
        <td align="center">
            <xsl:value-of select="." /><br /> （
            <xsl:value-of
                select="../../b:WeatherCodePart/
                    jmx_eb:WeatherCode[$day]" /> ）<br />
            <xsl:value-of
                select="../../../../b:Kind/b:Property/
                    b:ProbabilityOfPrecipitationPart/
                    jmx_eb:ProbabilityOfPrecipitation[$day]" /> % 
            <xsl:value-of
                select="../../../../b:Kind/b:Property/
                    b:ReliabilityClassPart/
                    jmx_eb:ReliabilityClass[$day]" /><br />
        </td>
    </xsl:template>

<!-- 最低最高気温 -->

    <xsl:template match="b:Item" mode="temp">
        <tr>
            <th><xsl:value-of select="b:Station/b:Name" /></th>
            <xsl:apply-templates
                select="b:Kind/b:Property[1]/b:TemperaturePart/
                    jmx_eb:Temperature" mode="temp"/>
        </tr>
    </xsl:template>

    <xsl:template match="jmx_eb:Temperature" mode="temp">
        <xsl:param name="day" select="position()" />
        <td align="center">

			<xsl:choose>

			<xsl:when test="contains(@description,'度')">
            最低
            <xsl:value-of select="." />（
            <xsl:value-of
                select="../../../b:Property[3]/b:TemperaturePart/
                    jmx_eb:Temperature[$day]" /> から
            <xsl:value-of
                select="../../../b:Property[2]/b:TemperaturePart/
                    jmx_eb:Temperature[$day]" /> ）<br />
            最高
            <xsl:value-of
                select="../../../b:Property[4]/b:TemperaturePart/
                    jmx_eb:Temperature[$day]" /> （
            <xsl:value-of
                select="../../../b:Property[6]/b:TemperaturePart/
                    jmx_eb:Temperature[$day]" /> から
            <xsl:value-of
                select="../../../b:Property[5]/b:TemperaturePart/
                    jmx_eb:Temperature[$day]" /> ）<br />

			</xsl:when>

			<xsl:otherwise>
				<xsl:text>　</xsl:text>
			</xsl:otherwise>
			
			</xsl:choose>

        </td>
    </xsl:template>

<!-- 最低最高気温平年値 -->

    <xsl:template match="b:Item" mode="average">
        <tr>
            <th><xsl:value-of select="b:Station/b:Name" /></th>
            <xsl:apply-templates
                select="b:Kind/b:Property[1]/b:TemperaturePart/
                    jmx_eb:Temperature" mode="average"/>
        </tr>
    </xsl:template>

    <xsl:template match="jmx_eb:Temperature" mode="average">
        <xsl:param name="day" select="position()" />
        <td align="center">
            最低
            <xsl:value-of select="." /><br />
            最高
            <xsl:value-of
                select="../../../b:Property[2]/b:TemperaturePart/
                    jmx_eb:Temperature[$day]" /><br />
        </td>
    </xsl:template>

<!-- 降水量７日間合計階級閾値 -->

    <xsl:template match="b:MeteorologicalInfo">
        <h2>降水量７日間合計階級閾値</h2>
        <table border="1">
            <tr>
                <th></th>
                <th>最小値</th>
                <th>かなり少ない</th>
                <th>少ない</th>
                <th>多い</th>
                <th>かなり多い</th>
                <th>最大値</th>
            </tr>
            <xsl:apply-templates select="b:Item" mode="average7" />
        </table>
    </xsl:template>

    <xsl:template match="b:Item" mode="average7">
        <tr>
            <th><xsl:value-of select="b:Station/b:Name" /></th>
            <td align="right"><xsl:value-of
                select="b:Kind/b:Property/b:PrecipitationClassPart/
                    jmx_eb:ThresholdOfMinimum" /></td>
            <td align="right"><xsl:value-of
                select="b:Kind/b:Property/b:PrecipitationClassPart/
                    jmx_eb:ThresholdOfSignificantlyBelowNormal" /></td>
            <td align="right"><xsl:value-of
                select="b:Kind/b:Property/b:PrecipitationClassPart/
                    jmx_eb:ThresholdOfBelowNormal" /></td>
            <td align="right"><xsl:value-of
                select="b:Kind/b:Property/b:PrecipitationClassPart/
                    jmx_eb:ThresholdOfAboveNormal" /></td>
            <td align="right"><xsl:value-of
                select="b:Kind/b:Property/b:PrecipitationClassPart/
                    jmx_eb:ThresholdOfSignificantlyAboveNormal" /></td>
            <td align="right"><xsl:value-of
                select="b:Kind/b:Property/b:PrecipitationClassPart/
                    jmx_eb:ThresholdOfMaximum" /></td>
        </tr>
    </xsl:template>

</xsl:stylesheet>

