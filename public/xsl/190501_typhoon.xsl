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
  台風解析・予報情報

  【更新履歴】
  2012年03月29日　Ver.1.0
  2019年04月24日　Ver.1.1 5月1日より施行される新元号への対応
  ======================================================================
-->

<!-- 名前空間の指定 気象庁使用の名前空間 -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:jmx="http://xml.kishou.go.jp/jmaxml1/" exclude-result-prefixes="jmx"
 xmlns:h="http://xml.kishou.go.jp/jmaxml1/informationBasis1/"
 xmlns:b="http://xml.kishou.go.jp/jmaxml1/body/meteorology1/"
 xmlns:jmx_eb="http://xml.kishou.go.jp/jmaxml1/elementBasis1/"
 >

<!-- 出力文字コード -->
<xsl:output method="html" indent="no" encoding="Shift-JIS"/>

<!-- メイン -->
<xsl:template match="/">
<html><head></head><body>

	<xsl:apply-templates select="jmx:Report" />
	<xsl:apply-templates select="jmx:Report/b:Body/b:MeteorologicalInfos/b:MeteorologicalInfo" />

</body></html>

</xsl:template>

<xsl:template match="jmx:Report">

	<xsl:value-of select="jmx:Control/jmx:Title" />
	<xsl:call-template name="newLine" />
	
	<xsl:call-template name="hiduke" />
	<xsl:value-of select="jmx:Control/jmx:PublishingOffice" /><xsl:text>発表</xsl:text>

	<xsl:if test="contains(h:Head/h:InfoType,'訂正')">
		<xsl:text>（訂正）</xsl:text>
	</xsl:if>

	<h2>
	<xsl:call-template name="InsertBlank">
		<xsl:with-param name="value" select="h:Head/h:Headline/h:Text" />
	</xsl:call-template>
	</h2>

	<xsl:call-template name="newLine" />


</xsl:template>

<!--body部実況と予報を繰り返し-->
<xsl:template match="jmx:Report/b:Body/b:MeteorologicalInfos/b:MeteorologicalInfo">

	<xsl:call-template name="datetime">
		<xsl:with-param name="dateTime" select="b:DateTime/@type" />
	</xsl:call-template>
	<xsl:call-template name="InsertBlank" />

	<xsl:call-template name="hiduke00">
		<xsl:with-param name="value" select="b:DateTime" />
	</xsl:call-template>
	<xsl:call-template name="newLine" />

	<xsl:apply-templates select="b:Item/b:Kind/b:Property" />
	<xsl:call-template name="newLine" />

	<!-- <xsl:apply-templates select="b:Item/b:Area" />  //-->
	<!-- <xsl:call-template name="newLine"/> //-->

	<xsl:call-template name="newLine" />

</xsl:template>


<xsl:template match="b:Item/b:Area" >
	
	<xsl:value-of select="b:Name" />
	<xsl:call-template name="InsertBlank" />
	<xsl:value-of select="jmx_eb:Circle/@type" />

	<table border='1'>
	<tr>
		<xsl:for-each select="jmx_eb:Circle/jmx_eb:BasePoint">
			<td bgcolor="lightblue" align="center"><xsl:value-of select="./@type" /></td>
		</xsl:for-each>
		<xsl:for-each select="jmx_eb:Circle/jmx_eb:Axes/jmx_eb:Axis">
			<td bgcolor="lightblue" align="center"><xsl:value-of select="jmx_eb:Direction/@type" /></td>
			<xsl:if test="jmx_eb:Radius/@unit='海里'">
				<td bgcolor="lightblue" align="center" colspan="2"><xsl:value-of select="translate(substring(jmx_eb:Radius/@type,1,11),'７０','70')" /></td>
			</xsl:if>
		</xsl:for-each>
	</tr><tr>
		<xsl:for-each select="jmx_eb:Circle/jmx_eb:BasePoint">
			<xsl:choose>
				<xsl:when test="./@type='中心位置（度）'">
					<td><xsl:call-template name="latlon01"><xsl:with-param name="latLon01" select="." /></xsl:call-template></td>
				</xsl:when>
				<xsl:otherwise>
					<td><xsl:call-template name="latlon02"><xsl:with-param name="latLon02" select="." /></xsl:call-template></td>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<xsl:for-each select="jmx_eb:Circle/jmx_eb:Axes/jmx_eb:Axis/jmx_eb:Direction">
			<xsl:choose>
				<xsl:when test=".=''">
					<td><xsl:value-of select="./@description" /></td>
				</xsl:when>
				<xsl:otherwise>
					<td><xsl:value-of select="." /><xsl:text>側</xsl:text></td>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:for-each select="../jmx_eb:Radius">
				<xsl:choose>
					<xsl:when test=".=''">
						<td><xsl:value-of select="./@description" /></td>
					</xsl:when>
					<xsl:otherwise>
						<td><xsl:value-of select="." /><xsl:value-of select="./@unit" /></td>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:for-each>
	</tr>
	</table>
	
