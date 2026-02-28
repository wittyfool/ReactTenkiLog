<?xml version="1.0" encoding="utf-8"?>

<!--
  ======================================================================
  本スタイルシートは、気象庁防災情報XMLフォーマット形式電文中の全ての情
  報コンテンツを出力するもので、システム処理の動作確認など、電文処理の参
  考資料としてお使い下さい。

  なお、本スタイルシートについては、システムに直接組み込む等の方法でご利
  用になることは避けていただくなど、ご利用に当たっては十分に注意していた
  だきますよう、よろしくお願いいたします。

//書き直す必要あり
  Copyright (c) 気象庁 2012 All rights reserved.
  
  【対象情報】
  気象警報・注意報（Ｈ２７）

  【更新履歴】
  2015年09月16日　Ver.1.0
  2019年04月24日　Ver.1.1 5月1日より施行される新元号への対応
  2019年05月29日　ver.1.2 警戒レベルへの対応
  ======================================================================
-->

<xsl:stylesheet 
xmlns:jmx="http://xml.kishou.go.jp/jmaxml1/"
xmlns:jmx_ib="http://xml.kishou.go.jp/jmaxml1/informationBasis1/" 
xmlns:jmx_mete="http://xml.kishou.go.jp/jmaxml1/body/meteorology1/" 
xmlns:jmx_eb="http://xml.kishou.go.jp/jmaxml1/elementBasis1/" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" indent="yes" encoding="Shift-JIS"/>
<xsl:template match="/">

<html><head></head><body>

	<table width="90%">
		<tr><td>
		<!--ヘッダ部-->
			<xsl:apply-templates select="jmx:Report/jmx_ib:Head" />
		<!--お知らせ-->
			<xsl:apply-templates select="jmx:Report/jmx_mete:Body/jmx_mete:Notice" />
		<!--警報種別（ヘッダ部）-->
			<xsl:apply-templates select="jmx:Report/jmx_ib:Head/jmx_ib:Headline" />
		<!--ヘッダ部と本文の間の罫線-->
			<br/><hr width="70%" size="1" /><br/>
		<!--ボディ部-->
			<xsl:apply-templates select="jmx:Report/jmx_mete:Body" />
		<!--ボディ部と量的予想時系列部の間の罫線-->
			<br/><hr width="70%" size="1" /><br/>
		<!--量的予想時系列部-->
			<xsl:apply-templates select="jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos" />
		</td></tr>
	</table>
	
</body></html>
	
</xsl:template>


<!--ヘッダ部-->
	<xsl:template match="jmx_ib:Head">
		<h1>
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
	<!--注意警戒文-->
		<p class="mtx"><b>
			<xsl:text>（（</xsl:text>
			<xsl:value-of select="jmx_ib:Headline/jmx_ib:Text"/>
			<xsl:text>））</xsl:text>
		</b></p>
	</xsl:template>


<!--お知らせ-->
	<xsl:template match="jmx_mete:Notice">
		<p class="mtx">
			<b><xsl:text>お知らせ　</xsl:text></b>
			<xsl:value-of select="." />
		</p>
	</xsl:template>


