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
  地方海上警報

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

<!--	要素なしグローバル変数	--> 
<xsl:variable name="YOUSO_NASHI" select="'NONE'"></xsl:variable>

<!-- 出力文字コード -->
<xsl:output method="html" indent="no" encoding="Shift-JIS"/>

<!-- メイン -->
<xsl:template match="/">
	<html>
	<head>
	<title><xsl:value-of select="jmx:Report/jmx:Control/jmx:Title"/><xsl:text>  </xsl:text><xsl:value-of select="jmx:Report/h:Head/h:Title"/></title>
	</head>
	<body>
			<div id="header">
			<!--	警報の対象日付の出力	-->
			<xsl:apply-templates select="jmx:Report" /><br />
			<xsl:if test="jmx:Report/h:Head/h:ValidDateTime">
				この警報の対象期間は、
				<xsl:call-template name="hiduke">
					<xsl:with-param name="DATE" select="jmx:Report/h:Head/h:ValidDateTime" />
				</xsl:call-template>
				までです。
			</xsl:if>
			</div>
			
			<!--	ホームページのメイン要素	-->
			<div id="contents">
				
				<!--	ヘッダー情報	
				海上台風警報、海上暴風警報、海上強風警報、海上風警報、
				海上うねり警報、海上着氷警報、海上濃霧警報
				の順番で検索し、存在する警報についてのみ表示をする。
				-->
				<xsl:apply-templates select="jmx:Report/h:Head/h:Headline" />
				<xsl:call-template name="newLine"/>

				<!--	気象要因	-->
				<xsl:apply-templates select="jmx:Report/b:Body/b:MeteorologicalInfos[ @type='気象要因' ]" mode="KISHOYOIN"/>
				<xsl:call-template name="newLine"/>

				<!--	警報の個別情報	-->
				<xsl:apply-templates select="jmx:Report/b:Body/b:Warning/b:Item" mode="KEIHO"/>
			</div>
	</body>
	</html>
</xsl:template>


<!--	

	個別テンプレート宣言部

-->
<!--	気象要因内容	-->
<xsl:template match="jmx_eb:Synopsis">
	<tr>
		<td><xsl:value-of select="."/></td>
	</tr>
</xsl:template>

<!--	気象要因テンプレート	-->
<xsl:template match="b:MeteorologicalInfos" mode="KISHOYOIN">
	<xsl:if test="b:MeteorologicalInfo/b:Item/b:Kind/b:Property/b:SynopsisPart/jmx_eb:Synopsis!=''">
		<table border="1">
			<tr>
				<th>気象要因</th>
			</tr>
			<xsl:apply-templates select="b:MeteorologicalInfo/b:Item/b:Kind/b:Property/b:SynopsisPart/jmx_eb:Synopsis"/>
		</table>
	</xsl:if>
</xsl:template>

<!--	警報名表示	-->
<xsl:template match="h:Name">
	<xsl:param name="KEIHOMEI">指定なし</xsl:param>
	
	<xsl:if test=".=$KEIHOMEI">
		<xsl:if test=".=$KEIHOMEI">
			<xsl:value-of select="../../h:Areas/h:Area/h:Name"/>
			<xsl:text>  </xsl:text>
		</xsl:if>
	</xsl:if>
</xsl:template>

