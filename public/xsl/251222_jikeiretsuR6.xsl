<?xml version="1.0" encoding="utf-8"?>

<!--
  ======================================================================
  本スタイルシートは、気象庁防災情報XMLフォーマット形式電文中の全ての情
  報コンテンツを出力するもので、システム処理の動作確認など、電文処理の参
  考資料としてお使い下さい。

  なお、本スタイルシートについては、システムに直接組み込む等の方法でご利
  用になることは避けていただくなど、ご利用に当たっては十分に注意していた
  だきますよう、よろしくお願いいたします。

  Copyright (c) 気象庁 2012,2025 All rights reserved.
  
  【対象情報】
  気象警報・注意報時系列情報（Ｒ０６）

  【更新履歴】
  2019年05月29日　オリジナル「190529_kei_h27.xsl」ver.1.2
  2024年10月31日　Ver.1.0（オリジナルから変更。新電文対応版）
  2025年12月22日　Ver.1.0_1　不具合改修版（時間要素と表幅を併せる）

  ======================================================================
-->

<xsl:stylesheet 
xmlns:jmx="http://xml.kishou.go.jp/jmaxml1/"
xmlns:jmx_ib="http://xml.kishou.go.jp/jmaxml1/informationBasis1/" 
xmlns:jmx_mete="http://xml.kishou.go.jp/jmaxml1/body/meteorology1/" 
xmlns:jmx_eb="http://xml.kishou.go.jp/jmaxml1/elementBasis1/" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" indent="yes" encoding="utf-8"/>
<xsl:template match="/">

<html><head></head><body>

		<!--ヘッダ部-->
			<xsl:apply-templates select="jmx:Report/jmx_ib:Head" />
		<!--お知らせ はない-->

		<!--警報種別（ヘッダ部 はない）-->

		<!--ヘッダ部と本文の間の罫線-->
			<br/><hr width="70%" size="1" /><br/>
		<!--ボディ部 はない-->

		<!--ボディ部と量的予想時系列部の間の罫線 はいらない-->

		<!--量的予想時系列部-->
			<xsl:apply-templates select="jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos" />
	
</body></html>
	
</xsl:template>


<!--ヘッダ部-->
	<xsl:template match="jmx_ib:Head">
		<h1>
		<!--標題名-->
			<xsl:value-of select="jmx_ib:Title"/><br/> <!-- R06addition -->
		<!--発表日時-->
			<xsl:text>令和</xsl:text>
			<xsl:choose>
			<xsl:when test="substring(jmx_ib:ReportDateTime,1,4)='2019'">元</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="translate(substring(jmx_ib:ReportDateTime,1,4) - 2018,'0123456789', '０１２３４５６７８９')"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>年</xsl:text>
			<xsl:value-of select="translate(substring(jmx_ib:ReportDateTime,6,1),'0123456789', '　１２３４５６７８９')"/>
			<xsl:value-of select="translate(substring(jmx_ib:ReportDateTime,7,1),'0123456789', '０１２３４５６７８９')"/>
			<xsl:text>月</xsl:text>
			<xsl:value-of select="translate(substring(jmx_ib:ReportDateTime,9,1),'0123456789', '　１２３４５６７８９')"/>
			<xsl:value-of select="translate(substring(jmx_ib:ReportDateTime,10,1),'0123456789', '０１２３４５６７８９')"/>
			<xsl:text>日</xsl:text>
			<xsl:value-of select="translate(substring(jmx_ib:ReportDateTime,12,2),'0123456789', '０１２３４５６７８９')"/>
			<xsl:text>時</xsl:text>
			<xsl:value-of select="translate(substring(jmx_ib:ReportDateTime,15,2),'0123456789', '０１２３４５６７８９')"/>
			<xsl:text>分</xsl:text>
			<xsl:text>　</xsl:text>
		<!--発表官署-->
			<xsl:value-of select="/jmx:Report/jmx:Control/jmx:PublishingOffice"/>
		<!--発表状況-->
			<xsl:text>発表</xsl:text>
			<xsl:if test="contains(jmx_ib:InfoType,'訂正')">
				<xsl:text>（訂正）</xsl:text>
			</xsl:if>
		</h1>
	<!--注意警戒文 はない-->
	</xsl:template>