<!--警報注意報（ヘッダ部）-->
	<xsl:template match="jmx_ib:Headline">
		<xsl:for-each select="jmx_ib:Information">
		<!--Informationのtype-->
			<br/>
			<p class="mtx"><b><font size="+1" color="navy">
				<xsl:text>＜</xsl:text>
				<xsl:value-of select="@type" />
				<xsl:text>＞</xsl:text>
			</font></b></p>
			<xsl:choose>
				<xsl:when test="@type != '気象警報・注意報（警報注意報種別毎）'">
				<!--標題-->
					<xsl:for-each select="jmx_ib:Item">
						<xsl:choose>
						<!--解除コードの処理-->
							<xsl:when test="jmx_ib:Kind/jmx_ib:Code = '00'">
								<xsl:value-of select="jmx_ib:Areas/jmx_ib:Area/jmx_ib:Name" />
								<xsl:text>　</xsl:text>
								<xsl:text>解除</xsl:text>
								<br/>
							</xsl:when>
						<!--解除コード以外の処理-->
							<xsl:otherwise>
							<!--領域名-->
								<xsl:value-of select="jmx_ib:Areas/jmx_ib:Area/jmx_ib:Name" />
								<xsl:text>　</xsl:text>
							<!--特別警報が発表中-->
								<xsl:if test="../../jmx_ib:Text[contains(.,'【特別警報')!=0] and ../../jmx_ib:Text[contains(.,'【特別警報解除】')=0]">
									<xsl:text>［特別警報］</xsl:text>
									<xsl:choose>
									<!--その領域に発表中の特別警報がある場合-->
										<xsl:when test="count(jmx_ib:Kind/jmx_ib:Name[contains(.,'特別')!=0])>0">
											<xsl:for-each select="jmx_ib:Kind[contains(jmx_ib:Name,'特別')!=0]">
												<xsl:value-of select="substring-before(jmx_ib:Name, '特')" />
											<!--Conditionがある場合は括弧つきで表示 -->
												<xsl:if test="count(jmx_ib:Condition)!= 0">
													<xsl:text>（</xsl:text>
													<xsl:value-of select="jmx_ib:Condition" />
													<xsl:text>）</xsl:text>
												</xsl:if>
													<xsl:if test="position() != last()">
													<xsl:text>，</xsl:text>
												</xsl:if>
											</xsl:for-each>
										</xsl:when>
								<!--特別警報が発表されていない領域には”なし”を記載-->
										<xsl:otherwise>
											<xsl:text>なし</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								<xsl:text>　　</xsl:text>
								</xsl:if>
								<xsl:if test="contains(../../jmx_ib:Information/@type,'特別警報報知')=0">
								<!--xsl:if test="1=1"-->
							<!--警報-->
								<xsl:text>［警報］</xsl:text>
								<xsl:choose>
								<!--発表中の警報がある場合-->
									<xsl:when test="count(jmx_ib:Kind/jmx_ib:Name[contains(.,'警')!=0 and contains(.,'特別')=0])>0">
										<xsl:for-each select="jmx_ib:Kind[contains(jmx_ib:Name,'警')!=0 and contains(.,'特別')=0]">
											<xsl:value-of select="substring-before(jmx_ib:Name, '警')" />
										<!--Conditionがある場合は括弧つきで表示 -->
											<xsl:if test="count(jmx_ib:Condition)!= 0">
												<xsl:text>（</xsl:text>
												<xsl:value-of select="jmx_ib:Condition" />
												<xsl:text>）</xsl:text>
											</xsl:if>
											<xsl:if test="position() != last()">
												<xsl:text>，</xsl:text>
											</xsl:if>
										</xsl:for-each>
									</xsl:when>
								<!--発表中の警報がない場合-->
									<xsl:otherwise>
										<xsl:text>なし</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:text>　　</xsl:text>
							<!--注意報-->
								<xsl:text>［注意報］</xsl:text>
								<xsl:choose>
								<!--発表中の注意報がある場合-->
									<xsl:when test="count(jmx_ib:Kind/jmx_ib:Name[contains(.,'注')!=0])>0">
										<xsl:for-each select="jmx_ib:Kind[contains(jmx_ib:Name,'注')!=0]">
											<xsl:value-of select="substring-before(jmx_ib:Name, '注')" />
											<xsl:if test="position() != last()">
												<xsl:text>，</xsl:text>
											</xsl:if>
										</xsl:for-each>
									</xsl:when>
								<!--発表中の注意報がない場合-->
									<xsl:otherwise>
										<xsl:text>なし</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
								</xsl:if>
								<br/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:when>
			<!--警報注意報種別毎-->
				<xsl:otherwise>
					<xsl:for-each select="jmx_ib:Item">
					<xsl:sort select="jmx_ib:Areas/jmx_ib:Area/jmx_ib:Code" />
						<xsl:value-of select="jmx_ib:Kind/jmx_ib:Name" />
						<xsl:if test="(jmx_ib:Kind/jmx_ib:Code = '03' or jmx_ib:Kind/jmx_ib:Code = '33') and count(jmx_ib:Kind/jmx_ib:Condition) != 0">
							<xsl:text>（</xsl:text>
							<xsl:value-of select="jmx_ib:Kind/jmx_ib:Condition" />
							<xsl:text>）</xsl:text>
						</xsl:if>
						<xsl:text>　　</xsl:text>
						<xsl:for-each select="jmx_ib:Areas/jmx_ib:Area">
							<xsl:value-of select="jmx_ib:Name" />
							<xsl:text>　</xsl:text>
						</xsl:for-each>
					<br/>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>


<!--ボディ部-->
	<xsl:template match="jmx_mete:Body">
		<xsl:for-each select="jmx_mete:Warning">
		<!--Warningのtype-->
			<br/>
			<p class="mtx"><b><font size="+1" color="navy">
				<xsl:text>＜</xsl:text>
				<xsl:value-of select="@type" />
				<xsl:text>＞</xsl:text>
			</font></b></p>
			<xsl:for-each select="jmx_mete:Item">
			<!--領域名-->
				<b><xsl:value-of select="jmx_mete:Area/jmx_mete:Name" /></b>
				<xsl:text>　</xsl:text>
			<!--警報注意報-->
				<xsl:choose>
					<xsl:when test="count(jmx_mete:Kind/jmx_mete:Name) > 0">
						<xsl:call-template name="Status_temp">
							<xsl:with-param name="status_param">発表</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="Status_temp">
							<xsl:with-param name="status_param">継続</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="Status_temp">
							<xsl:with-param name="status_param">特別警報から警報</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="Status_temp">
							<xsl:with-param name="status_param">特別警報から注意報</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="Status_temp">
							<xsl:with-param name="status_param">警報から注意報</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="Status_temp">
							<xsl:with-param name="status_param">解除</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="jmx_mete:Kind/jmx_mete:Status" />
					</xsl:otherwise>
				</xsl:choose>
				<br/>
			<!--前回発表状況-->
				<xsl:apply-templates select="jmx_mete:Kind/jmx_mete:LastKind" mode="LastKind_temp" />
			<!--発表切替の可能性-->
				<xsl:apply-templates select="jmx_mete:Kind/jmx_mete:NextKinds" mode="NextKinds_temp" />
			<!--特記事項-->
				<xsl:apply-templates select="jmx_mete:Kind/jmx_mete:Attention" mode="Attention_temp"/>
			<!--付加事項-->
				<xsl:apply-templates select="jmx_mete:Kind/jmx_mete:Addition" mode="Addition_temp" />
			<!-- 警戒レベル -->
				<xsl:call-template name="WarningLevel_temp" />
				<br/>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>