<!--	ヘッドライン	-->
<xsl:template match="h:Headline">
	
	<!--	ヘッダー情報	
	海上台風警報、海上暴風警報、海上強風警報、海上風警報、
	海上うねり警報、
	海上着氷警報、
	海上濃霧警報
	-->
	
	<xsl:if test="h:Information/h:Item">
		<br/>
		<table border="1">
	
		<!--	警報事項の列挙	-->
		<xsl:if test="true()=true()">
			<xsl:variable name="KEIHOMEI" select="'海上台風警報'"/>
			<xsl:if test="h:Information/h:Item/h:Kind/h:Name[.=$KEIHOMEI]">
					<tr><th><xsl:value-of select="$KEIHOMEI"/></th>
						<td>
							<xsl:apply-templates select="h:Information/h:Item/h:Kind/h:Name">
								<xsl:with-param name="KEIHOMEI" select="$KEIHOMEI"/>
							</xsl:apply-templates>
						</td>
					</tr>
			</xsl:if>
		</xsl:if>

		<xsl:if test="true()=true()">
			<xsl:variable name="KEIHOMEI" select="'海上暴風警報'"/>
			<xsl:if test="h:Information/h:Item/h:Kind/h:Name[.=$KEIHOMEI]">
					<tr><th><xsl:value-of select="$KEIHOMEI"/></th>
						<td>
							<xsl:apply-templates select="h:Information/h:Item/h:Kind/h:Name">
								<xsl:with-param name="KEIHOMEI" select="$KEIHOMEI"/>
							</xsl:apply-templates>
						</td>
					</tr>
			</xsl:if>
		</xsl:if>


		<xsl:if test="true()=true()">
			<xsl:variable name="KEIHOMEI" select="'海上強風警報'"/>
			<xsl:if test="h:Information/h:Item/h:Kind/h:Name[.=$KEIHOMEI]">
					<tr><th><xsl:value-of select="$KEIHOMEI"/></th>
						<td>
							<xsl:apply-templates select="h:Information/h:Item/h:Kind/h:Name">
								<xsl:with-param name="KEIHOMEI" select="$KEIHOMEI"/>
							</xsl:apply-templates>
						</td>
					</tr>
			</xsl:if>
		</xsl:if>

		<xsl:if test="true()=true()">
			<xsl:variable name="KEIHOMEI" select="'海上風警報'"/>
			<xsl:if test="h:Information/h:Item/h:Kind/h:Name[.=$KEIHOMEI]">
					<tr><th><xsl:value-of select="$KEIHOMEI"/></th>
						<td>
							<xsl:apply-templates select="h:Information/h:Item/h:Kind/h:Name">
								<xsl:with-param name="KEIHOMEI" select="$KEIHOMEI"/>
							</xsl:apply-templates>
						</td>
					</tr>
			</xsl:if>
		</xsl:if>

		<xsl:if test="true()=true()">
			<xsl:variable name="KEIHOMEI" select="'海上うねり警報'"/>
			<xsl:if test="h:Information/h:Item/h:Kind/h:Name[.=$KEIHOMEI]">
					<tr><th><xsl:value-of select="$KEIHOMEI"/></th>
						<td>
							<xsl:apply-templates select="h:Information/h:Item/h:Kind/h:Name">
								<xsl:with-param name="KEIHOMEI" select="$KEIHOMEI"/>
							</xsl:apply-templates>
						</td>
					</tr>
			</xsl:if>
		</xsl:if>

		<xsl:if test="true()=true()">
			<xsl:variable name="KEIHOMEI" select="'海上着氷警報'"/>
			<xsl:if test="h:Information/h:Item/h:Kind/h:Name[.=$KEIHOMEI]">
					<tr><th><xsl:value-of select="$KEIHOMEI"/></th>
						<td>
							<xsl:apply-templates select="h:Information/h:Item/h:Kind/h:Name">
								<xsl:with-param name="KEIHOMEI" select="$KEIHOMEI"/>
							</xsl:apply-templates>
						</td>
					</tr>
			</xsl:if>
		</xsl:if>

		<xsl:if test="true()=true()">
			<xsl:variable name="KEIHOMEI" select="'海上濃霧警報'"/>
			<xsl:if test="h:Information/h:Item/h:Kind/h:Name[.=$KEIHOMEI]">
					<tr><th><xsl:value-of select="$KEIHOMEI"/></th>
						<td>
							<xsl:apply-templates select="h:Information/h:Item/h:Kind/h:Name">
								<xsl:with-param name="KEIHOMEI" select="$KEIHOMEI"/>
							</xsl:apply-templates>
						</td>
					</tr>
			</xsl:if>
		</xsl:if>

		</table>
	</xsl:if>

</xsl:template>


<!--	警報名・海域名・解説表示テンプレート	-->
<xsl:template match="b:Item" mode="KEIHO">
	
	<!--	警報解除　　テンプレート	-->
	<xsl:apply-templates select="b:Kind" mode="KAIJO"/>
	
	<!--	風　　テンプレート	-->
	<xsl:apply-templates select="b:Kind/b:Property/b:WindPart"/>

	<!--	濃霧テンプレート	-->
	<xsl:apply-templates select="b:Kind/b:Property/b:VisibilityPart"/>

	<!--	うねりテンプレート	-->
	<xsl:apply-templates select="b:Kind/b:Property/b:WaveHeightPart"/>

	<!--	着氷テンプレート	-->
	<xsl:apply-templates select="b:Kind/b:Property/b:IcingPart"/>
			
</xsl:template>