<!--お知らせ はない-->


<!--警報注意報（ヘッダ部） はない-->


<!--ボディ部 は不要-->


<!-- 警戒レベル は不要 -->


<!--Statusでまとめる は不要-->


<!--量的予想時系列部-->
	<xsl:template match="jmx_mete:Body/jmx_mete:MeteorologicalInfos">
		<!--MeteorologicalInfosのtype-->
		<br/>
		<p class="mtx"><b><font size="+1" color="navy">
			<xsl:text>＜</xsl:text>
			<xsl:value-of select="@type" />
			<xsl:text>＞</xsl:text>
		</font></b></p>
		
		<!--時系列表の書き出し-->
		<xsl:for-each select="jmx_mete:TimeSeriesInfo">
			<xsl:for-each select="jmx_mete:Item">
				<!--領域名-->
				<font color="green">
					<xsl:text>==================</xsl:text><br/>
					<xsl:text>　　　</xsl:text>
					<b><xsl:value-of select="./jmx_mete:Area/jmx_mete:Name" /></b>
					<br/>
					<xsl:text>==================</xsl:text>
				</font>
				<br/>

			<table border="1">
			<!--予報期間の書き出し-->
			<thread>
				<tr>
					<th>
					<xsl:text> </xsl:text>
					</th>
					<xsl:for-each select="../jmx_mete:TimeDefines/jmx_mete:TimeDefine">
						<th><xsl:value-of select="./jmx_mete:Name" /></th>
					</xsl:for-each>
					<th><xsl:text>発表・更新日時</xsl:text></th>
				</tr>
			</thread>

				<!--発表中の警報等-->
				<xsl:for-each select="jmx_mete:Kind">
					<!--個々の現象についての書き出し -->
					<xsl:call-template name="TimeSeriesInfo_temp"/>
						<!-- オリジナルの各要素別にテンプレートを呼び出すところは不要 -->
				</xsl:for-each>
			</table>
			<br/>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	
	
	<!--予報時系列データの抽出-->
	<xsl:template name="TimeSeriesInfo_temp">

			<tbody>
				<!--危険度の抽出-->
				<xsl:if test="count(jmx_mete:Property/jmx_mete:SignificancyPart/jmx_mete:Base/jmx_mete:Significancy)>0">
					<xsl:for-each select="jmx_mete:Property/jmx_mete:SignificancyPart/jmx_mete:Base">
						<tr>
						<th>
							<xsl:value-of select="jmx_mete:Significancy/@type"/>
						</th>
						<xsl:for-each select="jmx_mete:Significancy">
							<!--危険度に応じて背景色を付ける-->
							<xsl:element name="td">
							<xsl:if test="./jmx_mete:Code[text()='01' or text()='11']"><xsl:attribute name="style">background-color:#F8F8FF;</xsl:attribute></xsl:if>
							<xsl:if test="./jmx_mete:Code[text()='20' or text()='21']"><xsl:attribute name="style">background-color:yellow;</xsl:attribute></xsl:if>
							<xsl:if test="./jmx_mete:Code[text()='30' or text()='31']"><xsl:attribute name="style">background-color:red;</xsl:attribute></xsl:if>
							<xsl:if test="./jmx_mete:Code[text()='41']"><xsl:attribute name="style">background-color:violet;</xsl:attribute></xsl:if>
							<xsl:if test="./jmx_mete:Code[text()='50' or text()='51']"><xsl:attribute name="style">background-color:black;color:white;</xsl:attribute></xsl:if>
							<xsl:if test="./jmx_mete:Code[text()='00']"><xsl:attribute name="style">background-color:gray;</xsl:attribute></xsl:if>
							<center>
							<xsl:value-of select="./jmx_mete:Name" />
							<xsl:text>（</xsl:text><xsl:value-of select="./jmx_mete:Code" /><xsl:text>）</xsl:text>
							<!--風雪フラグの判定-->
							<xsl:if test="@type='風危険度'">
								<xsl:call-template name="SnowStormFlag"/>
							</xsl:if>
							</center>
							</xsl:element>
						</xsl:for-each>
						<!--発表・更新日時-->
						<td><xsl:value-of select="substring(../../../jmx_mete:DateTime,12,2)"/><xsl:text>時</xsl:text><xsl:value-of select="substring(../../../jmx_mete:DateTime,15,2)"/><xsl:text>分</xsl:text>
						<xsl:value-of select="../../../jmx_mete:Status"/></td>
					</tr>
					</xsl:for-each>
				</xsl:if>

				<!--地域ごとの危険度があれば抽出-->
				<xsl:for-each select="jmx_mete:Property/jmx_mete:SignificancyPart/jmx_mete:Base/jmx_mete:Local">
					<tr>
						<th>
							<xsl:value-of select="jmx_mete:Significancy/@type"/>
							<xsl:text>（</xsl:text><xsl:value-of select="jmx_mete:AreaName"/><xsl:text>）</xsl:text>
						</th>
						<xsl:for-each select="jmx_mete:Significancy">
							<!--危険度に応じて背景色を付ける-->
							<xsl:element name="td">
							<xsl:if test="./jmx_mete:Code[text()='01' or text()='11']"><xsl:attribute name="style">background-color:#F8F8FF;</xsl:attribute></xsl:if>
							<xsl:if test="./jmx_mete:Code[text()='20' or text()='21']"><xsl:attribute name="style">background-color:yellow;</xsl:attribute></xsl:if>
							<xsl:if test="./jmx_mete:Code[text()='30' or text()='31']"><xsl:attribute name="style">background-color:red;</xsl:attribute></xsl:if>
							<xsl:if test="./jmx_mete:Code[text()='41']"><xsl:attribute name="style">background-color:violet;</xsl:attribute></xsl:if>
							<xsl:if test="./jmx_mete:Code[text()='50' or text()='51']"><xsl:attribute name="style">background-color:black;color:white;</xsl:attribute></xsl:if>
							<xsl:if test="./jmx_mete:Code[text()='00']"><xsl:attribute name="style">background-color:gray;</xsl:attribute></xsl:if>
							<center><xsl:value-of select="./jmx_mete:Name" /><xsl:text>（</xsl:text><xsl:value-of select="./jmx_mete:Code" /><xsl:text>）</xsl:text>
							<!--風雪フラグの判定-->
							<xsl:if test="@type='風危険度'">
								<xsl:call-template name="SnowStormFlagL">
									<xsl:with-param name="Local_Area" select="../jmx_mete:AreaName"/>
								</xsl:call-template>
							</xsl:if>
							</center>
							</xsl:element>
						</xsl:for-each>
						<!--発表・更新日時-->
						<td><xsl:value-of select="substring(../../../../jmx_mete:DateTime,12,2)"/><xsl:text>時</xsl:text><xsl:value-of select="substring(../../../../jmx_mete:DateTime,15,2)"/><xsl:text>分</xsl:text>
						<xsl:value-of select="../../../../jmx_mete:Status"/></td>
					</tr>
				</xsl:for-each>

				<!--大雨の時系列値を抽出-->
				<xsl:if test="count(jmx_mete:Property/jmx_mete:PrecipitationPart/jmx_mete:Base/jmx_eb:Precipitation)>0">
					<xsl:for-each select="jmx_mete:Property/jmx_mete:PrecipitationPart/jmx_mete:Base">
						<tr>					
						<th>
							<xsl:value-of select="jmx_eb:Precipitation/@type"/>
						</th>
							<xsl:for-each select="jmx_eb:Precipitation">
								<xsl:choose>
									<xsl:when test="count(@description)=0">
										<td><center><xsl:text>－</xsl:text></center></td>
									</xsl:when>
									<xsl:otherwise>
										<td><center><xsl:value-of select="@description" /></center></td>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						<!--発表・更新日時-->
						<td><xsl:value-of select="substring(../../../jmx_mete:DateTime,12,2)"/><xsl:text>時</xsl:text><xsl:value-of select="substring(../../../jmx_mete:DateTime,15,2)"/><xsl:text>分</xsl:text>
						<xsl:value-of select="../../../jmx_mete:Status"/></td>
						</tr>
					</xsl:for-each>
				</xsl:if>
				<!--地域ごとの時系列値を抽出-->
				<xsl:for-each select="jmx_mete:Property/jmx_mete:PrecipitationPart/jmx_mete:Base/jmx_mete:Local">
					<tr>
					<th>
						<xsl:value-of select="jmx_eb:Precipitation/@type"/>
						<xsl:text>（</xsl:text><xsl:value-of select="jmx_mete:AreaName"/><xsl:text>）</xsl:text>
					</th>
						<xsl:for-each select="jmx_eb:Precipitation">
							<xsl:choose>
								<xsl:when test="count(@description)=0">
									<td><center><xsl:text>－</xsl:text></center></td>
								</xsl:when>
								<xsl:otherwise>
									<td><center>
									<xsl:value-of select="@description"/></center></td>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
						<!--発表・更新日時-->
						<td><xsl:value-of select="substring(../../../../jmx_mete:DateTime,12,2)"/><xsl:text>時</xsl:text><xsl:value-of select="substring(../../../../jmx_mete:DateTime,15,2)"/><xsl:text>分</xsl:text>
						<xsl:value-of select="../../../../jmx_mete:Status"/></td>
					</tr>
				</xsl:for-each>
				
				<!--風向風速の時系列値を抽出-->
				<xsl:if test="count(jmx_mete:Property/jmx_mete:WindDirectionPart/jmx_mete:Base/jmx_eb:WindDirection)>0">
					<tr>
					<th>
						<xsl:value-of select="jmx_mete:Property/jmx_mete:WindDirectionPart/jmx_mete:Base/jmx_eb:WindDirection/@type"/>
						<xsl:text>・</xsl:text>
						<xsl:value-of select="jmx_mete:Property/jmx_mete:WindSpeedPart/jmx_mete:Base/jmx_eb:WindSpeed/@type"/>
					</th>
						<xsl:for-each select="jmx_mete:Property/jmx_mete:WindDirectionPart/jmx_mete:Base/jmx_eb:WindDirection">
							<xsl:call-template name="wind_tmp"/>
						</xsl:for-each>
						<!--発表・更新日時-->
						<td><xsl:value-of select="substring(./jmx_mete:DateTime,12,2)"/><xsl:text>時</xsl:text><xsl:value-of select="substring(./jmx_mete:DateTime,15,2)"/><xsl:text>分</xsl:text>
						<xsl:value-of select="./jmx_mete:Status"/></td>
					</tr>
				</xsl:if>							

				<!--地域ごとの時系列値を抽出-->
				<xsl:for-each select="jmx_mete:Property/jmx_mete:WindDirectionPart/jmx_mete:Base/jmx_mete:Local">
					<tr>
					<th>
						<xsl:value-of select="jmx_eb:WindDirection/@type"/>
						<xsl:text>・</xsl:text>
						<xsl:value-of select="../../../jmx_mete:WindSpeedPart/jmx_mete:Base/jmx_mete:Local/jmx_eb:WindSpeed/@type"/>
						<xsl:text>（</xsl:text><xsl:value-of select="jmx_mete:AreaName"/><xsl:text>）</xsl:text>
					</th>
						<xsl:for-each select="jmx_eb:WindDirection">
							<xsl:call-template name="windL_tmp">
								<xsl:with-param name="Local_Area" select="../jmx_mete:AreaName"/>
							</xsl:call-template>
						</xsl:for-each>
						<!--発表・更新日時-->
						<td><xsl:value-of select="substring(../../../../jmx_mete:DateTime,12,2)"/><xsl:text>時</xsl:text><xsl:value-of select="substring(../../../../jmx_mete:DateTime,15,2)"/><xsl:text>分</xsl:text>
						<xsl:value-of select="../../../../jmx_mete:Status"/></td>
					</tr>
				</xsl:for-each>


							
				<!--波の時系列値を抽出-->
				<xsl:if test="count(jmx_mete:Property/jmx_mete:WaveHeightPart/jmx_mete:Base/jmx_eb:WaveHeight)>0">
					<tr>
					<th>
						<xsl:value-of select="jmx_mete:Property/jmx_mete:WaveHeightPart/jmx_mete:Base/jmx_eb:WaveHeight/@type"/>
					</th>
						<xsl:for-each select="jmx_mete:Property/jmx_mete:WaveHeightPart/jmx_mete:Base/jmx_eb:WaveHeight">
							<xsl:choose>
								<xsl:when test="count(@description)=0">
									<td><center><xsl:text>－</xsl:text></center></td>
								</xsl:when>
								<xsl:otherwise>
									<td><center><xsl:value-of select="@description" /></center></td>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
						<!--発表・更新日時-->
						<td><xsl:value-of select="substring(./jmx_mete:DateTime,12,2)"/><xsl:text>時</xsl:text><xsl:value-of select="substring(./jmx_mete:DateTime,15,2)"/><xsl:text>分</xsl:text>
						<xsl:value-of select="./jmx_mete:Status"/></td>
					</tr>
				</xsl:if>

				<!--地域ごとの時系列値を抽出-->
				<xsl:for-each select="jmx_mete:Property/jmx_mete:WaveHeightPart/jmx_mete:Base/jmx_mete:Local">
					<tr>
					<th>
						<xsl:value-of select="jmx_eb:WaveHeight/@type"/>
						<xsl:text>（</xsl:text><xsl:value-of select="jmx_mete:AreaName"/><xsl:text>）</xsl:text>
					</th>
						<xsl:for-each select="jmx_eb:WaveHeight">
							<xsl:choose>
								<xsl:when test="count(@description)=0">
									<td><center><xsl:text>－</xsl:text></center></td>
								</xsl:when>
								<xsl:otherwise>
									<td><center>
									<xsl:value-of select="@description"/></center></td>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
						<!--発表・更新日時-->
						<td><xsl:value-of select="substring(../../../../jmx_mete:DateTime,12,2)"/><xsl:text>時</xsl:text><xsl:value-of select="substring(../../../../jmx_mete:DateTime,15,2)"/><xsl:text>分</xsl:text>
						<xsl:value-of select="../../../../jmx_mete:Status"/></td>
					</tr>
				</xsl:for-each>
				

				<!--高潮の時系列値を抽出-->
				<xsl:if test="count(jmx_mete:Property/jmx_mete:TidalLevelPart/jmx_mete:Base/jmx_eb:TidalLevel)>0">
					<tr>					
					<th>
						<xsl:value-of select="jmx_mete:Property/jmx_mete:TidalLevelPart/jmx_mete:Base/jmx_eb:TidalLevel/@type"/>
					</th>
						<xsl:for-each select="jmx_mete:Property/jmx_mete:TidalLevelPart/jmx_mete:Base/jmx_eb:TidalLevel">
							<xsl:choose>
								<xsl:when test="count(@description)=0">
									<td><center><xsl:text>－</xsl:text></center></td>
								</xsl:when>
								<xsl:otherwise>
									<td><center><xsl:value-of select="@description" /></center></td>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
						<!--発表・更新日時-->
						<td><xsl:value-of select="substring(./jmx_mete:DateTime,12,2)"/><xsl:text>時</xsl:text><xsl:value-of select="substring(./jmx_mete:DateTime,15,2)"/><xsl:text>分</xsl:text>
						<xsl:value-of select="./jmx_mete:Status"/></td>
					</tr>
				</xsl:if>

				<!--地域ごとの時系列値を抽出-->
				<xsl:for-each select="jmx_mete:Property/jmx_mete:TidalLevelPart/jmx_mete:Base/jmx_mete:Local">
					<tr>
					<th>
						<xsl:value-of select="jmx_eb:TidalLevel/@type"/>
						<xsl:text>（</xsl:text><xsl:value-of select="jmx_mete:AreaName"/><xsl:text>）</xsl:text>
					</th>
						<xsl:for-each select="jmx_eb:TidalLevel">
							<xsl:choose>
								<xsl:when test="count(@description)=0">
									<td><center><xsl:text>－</xsl:text></center></td>
								</xsl:when>
								<xsl:otherwise>
									<td><center>
									<xsl:value-of select="@description"/></center></td>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
						<!--発表・更新日時-->
						<td><xsl:value-of select="substring(../../../../jmx_mete:DateTime,12,2)"/><xsl:text>時</xsl:text><xsl:value-of select="substring(../../../../jmx_mete:DateTime,15,2)"/><xsl:text>分</xsl:text>
						<xsl:value-of select="../../../../jmx_mete:Status"/></td>
					</tr>
				</xsl:for-each>


				<!--雪の時系列値を抽出-->
				<xsl:if test="count(jmx_mete:Property/jmx_mete:SnowfallDepthPart/jmx_mete:Base/jmx_eb:SnowfallDepth)>0">
					<tr>					
					<th>
						<xsl:value-of select="jmx_mete:Property/jmx_mete:SnowfallDepthPart/jmx_mete:Base/jmx_eb:SnowfallDepth/@type"/>
					</th>
						<xsl:for-each select="jmx_mete:Property/jmx_mete:SnowfallDepthPart/jmx_mete:Base/jmx_eb:SnowfallDepth">
							<xsl:choose>
								<xsl:when test="count(@description)=0">
								<td><center><xsl:text>－</xsl:text></center></td>
								</xsl:when>
								<xsl:otherwise>
									<td><center><xsl:value-of select="@description" /></center></td>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
						<!--発表・更新日時-->
						<td><xsl:value-of select="substring(./jmx_mete:DateTime,12,2)"/><xsl:text>時</xsl:text><xsl:value-of select="substring(./jmx_mete:DateTime,15,2)"/><xsl:text>分</xsl:text>
						<xsl:value-of select="./jmx_mete:Status"/></td>
					</tr>
				</xsl:if>

				<!--地域ごとの時系列値を抽出-->
				<xsl:for-each select="jmx_mete:Property/jmx_mete:SnowfallDepthPart/jmx_mete:Base/jmx_mete:Local">
					<tr>
					<th>
						<xsl:value-of select="jmx_eb:SnowfallDepth/@type"/>
						<xsl:text>（</xsl:text><xsl:value-of select="jmx_mete:AreaName"/><xsl:text>）</xsl:text>
					</th>
						<xsl:for-each select="jmx_eb:SnowfallDepth">
							<xsl:choose>
								<xsl:when test="count(@description)=0">
									<td colspan="1"><center><xsl:text>－</xsl:text></center></td>
								</xsl:when>
								<xsl:otherwise>
									<td colspan="1"><center>
									<xsl:value-of select="@description"/></center></td>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
						<!--発表・更新日時-->
						<td><xsl:value-of select="substring(../../../../jmx_mete:DateTime,12,2)"/><xsl:text>時</xsl:text><xsl:value-of select="substring(../../../../jmx_mete:DateTime,15,2)"/><xsl:text>分</xsl:text>
						<xsl:value-of select="../../../../jmx_mete:Status"/></td>
					</tr>
				</xsl:for-each>
				
			
				<!--湿度の時系列値を抽出-->
				<xsl:if test="count(jmx_mete:Property/jmx_mete:HumidityPart/jmx_mete:Base/jmx_eb:Humidity)>0">
					<xsl:for-each select="jmx_mete:Property/jmx_mete:HumidityPart/jmx_mete:Base">
						<tr>					
						<th>
							<xsl:value-of select="jmx_eb:Humidity/@type"/>
						</th>
							<xsl:for-each select="jmx_eb:Humidity">
								<xsl:choose>
									<xsl:when test="count(@description)=0">
										<td><center><xsl:text>－</xsl:text></center></td>
									</xsl:when>
									<xsl:otherwise>
										<td><center><xsl:value-of select="@description" /></center></td>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						<!--発表・更新日時-->
						<td><xsl:value-of select="substring(../../../jmx_mete:DateTime,12,2)"/><xsl:text>時</xsl:text><xsl:value-of select="substring(../../../jmx_mete:DateTime,15,2)"/><xsl:text>分</xsl:text>
						<xsl:value-of select="../../../jmx_mete:Status"/></td>
						</tr>
					</xsl:for-each>
				</xsl:if>

				<!--地域ごとの時系列値を抽出-->
				<xsl:for-each select="jmx_mete:Property/jmx_mete:HumidityPart/jmx_mete:Base/jmx_mete:Local">
					<tr>
					<th>
						<xsl:value-of select="jmx_eb:Humidity/@type"/>
						<xsl:text>（</xsl:text><xsl:value-of select="jmx_mete:AreaName"/><xsl:text>）</xsl:text>
					</th>
						<xsl:for-each select="jmx_eb:Humidity">
							<xsl:choose>
								<xsl:when test="count(@description)=0">
									<td><center><xsl:text>－</xsl:text></center></td>
								</xsl:when>
								<xsl:otherwise>
									<td><center>
									<xsl:value-of select="@description"/></center></td>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
						<!--発表・更新日時-->
						<td><xsl:value-of select="substring(../../../../jmx_mete:DateTime,12,2)"/><xsl:text>時</xsl:text><xsl:value-of select="substring(../../../../jmx_mete:DateTime,15,2)"/><xsl:text>分</xsl:text>
						<xsl:value-of select="../../../../jmx_mete:Status"/></td>
					</tr>
				</xsl:for-each>
					
			
				<!--視程の時系列値を抽出-->
				<xsl:if test="count(jmx_mete:Property/jmx_mete:VisibilityPart/jmx_mete:Base/jmx_eb:Visibility)>0">
					<tr>					
					<th>
						<xsl:value-of select="jmx_mete:Property/jmx_mete:VisibilityPart/jmx_mete:Base/jmx_eb:Visibility/@type"/>
					</th>
						<xsl:for-each select="jmx_mete:Property/jmx_mete:VisibilityPart/jmx_mete:Base/jmx_eb:Visibility">
							<xsl:choose>
								<xsl:when test="count(@description)=0">
									<td colspan="1"><center><xsl:text>－</xsl:text></center></td>
								</xsl:when>
								<xsl:otherwise>
									<td colspan="1"><center><xsl:value-of select="@description" /></center></td>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
						<!--発表・更新日時-->
						<td><xsl:value-of select="substring(./jmx_mete:DateTime,12,2)"/><xsl:text>時</xsl:text><xsl:value-of select="substring(./jmx_mete:DateTime,15,2)"/><xsl:text>分</xsl:text>
						<xsl:value-of select="./jmx_mete:Status"/></td>
					</tr>
				</xsl:if>

				<!--地域ごとの時系列値を抽出-->
				<xsl:for-each select="jmx_mete:Property/jmx_mete:VisibilityPart/jmx_mete:Base/jmx_mete:Local">
					<tr>
					<th>
						<xsl:value-of select="jmx_eb:Visibility/@type"/>
						<xsl:text>（</xsl:text><xsl:value-of select="jmx_mete:AreaName"/><xsl:text>）</xsl:text>
					</th>
						<xsl:for-each select="jmx_eb:Visibility">
							<xsl:choose>
								<xsl:when test="count(@description)=0">
									<td colspan="1"><center><xsl:text>－</xsl:text></center></td>
								</xsl:when>
								<xsl:otherwise>
									<td colspan="1"><center>
									<xsl:value-of select="@description"/></center></td>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
						<!--発表・更新日時-->
						<td><xsl:value-of select="substring(../../../../jmx_mete:DateTime,12,2)"/><xsl:text>時</xsl:text><xsl:value-of select="substring(../../../../jmx_mete:DateTime,15,2)"/><xsl:text>分</xsl:text>
						<xsl:value-of select="../../../../jmx_mete:Status"/></td>
					</tr>
				</xsl:for-each>
				
				<!--雷、融雪、なだれ、着氷、着雪、霜、低温の量的予想は行わない。-->
				
			</tbody>			
	</xsl:template>