</xsl:template>

<xsl:template match="b:Item/b:Kind/b:Property" >	<!--個々の予想-->

	<xsl:choose>
		<xsl:when test="b:Type='呼称'">
			<xsl:value-of select="b:Type" />
			<xsl:call-template name="newLine" />
			<table border='1'><tr>
				<td bgcolor="lightblue" align="center">台風番号</td>
				<td bgcolor="lightblue" colspan="2" align="center">呼名</td>
				<td bgcolor="lightblue" align="center">記事</td>
			</tr><tr>
				<td><xsl:value-of select="b:TyphoonNamePart/b:Number" /></td>
				<td><xsl:value-of select="b:TyphoonNamePart/b:Name" /></td>
				<td><xsl:value-of select="b:TyphoonNamePart/b:NameKana" /></td>
				<xsl:choose>
					<xsl:when test="b:TyphoonNamePart/b:Remark=''">
						<td><xsl:value-of select="b:TyphoonNamePart/b:Remark" /></td>
					</xsl:when>
					<xsl:otherwise>
						<td bgcolor="red"><font color="white"><b><xsl:value-of select="b:TyphoonNamePart/b:Remark" /></b></font></td>
					</xsl:otherwise>
				</xsl:choose>
			</tr></table>
		</xsl:when>
		
		<xsl:when test="b:Type='階級'">
			<xsl:value-of select="b:Type" />
			<xsl:call-template name="newLine" />
			<table border='1'><tr>
				<td bgcolor="lightblue" align="center"><xsl:value-of select="substring(b:ClassPart/jmx_eb:TyphoonClass/@type,3,4)" /></td>
				<td bgcolor="lightblue" align="center"><xsl:value-of select="substring(b:ClassPart/jmx_eb:AreaClass/@type,1,3)" /></td>
				<td bgcolor="lightblue" align="center"><xsl:value-of select="substring(b:ClassPart/jmx_eb:IntensityClass/@type,1,2)" /></td>
			</tr><tr>
				<xsl:choose>
					<xsl:when test="b:ClassPart/jmx_eb:TyphoonClass='台風(TY)'">
						<td bgcolor="red"><font color="white"><xsl:value-of select="b:ClassPart/jmx_eb:TyphoonClass" /></font></td>
					</xsl:when>
					<xsl:when test="b:ClassPart/jmx_eb:TyphoonClass='台風(STS)'">
						<td bgcolor="orange"><xsl:value-of select="b:ClassPart/jmx_eb:TyphoonClass" /></td>
					</xsl:when>
					<xsl:when test="b:ClassPart/jmx_eb:TyphoonClass='台風(TS)'">
						<td bgcolor="yellow"><xsl:value-of select="b:ClassPart/jmx_eb:TyphoonClass" /></td>
					</xsl:when>
					<xsl:when test="b:ClassPart/jmx_eb:TyphoonClass='熱帯低気圧(TD)'">
						<td bgcolor="lime"><xsl:value-of select="b:ClassPart/jmx_eb:TyphoonClass" /></td>
					</xsl:when>
					<xsl:when test="b:ClassPart/jmx_eb:TyphoonClass='温帯低気圧(LOW)'">
						<td bgcolor="purple"><font color="white"><xsl:value-of select="b:ClassPart/jmx_eb:TyphoonClass" /></font></td>
					</xsl:when>
					<xsl:when test="b:ClassPart/jmx_eb:TyphoonClass='発達した熱帯低気圧'">
						<td bgcolor="orange"><xsl:value-of select="b:ClassPart/jmx_eb:TyphoonClass" /></td>
					</xsl:when>
					<xsl:when test="b:ClassPart/jmx_eb:TyphoonClass=''">
						<td><xsl:value-of select="b:ClassPart/jmx_eb:TyphoonClass" />&#160;</td>
					</xsl:when>
					<xsl:otherwise>
						<td><xsl:value-of select="b:ClassPart/jmx_eb:TyphoonClass" /></td>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="b:ClassPart/jmx_eb:AreaClass='超大型'">
						<td bgcolor="red"><font color="white"><xsl:value-of select="b:ClassPart/jmx_eb:AreaClass" /></font></td>
					</xsl:when>
					<xsl:when test="b:ClassPart/jmx_eb:AreaClass='大型'">
						<td bgcolor="orange"><xsl:value-of select="b:ClassPart/jmx_eb:AreaClass" /></td>
					</xsl:when>
					<xsl:otherwise>
						<td><xsl:value-of select="b:ClassPart/jmx_eb:AreaClass" /></td>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="b:ClassPart/jmx_eb:IntensityClass='猛烈な'">
						<td bgcolor="red"><font color="white"><xsl:value-of select="b:ClassPart/jmx_eb:IntensityClass" /></font></td>
					</xsl:when>
					<xsl:when test="b:ClassPart/jmx_eb:IntensityClass='非常に強い'">
						<td bgcolor="orange"><xsl:value-of select="b:ClassPart/jmx_eb:IntensityClass" /></td>
					</xsl:when>
					<xsl:when test="b:ClassPart/jmx_eb:IntensityClass='強い'">
						<td bgcolor="yellow"><xsl:value-of select="b:ClassPart/jmx_eb:IntensityClass" /></td>
					</xsl:when>
					<xsl:otherwise>
						<td><xsl:value-of select="b:ClassPart/jmx_eb:IntensityClass" /></td>
					</xsl:otherwise>
				</xsl:choose>
			</tr></table>
		</xsl:when>
		
		<xsl:when test="b:Type='中心'">
		
			<xsl:choose>
				<xsl:when test="b:CenterPart/b:ProbabilityCircle/@type='予報円'">
		
				<xsl:value-of select="b:Type" />
				<xsl:call-template name="newLine" />
				<table border='1'><tr>
					<td bgcolor="lightblue" align="center" rowspan="2"><xsl:value-of select="b:CenterPart/b:ProbabilityCircle/@type" /></td>
                   			<td bgcolor="lightblue" align="center">存在地域</td>
                   			<xsl:for-each select="b:CenterPart/b:ProbabilityCircle/jmx_eb:BasePoint">
						<td bgcolor="lightblue" align="center"><xsl:text>予報円の</xsl:text><xsl:value-of select="./@type" /></td>
					</xsl:for-each>
					<xsl:for-each select="b:CenterPart/b:ProbabilityCircle/jmx_eb:Axes/jmx_eb:Axis">
						<td bgcolor="lightblue" align="center"><xsl:value-of select="jmx_eb:Direction/@type" /></td>
						<xsl:if test="jmx_eb:Radius/@unit='海里'">
							<td bgcolor="lightblue" align="center" colspan="2"><xsl:text>中心が</xsl:text><xsl:value-of select="translate(substring(jmx_eb:Radius/@type,1,7),'７０','70')" /><xsl:text>の</xsl:text><xsl:value-of select="substring(jmx_eb:Radius/@type,8,2)" /><xsl:text>で入る</xsl:text><xsl:value-of select="substring(jmx_eb:Radius/@type,10,2)" /></td>
						</xsl:if>
					</xsl:for-each>
					</tr><tr>
					<td><xsl:value-of select="b:CenterPart/b:Location" /></td>
                  			<xsl:for-each select="b:CenterPart/b:ProbabilityCircle/jmx_eb:BasePoint">
						<xsl:choose>
							<xsl:when test="./@type='中心位置（度）'">
								<td><xsl:call-template name="latlon01"><xsl:with-param name="latLon01" select="." /></xsl:call-template></td>
							</xsl:when>
							<xsl:otherwise>
								<td><xsl:call-template name="latlon02"><xsl:with-param name="latLon02" select="." /></xsl:call-template></td>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
					<xsl:for-each select="b:CenterPart/b:ProbabilityCircle/jmx_eb:Axes/jmx_eb:Axis/jmx_eb:Direction">
						<xsl:choose>
							<xsl:when test=".=''">
								<td><xsl:value-of select="./@description" /></td>
							</xsl:when>
							<xsl:otherwise>
								<td><xsl:value-of select="." /><xsl:text>側</xsl:text></td>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:for-each select="../jmx_eb:Radius">
							<xsl:choose>
								<xsl:when test=".=''">
									<td><xsl:value-of select="./@description" /></td>
								</xsl:when>
								<xsl:otherwise>
									<td><xsl:value-of select="." /><xsl:value-of select="./@unit" /></td>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:for-each>
					</tr><tr>
					<td bgcolor="lightblue" align="center"><xsl:value-of select="b:CenterPart/jmx_eb:Direction/@type"/></td>
					<td bgcolor="lightblue" align="center" colspan="2"><xsl:value-of select="b:CenterPart/jmx_eb:Speed/@type"/></td>
					<td bgcolor="lightblue" align="center"><xsl:value-of select="b:CenterPart/jmx_eb:Pressure/@type" /></td>
					</tr><tr>
					<td><xsl:value-of select="b:CenterPart/jmx_eb:Direction"/></td>
                  			<xsl:for-each select="b:CenterPart/jmx_eb:Speed">
						<xsl:choose>
							<xsl:when test=".=''">
								<td><xsl:value-of select="./@description"/></td>
							</xsl:when>
							<xsl:otherwise>
								<td><xsl:value-of select="."/><xsl:value-of select="./@unit"/></td>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
					<td><xsl:value-of select="b:CenterPart/jmx_eb:Pressure"/><xsl:value-of select="b:CenterPart/jmx_eb:Pressure/@unit"/></td>
				</tr></table>
				
				</xsl:when>
			
				<xsl:otherwise>
				<xsl:value-of select="b:Type"/>
				<xsl:call-template name="newLine"/>
				<table border='1'><tr>
					<td bgcolor="lightblue" align="center">存在地域</td>
                   			<xsl:for-each select="b:CenterPart/jmx_eb:Coordinate">
						<td bgcolor="lightblue" align="center"><xsl:value-of select="./@type"/></td>
					</xsl:for-each>
					<xsl:if test="../../../b:DateTime/@type='実況'">
						<td bgcolor="lightblue" align="center">中心位置の確度</td>
					</xsl:if>
				</tr><tr>
					<td><xsl:value-of select="b:CenterPart/b:Location"/></td>
                  			<xsl:for-each select="b:CenterPart/jmx_eb:Coordinate">
						<xsl:choose>
							<xsl:when test="./@type='中心位置（度）'">
								<td><xsl:call-template name="latlon01"><xsl:with-param name="latLon01" select="."/></xsl:call-template></td>
							</xsl:when>
							<xsl:otherwise>
								<td><xsl:call-template name="latlon02"><xsl:with-param name="latLon02" select="."/></xsl:call-template></td>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
					<xsl:if test="../../../b:DateTime/@type='実況'">
						<td><xsl:value-of select="b:CenterPart/jmx_eb:Coordinate/@condition"/></td>
					</xsl:if>
				</tr><tr>
					<td bgcolor="lightblue" align="center"><xsl:value-of select="b:CenterPart/jmx_eb:Direction/@type"/></td>
                   			<td bgcolor="lightblue" align="center" colspan="2"><xsl:value-of select="b:CenterPart/jmx_eb:Speed/@type"/></td>
					<td bgcolor="lightblue" align="center"><xsl:value-of select="b:CenterPart/jmx_eb:Pressure/@type"/></td>
				</tr><tr>
					<td><xsl:value-of select="b:CenterPart/jmx_eb:Direction"/></td>
                  			<xsl:for-each select="b:CenterPart/jmx_eb:Speed">
						<xsl:choose>
							<xsl:when test=".=''">
								<td><xsl:value-of select="./@description"/></td>
							</xsl:when>
							<xsl:otherwise>
								<td><xsl:value-of select="."/><xsl:value-of select="./@unit"/></td>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
					<td><xsl:value-of select="b:CenterPart/jmx_eb:Pressure"/><xsl:value-of select="b:CenterPart/jmx_eb:Pressure/@unit"/></td>
				</tr></table>
									
				</xsl:otherwise>
			</xsl:choose>
			
		</xsl:when>

		<xsl:when test="b:Type='風'">
		
			<xsl:value-of select="b:Type" />
			<xsl:call-template name="newLine" />
			<table border='1'><tr>
			
			<xsl:for-each select="b:WindPart/jmx_eb:WindSpeed">
				<xsl:if test="./@unit='ノット'">
					<xsl:choose>
						<xsl:when test="./@condition='中心付近'">
							<td bgcolor="lightblue" align="center" colspan="2"><xsl:text>中心付近の</xsl:text><xsl:value-of select="./@type" /></td>
						</xsl:when>
						<xsl:otherwise>
							<td bgcolor="lightblue" align="center" colspan="2"><xsl:value-of select="./@type" /></td>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:for-each>
			<tr></tr>
			<xsl:for-each select="b:WindPart/jmx_eb:WindSpeed">
				<td><xsl:value-of select="."/><xsl:value-of select="./@unit" /></td>
			</xsl:for-each>
			</tr>
			
			<xsl:for-each select="b:WarningAreaPart">
				<tr>
					<xsl:choose>
						<xsl:when test="./@type='暴風域'">
							<td bgcolor="red" align="center" rowspan="2"><font color="white"><xsl:value-of select="./@type" /></font></td>
						</xsl:when>
						<xsl:when test="./@type='強風域'">
							<td bgcolor="yellow" align="center" rowspan="2"><xsl:value-of select="./@type" /></td>
						</xsl:when>
						<xsl:when test="./@type='暴風警戒域'">
							<td bgcolor="red" align="center" rowspan="2"><font color="white"><xsl:value-of select="./@type" /></font></td>
						</xsl:when>
						<xsl:otherwise>
							<td bgcolor="lightblue" align="center" rowspan="2"><xsl:value-of select="./@type" /></td>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:for-each select="jmx_eb:Circle/jmx_eb:Axes/jmx_eb:Axis">
						<td bgcolor="lightblue" align="center"><xsl:value-of select="jmx_eb:Direction/@type" /></td>
						<xsl:if test="jmx_eb:Radius/@unit='海里'">
							<td bgcolor="lightblue" align="center" colspan="2"><xsl:value-of select="jmx_eb:Radius/@type" /></td>
						</xsl:if>
					</xsl:for-each>
				</tr><tr>
					<xsl:for-each select="jmx_eb:Circle/jmx_eb:Axes/jmx_eb:Axis/jmx_eb:Direction">
						<xsl:choose>
							<xsl:when test=".=''">
								<td><xsl:value-of select="./@description" /></td>
							</xsl:when>
							<xsl:otherwise>
								<td><xsl:value-of select="." /><xsl:text>側</xsl:text></td>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:for-each select="../jmx_eb:Radius">
							<xsl:choose>
								<xsl:when test=".=''">
									<td><xsl:value-of select="./@description" /></td>
								</xsl:when>
								<xsl:otherwise>
									<td><xsl:value-of select="." /><xsl:value-of select="./@unit" /></td>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:for-each>
				</tr>
				
			</xsl:for-each>
			
			</table>

		</xsl:when>
	</xsl:choose>