<!--	警報解除　　テンプレート	-->
<xsl:template match="b:Kind" mode="KAIJO">
	
	<xsl:if test="contains( b:Name, '警報解除' )">
		<table border="1">
			<tr>
				<th>海域名</th><th>警報事項</th>
			</tr>
			<tr>
				<td><xsl:value-of select="../b:Area/b:Name"/></td>
				<td><xsl:value-of select="b:Name"/></td>
			</tr>
		</table>
	</xsl:if>
	
</xsl:template>


<!--	風向風速テンプレート	-->
<xsl:template match="jmx_eb:WindSpeed">
		
		<!--	風向	-->
		<td>
			<xsl:if test="../jmx_eb:WindDirection">
				<xsl:value-of select="../jmx_eb:WindDirection"/>
			</xsl:if>
			<xsl:if test="../jmx_eb:WindDirection[ 2 ]">
				又は<xsl:value-of select="../jmx_eb:WindDirection[ 2 ]"/>
			</xsl:if>
			<xsl:if test="not(../jmx_eb:WindDirection)">
					<xsl:value-of select="$YOUSO_NASHI"/>
			</xsl:if>
		</td>
		
		<!--	風速	-->
		<td>
			<!--	はじめの風速の記述	-->
			<xsl:if test="../jmx_eb:WindSpeed[@unit='ノット'][ 1 ]">

				<xsl:value-of select="../jmx_eb:WindSpeed[@unit='ノット'][ 1 ]/@description"/>
				(<xsl:value-of select="../jmx_eb:WindSpeed[@unit='m/s'][ 1 ]/@description"/>)
			</xsl:if>
			
			<!--	2つ目の風速の記述	-->
			<xsl:if test="../jmx_eb:WindSpeed[@unit='ノット'][ 2 ]">

				<xsl:value-of select="../jmx_eb:WindSpeed[@unit='ノット'][ 2 ]/@description"/>
				(<xsl:value-of select="../jmx_eb:WindSpeed[@unit='m/s'][ 2 ]/@description"/>)
			</xsl:if>
			
			<!--	風速が？？？？の場合	-->
			<xsl:if test="count( ../jmx_eb:WindSpeed ) = 1">
				<xsl:value-of select="../jmx_eb:WindSpeed/@description"/>
			</xsl:if>
			<!--	何も無い場合	-->
			<xsl:if test="not( ../jmx_eb:WindSpeed )">
				<xsl:value-of select="$YOUSO_NASHI"/>
			</xsl:if>
		</td>
		
</xsl:template>


<!--	風内容記述	-->
<xsl:template match="b:SubArea" mode="KAZE_KEIHO">
	<xsl:param name="KAIIKI"><xsl:value-of select="b:AreaName"/></xsl:param>
	<tr>
		<!--	海域名	-->
		<td>
			<xsl:value-of select="$KAIIKI"/>
		</td>
		
		<!--	警報事項	-->
		<td>
			<xsl:value-of select="./b:Sentence"/>
		</td>
		
		<!--	実況の風向と風速の記述	-->
		<xsl:apply-templates select="./b:Base/jmx_eb:WindSpeed[ 1 ]"/>
		
		<!--	予報時間	-->
		<td>
			<xsl:choose>
				<xsl:when test="b:Becoming/b:TimeModifier">
					<xsl:value-of select="b:Becoming/b:TimeModifier"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$YOUSO_NASHI"/>
				</xsl:otherwise>
			</xsl:choose>
		</td>

		<!--	実況の風向と風速の記述	-->
		<xsl:choose>
			<xsl:when test="b:Becoming">
				<xsl:apply-templates select="b:Becoming/jmx_eb:WindSpeed[ 1 ]"/>
			</xsl:when>
			<xsl:otherwise>
				<td><xsl:value-of select="$YOUSO_NASHI"/></td><td><xsl:value-of select="$YOUSO_NASHI"/></td>
			</xsl:otherwise>
		</xsl:choose>
		<!--	注意事項	-->
		<td>
			<xsl:if test="b:Remark">
				<xsl:value-of select="b:Remark"/>
			</xsl:if>
			<xsl:if test="not(b:Remark)">
				<xsl:value-of select="$YOUSO_NASHI"/>
			</xsl:if>
		</td>
	</tr>
</xsl:template>

