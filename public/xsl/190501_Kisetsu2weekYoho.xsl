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
  ２週間気温予報

  【更新履歴】
  2018年10月31日　Ver.1.0
  2019年04月24日　Ver.1.1 5月1日より施行される新元号への対応
  ======================================================================
-->


<!-- 名前空間の指定 気象庁使用の名前空間 -->
<xsl:stylesheet
  xmlns:jmx="http://xml.kishou.go.jp/jmaxml1/"
  xmlns:jmx_ib="http://xml.kishou.go.jp/jmaxml1/informationBasis1/"
  xmlns:jmx_eb="http://xml.kishou.go.jp/jmaxml1/elementBasis1/"
  xmlns:jmx_mete="http://xml.kishou.go.jp/jmaxml1/body/meteorology1/"
  xmlns:jmx_add="http://xml.kishou.go.jp/jmaxml1/addition1/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0">

<!-- 出力文字コード -->
	<xsl:output method="html" indent="no" encoding="UTF-8"/>

<!-- メイン -->
	<xsl:template match="/">
		<html><head></head><body>
		<xsl:apply-templates select="jmx:Report" />
		<xsl:apply-templates select="jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos" />
		</body></html>
	</xsl:template>
<!-- メイン -->

<!-- 発表日等の表示 -->
	<xsl:template match="jmx:Report">

		<xsl:value-of select="jmx_ib:Head/jmx_ib:Title" />
		<br/>

		<xsl:call-template name="yohokikan2" />
		<br/>

		<xsl:call-template name="hiduke" />

		<br/>
		<xsl:value-of select="jmx:Control/jmx:PublishingOffice"/><xsl:text>発表</xsl:text>

		<xsl:if test="contains(jmx_ib:Head/jmx_ib:InfoType,'訂正')">
			<xsl:text>（訂正）</xsl:text>
		</xsl:if>

	</xsl:template>
<!-- 発表日等の表示 -->

<!-- 予報の表示 -->
	<xsl:template match="jmx_mete:MeteorologicalInfos">
		<xsl:choose>
			<xsl:when test="position()='1'">
				<h3>各地域の平均気温の平年差階級</h3>
				<table border="1">
					<tr>
						<th></th>
						<xsl:apply-templates select="jmx_mete:TimeSeriesInfo/jmx_mete:TimeDefines/jmx_mete:TimeDefine" />
					</tr>
					<xsl:apply-templates select="jmx_mete:TimeSeriesInfo/jmx_mete:Item" mode="area_yoho" />
				</table>
			</xsl:when>
			<xsl:when test="position()='2'">
				<h3>主な地点の最高・最低気温と平年差階級（括弧内は気温の予測範囲）</h3>
				<xsl:apply-templates select="jmx_mete:TimeSeriesInfo/jmx_mete:Item" mode="point_yoho" />
			</xsl:when>
		</xsl:choose>
	</xsl:template>
<!-- 予報の表示 -->

<!-- 時刻行 -->
	<xsl:template match="jmx_mete:TimeDefine">

		<xsl:variable name="dateTime" select="jmx_mete:DateTime" />
		<xsl:variable name="dateTime_yyyymmdd0">
			<xsl:value-of select="substring($dateTime,1,10)" />
		</xsl:variable>

	  <xsl:variable name="dateTime_mjd">
			<xsl:call-template name="ymd2mjd">
				<xsl:with-param name="ymd" select="$dateTime_yyyymmdd0" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="dateTime_yyyymmdd">
			<xsl:call-template name="mjd2ymd">
				<xsl:with-param name="mjd" select="$dateTime_mjd" />
			</xsl:call-template>
		</xsl:variable>

		<th align="center"><font size="2">
			<xsl:value-of select="translate(substring($dateTime_yyyymmdd,9,1), '0123456789','　１２３４５６７８９')" />
			<xsl:value-of select="translate(substring($dateTime_yyyymmdd,10,1),'0123456789','０１２３４５６７８９')" />

<!--			<xsl:value-of select="translate(substring(jmx_mete:DateTime,9,1), '0123456789','　１２３４５６７８９')" /> -->
<!--			<xsl:value-of select="translate(substring(jmx_mete:DateTime,10,1),'0123456789','０１２３４５６７８９')" /> -->

			<xsl:text>日</xsl:text>
			<br/>
			<xsl:text>（</xsl:text>
			<xsl:value-of select="jmx_mete:Name" />
			<xsl:text>）</xsl:text>
		</font></th>
	</xsl:template>
