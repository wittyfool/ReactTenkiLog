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
   警報級の可能性（明日まで）

  【更新履歴】
  2015年09月16日　Ver.1.0
  2019年04月24日　Ver.1.1 5月1日より施行される新元号への対応
  2019年05月29日　ver.1.2 警戒レベルへの対応
  2022年08月31日　ver.1.3 高潮の早期注意情報の運用開始への対応
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
                <title>早期注意情報（警報級の可能性）（明日まで）</title>
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
        <h1>
        <!-- 警戒レベル化 -->
        	<xsl:value-of select="translate(h:Title, '警報級の可能性（明日まで）', '')" />早期注意情報
        	（<xsl:value-of select="translate(h:InfoKind, '（明日まで）', '')" />）
        	<xsl:value-of select="translate(h:InfoKind, '警報級の可能性', '')" />
        </h1>
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

<!-- 日降水量・日降雪量 -->
	<xsl:template match="b:MeteorologicalInfo">

		<xsl:for-each select="b:Item">
		<table border="1">
			<tr>
				<th><xsl:value-of select="b:Area/b:Name" /></th>
				<th><xsl:value-of select="../b:Name" /></th>
			</tr>
		
			<xsl:for-each select="b:Kind/b:Property">
			<tr>		
				<td><xsl:value-of select="b:Type" /></td>
				
				<xsl:if test="b:DetailForecast/b:PrecipitationForecastPart/b:Sentence">
					<td><xsl:value-of select="b:DetailForecast/b:PrecipitationForecastPart/b:Sentence" /></td>
				</xsl:if>

				<xsl:if test="b:DetailForecast/b:SnowfallDepthForecastPart/b:Sentence">
					<td><xsl:value-of select="b:DetailForecast/b:SnowfallDepthForecastPart/b:Sentence" /></td>
				</xsl:if>

				</tr>
			</xsl:for-each>
			
		</table>
		</xsl:for-each>

	</xsl:template>
	
    <xsl:template match="b:TimeSeriesInfo">

		<xsl:if test="position()='1'">
			<xsl:for-each select="b:Item">
			<table border="1">
                <tr>
                    <th><xsl:value-of select="b:Area/b:Name" /></th>
                    <xsl:apply-templates select="../b:TimeDefines/b:TimeDefine"/>
                </tr>
				<xsl:apply-templates select="b:Kind" mode="detail" />
			</table>			
			</xsl:for-each>	
		</xsl:if>

		<xsl:if test="position()='2'">
			<xsl:for-each select="b:Item">
			<table border="1">
                <tr>
                    <th><xsl:value-of select="b:Area/b:Name" /></th>
                    <xsl:apply-templates select="../b:TimeDefines/b:TimeDefine"/>
                </tr>
				<xsl:apply-templates select="b:Kind" mode="possible" />
			</table>			
			</xsl:for-each>	
			<xsl:call-template name="WarningLevel_temp"/>
		</xsl:if>		
		
		
		</xsl:template>

<!-- 日時 -->

    <xsl:template match="b:TimeDefine">
        <th><xsl:value-of select="b:Name" /></th>
    </xsl:template>


	
	
	
<!-- 量的予報 -->

    <xsl:template match="b:Kind" mode="detail" >
		<tr>
		<th>
			<xsl:value-of select="b:Property/b:Type" />
		</th>
		
		<xsl:for-each select="b:Property/b:DetailForecast/b:PrecipitationForecastPart">
			<td><xsl:value-of select="b:Sentence"/></td>
		</xsl:for-each>

		<xsl:for-each select="b:Property/b:DetailForecast/b:SnowfallDepthForecastPart">
			<td><xsl:value-of select="b:Sentence"/></td>
		</xsl:for-each>
		
		<xsl:for-each select="b:Property/b:DetailForecast/b:WindForecastPart">
			<td><xsl:value-of select="b:Sentence"/></td>
		</xsl:for-each>

		<xsl:for-each select="b:Property/b:DetailForecast/b:WaveHeightForecastPart">
			<td><xsl:value-of select="b:Sentence"/></td>
		</xsl:for-each>
		
		</tr>
    </xsl:template>	
	
	
<!-- 警報級の可能性 -->

    <xsl:template match="b:Kind" mode="possible" >
		<tr>
		
		
		<xsl:variable name="txt" select="b:Property/b:Text" />
		<xsl:if test="string-length($txt) &gt; 0 ">
			<th>
				<xsl:value-of select="b:Property/b:Type" /><br/>
				（
			<!--警戒レベル表示（雨と潮位の警報級の可能性が期間内に中以上が存在する場合は警戒レベル1に相当する）-->
				<xsl:choose>
					<xsl:when test="b:Property/b:Type='雨の警報級の可能性'">
						<xsl:if test="b:Property/b:PossibilityRankOfWarningPart/jmx_eb:PossibilityRankOfWarning='高' or 
							b:Property/b:PossibilityRankOfWarningPart/jmx_eb:PossibilityRankOfWarning='中'">
						【警戒レベル1】
						</xsl:if>
					
					</xsl:when>
					<xsl:when test="b:Property/b:Type='潮位の警報級の可能性'">
						<xsl:if test="b:Property/b:PossibilityRankOfWarningPart/jmx_eb:PossibilityRankOfWarning='高' or 
							b:Property/b:PossibilityRankOfWarningPart/jmx_eb:PossibilityRankOfWarning='中'">
						【警戒レベル1】
						</xsl:if>
					</xsl:when>
				</xsl:choose>
				
				<xsl:value-of select="$txt" />）
			</th>
		</xsl:if>
		
		<xsl:if test="string-length($txt) = 0 ">
			<th>
				<xsl:value-of select="b:Property/b:Type" />
			</th>
		</xsl:if>		
		
		<xsl:for-each select="b:Property/b:PossibilityRankOfWarningPart/jmx_eb:PossibilityRankOfWarning">
			<xsl:variable name="val" select="." />
			<td>
				<xsl:if test="string-length($val) &gt; 0 " >	<!--通常-->
					<xsl:value-of select="$val" />
				</xsl:if>
			
				<xsl:if test="string-length($val) = 0 " >		<!--高潮-->
					<xsl:value-of select="./@condition" />
				</xsl:if>			
			</td>
		</xsl:for-each>
		
		</tr>
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
<xsl:template name="WarningLevel_temp">大雨又は高潮の早期注意情報（警報級の可能性）は、災害への心構えを高める必要があることを示す警戒レベル１です。<BR/></xsl:template>

</xsl:stylesheet>




