<!--ピーク時間の抽出-->
	<xsl:template name="Peak_temp">
		<xsl:text>　※</xsl:text>	
		<xsl:text>現象のピークは</xsl:text>
		<xsl:value-of select="jmx_mete:Property/jmx_mete:SignificancyPart/jmx_mete:Base/jmx_mete:PeakTime/jmx_mete:Date"/>
		<xsl:value-of select="jmx_mete:Property/jmx_mete:SignificancyPart/jmx_mete:Base/jmx_mete:PeakTime/jmx_mete:Term"/>
	</xsl:template>

<!--地域ごとのピーク時間の抽出-->
	<xsl:template name="PeakL_temp">
		<xsl:text>　※</xsl:text>	
		<xsl:value-of select="./jmx_mete:AreaName"/>
		<xsl:text>での現象のピークは</xsl:text>
		<xsl:value-of select="./jmx_mete:PeakTime/jmx_mete:Date"/>
		<xsl:value-of select="./jmx_mete:PeakTime/jmx_mete:Term"/>
	</xsl:template>
	
<!--風向・風速の時系列データの取得-->	
	<xsl:template name="wind_tmp">
		<xsl:param name="time" select="position()" /> 
		<xsl:choose>
			<xsl:when test="count(@description)=0">
				<td><center><xsl:text>－</xsl:text></center></td>
			</xsl:when>
			<xsl:otherwise>
				<td><center>
				<xsl:value-of select="@description"/><br/>
				<xsl:value-of select="../../../jmx_mete:WindSpeedPart/jmx_mete:Base/jmx_eb:WindSpeed[$time]/@description"/>
				</center></td>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
		
	<xsl:template name="windL_tmp">
		<xsl:param name="time" select="position()" /> 
		<xsl:param name="Local_Area" /> 
		<xsl:choose>
			<xsl:when test="count(@description)=0">
				<td><center><xsl:text>－</xsl:text></center></td>
			</xsl:when>
			<xsl:otherwise>
				<td><center>
				<xsl:value-of select="@description"/><br/>
				<xsl:value-of select="../../../../jmx_mete:WindSpeedPart/jmx_mete:Base/jmx_mete:Local[jmx_mete:AreaName=$Local_Area]/jmx_eb:WindSpeed[$time]/@description"/>
				</center></td>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