<!-- 時刻行 -->

<!-- 地点予報 -->
	<xsl:template match="jmx_mete:Item" mode="point_yoho">
		<table border="1">
			<tr>
				<th>
					<xsl:value-of select="jmx_mete:Station/jmx_mete:Name" />
				</th>
				<xsl:apply-templates select="../jmx_mete:TimeDefines/jmx_mete:TimeDefine" />
			</tr>
			<tr>
			<th>最高気温</th>
			<xsl:apply-templates select="jmx_mete:Kind/jmx_mete:Property[1]/jmx_mete:ClimateValuesPart/jmx_eb:Temperature" mode="point_yoho_mxtem" />
			</tr>
			<tr>
			<th>最高気温階級</th>
			<xsl:apply-templates select="jmx_mete:Kind/jmx_mete:Property[4]/jmx_mete:ClimateValuesPart/jmx_eb:Comparison" mode="point_yoho_mxtem_rank" />
			</tr>
			<tr>
			<th>最低気温</th>
			<xsl:apply-templates select="jmx_mete:Kind/jmx_mete:Property[5]/jmx_mete:ClimateValuesPart/jmx_eb:Temperature" mode="point_yoho_mntem" />
			</tr>
			<tr>
			<th>最低気温階級</th>
			<xsl:apply-templates select="jmx_mete:Kind/jmx_mete:Property[8]/jmx_mete:ClimateValuesPart/jmx_eb:Comparison" mode="point_yoho_mntem_rank" />
			</tr>
		</table>
		<br/>
	</xsl:template>
<!-- 地点予報 -->

<!-- 地点予報（最高気温） -->
	<xsl:template match="jmx_eb:Temperature" mode="point_yoho_mxtem">
		<xsl:param name="day" select="position()" />
		<xsl:choose>
			<xsl:when test="contains(@type,'最高')">

				<xsl:variable name="yoho">
					<xsl:value-of select="." />
					<xsl:text>（</xsl:text>
					<xsl:value-of select="../../../jmx_mete:Property[3]/jmx_mete:ClimateValuesPart/jmx_eb:Temperature[$day]" />
					<xsl:text>～</xsl:text>
					<xsl:value-of select="../../../jmx_mete:Property[2]/jmx_mete:ClimateValuesPart/jmx_eb:Temperature[$day]" />
					<xsl:text>）</xsl:text>
				</xsl:variable>

				<th align="center"><xsl:value-of select="$yoho" /></th>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text></xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
<!-- 地点予報（最高気温） -->

<!-- 地点予報（最高気温階級） -->
	<xsl:template match="jmx_eb:Comparison" mode="point_yoho_mxtem_rank">
		<xsl:param name="day" select="position()" />
		<xsl:choose>
			<xsl:when test="contains(@type,'最高')">
				<xsl:variable name="rank">
					<xsl:value-of select="@description" />
				</xsl:variable>
				<th align="center"><xsl:value-of select="$rank" /></th>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text></xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
<!-- 地点予報（最高気温階級） -->

<!-- 地点予報（最低気温） -->
	<xsl:template match="jmx_eb:Temperature" mode="point_yoho_mntem">
		<xsl:param name="day" select="position()" />
		<xsl:choose>
			<xsl:when test="contains(@type,'最低')">

				<xsl:variable name="yoho">
					<xsl:value-of select="." />
					<xsl:text>（</xsl:text>
					<xsl:value-of select="../../../jmx_mete:Property[7]/jmx_mete:ClimateValuesPart/jmx_eb:Temperature[$day]" />
					<xsl:text>～</xsl:text>
					<xsl:value-of select="../../../jmx_mete:Property[6]/jmx_mete:ClimateValuesPart/jmx_eb:Temperature[$day]" />
					<xsl:text>）</xsl:text>
				</xsl:variable>

				<th align="center"><xsl:value-of select="$yoho" /></th>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text></xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
<!-- 地点予報（最低気温） -->

