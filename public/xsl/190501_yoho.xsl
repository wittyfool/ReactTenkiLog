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
  府県天気予報、地域時系列予報

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
                <title>天気予報</title>
                <link
                    rel="stylesheet" type="text/css"
                    href="./style.css" />
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
            <h2>風・天気・波</h2>
            <table border="1">
                <tr>
                    <th></th>
                    <xsl:apply-templates
                        select="b:TimeDefines/b:TimeDefine" mode="name" />
                </tr>
                <xsl:apply-templates select="b:Item" mode="weather" />
            </table>
        </xsl:when>
        <xsl:when test="position()='2'">
            <h2>降水確率</h2>
            <table border="1">
                <tr>
                    <th></th>
                    <xsl:apply-templates
                        select="b:TimeDefines/b:TimeDefine" mode="name" />
                </tr>
                <xsl:apply-templates select="b:Item" mode="pop" />
            </table>
        </xsl:when>
        <xsl:when test="position()='3'">
            <h2>最高気温・最低気温</h2>
            <table border="1">
                <tr>
                    <th></th>
                    <xsl:apply-templates
                        select="b:TimeDefines/b:TimeDefine" mode="name" />
                </tr>
                <xsl:apply-templates select="b:Item" mode="temp" />
            </table>
        </xsl:when>
        <xsl:when test="position()='4'">
            <h2>３時間内代表風・３時間内卓越天気</h2>
            <table border="1">
                <tr>
                    <th></th>
                    <xsl:apply-templates
                        select="b:TimeDefines/b:TimeDefine" mode="time" />
                </tr>
                <xsl:apply-templates select="b:Item" mode="weather3h" />
            </table>
        </xsl:when>
        <xsl:when test="position()='5'">
            <h2>３時間毎気温</h2>
            <table border="1">
                <tr>
                    <th></th>
                    <xsl:apply-templates
                        select="b:TimeDefines/b:TimeDefine" mode="time" />
                </tr>
                <xsl:apply-templates select="b:Item" mode="temp3h" />
            </table>
        </xsl:when>
        </xsl:choose>
    </xsl:template>

<!-- 時刻行 -->

    <xsl:template match="b:TimeDefine" mode="name">
        <th><xsl:value-of select="b:Name" /></th>
    </xsl:template>

    <xsl:template match="b:TimeDefine" mode="time">
        <th><xsl:value-of select="substring(b:DateTime, 12, 2)" /></th>
    </xsl:template>

<!-- 風・天気・波 -->

    <xsl:template match="b:Item" mode="weather">
        <tr>
            <th><xsl:value-of select="b:Area/b:Name" /></th>
            <xsl:apply-templates
                select="b:Kind/b:Property/b:DetailForecast/
                    b:WeatherForecastPart" />
        </tr>
    </xsl:template>

    <xsl:template match="b:WeatherForecastPart">
        <xsl:param name="day" select="position()" />
        <td>
            <xsl:value-of
                select="../../../../b:Kind/b:Property/b:DetailForecast/
                    b:WindForecastPart[$day]/b:Sentence" /><br />
            <xsl:value-of select="b:Sentence" /> （
            <xsl:value-of
                select="../../b:WeatherCodePart/jmx_eb:WeatherCode[$day]" /> ：
            <xsl:value-of
                select="../../b:WeatherPart/jmx_eb:Weather[$day]" /> ）<br />
            <xsl:value-of
                select="../../../../b:Kind/b:Property/b:DetailForecast/
                    b:WaveHeightForecastPart[$day]/b:Sentence" /><br />
        </td>
    </xsl:template>

<!-- 降水確率 -->

    <xsl:template match="b:Item" mode="pop">
        <tr>
            <th><xsl:value-of select="b:Area/b:Name" /></th>
            <xsl:apply-templates
                select="b:Kind/b:Property/b:ProbabilityOfPrecipitationPart/
                    jmx_eb:ProbabilityOfPrecipitation" />
        </tr>
    </xsl:template>

    <xsl:template match="jmx_eb:ProbabilityOfPrecipitation">
        <td align="right">
            <xsl:value-of select="@condition" /> ： 
            <xsl:value-of select="." />%
        </td>
    </xsl:template>

<!-- 最高気温・最低気温 -->

    <xsl:template match="b:Item" mode="temp">
        <tr>
            <th><xsl:value-of select="b:Station/b:Name" /></th>
            <xsl:apply-templates
                select="b:Kind/b:Property/b:TemperaturePart/
                    jmx_eb:Temperature" />
        </tr>
    </xsl:template>

    <xsl:template match="jmx_eb:Temperature">
        <td align="right"><xsl:value-of select="." /></td>
    </xsl:template>

<!-- ３時間内代表風・３時間内卓越天気 -->

    <xsl:template match="b:Item" mode="weather3h">
        <tr>
            <th><xsl:value-of select="b:Area/b:Name" /></th>
            <xsl:apply-templates select="b:Kind/b:Property/b:WindDirectionPart/
                    jmx_eb:WindDirection" />
        </tr>
    </xsl:template>

    <xsl:template match="jmx_eb:WindDirection">
        <xsl:param name="time" select="position()" />
        <td>
            <xsl:value-of select="." />
            <xsl:value-of
                select="../../b:WindSpeedPart/b:WindSpeedLevel[$time]" /><br />
            <xsl:value-of
                select="../../../../b:Kind/b:Property/b:WeatherPart/
                    jmx_eb:Weather[$time]" /><br />
        </td>
    </xsl:template>

<!-- ３時間毎気温 -->

    <xsl:template match="b:Item" mode="temp3h">
        <tr>
            <th><xsl:value-of select="b:Station/b:Name" /></th>
            <xsl:apply-templates
                select="b:Kind/b:Property/b:TemperaturePart/
                    jmx_eb:Temperature" />
        </tr>
    </xsl:template>

<!-- 独自予報 -->

    <xsl:template match="b:MeteorologicalInfo">
        <h2>独自予報</h2>
        <table border="1">
            <xsl:apply-templates select="b:Item" mode="dokuji" />
        </table>
    </xsl:template>

    <xsl:template match="b:Item" mode="dokuji">
        <tr>
            <th><xsl:value-of select="b:Area/b:Name" /></th>
            <td>
                <pre><xsl:value-of select="b:Kind/b:Property/b:Text" /></pre>
            </td>
        </tr>
    </xsl:template>

</xsl:stylesheet>