<!--風雪フラグの判定-->
	<xsl:template name="SnowStormFlag">
		<xsl:param name="time" select="position()" /> 
		<xsl:if test="../../../../../jmx_mete:Kind/jmx_mete:Property/jmx_mete:WindSpeedPart/jmx_mete:Base/jmx_eb:WindSpeed[$time]/@condition='風雪'">
			<font color="blue" size="-1"><xsl:text>（風雪）</xsl:text></font>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="SnowStormFlagL">
		<xsl:param name="time" select="position()" /> 
		<xsl:param name="Local_Area" /> 
		<xsl:if test="../../../../../../jmx_mete:Kind/jmx_mete:Property/jmx_mete:WindSpeedPart/jmx_mete:Base/jmx_mete:Local[jmx_mete:AreaName=$Local_Area]/jmx_eb:WindSpeed[$time]/@condition='風雪'">
			<font color="blue" size="-1"><xsl:text>（風雪）</xsl:text></font>
		</xsl:if>
	</xsl:template>
	
<!--予報期間以降の危険度データの取得　はない-->
	
<!--地域ごとの予報期間以降の危険度データの取得　はない-->

<!--時系列データの特記事項の抽出　はない-->

<!--地域ごとの時系列データの付加事項の抽出　はない-->

</xsl:stylesheet>