<!-- 警戒レベル -->
	<xsl:template name="WarningLevel_temp">
		<xsl:variable name="level1" select="'警戒レベル１（災害への心構えを高める状況）'"/>
		<xsl:variable name="level2" select="'警戒レベル２（避難行動の確認が必要とされる状況）'"/>
		<xsl:variable name="level3" select="'警戒レベル３相当（高齢者の避難が必要とされる状況）'"/>
		<xsl:variable name="level4" select="'警戒レベル４相当（避難が必要とされる状況）'"/>
		<xsl:variable name="level5" select="'警戒レベル５相当（災害がすでに発生している状況）'"/>
		<b><xsl:text>［警戒レベル］</xsl:text></b><br/>
		<!-- 土砂災害の警戒レベル判定 -->
		<xsl:choose>
			<!-- 大雨（土砂災害）特別警報 -->
			<xsl:when test="count(jmx_mete:Kind/jmx_mete:Code[.='33']) > 0">
				<xsl:choose>
					<!-- 波浪、暴風（雪）、高潮特別警報も発表 -->
					<xsl:when test="count(jmx_mete:Kind/jmx_mete:Code[.='32' or .='35' or .='37' or .='38']) > 0">
						<!-- 特に警戒すべき事項に「土砂災害」を含む -->
						<xsl:if test="contains(jmx_mete:Kind[jmx_mete:Code='33']/jmx_mete:Condition, '土砂災害')">
							<b><xsl:text>土砂災害　</xsl:text></b>
							<xsl:value-of select="$level3" /><br/>
						</xsl:if>
					</xsl:when>
					<!-- 大雨特別警報のみ発表 -->
					<xsl:otherwise>
						<!-- 特に警戒すべき事項に「土砂災害」を含む -->
						<xsl:if test="contains(jmx_mete:Kind[jmx_mete:Code='33']/jmx_mete:Condition, '土砂災害')">
							<b><xsl:text>土砂災害　</xsl:text></b>
							<xsl:value-of select="$level5" /><br/>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<!-- 大雨（土砂災害）警報 -->
			<xsl:when test="count(jmx_mete:Kind/jmx_mete:Code[.='03']) > 0">
				<!-- 特に警戒すべき事項に「土砂災害」を含む -->
				<xsl:if test="contains(jmx_mete:Kind[jmx_mete:Code='03']/jmx_mete:Condition, '土砂災害')">
					<b><xsl:text>土砂災害　</xsl:text></b>
					<xsl:value-of select="$level3" /><br/>
				</xsl:if>
			</xsl:when>
			<!-- 大雨注意報（警報予告） -->
			<xsl:when test="count(jmx_mete:Kind/jmx_mete:Code[.='10']) > 0">
				<!-- 「土砂災害注意」を含む -->
				<xsl:if test="contains(jmx_mete:Kind[jmx_mete:Code='10']/jmx_mete:Attention/jmx_mete:Note, '土砂災害注意')">
					<b><xsl:text>土砂災害　</xsl:text></b>
					<xsl:value-of select="$level2" /><br/>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
		<!-- 洪水の警戒レベル判定 -->
		<!-- 大雨特別警報発表時の判別 -->
		<xsl:variable name="tokukei_kozui">
			<xsl:choose>
				<!-- 大雨特別警報 -->
				<xsl:when test="count(jmx_mete:Kind/jmx_mete:Code[.='33']) > 0">
					<xsl:choose>
						<!-- 波浪、暴風（雪）、高潮特別警報も発表 -->
						<xsl:when test="count(jmx_mete:Kind/jmx_mete:Code[.='32' or .='35' or .='37' or .='38']) > 0">
							<!-- 記述しない -->
						</xsl:when>
						<!-- 大雨特別警報のみ発表 -->
						<xsl:otherwise>
							<!-- 特に警戒すべき事項に「浸水害」を含む -->
							<xsl:if test="contains(jmx_mete:Kind[jmx_mete:Code='33']/jmx_mete:Condition, '浸水害')">
								<xsl:value-of select="$level5" />
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<!-- 大雨特別警報 -->
			<xsl:when test="$tokukei_kozui != ''">
				<b><xsl:text>洪水　　　</xsl:text></b>
				<xsl:value-of select="$tokukei_kozui" /><br/>
			</xsl:when>
			<!-- 洪水警報 -->
			<xsl:when test="count(jmx_mete:Kind/jmx_mete:Code[.='04']) > 0">
				<b><xsl:text>洪水　　　</xsl:text></b>
				<xsl:value-of select="$level3" /><br/>
			</xsl:when>
			<!-- 洪水注意報 -->
			<xsl:when test="count(jmx_mete:Kind/jmx_mete:Code[.='18']) > 0">
				<b><xsl:text>洪水　　　</xsl:text></b>
				<xsl:value-of select="$level2" /><br/>
			</xsl:when>
		</xsl:choose>
		<!-- 高潮の警戒レベル判定 -->
		<xsl:choose>
			<!-- 高潮特別警報、高潮警報 -->
			<xsl:when test="count(jmx_mete:Kind/jmx_mete:Code[.='38' or .='08']) > 0">
				<b><xsl:text>高潮　　　</xsl:text></b>
				<xsl:value-of select="$level4" /><br/>
			</xsl:when>
			<!-- 高潮注意報 -->
			<xsl:when test="count(jmx_mete:Kind/jmx_mete:Code[.='19']) > 0">
				<xsl:choose>
					<!-- 高潮警報予告 -->
					<xsl:when test="count(jmx_mete:Kind[jmx_mete:Code='19']/jmx_mete:NextKinds/jmx_mete:NextKind[jmx_mete:Code='08']) > 0">
						<b><xsl:text>高潮　　　</xsl:text></b>
						<xsl:value-of select="$level3" /><br/>
					</xsl:when>
					<!-- 高潮警報予告以外 -->
					<xsl:otherwise>
						<b><xsl:text>高潮　　　</xsl:text></b>
						<xsl:value-of select="$level2" /><br/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