<!--	風関連警報	-->
<xsl:template match="b:WindPart" >
	
	<!--	警報名	-->
	<xsl:value-of select="../../../b:Kind/b:Name"/>
	<table border="1">
		<tr>
			<th>海域名</th><th>警報事項</th><th>風向（実況）</th><th>風速（実況）</th><th>予報時間</th><th>風向（予報）</th><th>風速（予報）</th><th>付加情報</th>
		</tr>

		<!--	地方海上区分の警報	-->
		<xsl:apply-templates select="b:SubArea[ 1 ]" mode="KAZE_KEIHO">
			<xsl:with-param name="KAIIKI" select="../../../b:Area/b:Name"/>
		</xsl:apply-templates>
		<!--	細かい領域の警報	-->
		<xsl:if test="b:SubArea[ 2 ]">
			<tr>
				<th>細かい領域名</th><th>警報事項</th><th>風向（実況）</th><th>風速（実況）</th><th>予報時間</th><th>風向（予報）</th><th>風速（予報）</th><th>付加情報</th>
			</tr>
			<xsl:apply-templates select="b:SubArea[ position() &gt; 1 ]" mode="KAZE_KEIHO"/>
		</xsl:if>
	</table>
	<xsl:call-template name="newLine"/>
	
</xsl:template>

<!--	濃霧記述	-->
<xsl:template match="b:SubArea" mode="NOUMU_KEIHO">
	<xsl:param name="KAIIKI"><xsl:value-of select="b:AreaName"/></xsl:param>
	<tr>
		<!--	海域名	-->
		<td><xsl:value-of select="$KAIIKI"/></td>
		
		<!--	警報事項	-->
		<td><xsl:value-of select="b:Sentence"/></td>
		
		<!--	実況視程	-->
		<td>
			<xsl:choose>
				<xsl:when test="b:Base/jmx_eb:Visibility">
					<xsl:value-of select="b:Base/jmx_eb:Visibility/@description"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$YOUSO_NASHI"/>
				</xsl:otherwise>
			</xsl:choose>
		</td>
		
		<!--	予報時間	-->
		<td>
			<xsl:if test="b:Becoming/b:TimeModifier">
				<xsl:value-of select="b:Becoming/b:TimeModifier"/>
			</xsl:if>
			<xsl:if test="not(b:Becoming/b:TimeModifier)">
				<xsl:value-of select="$YOUSO_NASHI"/>
			</xsl:if>
		</td>

		<!--	予想視程	-->
		<td>
			<xsl:choose>
				<xsl:when test="b:Becoming/jmx_eb:Visibility">
					<xsl:value-of select="b:Becoming/jmx_eb:Visibility/@description"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$YOUSO_NASHI"/>
				</xsl:otherwise>
			</xsl:choose>
		</td>
		
	</tr>
</xsl:template>

<!--	濃霧	-->
<xsl:template match="b:VisibilityPart" >
	
	<!--	警報名	-->
	<xsl:value-of select="../../../b:Kind/b:Name"/>
	<table border="1">
		<tr>
			<th>海域名</th><th>警報事項</th><th>視程（実況）</th><th>予報時間</th><th>視程（予報）</th>
		</tr>

		<!--	地方海上区分の警報	-->
		<xsl:apply-templates select="b:SubArea[ 1 ]" mode="NOUMU_KEIHO">
			<xsl:with-param name="KAIIKI" select="../../../b:Area/b:Name"/>
		</xsl:apply-templates>
		<!--	細かい領域の警報	-->
		<xsl:if test="b:SubArea[ 2 ]">
			<tr>
				<th>細かい領域名</th><th>警報事項</th><th>視程（実況）</th><th>予報時間</th><th>視程（予報）</th>
			</tr>
			<xsl:apply-templates select="b:SubArea[ position() &gt; 1 ]" mode="NOUMU_KEIHO"/>
		</xsl:if>
	</table>
	<xsl:call-template name="newLine"/>
	
</xsl:template>