</xsl:template>





<xsl:template name="hiduke">
	<xsl:variable name="reportTime" select="h:Head/h:ReportDateTime" />
	<xsl:value-of select="substring($reportTime,1,4)" />
	<xsl:text>年</xsl:text>
	<xsl:if test="substring($reportTime,6,1)!='0'">
		<xsl:value-of select="substring($reportTime,6,1)" />
	</xsl:if>
	<xsl:value-of select="substring($reportTime,7,1)" />
	<xsl:text>月</xsl:text>
	<xsl:if test="substring($reportTime,9,1)!='0'">
		<xsl:value-of select="substring($reportTime,9,1)" />
	</xsl:if>
	<xsl:value-of select="substring($reportTime,10,1)" />
	<xsl:text>日</xsl:text>
	<xsl:value-of select="substring($reportTime,12,2)" />
	<xsl:text>時</xsl:text>
	<xsl:value-of select="substring($reportTime,15,2)" />
	<xsl:text>分</xsl:text>
	<xsl:text>　</xsl:text>
</xsl:template>

<xsl:template name="hiduke00">
	<xsl:param name="value" />
	<xsl:text>（</xsl:text>
	<xsl:value-of select="substring($value,1,4)" />
	<xsl:text>年</xsl:text>
	<xsl:if test="substring($value,6,1)!='0'">
		<xsl:value-of select="substring($value,6,1)" />
	</xsl:if>
	<xsl:value-of select="substring($value,7,1)" />
	<xsl:text>月</xsl:text>
	<xsl:if test="substring($value,9,1)!='0'">
		<xsl:value-of select="substring($value,9,1)" />
	</xsl:if>
	<xsl:value-of select="substring($value,10,1)" />
	<xsl:text>日</xsl:text>
	<xsl:value-of select="substring($value,12,2)" />
	<xsl:text>時）</xsl:text>
	<xsl:text>　</xsl:text>