<!--Statusでまとめる-->
	<xsl:template name="Status_temp">
		<xsl:param name="status_param"/>
		<xsl:if test="count(jmx_mete:Kind/jmx_mete:Status[.=$status_param]) > 0">
			<b><xsl:text>［</xsl:text>
			<xsl:value-of select="$status_param"/>
			<xsl:text>］</xsl:text></b>
		<!--特別警報-->
			<xsl:if test="count(jmx_mete:Kind[./jmx_mete:Status=$status_param and contains(./jmx_mete:Name,'特別警報')!=0]) > 0">
				<xsl:choose>
					<xsl:when test="$status_param!='解除'">
						<b><font color="purple">
							<xsl:choose>
							<!-- 特別警報の種類が一種類のとき-->
								<xsl:when test="count(jmx_mete:Kind[./jmx_mete:Status=$status_param and contains(./jmx_mete:Name,'特')!=0])=1">
									<xsl:for-each select="jmx_mete:Kind[./jmx_mete:Status=$status_param and contains(./jmx_mete:Name,'特')!=0]">
										<xsl:value-of select="jmx_mete:Name"/>
									<!--Conditionがある場合-->
										<xsl:if test="count(jmx_mete:Condition)!= 0">
											<xsl:text>（</xsl:text>
											<xsl:value-of select="jmx_mete:Condition" />
											<xsl:text>）</xsl:text>
										</xsl:if>
									</xsl:for-each>
								</xsl:when>
							<!-- 特別警報の種類が一種類以上のとき-->
								<xsl:otherwise>
									<xsl:for-each select="jmx_mete:Kind[./jmx_mete:Status=$status_param and contains(./jmx_mete:Name,'特')!=0]">
										<xsl:value-of select="substring-before(jmx_mete:Name, '特')"/>
									<!--Conditionがある場合-->
										<xsl:if test="count(jmx_mete:Condition)!= 0">
											<xsl:text>（</xsl:text>
											<xsl:value-of select="jmx_mete:Condition" />
											<xsl:text>）</xsl:text>
										</xsl:if>
										<xsl:if test="position() != last()">
											<xsl:text>，</xsl:text>
										</xsl:if>
									</xsl:for-each>
									<xsl:text>特別警報</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</font></b>
					</xsl:when>
					<xsl:otherwise>
						<b><font color="black">
							<xsl:choose>
							<!-- 特別警報の種類が一種類のとき-->
								<xsl:when test="count(jmx_mete:Kind[./jmx_mete:Status=$status_param and contains(./jmx_mete:Name,'特')!=0])=1">
									<xsl:for-each select="jmx_mete:Kind[./jmx_mete:Status=$status_param and contains(./jmx_mete:Name,'特')!=0]">
										<xsl:value-of select="jmx_mete:Name"/>
									<!--Conditionがある場合-->
										<xsl:if test="count(jmx_mete:Condition)!= 0">
											<xsl:text>（</xsl:text>
											<xsl:value-of select="jmx_mete:Condition" />
											<xsl:text>）</xsl:text>
										</xsl:if>
									</xsl:for-each>
								</xsl:when>
							<!-- 特別警報の種類が一種類以上のとき-->
								<xsl:otherwise>
									<xsl:for-each select="jmx_mete:Kind[./jmx_mete:Status=$status_param and contains(./jmx_mete:Name,'特')!=0]">
										<xsl:value-of select="substring-before(jmx_mete:Name, '特')"/>
									<!--Conditionがある場合-->
										<xsl:if test="count(jmx_mete:Condition)!= 0">
											<xsl:text>（</xsl:text>
											<xsl:value-of select="jmx_mete:Condition" />
											<xsl:text>）</xsl:text>
										</xsl:if>
										<xsl:if test="position() != last()">
											<xsl:text>，</xsl:text>
										</xsl:if>
									</xsl:for-each>
									<xsl:text>特別警報</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</font></b>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>　</xsl:text>
			</xsl:if>
		<!--警報-->
			<xsl:if test="count(jmx_mete:Kind[./jmx_mete:Status=$status_param and contains(./jmx_mete:Name,'警')!=0 and contains(./jmx_mete:Name,'特別警報')=0]) >0 ">
				<xsl:choose>
					<xsl:when test="$status_param!='解除'">
						<b><font color="red">
							<xsl:choose>
							<!-- 警報の種類が一種類のとき-->
								<xsl:when test="count(jmx_mete:Kind[./jmx_mete:Status=$status_param and contains(./jmx_mete:Name,'警')!=0 and contains(./jmx_mete:Name,'特別警報')=0])=1">
									<xsl:for-each select="jmx_mete:Kind[./jmx_mete:Status=$status_param and contains(./jmx_mete:Name,'警')!=0 and contains(./jmx_mete:Name,'特別警報')=0]">
										<xsl:value-of select="jmx_mete:Name"/>
									<!--Conditionがある場合-->
										<xsl:if test="count(jmx_mete:Condition)!= 0">
											<xsl:text>（</xsl:text>
											<xsl:value-of select="jmx_mete:Condition" />
											<xsl:text>）</xsl:text>
										</xsl:if>
									</xsl:for-each>
								</xsl:when>
							<!-- 警報の種類が一種類以上のとき-->
								<xsl:otherwise>
									<xsl:for-each select="jmx_mete:Kind[./jmx_mete:Status=$status_param and contains(./jmx_mete:Name,'警')!=0 and contains(./jmx_mete:Name,'特別警報')=0]">
										<xsl:value-of select="substring-before(jmx_mete:Name, '警')"/>
									<!--Conditionがある場合-->
										<xsl:if test="count(jmx_mete:Condition)!= 0">
											<xsl:text>（</xsl:text>
											<xsl:value-of select="jmx_mete:Condition" />
											<xsl:text>）</xsl:text>
										</xsl:if>
										<xsl:if test="position() != last()">
											<xsl:text>，</xsl:text>
										</xsl:if>
									</xsl:for-each>
									<xsl:text>警報</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</font></b>
					</xsl:when>
					<xsl:otherwise>
						<b><font color="black">
							<xsl:choose>
							<!-- 警報の種類が一種類のとき-->
								<xsl:when test="count(jmx_mete:Kind[./jmx_mete:Status=$status_param and contains(./jmx_mete:Name,'警')!=0 and contains(./jmx_mete:Name,'特別警報')=0])=1">
									<xsl:for-each select="jmx_mete:Kind[./jmx_mete:Status=$status_param and contains(./jmx_mete:Name,'警')!=0 and contains(./jmx_mete:Name,'特別警報')=0]">
										<xsl:value-of select="jmx_mete:Name"/>
									<!--Conditionがある場合-->
										<xsl:if test="count(jmx_mete:Condition)!= 0">
											<xsl:text>（</xsl:text>
											<xsl:value-of select="jmx_mete:Condition" />
											<xsl:text>）</xsl:text>
										</xsl:if>
									</xsl:for-each>
								</xsl:when>
							<!-- 警報の種類が一種類以上のとき-->
								<xsl:otherwise>
									<xsl:for-each select="jmx_mete:Kind[./jmx_mete:Status=$status_param and contains(./jmx_mete:Name,'警')!=0 and contains(./jmx_mete:Name,'特別警報')=0]">
										<xsl:value-of select="substring-before(jmx_mete:Name, '警')"/>
									<!--Conditionがある場合-->
										<xsl:if test="count(jmx_mete:Condition)!= 0">
											<xsl:text>（</xsl:text>
											<xsl:value-of select="jmx_mete:Condition" />
											<xsl:text>）</xsl:text>
										</xsl:if>
										<xsl:if test="position() != last()">
											<xsl:text>，</xsl:text>
										</xsl:if>
									</xsl:for-each>
									<xsl:text>警報</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</font></b>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>　</xsl:text>
			</xsl:if>
		<!--注意報-->
			<xsl:if test="count(jmx_mete:Kind[./jmx_mete:Status=$status_param and contains(./jmx_mete:Name,'注')!=0]) > 0">
				<xsl:choose>
					<xsl:when test="$status_param!='解除'">
						<b><font color="blue">
							<xsl:for-each select="jmx_mete:Kind[./jmx_mete:Status=$status_param and contains(./jmx_mete:Name,'注')!=0]">
								<xsl:value-of select="substring-before(jmx_mete:Name, '注')"/>
								<xsl:if test="position() != last()">
									<xsl:text>，</xsl:text>
								</xsl:if>
							</xsl:for-each>
							<xsl:text>注意報</xsl:text>
						</font></b>
					</xsl:when>
					<xsl:otherwise>
						<b><font color="black">
							<xsl:for-each select="jmx_mete:Kind[./jmx_mete:Status=$status_param and contains(./jmx_mete:Name,'注')!=0]">
								<xsl:value-of select="substring-before(jmx_mete:Name, '注')"/>
								<xsl:if test="position() != last()">
									<xsl:text>，</xsl:text>
								</xsl:if>
							</xsl:for-each>
							<xsl:text>注意報</xsl:text>
						</font></b>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>　</xsl:text>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<!--前回発表状況-->
	<xsl:template match="jmx_mete:LastKind" mode="LastKind_temp">
		<xsl:if test="count(../jmx_mete:LastKind)!= 0">
			<xsl:if test="position() = 1">
				<b><xsl:text>　[前回発表警報等]</xsl:text></b>
			</xsl:if>
			<xsl:value-of select="jmx_mete:Name"/>
			<!--conditionがあれば抽出-->
			<xsl:if test="count(./jmx_mete:Condition)!= 0">
				<xsl:text>（</xsl:text>
				<xsl:value-of select="./jmx_mete:Condition"/>
				<xsl:text>）</xsl:text>
			</xsl:if>
			<xsl:if test="position() != last()">
				<xsl:text>，</xsl:text>
			</xsl:if>
			<xsl:if test="position() = last()">
				<br/>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<!--警報予告-->
	<xsl:template match="jmx_mete:NextKinds" mode="NextKinds_temp">
		<xsl:if test="position() = 1">
			<xsl:text>　</xsl:text>
			<b><xsl:text>警報等の発表切替の可能性</xsl:text></b>
			<br/>
		</xsl:if>
		<xsl:for-each select="jmx_mete:NextKind/jmx_mete:Name">
			<xsl:text>　</xsl:text>
			<xsl:text>※</xsl:text>
			<xsl:value-of select="../jmx_mete:Sentence"/>
			<xsl:text>　：</xsl:text>
			<xsl:value-of select="."/>

			<!--conditionがあれば抽出 -->
			<xsl:if test="count(../jmx_mete:Condition)!= 0">
				<xsl:text>（</xsl:text>
				<xsl:value-of select="../jmx_mete:Condition"/>
				<xsl:text>）</xsl:text>
			</xsl:if>
			<br/>
		</xsl:for-each>
	</xsl:template>


	<!--特記事項-->
	<xsl:template match="jmx_mete:Attention" mode="Attention_temp">
		<xsl:text>　</xsl:text>
		<b><xsl:text>特記事項</xsl:text></b>
		<xsl:for-each select="./jmx_mete:Note">
			<xsl:text>　</xsl:text>
			<xsl:value-of select="." />
		</xsl:for-each>
		<br/>
	</xsl:template>



	<!--付加事項-->
	<xsl:template match="jmx_mete:Addition" mode="Addition_temp">
		<xsl:if test="position() = 1">
			<xsl:text>　</xsl:text>
			<b><xsl:text>付加事項</xsl:text></b>
		</xsl:if>
		<xsl:for-each select="./jmx_mete:Note">
			<xsl:text>　</xsl:text>
			<xsl:value-of select="."/>
		</xsl:for-each>
		<xsl:if test="position() = last()">
			<br/>
		</xsl:if>
	</xsl:template> 


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

				<!--発表中の警報等-->
				<xsl:for-each select="jmx_mete:Kind">
					<xsl:text>　</xsl:text>
					<b>
					<xsl:value-of select="jmx_mete:Name" />
					<xsl:text>発表中</xsl:text>

					<!--conditionがあれば抽出 -->
					<xsl:if test="count(jmx_mete:Condition)!= 0">
						<xsl:text>（</xsl:text>
						<xsl:value-of select="jmx_mete:Condition"/>
						<xsl:text>）</xsl:text>
					</xsl:if>
					</b>
					
					<!--個々の現象についての書き出し -->
					<xsl:choose>
						<xsl:when test="jmx_mete:Property/jmx_mete:Type='危険度'">
							<xsl:call-template name="TimeSeriesInfo_temp"/>
							<!--予報期間以降の危険度についての書き出し-->
							<xsl:for-each select="jmx_mete:Property/jmx_mete:SubsequentSignificancyPart/jmx_mete:Base/jmx_mete:Significancy">
								<xsl:call-template name="Significancy_tmp"/>
								<br/>
							</xsl:for-each>
							<!--地域ごとの予報期間以降の危険度についての書き出し-->
							<xsl:for-each select="jmx_mete:Property/jmx_mete:SubsequentSignificancyPart/jmx_mete:Base/jmx_mete:Local/jmx_mete:Significancy">
								<xsl:call-template name="SignificancyL_tmp"/>
								<br/>
							</xsl:for-each>
							<!--現象のピーク時間があれば書き出し-->
							<xsl:if test="count(jmx_mete:Property/jmx_mete:SignificancyPart/jmx_mete:Base/jmx_mete:PeakTime)!= 0 ">
								<xsl:call-template name="Peak_temp"/>
								<br/>
							</xsl:if>
							<!--地域ごとの現象のピーク時間があれば書き出し-->
							<xsl:for-each select="jmx_mete:Property/jmx_mete:SignificancyPart/jmx_mete:Base/jmx_mete:Local">
								<xsl:if test="count(./jmx_mete:PeakTime)!= 0 ">
									<xsl:call-template name="PeakL_temp"/>
								</xsl:if>
								<br/>
							</xsl:for-each>
							<!--特記事項があれば書き出し-->
							<xsl:if test="count(jmx_mete:Property/jmx_mete:SignificancyPart/jmx_mete:Base/jmx_mete:Attention)!= 0 ">
								<xsl:call-template name="Attention_temp2"/>
								<br/>
							</xsl:if>
							<!--付加事項があれば書き出し-->	
							<xsl:apply-templates select="jmx_mete:Property/jmx_mete:SignificancyPart/jmx_mete:Base/jmx_mete:Addition" mode="Addition_temp" />
							   <!--地域ごと-->	
							<xsl:apply-templates select="jmx_mete:Property/jmx_mete:SignificancyPart/jmx_mete:Base/jmx_mete:Local/jmx_mete:Addition" mode="Addition_tempL" />
							<br/>							

						</xsl:when>
						<xsl:when test="jmx_mete:Property/jmx_mete:Type='雨'">
							<xsl:call-template name="TimeSeriesInfo_temp"/>
							<br/>
						</xsl:when>
						<xsl:when test="jmx_mete:Property/jmx_mete:Type='風'">
							<xsl:call-template name="TimeSeriesInfo_temp"/>
							<br/>
						</xsl:when>
						<xsl:when test="jmx_mete:Property/jmx_mete:Type='波'">
							<xsl:call-template name="TimeSeriesInfo_temp"/>
							<br/>
						</xsl:when>
						<xsl:when test="jmx_mete:Property/jmx_mete:Type='高潮'">
							<xsl:call-template name="TimeSeriesInfo_temp"/>
							<br/>
						</xsl:when>
						<xsl:when test="jmx_mete:Property/jmx_mete:Type='雪'">
							<xsl:call-template name="TimeSeriesInfo_temp"/>
							<br/>
						</xsl:when>
						<xsl:when test="jmx_mete:Property/jmx_mete:Type='洪水'">
							<xsl:call-template name="TimeSeriesInfo_temp"/>
							<br/>
						</xsl:when>
						<xsl:when test="jmx_mete:Property/jmx_mete:Type='雷'">
							<xsl:call-template name="TimeSeriesInfo_temp"/>
							<br/>
						</xsl:when>
						<xsl:when test="jmx_mete:Property/jmx_mete:Type='融雪'">
							<xsl:call-template name="TimeSeriesInfo_temp"/>
							<br/>
						</xsl:when>
						<xsl:when test="jmx_mete:Property/jmx_mete:Type='なだれ'">
							<xsl:call-template name="TimeSeriesInfo_temp"/>
							<br/>
						</xsl:when>
						<xsl:when test="jmx_mete:Property/jmx_mete:Type='着氷'">
							<xsl:call-template name="TimeSeriesInfo_temp"/>
							<br/>
						</xsl:when>
						<xsl:when test="jmx_mete:Property/jmx_mete:Type='着雪'">
							<xsl:call-template name="TimeSeriesInfo_temp"/>
							<br/>
						</xsl:when>
						<xsl:when test="jmx_mete:Property/jmx_mete:Type='乾燥'">
							<xsl:call-template name="TimeSeriesInfo_temp"/>
							<br/>
						</xsl:when>
						<xsl:when test="jmx_mete:Property/jmx_mete:Type='濃霧'">
							<xsl:call-template name="TimeSeriesInfo_temp"/>
							<br/>
						</xsl:when>
						<xsl:when test="jmx_mete:Property/jmx_mete:Type='霜'">
							<xsl:call-template name="TimeSeriesInfo_temp"/>
							<br/>
						</xsl:when>
						<xsl:when test="jmx_mete:Property/jmx_mete:Type='低温'">
							<xsl:call-template name="TimeSeriesInfo_temp"/>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	
	
	<!--予報時系列データの抽出-->
	<xsl:template name="TimeSeriesInfo_temp">
		<table border="1">
			<!--予報期間の書き出し-->
			<thread>
				<tr>
					<th>
					<xsl:text> </xsl:text>
					</th>
					<xsl:for-each select="../../jmx_mete:TimeDefines/jmx_mete:TimeDefine">
						<th><xsl:value-of select="./jmx_mete:Name" /></th>
					</xsl:for-each>
				</tr>
			</thread>
			<tbody>
				<!--危険度の抽出-->
				<xsl:if test="count(jmx_mete:Property/jmx_mete:SignificancyPart/jmx_mete:Base/jmx_mete:Significancy)>0">
					<xsl:for-each select="jmx_mete:Property/jmx_mete:SignificancyPart/jmx_mete:Base">
						<tr>
						<th>
							<xsl:value-of select="jmx_mete:Significancy/@type"/>
						</th>
						<xsl:for-each select="jmx_mete:Significancy">
							<td><center><xsl:value-of select="./jmx_mete:Name" /><xsl:text>（</xsl:text><xsl:value-of select="./jmx_mete:Code" /><xsl:text>）</xsl:text>
							<!--風雪フラグの判定-->
							<xsl:if test="@type='風危険度'">
								<xsl:call-template name="SnowStormFlag"/>
							</xsl:if>
							</center></td>
						</xsl:for-each>
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
							<td><center><xsl:value-of select="./jmx_mete:Name" /><xsl:text>（</xsl:text><xsl:value-of select="./jmx_mete:Code" /><xsl:text>）</xsl:text>
							<!--風雪フラグの判定-->
							<xsl:if test="@type='風危険度'">
								<xsl:call-template name="SnowStormFlagL">
									<xsl:with-param name="Local_Area" select="../jmx_mete:AreaName"/>
								</xsl:call-template>
							</xsl:if>
							</center></td>
						</xsl:for-each>
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
								<td colspan="9"><center><xsl:text>－</xsl:text></center></td>
								</xsl:when>
								<xsl:otherwise>
									<td colspan="9"><center><xsl:value-of select="@description" /></center></td>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
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
									<td colspan="9"><center><xsl:text>－</xsl:text></center></td>
								</xsl:when>
								<xsl:otherwise>
									<td colspan="9"><center>
									<xsl:value-of select="@description"/></center></td>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
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
									<td colspan="9"><center><xsl:text>－</xsl:text></center></td>
								</xsl:when>
								<xsl:otherwise>
									<td colspan="9"><center><xsl:value-of select="@description" /></center></td>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
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
									<td colspan="9"><center><xsl:text>－</xsl:text></center></td>
								</xsl:when>
								<xsl:otherwise>
									<td colspan="9"><center>
									<xsl:value-of select="@description"/></center></td>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</tr>
				</xsl:for-each>
				
				<!--雷、融雪、なだれ、着氷、着雪、霜、低温の量的予想は行わない。-->
				
			</tbody>			
		</table>
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
		<xsl:if test="../../../../jmx_mete:Property/jmx_mete:WindSpeedPart/jmx_mete:Base/jmx_eb:WindSpeed[$time]/@condition='風雪'">
			<font color="blue" size="-1"><xsl:text>（風雪）</xsl:text></font>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="SnowStormFlagL">
		<xsl:param name="time" select="position()" /> 
		<xsl:param name="Local_Area" /> 
		<xsl:if test="../../../../../jmx_mete:Property/jmx_mete:WindSpeedPart/jmx_mete:Base/jmx_mete:Local[jmx_mete:AreaName=$Local_Area]/jmx_eb:WindSpeed[$time]/@condition='風雪'">
			<font color="blue" size="-1"><xsl:text>（風雪）</xsl:text></font>
		</xsl:if>
	</xsl:template>
	