<!--	うねり記述	-->
<xsl:template match="b:SubArea" mode="UNERI_KEIHO">
	<xsl:param name="KAIIKI"><xsl:value-of select="b:AreaName"/></xsl:param>
	<tr>
		<!--	海域名	-->
		<td><xsl:value-of select="$KAIIKI"/></td>
		
		<!--	警報事項	-->
		<td><xsl:value-of select="b:Sentence"/></td>
		
		<!--	実況うねり	の高さ	-->
		<td>
			<!--	はじめの　うねりの記述	-->
			<xsl:if test="b:Base/jmx_eb:WaveHeight">
				<xsl:value-of select="b:Base/jmx_eb:WaveHeight/@description"/>
			</xsl:if>
			<!--	２つ目の　うねりの記述	-->
			<xsl:if test="b:Base/jmx_eb:WaveHeight[ 2 ]">
				から<xsl:value-of select="b:Base/jmx_eb:WaveHeight/@description[ 2 ]"/>
			</xsl:if>
			
			<!--	何も無い場合	-->
			<xsl:if test="not( b:Base/jmx_eb:WaveHeight )">
				<xsl:value-of select="$YOUSO_NASHI"/>
			</xsl:if>
		</td>
		
		<!--	予報時間	-->
		<td>
			<xsl:if test="b:Becoming/b:TimeModifier">
				<xsl:value-of select="b:Becoming/b:TimeModifier"/>
			</xsl:if>
			<xsl:if test="not(b:Becoming/b:TimeModifier)">
				<xsl:value-of select="$YOUSO_NASHI"/>
			</xsl:if>
		</td>

		<!--	予想視程	-->
		<td>
			<!--	はじめの　うねりの記述	-->
			<xsl:if test="b:Becoming/jmx_eb:WaveHeight">
				<xsl:value-of select="b:Becoming/jmx_eb:WaveHeight/@description"/>
			</xsl:if>
			<!--	２つ目の　うねりの記述	-->
			<xsl:if test="b:Becoming/jmx_eb:WaveHeight[ 2 ]">
				から<xsl:value-of select="b:Becoming/jmx_eb:WaveHeight/@description[ 2 ]"/>
			</xsl:if>
			
			<!--	何も無い場合	-->
			<xsl:if test="not( b:Becoming/jmx_eb:WaveHeight )">
				<xsl:value-of select="$YOUSO_NASHI"/>
			</xsl:if>
		</td>		
	</tr>
</xsl:template>

<!--	うねり警報	-->
<xsl:template match="b:WaveHeightPart" >
	
	<!--	警報名	-->
	<xsl:value-of select="../../../b:Kind/b:Name"/>
	<table border="1">
		<tr>
			<th>海域名</th><th>警報事項</th><th>うねりの高さ（実況）</th><th>予報時間</th><th>うねりの高さ（予報）</th>
		</tr>

		<!--	地方海上区分の警報	-->
		<xsl:apply-templates select="b:SubArea[ 1 ]" mode="UNERI_KEIHO">
			<xsl:with-param name="KAIIKI" select="../../../b:Area/b:Name"/>
		</xsl:apply-templates>
		<!--	細かい領域の警報	-->
		<xsl:if test="b:SubArea[ 2 ]">
			<tr>
				<th>細かい領域名</th><th>警報事項</th><th>うねりの高さ（実況）</th><th>予報時間</th><th>うねりの高さ（予報）</th>
			</tr>
			<xsl:apply-templates select="b:SubArea[ position() &gt; 1 ]" mode="UNERI_KEIHO"/>
		</xsl:if>
	</table>
	<xsl:call-template name="newLine"/>
	
</xsl:template>


<!--	着氷記述		-->
<xsl:template match="b:SubArea" mode="CHAKUHYO_KEIHO">
	<xsl:param name="KAIIKI"><xsl:value-of select="b:AreaName"/></xsl:param>
	<tr>
		<!--	海域名	-->
		<td><xsl:value-of select="$KAIIKI"/></td>
		
		<!--	警報事項	-->
		<td><xsl:value-of select="b:Sentence"/></td>
		
		<!--	実況着氷-->
		<td>
			<xsl:choose>
				<xsl:when test="b:Base/jmx_eb:Icing">
					<xsl:value-of select="b:Base/jmx_eb:Icing/@description"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$YOUSO_NASHI"/>
				</xsl:otherwise>
			</xsl:choose>
		</td>
		
		<!--	予報時間	-->
		<td>
			<xsl:if test="b:Becoming/b:TimeModifier">
				<xsl:value-of select="b:Becoming/b:TimeModifier"/>
			</xsl:if>
			<xsl:if test="not(b:Becoming/b:TimeModifier)">
				<xsl:value-of select="$YOUSO_NASHI"/>
			</xsl:if>
		</td>

		<!--	予想着氷-->
		<td>
			<xsl:choose>
				<xsl:when test="b:Becoming/jmx_eb:Icing">
					<xsl:value-of select="b:Becoming/jmx_eb:Icing/@description"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$YOUSO_NASHI"/>
				</xsl:otherwise>
			</xsl:choose>
		</td>
		
	</tr>
</xsl:template>