<!-- 地点予報（最低気温階級） -->
	<xsl:template match="jmx_eb:Comparison" mode="point_yoho_mntem_rank">
		<xsl:param name="day" select="position()" />
		<xsl:choose>
			<xsl:when test="contains(@type,'最低')">
				<xsl:variable name="rank">
					<xsl:value-of select="@description" />
				</xsl:variable>
				<th align="center"><xsl:value-of select="$rank" /></th>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text></xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
<!-- 地点予報（最低気温階級） -->

<!-- 地域予報 -->
	<xsl:template match="jmx_mete:Item" mode="area_yoho">
		<tr>
			<xsl:apply-templates select="jmx_mete:Kind/jmx_mete:Property[1]/jmx_mete:ClimateValuesPart/jmx_eb:Comparison" mode="area_yoho_rank" />
		</tr>
	</xsl:template>
<!-- 地域予報 -->

<!-- 地域予報の階級を取得し表示 -->
	<xsl:template match="jmx_eb:Comparison" mode="area_yoho_rank">
		<xsl:param name="day" select="position()" />
		<xsl:if test="$day='1'">
				<th><xsl:value-of select="../../../../jmx_mete:Area/jmx_mete:Name" /></th>
		</xsl:if>
		<xsl:variable name="rank">
			<xsl:value-of select="@refID" />
		</xsl:variable>
		<th align="center"><xsl:value-of select="@description" /></th>
	</xsl:template>
<!-- 地域予報の階級を取得し表示 -->
	

<!-- 予報発表日の表示 -->
	<xsl:template name="hiduke">
		<xsl:variable name="reportTime" select="jmx_ib:Head/jmx_ib:ReportDateTime" />

		<xsl:text>令和</xsl:text>
		<xsl:if test="number(substring($reportTime,1,4))=2019">
			<xsl:text>元</xsl:text>
		</xsl:if>
		<xsl:if test="number(substring($reportTime,1,4))!=2019">
			<xsl:value-of select="translate(substring($reportTime,1,4) - 2018,'0123456789', '０１２３４５６７８９')"/>
		</xsl:if>
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

<!-- 予報期間の表示 -->
	<xsl:template name="yohokikan">

		<xsl:text>予報期間　</xsl:text>

		<xsl:variable name="targetTime" select="jmx_ib:Head/jmx_ib:TargetDateTime" />

		<xsl:value-of select="translate(substring($targetTime,6,1),'0123456789', '　１２３４５６７８９')"/>
		<xsl:value-of select="translate(substring($targetTime,7,1),'0123456789', '０１２３４５６７８９')"/>
		<xsl:text>月</xsl:text>
		<xsl:value-of select="translate(substring($targetTime,9,1),'0123456789', '　１２３４５６７８９')"/>
		<xsl:value-of select="translate(substring($targetTime,10,1),'0123456789', '０１２３４５６７８９')"/>
		<xsl:text>日</xsl:text>

		<xsl:text>から</xsl:text>

		<xsl:variable name="validTime" select="jmx_ib:Head/jmx_ib:ValidDateTime" />

		<xsl:value-of select="translate(substring($validTime,6,1),'0123456789', '　１２３４５６７８９')"/>
		<xsl:value-of select="translate(substring($validTime,7,1),'0123456789', '０１２３４５６７８９')"/>
		<xsl:text>月</xsl:text>
		<xsl:value-of select="translate(substring($validTime,9,1),'0123456789', '　１２３４５６７８９')"/>
		<xsl:value-of select="translate(substring($validTime,10,1),'0123456789', '０１２３４５６７８９')"/>
		<xsl:text>日</xsl:text>
	</xsl:template>