<!--予報期間以降の危険度データの取得-->
	<xsl:template name="Significancy_tmp">
		<xsl:text> 　※</xsl:text>		
		<xsl:choose>
			<xsl:when test="@type='土砂災害危険度'">
				<xsl:value-of select="../jmx_mete:Sentence"/>
				<xsl:text>（土砂災害）</xsl:text>
			</xsl:when>
			<xsl:when test="@type='浸水害危険度'">
				<xsl:value-of select="../jmx_mete:Sentence"/>
				<xsl:text>（浸水害）</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="../jmx_mete:Sentence"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
<!--地域ごとの予報期間以降の危険度データの取得-->
	<xsl:template name="SignificancyL_tmp">
		<xsl:text> 　※</xsl:text>
		<xsl:value-of select="../jmx_mete:AreaName"/>
		<xsl:text>では</xsl:text>
		<xsl:choose>
			<xsl:when test="@type='土砂災害危険度'">
				<xsl:value-of select="../jmx_mete:Sentence"/>
				<xsl:text>（土砂災害）</xsl:text>
			</xsl:when>
			<xsl:when test="@type='浸水害危険度'">
				<xsl:value-of select="../jmx_mete:Sentence"/>
				<xsl:text>（浸水害）</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="../jmx_mete:Sentence"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