<!--	着氷警報		-->
<xsl:template match="b:IcingPart" >
	
	<!--	警報名	-->
	<xsl:value-of select="../../../b:Kind/b:Name"/>
	<table border="1">
		<tr>
			<th>海域名</th><th>警報事項</th><th>着氷の強度（実況）</th><th>予報時間</th><th>着氷の強度（予報）</th>
		</tr>

		<!--	地方海上区分の警報	-->
		<xsl:apply-templates select="b:SubArea[ 1 ]" mode="CHAKUHYO_KEIHO">
			<xsl:with-param name="KAIIKI" select="../../../b:Area/b:Name"/>
		</xsl:apply-templates>
		<!--	細かい領域の警報	-->
		<xsl:if test="b:SubArea[ 2 ]">
			<tr>
				<th>細かい領域名</th><th>警報事項</th><th>着氷の強度（実況）</th><th>予報時間</th><th>着氷の強度（予報）</th>
			</tr>
			<xsl:apply-templates select="b:SubArea[ position() &gt; 1 ]" mode="CHAKUHYO_KEIHO"/>
		</xsl:if>
	</table>
	<xsl:call-template name="newLine"/>
</xsl:template>


<!--	ヘッダー部-->
<xsl:template match="jmx:Report">
	<h2>
		<xsl:value-of select="jmx:Control/jmx:Title"/><br />
	</h2>
	<xsl:value-of select="h:Head/h:Title"/><br />
	
	<xsl:if test="h:Head/h:ReportDateTime">
		<xsl:call-template name="hiduke">
			<xsl:with-param name="DATE" select="h:Head/h:ReportDateTime" />
		</xsl:call-template>
	</xsl:if>

	<xsl:value-of select="jmx:Control/jmx:PublishingOffice"/><xsl:text>発表</xsl:text>

	<xsl:if test="contains(h:Head/h:InfoType,'訂正')">
		<xsl:text>（訂正）</xsl:text>
	</xsl:if>

	<xsl:call-template name="newLine"/>

</xsl:template>

<!--
	日付フォーマット
-->
<xsl:template name="hiduke0">
	<xsl:param name="DATE">""</xsl:param>

	<xsl:value-of select="translate(substring($DATE,1,4),'0123456789', '０１２３４５６７８９')"/>
	<xsl:text>年</xsl:text>
	<xsl:value-of select="translate(substring($DATE,6,1),'0123456789', '　１２３４５６７８９')"/>
	<xsl:value-of select="translate(substring($DATE,7,1),'0123456789', '０１２３４５６７８９')"/>
	<xsl:text>月</xsl:text>
	<xsl:value-of select="translate(substring($DATE,9,1),'0123456789', '　１２３４５６７８９')"/>
	<xsl:value-of select="translate(substring($DATE,10,1),'0123456789', '０１２３４５６７８９')"/>
	<xsl:text>日</xsl:text>
	<xsl:value-of select="translate(substring($DATE,12,2),'0123456789', '０１２３４５６７８９')"/>
	<xsl:text>時</xsl:text>
	<xsl:text>(JST)</xsl:text>
</xsl:template>

<xsl:template name="hiduke">
	<xsl:param name="DATE">""</xsl:param>
	
	<xsl:text>令和</xsl:text>
	    <xsl:choose>
     <xsl:when test="substring($DATE,1,4)='2019'">元</xsl:when>
     <xsl:otherwise>
      <xsl:value-of select="translate(substring($DATE,1,4) - 2018,'0123456789', '０１２３４５６７８９')"/>
     </xsl:otherwise>
    </xsl:choose>
	<xsl:text>年</xsl:text>
	<xsl:value-of select="translate(substring($DATE,6,1),'0123456789', '　１２３４５６７８９')"/>
	<xsl:value-of select="translate(substring($DATE,7,1),'0123456789', '０１２３４５６７８９')"/>
	<xsl:text>月</xsl:text>
	<xsl:value-of select="translate(substring($DATE,9,1),'0123456789', '　１２３４５６７８９')"/>
	<xsl:value-of select="translate(substring($DATE,10,1),'0123456789', '０１２３４５６７８９')"/>
	<xsl:text>日</xsl:text>
	<xsl:value-of select="translate(substring($DATE,12,2),'0123456789', '０１２３４５６７８９')"/>
	<xsl:text>時</xsl:text>
	<xsl:value-of select="translate(substring($DATE,15,2),'0123456789', '０１２３４５６７８９')"/>
	<xsl:text>分</xsl:text>
	<xsl:text>(JST)</xsl:text>
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


<xsl:template name="newLine"><br/></xsl:template>


</xsl:stylesheet>