</xsl:template>

<xsl:template name="datetime">
	<xsl:param name="dateTime" />
	<xsl:value-of select="translate(substring($dateTime,1,11),'０１２３４５６７８９','0123456789')" />
</xsl:template>

<xsl:template name="latlon01">
	<xsl:param name="latLon01"/>
	<xsl:value-of select="translate(substring($latLon01,1,1),'+-', '北南')" />
	<xsl:text>緯</xsl:text>
	<xsl:value-of select="substring($latLon01,2,4)" />
	<xsl:text>度&#160;</xsl:text>
	<xsl:value-of select="translate(substring($latLon01,6,1),'+-', '東西')" />
	<xsl:text>経</xsl:text>
	<xsl:value-of select="substring($latLon01,7,5)" />
	<xsl:text>度</xsl:text>
</xsl:template>

<xsl:template name="latlon02">
	<xsl:param name="latLon02"/>
	<xsl:value-of select="translate(substring($latLon02,1,1),'+-', '北南')" />
	<xsl:text>緯</xsl:text>
	<xsl:value-of select="substring($latLon02,2,2)" />
	<xsl:text>度</xsl:text>
	<xsl:value-of select="substring($latLon02,4,2)" />
	<xsl:text>分&#160;</xsl:text>
	<xsl:value-of select="translate(substring($latLon02,6,1),'+-', '東西')" />
	<xsl:text>経</xsl:text>
	<xsl:value-of select="substring($latLon02,7,3)" />
	<xsl:text>度</xsl:text>
	<xsl:value-of select="substring($latLon02,10,2)"/>
	<xsl:text>分</xsl:text>
</xsl:template>

<xsl:template name="InsertBlank">
	<xsl:param name="value" />
	<xsl:choose>
		<xsl:when test="contains($value, '&#xA;')">
			<xsl:value-of select="concat('　', substring-before($value, '&#xA;'))" />
			<xsl:call-template name="newLine" />
			<xsl:call-template name="InsertBlank">
				<xsl:with-param name="value" select="substring-after($value, '&#xA;')" />
			</xsl:call-template>
		</xsl:when>

		<xsl:otherwise>
			<xsl:value-of select="concat('　', $value)" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template name="newLine"><br /></xsl:template>


</xsl:stylesheet>