<!-- 予報期間の表示（日付計算ver） -->
	<xsl:template name="yohokikan2">

		<xsl:text>予報期間　</xsl:text>

		<xsl:variable name="targetTime" select="jmx_ib:Head/jmx_ib:TargetDateTime" />
		<xsl:variable name="start_yyyymmdd0">
			<xsl:value-of select="substring($targetTime,1,10)" />
		</xsl:variable>

	  <xsl:variable name="start_mjd">
			<xsl:call-template name="ymd2mjd">
				<xsl:with-param name="ymd" select="$start_yyyymmdd0" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="start_yyyymmdd">
			<xsl:call-template name="mjd2ymd">
				<xsl:with-param name="mjd" select="$start_mjd - 2" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="end_yyyymmdd">
			<xsl:call-template name="mjd2ymd">
				<xsl:with-param name="mjd" select="$start_mjd + 6" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:value-of select="translate(substring($start_yyyymmdd,6,1),'0123456789', '　１２３４５６７８９')"/>
		<xsl:value-of select="translate(substring($start_yyyymmdd,7,1),'0123456789', '０１２３４５６７８９')"/>
		<xsl:text>月</xsl:text>
		<xsl:value-of select="translate(substring($start_yyyymmdd,9,1),'0123456789', '　１２３４５６７８９')"/>
		<xsl:value-of select="translate(substring($start_yyyymmdd,10,1),'0123456789', '０１２３４５６７８９')"/>
		<xsl:text>日</xsl:text>
		<xsl:text>から</xsl:text>
    <xsl:value-of select="translate(substring($end_yyyymmdd,6,1),'0123456789', '　１２３４５６７８９')"/>
		<xsl:value-of select="translate(substring($end_yyyymmdd,7,1),'0123456789', '０１２３４５６７８９')"/>
		<xsl:text>月</xsl:text>
		<xsl:value-of select="translate(substring($end_yyyymmdd,9,1),'0123456789', '　１２３４５６７８９')"/>
		<xsl:value-of select="translate(substring($end_yyyymmdd,10,1),'0123456789', '０１２３４５６７８９')"/>
		<xsl:text>日</xsl:text>

	</xsl:template>

	<!-- 西暦の yyyy-mm-dd から修正ユリウス通日(MJD) を求める -->
	<xsl:template name="ymd2mjd">
	  <xsl:param name="ymd"/>
	  <xsl:variable name="y">
	    <xsl:choose>
	      <xsl:when test="number(substring($ymd,6,2)) &lt;= 2">
	      <xsl:value-of select="number(substring($ymd,1,4)) - 1"/>
	      </xsl:when>
	      <xsl:otherwise>
	      <xsl:value-of select="number(substring($ymd,1,4))"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:variable>
	  <xsl:variable name="m">
	    <xsl:choose>
	      <xsl:when test="number(substring($ymd,6,2)) &lt;= 2">
	      <xsl:value-of select="number(substring($ymd,6,2)) + 12"/>
	      </xsl:when>
	      <xsl:otherwise>
	      <xsl:value-of select="number(substring($ymd,6,2))"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:variable>
	  <xsl:variable name="d" select="number(substring($ymd,9,2))"/>
	  <xsl:value-of select="floor(365.25 * $y) + floor($y div 400) - floor($y div 100) + floor(30.59 * ($m - 2)) + $d - 678912"/>
	</xsl:template>




	<!-- 修正ユリウス通日(MJD) から西暦の yyyy-mm-dd からに変換 -->
	<xsl:template name="mjd2ymd">
	  <xsl:param name="mjd"/>
	  <xsl:variable name="y1" select="floor(($mjd - 15078.2) div 365.25 )"/>
	  <xsl:variable name="m1" select="floor(($mjd - 14956.1 - floor($y1 * 365.25)) div 30.6001)"/>
	  <xsl:variable name="d1" select="$mjd - 14956 - floor($y1 * 365.25) - floor($m1 * 30.6001)"/>
	  <xsl:variable name="k">
	    <xsl:choose>
	    <xsl:when test="$m1 = 14 or $m1 = 15">1</xsl:when>
	    <xsl:otherwise>0</xsl:otherwise>
	    </xsl:choose>
	  </xsl:variable>
	  <xsl:variable name="y" select="$y1 + $k + 1900"/>
	  <xsl:variable name="m2" select="$m1 - 1 - $k * 12"/>
	 
	  <xsl:variable name="m3" select="concat('00',string($m2))"/>
	  <xsl:variable name="m" select="substring($m3,string-length($m3)-1,2)"/>
	 
	  <xsl:variable name="d2" select="concat('00',string($d1))"/>
	  <xsl:variable name="d" select="substring($d2,string-length($d2)-1,2)"/>
	 
	  <xsl:value-of select="concat($y,'-',$m,'-',$d)"/>
	</xsl:template>


</xsl:stylesheet>
