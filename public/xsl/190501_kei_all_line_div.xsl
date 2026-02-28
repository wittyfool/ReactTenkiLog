<?xml version="1.0" encoding="utf-8"?>

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
  気象特別警報・警報・注意報、気象特別警報報知

  【更新履歴】
  2012年03月29日　Ver.1.0
  2013年04月12日　Ver.1.1　気象特別警報に関する情報等の変更に伴う更新
  2019年04月24日　Ver.1.2 5月1日より施行される新元号への対応
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
							<!--特別警報が発表中（VPWW53orVPNO50で注意警戒文に特別警報の記載あり）の場合-->
								<xsl:if test="../../jmx_ib:Text[contains(.,'【特別警報')!=0] and ../../jmx_ib:Text[contains(.,'【特別警報解除】')=0] and /jmx:Report/jmx:Control/jmx:Title[contains(.,'特別警報')!=0]">
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
			<!--特記事項-->
				<xsl:apply-templates select="jmx_mete:Kind/jmx_mete:Attention" mode="Attention_temp"/>
			<!--警報予告-->
				<xsl:apply-templates select="jmx_mete:Kind/jmx_mete:WarningNotice" mode="WarningNotice_temp" />
			<!--量的予想事項-->
				<xsl:apply-templates select="jmx_mete:Kind/jmx_mete:Property" mode="Property_temp" />
			<!--付加事項-->
				<xsl:apply-templates select="jmx_mete:Kind/jmx_mete:Addition" mode="Addition_temp" />
				<br/>
			</xsl:for-each>
		</xsl:for-each>
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


<!--警報予告-->
	<xsl:template match="jmx_mete:WarningNotice" mode="WarningNotice_temp">
		<xsl:choose>
			<xsl:when test="count(../../jmx_mete:Kind[count(jmx_mete:Attention)>0]) = 0">
				<xsl:text>　</xsl:text>
				<b><xsl:text>特記事項</xsl:text></b>
				<xsl:text>　</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>　　　</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="jmx_mete:StartTime/jmx_mete:Date" />
		<xsl:value-of select="jmx_mete:StartTime/jmx_mete:Term" />
		<xsl:text>までに</xsl:text>
		<xsl:value-of select="jmx_mete:Note" />
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