<!--時系列データの特記事項の抽出-->
	<xsl:template name="Attention_temp2">
		<b><xsl:text>　特記事項　</xsl:text></b>
		<xsl:value-of select="jmx_mete:Property/jmx_mete:SignificancyPart/jmx_mete:Base[jmx_mete:Significancy/@type='土砂災害危険度']/jmx_mete:Attention/jmx_mete:Note"/>
		<xsl:if test="count(jmx_mete:Property/jmx_mete:SignificancyPart/jmx_mete:Base[jmx_mete:Significancy/@type='土砂災害危険度']/jmx_mete:Attention/jmx_mete:Note)!=0">
			<xsl:text>　</xsl:text>
		</xsl:if>
		<xsl:value-of select="jmx_mete:Property/jmx_mete:SignificancyPart/jmx_mete:Base[jmx_mete:Significancy/@type='浸水害危険度']/jmx_mete:Attention/jmx_mete:Note"/>
	</xsl:template>

<!--地域ごとの時系列データの付加事項の抽出-->
	<xsl:template match="jmx_mete:Addition" mode="Addition_tempL">
		<xsl:if test="position() = 1">
			<xsl:text>　</xsl:text>
			<b><xsl:text>付加事項　</xsl:text></b>
		</xsl:if>
		<xsl:value-of select="../jmx_mete:AreaName"/>
		<xsl:text>では</xsl:text>
		<xsl:for-each select="./jmx_mete:Note">
			<xsl:value-of select="."/>
		    <xsl:text>　</xsl:text>
		</xsl:for-each>
		<xsl:text></xsl:text>
		<xsl:if test="position() = last()">
			<br/>
		</xsl:if>
	</xsl:template> 
</xsl:stylesheet>
