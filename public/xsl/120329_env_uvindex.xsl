<?xml version="1.0" encoding="utf-8" ?>
<!--
  ======================================================================
  本スタイルシートは、気象庁防災情報XMLフォーマット形式電文中の全ての情報コンテンツを出力するもので、
システム処理の動作確認など、電文処理の参考資料としてお使い下さい。

  なお、本スタイルシートについては、システムに直接組み込む等の方法でご利用になることは避けていただくなど、
ご利用に当たっては十分に注意していただきますよう、よろしくお願いいたします。

  Copyright (c) 気象庁 2012 All rights reserved.

【対象情報】
  紫外線観測データ

【更新履歴】
  2012年03月29日　Ver.1.0
  ======================================================================
-->

<xsl:stylesheet 
xmlns:jmx="http://xml.kishou.go.jp/jmaxml1/"
xmlns:jmx_ib="http://xml.kishou.go.jp/jmaxml1/informationBasis1/" 
xmlns:jmx_mete="http://xml.kishou.go.jp/jmaxml1/body/meteorology1/" 
xmlns:jma_eb="http://xml.kishou.go.jp/jmaxml1/elementBasis1/"  
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" encoding="Shift_Jis" />

	<xsl:template match="/">
		<html>
		<xsl:apply-templates select="jmx:Report" />
		</html>
	</xsl:template>
	<xsl:template match="jmx:Report">
		<xsl:apply-templates select="jmx:Control"/>
		<xsl:apply-templates select="jmx_ib:Head"/>
		<xsl:apply-templates select="jmx_mete:Body/jmx_mete:MeteorologicalInfos"/>
	</xsl:template>

	<xsl:template match="jmx:Control">

		<table border="1">
		<th>Control部　タグ</th><th>内　容</th>
		<tr>
			<td>情報名称（Title）</td>
			<td><xsl:value-of select="jmx:Title" /></td>
		</tr>
		<tr>
			<td>電文発信時刻（DateTime）</td>
			<td><xsl:value-of select="jmx:DateTime" /></td>
		</tr>
		<tr>
			<td>運用種別（Status）</td>
			<td><xsl:value-of select="jmx:Status" /></td>
		</tr>
		<tr>
			<td>編集官署名（EditorialOffice）</td>
			<td><xsl:value-of select="jmx:EditorialOffice" /></td>
		</tr>
		<tr>
			<td>発表官署名（PublishingOffice）</td>
			<td><xsl:value-of select="jmx:PublishingOffice" /></td>
		</tr>
		</table>
        	<br/><br/>
	</xsl:template>

	<xsl:template match="jmx_ib:Head">
		<table border="1">
		<th>Head部　タグ</th><th>内　容</th>
		<tr>
			<td>標題（Title）</td>
			<td><xsl:value-of select="jmx_ib:Title" /></td>
		</tr>
		<tr>
			<td>電文発表時刻（ReportDateTime）</td>
			<td><xsl:value-of select="/jmx:Report/jmx_ib:Head/jmx_ib:ReportDateTime" /></td>
		</tr>
		<tr>
			<td>観測年月日（TargetDateTime）</td>
			<td><xsl:value-of select="/jmx:Report/jmx_ib:Head/jmx_ib:TargetDateTime" /></td>
		</tr>
		<tr>
			<td>電文識別情報(常になし）（EventID）</td>
			<td>
			<xsl:if test="/jmx:Report/jmx_ib:Head/jmx_ib:EventID=''">-</xsl:if>
			<xsl:value-of select="/jmx:Report/jmx_ib:Head/jmx_ib:EventID" /><br /></td>
		</tr>
		<tr>
			<td>情報形態（発表）（InfoType）</td>
			<td>
			<xsl:if test="/jmx:Report/jmx_ib:Head/jmx_ib:InfoType=''">-</xsl:if>
			<xsl:value-of select="/jmx:Report/jmx_ib:Head/jmx_ib:InfoType" /><br /></td>
		</tr>
		<tr>
			<td>情報番号（常になし）（Serial）</td>
			<td>
			<xsl:if test="/jmx:Report/jmx_ib:Head/jmx_ib:Serial=''">-</xsl:if>
			<xsl:value-of select="/jmx:Report/jmx_ib:Head/jmx_ib:Serial" /></td>
		</tr>
		<tr>
			<td>スキーマの運用種別情報（InfoKind）</td>
			<td><xsl:value-of select="/jmx:Report/jmx_ib:Head/jmx_ib:InfoKind" /></td>
		</tr>
		<tr>
			<td>スキーマの運用種別情報のバージョン番号（InfoKindVersion）</td>
			<td><xsl:value-of select="/jmx:Report/jmx_ib:Head/jmx_ib:InfoKindVersion" /></td>
		</tr>
		<tr>
			<td>見出し文（常になし）（Headline/Text）</td><td>
			<xsl:if test="/jmx:Report/jmx_ib:Head/jmx_ib:Headline/jmx_ib:Text=''">-</xsl:if>
			<xsl:value-of select="/jmx:Report/jmx_ib:Head/jmx_ib:Headline/jmx_ib:Text" /><br /></td>
		</tr>
		</table>
		<br/><br/>
	</xsl:template>

	<xsl:template match="jmx_mete:Body/jmx_mete:MeteorologicalInfos">
        <h2>Body部　
			<xsl:value-of select="@type" />

	</h2>
		<xsl:for-each select="jmx_mete:TimeSeriesInfo">
					<xsl:variable name="item_no">
			            	  <xsl:number />
					</xsl:variable>
			<xsl:if test="$item_no=1">
			<br/>

			<table border="1">
			<tr><th>観測地点<br/>コード[市町村/WMO/WOUDC]<br/>市町村名<br/>緯度経度</th><th>項　目</th>
					<xsl:variable name="youso_no">
			            	  <xsl:number />
					</xsl:variable>
					<xsl:for-each select="jmx_mete:TimeDefines/jmx_mete:TimeDefine">
						<xsl:variable name="hour"><xsl:value-of select="substring(jmx_mete:DateTime,12,2)" /></xsl:variable>
						<xsl:if test="@timeId &lt; 100">
								<th>
									<xsl:value-of select="$hour" />時
								</th>
						</xsl:if>
					</xsl:for-each>
			</tr>
			<xsl:for-each select="jmx_mete:Item">
					<xsl:variable name="kno_max"> <xsl:value-of select="count(jmx_mete:Kind)"/></xsl:variable>
					<xsl:for-each select="jmx_mete:Kind">
							<xsl:variable name="kno"> 
								<xsl:number />
							</xsl:variable>
	
								<!--  太陽天頂角  -->
								 <xsl:if test="$kno=2" >
									<tr>
										<td rowspan="2"><xsl:value-of select="../jmx_mete:Station/jmx_mete:Name" /><br/>
										[<xsl:for-each select="../jmx_mete:Station/jmx_mete:Code">
											<xsl:value-of select="." />/
										</xsl:for-each>]
										<br/><xsl:value-of select="../jmx_mete:Station/jmx_mete:Location" />
										<br/>緯度<xsl:value-of select="substring(../jmx_mete:Station/jma_eb:Coordinate,0,8)" />
										<br/>経度<xsl:value-of select="substring(../jmx_mete:Station/jma_eb:Coordinate,8,8)" />
										</td>
																	

									<th><xsl:value-of select="../jmx_mete:Kind/jmx_mete:Property/jmx_mete:SolarZenithAnglePart/../jmx_mete:Type" />[1]</th>
								
								<xsl:for-each select="jmx_mete:Property/jmx_mete:UvIndexPart/jma_eb:UvIndex">
									<xsl:variable name="tid"> 
										<xsl:value-of select="@refID" />
									</xsl:variable>
									<xsl:variable name="tdate"> 
										<xsl:for-each select="../../../../../jmx_mete:TimeDefines/jmx_mete:TimeDefine">
											<xsl:if test="@timeId=$tid" > <xsl:value-of select="jmx_mete:DateTime" /></xsl:if>
										</xsl:for-each>
									</xsl:variable>
									<xsl:variable name="sdata"> 
										<xsl:for-each select="../../../../jmx_mete:Kind/jmx_mete:Property/jmx_mete:SolarZenithAnglePart/jma_eb:SolarZenithAngle">
											<xsl:if test="number(@refID)=number($tid)" > <xsl:value-of select="." /></xsl:if>
										</xsl:for-each>
									</xsl:variable>
										<td>
										<xsl:if test="$sdata!=''" >
											<xsl:value-of select="$sdata" /><br/>
										</xsl:if>
										<xsl:if test="$sdata=''">-</xsl:if>
										</td>
						
								</xsl:for-each></tr>
								</xsl:if>

								<!--  UVindex  -->
								<xsl:if test="$kno=2" >
								<tr>
								<th><xsl:value-of select="jmx_mete:Property/jmx_mete:UvIndexPart/../jmx_mete:Type" />[<xsl:value-of select="$kno"/>]</th>
								<xsl:for-each select="jmx_mete:Property/jmx_mete:UvIndexPart/jma_eb:UvIndex">
									<xsl:variable name="tid"> 
										<xsl:value-of select="@refID" />
									</xsl:variable>
									<xsl:variable name="tdate"> 
										<xsl:for-each select="../../../../../jmx_mete:TimeDefines/jmx_mete:TimeDefine">
											<xsl:if test="@timeId=$tid" > <xsl:value-of select="jmx_mete:DateTime" /></xsl:if>
										</xsl:for-each>
									</xsl:variable>
											<xsl:if test="(text()>=0.0)" >
												<td><xsl:value-of select="." /></td>
											</xsl:if>
											<xsl:if test=".=''">
												<td>-</td>
											</xsl:if>
																						
								</xsl:for-each></tr>
								</xsl:if>

					</xsl:for-each>
			</xsl:for-each>
			</table>
	
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