<!--プロパティ-->
	<xsl:template match="jmx_mete:Property" mode="Property_temp">
		<xsl:text>　</xsl:text>
		<b><xsl:value-of select="jmx_mete:Type" /></b>
		<xsl:text>　</xsl:text>
		<xsl:if test="jmx_mete:WarningPeriod">
			<xsl:text>警戒期間　</xsl:text>
			<xsl:if test="jmx_mete:WarningPeriod/jmx_mete:StartTime">
				<xsl:value-of select="jmx_mete:WarningPeriod/jmx_mete:StartTime/jmx_mete:Date" />
				<xsl:value-of select="jmx_mete:WarningPeriod/jmx_mete:StartTime/jmx_mete:Term" />
				<xsl:text>から</xsl:text>
			</xsl:if>
			<xsl:if test="jmx_mete:WarningPeriod/jmx_mete:EndTime">
				<xsl:value-of select="jmx_mete:WarningPeriod/jmx_mete:EndTime/jmx_mete:Date" />
				<xsl:if test="jmx_mete:WarningPeriod/jmx_mete:EndTime/jmx_mete:Term">
					<xsl:value-of select="jmx_mete:WarningPeriod/jmx_mete:EndTime/jmx_mete:Term" />
				</xsl:if>
				<xsl:choose>
					<xsl:when test="jmx_mete:WarningPeriod/jmx_mete:OverTime">
						<xsl:value-of select="jmx_mete:WarningPeriod/jmx_mete:OverTime" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>まで</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="jmx_mete:WarningPeriod/jmx_mete:ZoneTime">
				<xsl:value-of select="jmx_mete:WarningPeriod/jmx_mete:ZoneTime/jmx_mete:Date" />
				<xsl:value-of select="jmx_mete:WarningPeriod/jmx_mete:ZoneTime/jmx_mete:Term" />
					<xsl:if test="jmx_mete:WarningPeriod/jmx_mete:OverTime">
						<xsl:text>　以後も続く</xsl:text>
					</xsl:if>
			</xsl:if>
			<br/>
			<xsl:text>　　　</xsl:text>
		</xsl:if>
			<xsl:if test="jmx_mete:AdvisoryPeriod">
				<xsl:text>注意期間　</xsl:text>
			<xsl:if test="jmx_mete:AdvisoryPeriod/jmx_mete:StartTime">
				<xsl:value-of select="jmx_mete:AdvisoryPeriod/jmx_mete:StartTime/jmx_mete:Date" />
				<xsl:value-of select="jmx_mete:AdvisoryPeriod/jmx_mete:StartTime/jmx_mete:Term" />
				<xsl:text>から</xsl:text>
			</xsl:if>
			<xsl:if test="jmx_mete:AdvisoryPeriod/jmx_mete:EndTime">
				<xsl:value-of select="jmx_mete:AdvisoryPeriod/jmx_mete:EndTime/jmx_mete:Date" />
				<xsl:if test="jmx_mete:AdvisoryPeriod/jmx_mete:EndTime/jmx_mete:Term">
					<xsl:value-of select="jmx_mete:AdvisoryPeriod/jmx_mete:EndTime/jmx_mete:Term" />
				</xsl:if>
				<xsl:choose>
					<xsl:when test="jmx_mete:AdvisoryPeriod/jmx_mete:OverTime">
						<xsl:value-of select="jmx_mete:AdvisoryPeriod/jmx_mete:OverTime" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>まで</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="jmx_mete:AdvisoryPeriod/jmx_mete:ZoneTime">
				<xsl:value-of select="jmx_mete:AdvisoryPeriod/jmx_mete:ZoneTime/jmx_mete:Date" />
				<xsl:value-of select="jmx_mete:AdvisoryPeriod/jmx_mete:ZoneTime/jmx_mete:Term" />
					<xsl:if test="jmx_mete:AdvisoryPeriod/jmx_mete:OverTime">
						<xsl:text>　以後も続く</xsl:text>
					</xsl:if>
			</xsl:if>
			<br/>
			</xsl:if>
			<xsl:if test="jmx_mete:PeakTime">
				<xsl:text>　　　</xsl:text>
				<xsl:choose>
					<xsl:when test="jmx_mete:Type='浸水'">
						<xsl:text>雨のピークは</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>ピークは</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:value-of select="jmx_mete:PeakTime/jmx_mete:Date" />
				<xsl:value-of select="jmx_mete:PeakTime/jmx_mete:Term" />
				<br/>
			</xsl:if>
			<xsl:if test="jmx_mete:PrecipitationPart">
				<xsl:text>　　　</xsl:text>
				<xsl:value-of select="jmx_mete:PrecipitationPart/jmx_mete:Base/jmx_eb:Precipitation/@type" />
				<xsl:text>　</xsl:text>
				<xsl:value-of select="jmx_mete:PrecipitationPart/jmx_mete:Base/jmx_eb:Precipitation/@description" />
				<br/>
			</xsl:if>
			<xsl:if test="jmx_mete:WindDirectionPart">
				<xsl:text>　　　</xsl:text>
				<xsl:value-of select="jmx_mete:WindDirectionPart/jmx_mete:Base/jmx_eb:WindDirection/@description" />
				<xsl:if test="jmx_mete:WindDirectionPart/jmx_mete:Becoming">
					<xsl:text>のち</xsl:text>
					<xsl:value-of select="jmx_mete:WindDirectionPart/jmx_mete:Becoming/jmx_eb:WindDirection/@description" />
				</xsl:if>
				<br/>
			</xsl:if>
			<xsl:if test="jmx_mete:WindSpeedPart">
				<xsl:choose>
					<xsl:when test="jmx_mete:WindSpeedPart/jmx_mete:Base/jmx_mete:Local">
						<xsl:for-each select="jmx_mete:WindSpeedPart/jmx_mete:Base/jmx_mete:Local">
							<xsl:text>　　　</xsl:text>
							<xsl:value-of select="jmx_mete:AreaName"/>
							<xsl:text>　</xsl:text>
							<xsl:value-of select="jmx_eb:WindSpeed/@type" />
							<xsl:text>　</xsl:text>
							<xsl:value-of select="jmx_eb:WindSpeed/@description" />
							<br/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>　　　</xsl:text>
						<xsl:value-of select="jmx_mete:WindSpeedPart/jmx_mete:Base/jmx_eb:WindSpeed/@type" />
						<xsl:text>　</xsl:text>
						<xsl:value-of select="jmx_mete:WindSpeedPart/jmx_mete:Base/jmx_eb:WindSpeed/@description" />
						<br/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="jmx_mete:HumidityPart">
				<xsl:text>　　　</xsl:text>
				<xsl:for-each select="jmx_mete:HumidityPart/jmx_mete:Base/jmx_eb:Humidity">
					<xsl:value-of select="@type" />
					<xsl:text>　</xsl:text>
					<xsl:value-of select="@description" />
					<xsl:text>　</xsl:text>
				</xsl:for-each>
				<br/>
			</xsl:if>
			<xsl:if test="jmx_mete:TemperaturePart">
				<xsl:text>　　　</xsl:text>
				<xsl:value-of select="jmx_mete:TemperaturePart/jmx_mete:Base/jmx_eb:Temperature/@type" />
				<xsl:text>　</xsl:text>
				<xsl:value-of select="jmx_mete:TemperaturePart/jmx_mete:Base/jmx_eb:Temperature/@description" />
				<br/>
			</xsl:if>
			<xsl:if test="jmx_mete:SnowfallDepthPart">
				<xsl:choose>
					<xsl:when test="jmx_mete:SnowfallDepthPart/jmx_mete:Base/jmx_mete:Local">
						<xsl:for-each select="jmx_mete:SnowfallDepthPart/jmx_mete:Base/jmx_mete:Local">
							<xsl:text>　　　</xsl:text>
							<xsl:value-of select="jmx_mete:AreaName"/>
							<xsl:for-each select="jmx_eb:SnowfallDepth">
								<xsl:text>　</xsl:text>
								<xsl:value-of select="@type" />
								<xsl:text>　</xsl:text>
								<xsl:value-of select="@description" />
							</xsl:for-each>
							<br/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>　　</xsl:text>
						<xsl:for-each select="jmx_mete:SnowfallDepthPart/jmx_mete:Base/jmx_eb:SnowfallDepth">
							<xsl:text>　</xsl:text>
							<xsl:value-of select="@type" />
							<xsl:text>　</xsl:text>
							<xsl:value-of select="@description" />
						</xsl:for-each>
						<br/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="jmx_mete:VisibilityPart">
				<xsl:choose>
					<xsl:when test="jmx_mete:VisibilityPart/jmx_mete:Base/jmx_mete:Local">
						<xsl:for-each select="jmx_mete:VisibilityPart/jmx_mete:Base/jmx_mete:Local">
							<xsl:text>　　　</xsl:text>
							<xsl:value-of select="jmx_mete:AreaName"/>
							<xsl:text>　</xsl:text>
							<xsl:value-of select="jmx_eb:Visibility/@type" />
							<xsl:text>　</xsl:text>
							<xsl:value-of select="jmx_eb:Visibility/@description" />
							<br/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>　　　</xsl:text>
						<xsl:value-of select="jmx_mete:VisibilityPart/jmx_mete:Base/jmx_eb:Visibility/@type" />
						<xsl:text>　</xsl:text>
						<xsl:value-of select="jmx_mete:VisibilityPart/jmx_mete:Base/jmx_eb:Visibility/@description" />
						<br/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="jmx_mete:WaveHeightPart">
				<xsl:choose>
					<xsl:when test="jmx_mete:WaveHeightPart/jmx_mete:Base/jmx_mete:Local">
						<xsl:for-each select="jmx_mete:WaveHeightPart/jmx_mete:Base/jmx_mete:Local">
							<xsl:text>　　　</xsl:text>
							<xsl:value-of select="jmx_mete:AreaName"/>
							<xsl:text>　</xsl:text>
							<xsl:value-of select="jmx_eb:WaveHeight/@type" />
							<xsl:text>　</xsl:text>
							<xsl:value-of select="jmx_eb:WaveHeight/@description" />
							<br/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>　　　</xsl:text>
						<xsl:value-of select="jmx_mete:WaveHeightPart/jmx_mete:Base/jmx_eb:WaveHeight/@type" />
						<xsl:text>　</xsl:text>
						<xsl:value-of select="jmx_mete:WaveHeightPart/jmx_mete:Base/jmx_eb:WaveHeight/@description" />
						<br/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="jmx_mete:TidalLevelPart">
				<xsl:choose>
					<xsl:when test="jmx_mete:TidalLevelPart/jmx_mete:Base/jmx_mete:Local">
						<xsl:for-each select="jmx_mete:TidalLevelPart/jmx_mete:Base/jmx_mete:Local">
							<xsl:text>　　　</xsl:text>
							<xsl:value-of select="jmx_mete:AreaName"/>
							<xsl:text>　</xsl:text>
							<xsl:value-of select="jmx_eb:TidalLevel/@type" />
							<xsl:text>　</xsl:text>
							<xsl:value-of select="jmx_eb:TidalLevel/@description" />
							<br/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>　　　</xsl:text>
						<xsl:value-of select="jmx_mete:TidalLevelPart/jmx_mete:Base/jmx_eb:TidalLevel/@type" />
						<xsl:text>　</xsl:text>
						<xsl:value-of select="jmx_mete:TidalLevelPart/jmx_mete:Base/jmx_eb:TidalLevel/@description" />
						<br/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
	</xsl:template>
</xsl:stylesheet>
