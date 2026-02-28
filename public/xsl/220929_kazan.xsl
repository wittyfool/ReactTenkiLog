<?xml version="1.0" encoding="UTF-8"?>
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
　火山に関するお知らせ、噴火に関する火山観測報、火山の状況に関する解説情
  報、噴火警報・予報、火山現象に関する海上警報・海上予報、降灰予報、噴火
  速報、推定噴煙流向報

  【更新履歴】
  2012年03月29日　Ver.1.0
  2012年06月15日　Ver.1.1 ('噴火警報・予報（対象市町村の防災対応等）'への対応）
  2014年10月24日　Ver.1.2 (降灰予報への対応）
  2015年05月14日　Ver.1.3 (噴火速報への対応)
  2022年09月29日　Ver.1.4 (推定噴煙流向報への対応)
  ======================================================================
  --> 
<xsl:stylesheet xmlns:jmx="http://xml.kishou.go.jp/jmaxml1/"
 xmlns:jmx_ib="http://xml.kishou.go.jp/jmaxml1/informationBasis1/"
 xmlns:jmx_volc="http://xml.kishou.go.jp/jmaxml1/body/volcanology1/"
 xmlns:jmx_eb="http://xml.kishou.go.jp/jmaxml1/elementBasis1/"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
 <xsl:output method="html" encoding="UTF-8" />

<!-- ***** 文書のテンプレート ***** -->
<xsl:template match="/">
  <html>
    <xsl:apply-templates select="/jmx:Report"/>
  </html>
</xsl:template>

<!-- ***** 電文全体のテンプレート ***** -->
<xsl:template match="/jmx:Report">
  <head>
    <xsl:copy-of select="jmx:Control/jmx:Title"/>
  </head>
  <body>
    <xsl:apply-templates select="jmx:Control"/>
    <xsl:apply-templates select="jmx_ib:Head"/>
    <xsl:apply-templates select="jmx_volc:Body"/>
  </body>
</xsl:template>

<!-- ***** 管理部を表示するテンプレート ***** -->
<xsl:template match="jmx:Control">
	<div>
		<h1>【管理部】</h1>
		<h2><xsl:value-of select="jmx:Title"/></h2>
		<xsl:text>発信時刻(UTC)：</xsl:text><xsl:value-of select="jmx:DateTime"/><br/>
		<xsl:text>運用種別：</xsl:text><xsl:value-of select="jmx:Status"/><br/>
		<xsl:text>発信官署：</xsl:text><xsl:value-of select="jmx:EditorialOffice"/><br/>
		<xsl:text>発表官署：</xsl:text><xsl:value-of select="jmx:PublishingOffice"/><br/>
	</div>
</xsl:template>

<!-- ***** ヘッダ部を表示するテンプレート ***** -->
<xsl:template match="jmx_ib:Head">
	<div>
		<h1>【ヘッダ部】</h1>
		<h2><xsl:value-of select="jmx_ib:Title"/></h2>
		<xsl:text>発表時刻：</xsl:text>
		<xsl:call-template name="time_convert">
			<xsl:with-param name="jikoku" select="jmx_ib:ReportDateTime"/>
		</xsl:call-template><br/>
		<xsl:text>基点時刻：</xsl:text>
		<xsl:call-template name="time_convert">
			<xsl:with-param name="jikoku" select="jmx_ib:TargetDateTime"/>
		</xsl:call-template><br/>
		<xsl:text>識別情報：</xsl:text><xsl:value-of select="jmx_ib:EventID"/><br/>
		<xsl:text>情報形態：</xsl:text><xsl:value-of select="jmx_ib:InfoType"/><br/>
		<xsl:text>発表番号：</xsl:text>
		<xsl:choose>
			<xsl:when  test="jmx_ib:Serial=''">
				<xsl:text>なし</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>第</xsl:text><xsl:value-of select="jmx_ib:Serial"/><xsl:text>号</xsl:text>
			</xsl:otherwise>
		</xsl:choose><br/>
		<xsl:apply-templates select="jmx_ib:Headline"/>
	</div>
</xsl:template>

<xsl:template match="jmx_ib:Headline">
	<xsl:apply-templates select="jmx_ib:Information[@type='噴火に関する火山観測報']"/>
	<xsl:apply-templates select="jmx_ib:Information[@type='推定噴煙流向報']"/>
	<xsl:apply-templates select="jmx_ib:Text"/>
	<xsl:apply-templates select="jmx_ib:Information[@type='噴火警報・予報（対象火山）']"/>
	<xsl:apply-templates select="jmx_ib:Information[@type='火山の状況に関する解説情報（対象火山）']"/>
	<xsl:apply-templates select="jmx_ib:Information[@type='降灰予報（対象火山）']"/>
	<xsl:apply-templates select="jmx_ib:Information[@type='噴火警報・予報（対象市町村等）']"/>
	<xsl:apply-templates select="jmx_ib:Information[@type='降灰予報（対象市町村等）']"/>
	<xsl:apply-templates select="jmx_ib:Information[@type='噴火警報・予報（対象市町村の防災対応等）']"/>
	<xsl:apply-templates select="jmx_ib:Information[@type='火山現象に関する海上警報・海上予報（対象海上予報区）']"/>
	<xsl:apply-templates select="jmx_ib:Information[@type='噴火速報']"/>
</xsl:template>

<!-- ***** ヘッダ部の見出しを表示するテンプレート ***** -->
<xsl:template match="jmx_ib:Text">
	<xsl:choose>
		<xsl:when test="contains(/jmx:Report/jmx:Control/jmx:Title,'降灰予報')">
			<h3><xsl:text>＊＊（主文）＊＊</xsl:text></h3>
		</xsl:when>
		<xsl:when test="contains(/jmx:Report/jmx:Control/jmx:Title,'推定噴煙流向報')">
		</xsl:when> 
		<xsl:otherwise>
			<h3><xsl:text>＊＊（見出し）＊＊</xsl:text></h3>
		</xsl:otherwise>
	</xsl:choose>
	<p><xsl:call-template name="loop">
		<xsl:with-param name="honbun" select="current()"/>
	</xsl:call-template></p>
</xsl:template>

<!-- ***** ヘッダ部の対象火山に関する情報を表示するテンプレート ***** -->
<xsl:template match="jmx_ib:Information[@type='噴火警報・予報（対象火山）']">
	<h3><xsl:text>対象火山に関する情報</xsl:text></h3>
	<xsl:text>今回：</xsl:text>
	<xsl:value-of select="jmx_ib:Item/jmx_ib:Kind/jmx_ib:Name"/>
	<xsl:text>（コード</xsl:text>
	<xsl:value-of select="jmx_ib:Item/jmx_ib:Kind/jmx_ib:Code"/><xsl:text>） </xsl:text>
	<xsl:value-of select="jmx_ib:Item/jmx_ib:Kind/jmx_ib:Condition"/><br/>
	<xsl:text>前回：</xsl:text>
	<xsl:value-of select="jmx_ib:Item/jmx_ib:LastKind/jmx_ib:Name"/>
	<xsl:text>（コード</xsl:text>
	<xsl:value-of select="jmx_ib:Item/jmx_ib:LastKind/jmx_ib:Code"/><xsl:text>）</xsl:text><br/>
	<xsl:text>火山名：</xsl:text>
	<xsl:for-each select="jmx_ib:Item/jmx_ib:Areas[@codeType='火山名']/jmx_ib:Area">
		<xsl:if test="not(position()=1)">、</xsl:if>
		<xsl:value-of select="jmx_ib:Name"/>
		<xsl:text>（</xsl:text>
		<xsl:value-of select="jmx_ib:Code"/><xsl:text>）</xsl:text>
	</xsl:for-each><br/><br/>
</xsl:template>

<xsl:template match="jmx_ib:Information[@type='火山の状況に関する解説情報（対象火山）']">
	<h3><xsl:text>対象火山に関する情報</xsl:text></h3>
	<xsl:for-each select="jmx_ib:Item">
		<xsl:text>今回：</xsl:text>
		<xsl:value-of select="jmx_ib:Kind/jmx_ib:Name"/>
		<xsl:text>（コード</xsl:text>
		<xsl:value-of select="jmx_ib:Kind/jmx_ib:Code"/><xsl:text>） </xsl:text>
		<xsl:value-of select="jmx_ib:Kind/jmx_ib:Condition"/><br/>
		<xsl:text>前回：</xsl:text>
		<xsl:value-of select="jmx_ib:LastKind/jmx_ib:Name"/>
		<xsl:text>（コード</xsl:text>
		<xsl:value-of select="jmx_ib:LastKind/jmx_ib:Code"/><xsl:text>）</xsl:text><br/>
		<xsl:text>火山名：</xsl:text>
		<xsl:for-each select="jmx_ib:Areas[@codeType='火山名']/jmx_ib:Area">
			<xsl:if test="not(position()=1)">、</xsl:if>
			<xsl:value-of select="jmx_ib:Name"/>
			<xsl:text>（</xsl:text>
			<xsl:value-of select="jmx_ib:Code"/><xsl:text>）</xsl:text>
		</xsl:for-each><br/><br/>
	</xsl:for-each>
</xsl:template>

<xsl:template match="jmx_ib:Information[@type='降灰予報（対象火山）']">
	<h3><xsl:text>対象火山に関する情報</xsl:text></h3>
	<xsl:value-of select="jmx_ib:Item/jmx_ib:Kind/jmx_ib:Name"/>
	<xsl:text>（コード</xsl:text>
	<xsl:value-of select="jmx_ib:Item/jmx_ib:Kind/jmx_ib:Code"/>
	<xsl:text>）</xsl:text><br/>
	<xsl:text>火山名：</xsl:text>
	<xsl:value-of select="jmx_ib:Item/jmx_ib:Areas[@codeType='火山名']/jmx_ib:Area/jmx_ib:Name"/>
	<xsl:text>（</xsl:text>
	<xsl:value-of select="jmx_ib:Item/jmx_ib:Areas[@codeType='火山名']/jmx_ib:Area/jmx_ib:Code"/>
	<xsl:text>）</xsl:text><br/>
</xsl:template>

<!-- ***** ヘッダ部の対象市町村等に関する情報を表示するテンプレート ***** -->
<xsl:template match="jmx_ib:Information[@type='噴火警報・予報（対象市町村等）']">
	<h3><xsl:text>対象市町村等に関する情報</xsl:text></h3>
	<xsl:for-each select="jmx_ib:Item">
		<xsl:text>今回：</xsl:text>
		<xsl:value-of select="jmx_ib:Kind/jmx_ib:Name"/>
		<xsl:text>（コード</xsl:text>
		<xsl:value-of select="jmx_ib:Kind/jmx_ib:Code"/><xsl:text>） </xsl:text>
		<xsl:value-of select="jmx_ib:Kind/jmx_ib:Condition"/><br/>
		<xsl:text>前回：</xsl:text>
		<xsl:value-of select="jmx_ib:LastKind/jmx_ib:Name"/>
		<xsl:text>（コード</xsl:text>
		<xsl:value-of select="jmx_ib:LastKind/jmx_ib:Code"/><xsl:text>）</xsl:text><br/>
		<xsl:apply-templates select="jmx_ib:Areas[@codeType='気象・地震・火山情報／市町村等']"/>
	</xsl:for-each>
</xsl:template>

<xsl:template match="jmx_ib:Information[@type='降灰予報（対象市町村等）']">
	<h3><xsl:text>対象市町村等に関する情報</xsl:text></h3>
	<xsl:for-each select="jmx_ib:Item">
		<xsl:value-of select="jmx_ib:Kind/jmx_ib:Name"/>
		<xsl:text>（コード</xsl:text>
		<xsl:value-of select="jmx_ib:Kind/jmx_ib:Code"/><xsl:text>）</xsl:text><br/>
		<xsl:apply-templates select="jmx_ib:Areas[@codeType='気象・地震・火山情報／市町村等']"/>
	</xsl:for-each>
</xsl:template>

<!-- ***** ヘッダ部の対象市町村の防災対応等に関する情報を表示するテンプレート ***** -->
<xsl:template match="jmx_ib:Information[@type='噴火警報・予報（対象市町村の防災対応等）']">
	<h3><xsl:text>対象市町村の防災対応等に関する情報</xsl:text></h3>
	<xsl:for-each select="jmx_ib:Item">
		<xsl:text>今回：</xsl:text>
		<xsl:value-of select="jmx_ib:Kind/jmx_ib:Name"/>
		<xsl:text>（コード</xsl:text>
		<xsl:value-of select="jmx_ib:Kind/jmx_ib:Code"/><xsl:text>） </xsl:text>
		<xsl:value-of select="jmx_ib:Kind/jmx_ib:Condition"/><br/>
		<xsl:text>前回：</xsl:text>
		<xsl:value-of select="jmx_ib:LastKind/jmx_ib:Name"/>
		<xsl:text>（コード</xsl:text>
		<xsl:value-of select="jmx_ib:LastKind/jmx_ib:Code"/><xsl:text>）</xsl:text><br/>
		<xsl:apply-templates select="jmx_ib:Areas[@codeType='気象・地震・火山情報／市町村等']"/>
	</xsl:for-each>
</xsl:template>

<!-- 各市町村を表示するテンプレート -->
<xsl:template match="jmx_ib:Areas[@codeType='気象・地震・火山情報／市町村等']">
	<xsl:for-each select="jmx_ib:Area">
    <xsl:choose>
    	<xsl:when test="position()=last()">
        	<xsl:value-of select="jmx_ib:Name"/>
        	<xsl:text>（</xsl:text><xsl:value-of select="jmx_ib:Code"/><xsl:text>）</xsl:text><br/>
    	</xsl:when>
    	<xsl:otherwise>
        	<xsl:value-of select="jmx_ib:Name"/>
        	<xsl:text>（</xsl:text><xsl:value-of select="jmx_ib:Code"/><xsl:text>）</xsl:text>、
    	</xsl:otherwise>
    </xsl:choose>
  </xsl:for-each><br/>
</xsl:template>

<!-- ***** ヘッダ部の対象海上予報区に関する情報を表示するテンプレート ***** -->
<xsl:template match="jmx_ib:Information[@type='火山現象に関する海上警報・海上予報（対象海上予報区）']">
	<h3><xsl:text>対象海上予報区に関する情報</xsl:text></h3>
	<xsl:for-each select="jmx_ib:Item">
		<xsl:text>今回：</xsl:text>
		<xsl:value-of select="jmx_ib:Kind/jmx_ib:Name"/>
		<xsl:text>（コード</xsl:text>
		<xsl:value-of select="jmx_ib:Kind/jmx_ib:Code"/><xsl:text>） </xsl:text>
		<xsl:value-of select="jmx_ib:Kind/jmx_ib:Condition"/><br/>
		<xsl:text>前回：</xsl:text>
		<xsl:value-of select="jmx_ib:LastKind/jmx_ib:Name"/>
		<xsl:text>（コード</xsl:text>
		<xsl:value-of select="jmx_ib:LastKind/jmx_ib:Code"/><xsl:text>）</xsl:text><br/>
		<xsl:apply-templates select="jmx_ib:Areas[@codeType='地方海上予報区']"/>
	</xsl:for-each>
</xsl:template>

<!-- 各海上予報区を表示するテンプレート -->
<xsl:template match="jmx_ib:Areas[@codeType='地方海上予報区']">
	<xsl:for-each select="jmx_ib:Area">
    <xsl:choose>
    	<xsl:when test="position()=last()">
        	<xsl:value-of select="jmx_ib:Name"/>
        	<xsl:text>（</xsl:text><xsl:value-of select="jmx_ib:Code"/><xsl:text>）</xsl:text><br/>
    	</xsl:when>
    	<xsl:otherwise>
        	<xsl:value-of select="jmx_ib:Name"/>
        	<xsl:text>（</xsl:text><xsl:value-of select="jmx_ib:Code"/><xsl:text>）</xsl:text>、
    	</xsl:otherwise>
    </xsl:choose>
  </xsl:for-each><br/>
</xsl:template>

<!-- ***** ヘッダ部の発生現象に関する情報を表示するテンプレート ***** -->
<xsl:template match="jmx_ib:Information[@type='噴火に関する火山観測報']">
		<xsl:text>発生現象：</xsl:text>
		<xsl:value-of select="jmx_ib:Item/jmx_ib:Kind/jmx_ib:Name"/>
		<xsl:text>（</xsl:text>
		<xsl:value-of select="jmx_ib:Item/jmx_ib:Kind/jmx_ib:Code"/>
		<xsl:text>）</xsl:text><br/>
		<xsl:text>火山名　：</xsl:text>
		<xsl:value-of select="jmx_ib:Item/jmx_ib:Areas[@codeType='火山名']/jmx_ib:Area/jmx_ib:Name"/>
		<xsl:text>（</xsl:text>
		<xsl:value-of select="jmx_ib:Item/jmx_ib:Areas[@codeType='火山名']/jmx_ib:Area/jmx_ib:Code"/>
		<xsl:text>）</xsl:text><br/>
</xsl:template>

<!-- ***** ヘッダ部の発生現象に関する情報を表示するテンプレート ***** -->
<xsl:template match="jmx_ib:Information[@type='噴火速報']">
		<xsl:text>発生現象：</xsl:text>
		<xsl:value-of select="jmx_ib:Item/jmx_ib:Kind/jmx_ib:Name"/>
		<xsl:text>（</xsl:text>
		<xsl:value-of select="jmx_ib:Item/jmx_ib:Kind/jmx_ib:Code"/>
		<xsl:text>）</xsl:text><br/>
		<xsl:text>火山名　：</xsl:text>
		<xsl:value-of select="jmx_ib:Item/jmx_ib:Areas[@codeType='火山名']/jmx_ib:Area/jmx_ib:Name"/>
		<xsl:text>（</xsl:text>
		<xsl:value-of select="jmx_ib:Item/jmx_ib:Areas[@codeType='火山名']/jmx_ib:Area/jmx_ib:Code"/>
		<xsl:text>）</xsl:text><br/>
</xsl:template>

<!-- ***** ヘッダ部の発生現象に関する情報を表示するテンプレート ***** -->
<xsl:template match="jmx_ib:Information[@type='推定噴煙流向報']">
		<xsl:text>発生現象：</xsl:text>
		<xsl:value-of select="jmx_ib:Item/jmx_ib:Kind/jmx_ib:Name"/>
		<xsl:text>（</xsl:text>
		<xsl:value-of select="jmx_ib:Item/jmx_ib:Kind/jmx_ib:Code"/>
		<xsl:text>）</xsl:text><br/>
		<xsl:text>火山名　：</xsl:text>
		<xsl:value-of select="jmx_ib:Item/jmx_ib:Areas[@codeType='火山名']/jmx_ib:Area/jmx_ib:Name"/>
		<xsl:text>（</xsl:text>
		<xsl:value-of select="jmx_ib:Item/jmx_ib:Areas[@codeType='火山名']/jmx_ib:Area/jmx_ib:Code"/>
		<xsl:text>）</xsl:text><br/>
</xsl:template>

<!-- ***** 内容部を表示するテンプレート ***** -->
<xsl:template match="jmx_volc:Body">
  <div>
	<br/>
	<h1><xsl:text>【内容部】</xsl:text></h1>
	<xsl:apply-templates select="jmx_volc:Notice"/>
	<div>
		<xsl:apply-templates select="jmx_volc:VolcanoInfo[@type='噴火警報・予報（対象火山）']"/>
		<xsl:apply-templates select="jmx_volc:VolcanoInfo[@type='火山の状況に関する解説情報（対象火山）']"/>
		<xsl:apply-templates select="jmx_volc:VolcanoInfo[@type='降灰予報（対象火山）']"/>
		<xsl:apply-templates select="jmx_volc:VolcanoInfo[@type='噴火警報・予報（対象市町村等）']"/>
		<xsl:apply-templates select="jmx_volc:VolcanoInfo[@type='降灰予報（対象市町村等）']"/>
		<xsl:apply-templates select="jmx_volc:VolcanoInfo[@type='噴火警報・予報（対象市町村の防災対応等）']"/>
		<xsl:apply-templates select="jmx_volc:VolcanoInfo[@type='火山現象に関する海上警報・海上予報（対象海上予報区）']"/>
		<xsl:apply-templates select="jmx_volc:VolcanoInfo[@type='噴火に関する火山観測報']"/>
		<xsl:apply-templates select="jmx_volc:VolcanoInfo[@type='噴火速報']"/>
		<xsl:apply-templates select="jmx_volc:VolcanoInfo[@type='噴火速報（対象市町村等）']"/>
		<xsl:apply-templates select="jmx_volc:VolcanoInfo[@type='推定噴煙流向報']"/>
	</div>
	<div>
		<xsl:apply-templates select="jmx_volc:AshInfos"/>
	</div>
	<div align="left">
	  <xsl:apply-templates select="jmx_volc:VolcanoInfoContent"/>
  	  <xsl:apply-templates select="jmx_volc:VolcanoObservation"/>
	</div>
	<xsl:apply-templates select="jmx_volc:Text"/>
  </div>
</xsl:template>

<!-- ***** 内容部の対象火山に関する情報を表示するテンプレート ***** -->
<xsl:template match="jmx_volc:VolcanoInfo[@type='噴火警報・予報（対象火山）']">
	<h3><xsl:text>対象火山に関する情報</xsl:text></h3>
	<xsl:text>今回：</xsl:text>
	<xsl:value-of select="jmx_volc:Item/jmx_volc:Kind/jmx_volc:Name"/>
	<xsl:text>（コード</xsl:text>
	<xsl:value-of select="jmx_volc:Item/jmx_volc:Kind/jmx_volc:Code"/><xsl:text>） </xsl:text>
	<xsl:value-of select="jmx_volc:Item/jmx_volc:Kind/jmx_volc:Condition"/><br/>
	<xsl:text>前回：</xsl:text>
	<xsl:value-of select="jmx_volc:Item/jmx_volc:LastKind/jmx_volc:Name"/>
	<xsl:text>（コード</xsl:text>
	<xsl:value-of select="jmx_volc:Item/jmx_volc:LastKind/jmx_volc:Code"/><xsl:text>）</xsl:text><br/>
	<xsl:for-each select="jmx_volc:Item/jmx_volc:Areas[@codeType='火山名']/jmx_volc:Area">
<!--		<xsl:call-template name="volcano_convert">
			<xsl:with-param name="kazan" select="current()"/>
		</xsl:call-template><br/>-->
		<xsl:text>火山名：</xsl:text>
<!--			<xsl:if test="not(position()=1)">、</xsl:if>-->
			<xsl:value-of select="jmx_volc:Name"/>
			<xsl:text>（</xsl:text>
			<xsl:value-of select="jmx_volc:Code"/><xsl:text>）    </xsl:text>
			<xsl:text>位置：</xsl:text><xsl:value-of select="jmx_volc:Coordinate/@description"/><br/>
	</xsl:for-each><br/>
</xsl:template>

<xsl:template match="jmx_volc:VolcanoInfo[@type='火山の状況に関する解説情報（対象火山）']">
	<h3><xsl:text>対象火山に関する情報</xsl:text></h3>
	<xsl:for-each select="jmx_volc:Item">
		<xsl:text>今回：</xsl:text>
		<xsl:value-of select="jmx_volc:Kind/jmx_volc:Name"/>
		<xsl:text>（コード</xsl:text>
		<xsl:value-of select="jmx_volc:Kind/jmx_volc:Code"/><xsl:text>） </xsl:text>
		<xsl:value-of select="jmx_volc:Kind/jmx_volc:Condition"/><br/>
		<xsl:text>前回：</xsl:text>
		<xsl:value-of select="jmx_volc:LastKind/jmx_volc:Name"/>
		<xsl:text>（コード</xsl:text>
		<xsl:value-of select="jmx_volc:LastKind/jmx_volc:Code"/><xsl:text>）</xsl:text><br/>
<!--		<xsl:call-template name="volcano_convert">
			<xsl:with-param name="kazan" select="current()"/>
		</xsl:call-template><br/>-->
		<xsl:text>火山名：</xsl:text>
		<xsl:for-each select="jmx_volc:Areas[@codeType='火山名']/jmx_volc:Area">
<!--			<xsl:if test="not(position()=1)">、</xsl:if>-->
			<xsl:value-of select="jmx_volc:Name"/>
			<xsl:text>（</xsl:text>
			<xsl:value-of select="jmx_volc:Code"/><xsl:text>）    </xsl:text>
			<xsl:text>位置：</xsl:text><xsl:value-of select="jmx_volc:Coordinate/@description"/><br/>
		</xsl:for-each><br/><br/>
	</xsl:for-each>
</xsl:template>

<xsl:template match="jmx_volc:VolcanoInfo[@type='降灰予報（対象火山）']">
	<h3><xsl:text>対象火山に関する情報</xsl:text></h3>
	<xsl:value-of select="jmx_volc:Item/jmx_volc:Kind/jmx_volc:Name"/>
	<xsl:text>（コード</xsl:text>
	<xsl:value-of select="jmx_volc:Item/jmx_volc:Kind/jmx_volc:Code"/><xsl:text>）</xsl:text><br/>
	<xsl:text>火山名：</xsl:text>
	<xsl:value-of select="jmx_volc:Item/jmx_volc:Areas[@codeType='火山名']/jmx_volc:Area/jmx_volc:Name"/>
	<xsl:text>（</xsl:text>
	<xsl:value-of select="jmx_volc:Item/jmx_volc:Areas[@codeType='火山名']/jmx_volc:Area/jmx_volc:Code"/><xsl:text>）    </xsl:text>
	<xsl:text>位置：</xsl:text><xsl:value-of select="jmx_volc:Item/jmx_volc:Areas[@codeType='火山名']/jmx_volc:Area/jmx_volc:Coordinate/@description"/><br/>
	<xsl:if test="boolean(jmx_volc:Item/jmx_volc:Areas[@codeType='火山名']/jmx_volc:Area/jmx_volc:CraterName)">
		<xsl:text>火口名：</xsl:text>
		<xsl:value-of select="jmx_volc:Item/jmx_volc:Areas[@codeType='火山名']/jmx_volc:Area/jmx_volc:CraterName"/>
		<xsl:text>    位置：</xsl:text><xsl:value-of select="jmx_volc:Item/jmx_volc:Areas[@codeType='火山名']/jmx_volc:Area/jmx_volc:CraterCoordinate/@description"/><br/>
	</xsl:if>
</xsl:template>

<!-- ***** 内容部の対象市町村等に関する情報を表示するテンプレート ***** -->
<xsl:template match="jmx_volc:VolcanoInfo[@type='噴火警報・予報（対象市町村等）']">
	<h3><xsl:text>対象市町村等に関する情報</xsl:text></h3>
	<xsl:for-each select="jmx_volc:Item">
		<xsl:text>今回：</xsl:text>
		<xsl:value-of select="jmx_volc:Kind/jmx_volc:Name"/>
		<xsl:text>（コード</xsl:text>
		<xsl:value-of select="jmx_volc:Kind/jmx_volc:Code"/><xsl:text>） </xsl:text>
		<xsl:value-of select="jmx_volc:Kind/jmx_volc:Condition"/><br/>
		<xsl:text>前回：</xsl:text>
		<xsl:value-of select="jmx_volc:LastKind/jmx_volc:Name"/>
		<xsl:text>（コード</xsl:text>
		<xsl:value-of select="jmx_volc:LastKind/jmx_volc:Code"/><xsl:text>）</xsl:text><br/>
		<xsl:apply-templates select="jmx_volc:Areas[@codeType='気象・地震・火山情報／市町村等']"/>
	</xsl:for-each>
</xsl:template>

<xsl:template match="jmx_volc:VolcanoInfo[@type='降灰予報（対象市町村等）']">
	<h3><xsl:text>対象市町村等に関する情報</xsl:text></h3>
	<xsl:for-each select="jmx_volc:Item">
		<xsl:value-of select="jmx_volc:Kind/jmx_volc:Name"/>
		<xsl:text>（コード</xsl:text>
		<xsl:value-of select="jmx_volc:Kind/jmx_volc:Code"/><xsl:text>）</xsl:text><br/>
		<xsl:apply-templates select="jmx_volc:Areas[@codeType='気象・地震・火山情報／市町村等']"/>
		<br/>
	</xsl:for-each>
</xsl:template>

<!-- ***** 内容部の対象市町村の防災対応等に関する情報を表示するテンプレート ***** -->
<xsl:template match="jmx_volc:VolcanoInfo[@type='噴火警報・予報（対象市町村の防災対応等）']">
	<h3><xsl:text>対象市町村の防災対応等に関する情報</xsl:text></h3>
	<xsl:for-each select="jmx_volc:Item">
		<xsl:text>今回：</xsl:text>
		<xsl:value-of select="jmx_volc:Kind/jmx_volc:Name"/>
		<xsl:text>（コード</xsl:text>
		<xsl:value-of select="jmx_volc:Kind/jmx_volc:Code"/><xsl:text>） </xsl:text>
		<xsl:value-of select="jmx_volc:Kind/jmx_volc:Condition"/><br/>
		<xsl:text>前回：</xsl:text>
		<xsl:value-of select="jmx_volc:LastKind/jmx_volc:Name"/>
		<xsl:text>（コード</xsl:text>
		<xsl:value-of select="jmx_volc:LastKind/jmx_volc:Code"/><xsl:text>）</xsl:text><br/>
		<xsl:apply-templates select="jmx_volc:Areas[@codeType='気象・地震・火山情報／市町村等']"/>
	</xsl:for-each>
</xsl:template>

<!-- 各市町村を表示するテンプレート -->
<xsl:template match="jmx_volc:Areas[@codeType='気象・地震・火山情報／市町村等']">
	<xsl:for-each select="jmx_volc:Area">
    <xsl:choose>
    	<xsl:when test="position()=last()">
        	<xsl:value-of select="jmx_volc:Name"/>
        	<xsl:text>（</xsl:text><xsl:value-of select="jmx_volc:Code"/><xsl:text>）</xsl:text><br/>
    	</xsl:when>
    	<xsl:otherwise>
        	<xsl:value-of select="jmx_volc:Name"/>
        	<xsl:text>（</xsl:text><xsl:value-of select="jmx_volc:Code"/><xsl:text>）</xsl:text>、
    	</xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>

<!-- ***** 内容部の対象海上予報区に関する情報を表示するテンプレート ***** -->
<xsl:template match="jmx_volc:VolcanoInfo[@type='火山現象に関する海上警報・海上予報（対象海上予報区）']">
	<h3><xsl:text>対象海上予報区に関する情報</xsl:text></h3>
	<xsl:for-each select="jmx_volc:Item">
		<xsl:text>今回：</xsl:text>
		<xsl:value-of select="jmx_volc:Kind/jmx_volc:Name"/>
		<xsl:text>（コード</xsl:text>
		<xsl:value-of select="jmx_volc:Kind/jmx_volc:Code"/><xsl:text>） </xsl:text>
		<xsl:value-of select="jmx_volc:Kind/jmx_volc:Condition"/><br/>
		<xsl:text>前回：</xsl:text>
		<xsl:value-of select="jmx_volc:LastKind/jmx_volc:Name"/>
		<xsl:text>（コード</xsl:text>
		<xsl:value-of select="jmx_volc:LastKind/jmx_volc:Code"/><xsl:text>）</xsl:text><br/>
		<xsl:apply-templates select="jmx_volc:Areas[@codeType='地方海上予報区']"/>
	</xsl:for-each>
</xsl:template>

<!-- 各海上予報区を表示するテンプレート -->
<xsl:template match="jmx_volc:Areas[@codeType='地方海上予報区']">
	<xsl:for-each select="jmx_volc:Area">
    <xsl:choose>
    	<xsl:when test="position()=last()">
        	<xsl:value-of select="jmx_volc:Name"/>
        	<xsl:text>（</xsl:text><xsl:value-of select="jmx_volc:Code"/><xsl:text>）</xsl:text><br/>
    	</xsl:when>
    	<xsl:otherwise>
        	<xsl:value-of select="jmx_volc:Name"/>
        	<xsl:text>（</xsl:text><xsl:value-of select="jmx_volc:Code"/><xsl:text>）</xsl:text>、
    	</xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>

<!-- ***** 内容部の対象火山の現象に関する情報を表示するテンプレート ***** -->
<xsl:template match="jmx_volc:VolcanoInfo[@type='噴火に関する火山観測報']">
<!--	<h3><xsl:text>対象火山の現象に関する情報</xsl:text></h3>-->
	<xsl:text>発生時刻：</xsl:text>
	<xsl:call-template name="time_convert">
		<xsl:with-param name="jikoku" select="jmx_volc:Item/jmx_volc:EventTime/jmx_volc:EventDateTime"/>
	</xsl:call-template>
	<xsl:text>（UTC：</xsl:text><xsl:value-of select="jmx_volc:Item/jmx_volc:EventTime/jmx_volc:EventDateTimeUTC"/>
	<xsl:text>）</xsl:text><br/>
	<xsl:text>発生現象：</xsl:text>
	<xsl:value-of select="jmx_volc:Item/jmx_volc:Kind/jmx_volc:Name"/>
	<xsl:text>（コード</xsl:text>
	<xsl:value-of select="jmx_volc:Item/jmx_volc:Kind/jmx_volc:Code"/><xsl:text>） </xsl:text><br/>
	<xsl:call-template name="volcano_convert">
		<xsl:with-param name="kazan" select="jmx_volc:Item/jmx_volc:Areas[@codeType='火山名']/jmx_volc:Area"/>
	</xsl:call-template><br/>
</xsl:template>

<!-- ***** 内容部の対象火山の現象に関する情報を表示するテンプレート ***** -->
<xsl:template match="jmx_volc:VolcanoInfo[@type='噴火速報']">
<!--	<h3><xsl:text>対象火山の現象に関する情報</xsl:text></h3>-->
	<xsl:text>発生時刻：</xsl:text>
	<xsl:call-template name="time_convert">
		<xsl:with-param name="jikoku" select="jmx_volc:Item/jmx_volc:EventTime/jmx_volc:EventDateTime"/>
	</xsl:call-template>
	<xsl:text>（UTC：</xsl:text><xsl:value-of select="jmx_volc:Item/jmx_volc:EventTime/jmx_volc:EventDateTimeUTC"/>
	<xsl:text>）</xsl:text><br/>
	<xsl:text>発生現象：</xsl:text>
	<xsl:value-of select="jmx_volc:Item/jmx_volc:Kind/jmx_volc:Name"/>
	<xsl:text>（コード</xsl:text>
	<xsl:value-of select="jmx_volc:Item/jmx_volc:Kind/jmx_volc:Code"/><xsl:text>） </xsl:text><br/>
	<xsl:for-each select="jmx_volc:Item/jmx_volc:Areas[@codeType='火山名']/jmx_volc:Area">
		<xsl:text>火山名：</xsl:text>
			<xsl:value-of select="jmx_volc:Name"/>
			<xsl:text>（</xsl:text>
			<xsl:value-of select="jmx_volc:Code"/><xsl:text>）</xsl:text><br/>
	</xsl:for-each><br/>
<!--
	<xsl:call-template name="volcano_convert">
		<xsl:with-param name="kazan" select="jmx_volc:Item/jmx_volc:Areas[@codeType='火山名']/jmx_volc:Area"/>
	</xsl:call-template><br/>
-->
</xsl:template>

<!-- ***** 内容部の対象火山の現象に関する情報を表示するテンプレート ***** -->
<xsl:template match="jmx_volc:VolcanoInfo[@type='推定噴煙流向報']">
	<xsl:text>発生時刻：</xsl:text>
	<xsl:call-template name="time_convert">
		<xsl:with-param name="jikoku" select="jmx_volc:Item/jmx_volc:EventTime/jmx_volc:EventDateTime"/>
	</xsl:call-template>
	<xsl:text>（UTC：</xsl:text><xsl:value-of select="jmx_volc:Item/jmx_volc:EventTime/jmx_volc:EventDateTimeUTC"/>
	<xsl:text>）</xsl:text><br/>
	<xsl:text>発生現象：</xsl:text>
	<xsl:value-of select="jmx_volc:Item/jmx_volc:Kind/jmx_volc:Name"/>
	<xsl:text>（コード</xsl:text>
	<xsl:value-of select="jmx_volc:Item/jmx_volc:Kind/jmx_volc:Code"/><xsl:text>） </xsl:text><br/>
	<xsl:call-template name="volcano_convert">
		<xsl:with-param name="kazan" select="jmx_volc:Item/jmx_volc:Areas[@codeType='火山名']/jmx_volc:Area"/>
	</xsl:call-template>
	<xsl:if test="boolean(jmx_volc:Item/jmx_volc:Areas[@codeType='火山名']/jmx_volc:Area/jmx_volc:CraterName)">
		<xsl:text>火口名：</xsl:text>
		<xsl:value-of select="jmx_volc:Item/jmx_volc:Areas[@codeType='火山名']/jmx_volc:Area/jmx_volc:CraterName"/>
		<xsl:text>    位置：</xsl:text><xsl:value-of select="jmx_volc:Item/jmx_volc:Areas[@codeType='火山名']/jmx_volc:Area/jmx_volc:CraterCoordinate/@description"/><br/>
	</xsl:if><br/>
</xsl:template>


<!-- ***** 内容部の対象市町村等に関する情報を表示するテンプレート ***** -->
<xsl:template match="jmx_volc:VolcanoInfo[@type='噴火速報（対象市町村等）']">
	<h3><xsl:text>対象市町村等に関する情報</xsl:text></h3>
	<xsl:for-each select="jmx_volc:Item">
		<xsl:apply-templates select="jmx_volc:Areas[@codeType='気象・地震・火山情報／市町村等']"/>
	</xsl:for-each>
</xsl:template>

<!-- ***** 内容部の降灰予報に関する情報を表示するテンプレート ***** -->
<xsl:template match="jmx_volc:AshInfos">
	<xsl:for-each select="jmx_volc:AshInfo">
		<h3>
		<xsl:value-of select="../@type"/><xsl:text>の予報事項等（</xsl:text>
		<xsl:choose>
		<xsl:when test="/jmx:Report/jmx:Control/jmx:Title = '降灰予報（定時）'">
			<xsl:value-of select="substring(jmx_volc:StartTime,9,2)"/><xsl:text>日</xsl:text>
			<xsl:value-of select="substring(jmx_volc:StartTime,12,2)"/><xsl:text>時から</xsl:text>
			<xsl:choose>
			<xsl:when test="substring(jmx_volc:EndTime,12,2) = '00'">
				<xsl:text>24時まで</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring(jmx_volc:EndTime,12,2)"/><xsl:text>時まで</xsl:text>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="./@type"/>
		</xsl:otherwise>
		</xsl:choose>
		<xsl:text>）</xsl:text>
		</h3>
		<xsl:for-each select="jmx_volc:Item">
			<xsl:value-of select="jmx_volc:Kind/jmx_volc:Name"/>
			<xsl:text>（コード</xsl:text>
			<xsl:value-of select="jmx_volc:Kind/jmx_volc:Code"/><xsl:text>）</xsl:text><br/>
			<xsl:apply-templates select="jmx_volc:Areas[@codeType='気象・地震・火山情報／市町村等']"/>
			<xsl:text>　等値線</xsl:text>
			<xsl:if test="boolean(jmx_volc:Kind/jmx_volc:Property/jmx_volc:Size)">
				<xsl:text>（</xsl:text><xsl:value-of select="jmx_volc:Kind/jmx_volc:Property/jmx_volc:Size"/><xsl:value-of select="jmx_volc:Kind/jmx_volc:Property/jmx_volc:Size/@unit"/><xsl:text>）</xsl:text>
			</xsl:if>
			<xsl:text>：</xsl:text>
			<xsl:for-each select="jmx_volc:Kind/jmx_volc:Property/jmx_eb:Polygon">
				<xsl:value-of select="."/><br/>
			</xsl:for-each>
			<xsl:text>　方向：</xsl:text>
			<xsl:value-of select="jmx_volc:Kind/jmx_volc:Property/jmx_eb:PlumeDirection/@description"/><br/>
			<xsl:text>　到達距離：</xsl:text>
			<xsl:value-of select="jmx_volc:Kind/jmx_volc:Property/jmx_volc:Distance"/><xsl:value-of select="jmx_volc:Kind/jmx_volc:Property/jmx_volc:Distance/@unit"/><br/>
			<br/>
		</xsl:for-each>
	</xsl:for-each>
</xsl:template>

<!-- ** ボディ部＞本文 -->
<xsl:template match="jmx_volc:VolcanoInfoContent">
<!-- 見出しの内容表示 -->
  <div align="left">
	<xsl:choose>
    	<xsl:when test="contains(/jmx:Report/jmx:Control/jmx:Title,'降灰予報')">
    		<h3><xsl:text>＊＊（主文）＊＊</xsl:text></h3>
    	</xsl:when>
    	<xsl:otherwise>
    		<h3><xsl:text>＊＊（見出し）＊＊</xsl:text></h3>
    	</xsl:otherwise>
	</xsl:choose>
	<p><xsl:call-template name="loop">
    <xsl:with-param name="honbun" select="jmx_volc:VolcanoHeadline"/>
	</xsl:call-template></p>
  </div>
<!-- 火山活動と予報警報事項 -->
  <div align="left">
	<xsl:choose>
<!--
	<xsl:when test="/jmx:Report/jmx:Control/jmx:Title='噴火警報・予報'">
    <h3><xsl:text>＊＊（本　文）＊＊</xsl:text></h3>
	</xsl:when>
-->
	<xsl:when test="contains(/jmx:Report/jmx:Control/jmx:Title,'降灰予報')">
    <h3><xsl:text>＊＊（詳細）＊＊</xsl:text></h3>
	</xsl:when>
	<xsl:otherwise>
    <h3><xsl:text>＊＊（本　文）＊＊</xsl:text></h3>
	</xsl:otherwise>
	</xsl:choose>
    <xsl:apply-templates select="jmx_volc:VolcanoActivity"/>
  </div>
<!-- 防災上の警戒事項、次回発表予告、補足 -->
	<xsl:apply-templates select="jmx_volc:VolcanoPrevention"/>
	<xsl:apply-templates select="jmx_volc:NextAdvisory"/>
	<xsl:apply-templates select="jmx_volc:OtherInfo"/>
	<xsl:apply-templates select="jmx_volc:Appendix"/>
	<xsl:apply-templates select="jmx_volc:Text"/>
</xsl:template>

<!-- ** ボディ部＞本文（観測データ） -->
<xsl:template match="jmx_volc:VolcanoObservation">
	<xsl:if test="boolean(jmx_volc:EventTime)">
		<xsl:text>発生時刻：</xsl:text>
		<xsl:call-template name="time_convert">
			<xsl:with-param name="jikoku" select="jmx_volc:EventTime/jmx_volc:EventDateTime"/>
		</xsl:call-template>
		<xsl:text>（UTC：</xsl:text><xsl:value-of select="jmx_volc:EventTime/jmx_volc:EventDateTimeUTC"/>
		<xsl:text>）</xsl:text><br/>
	</xsl:if>
	<xsl:if test="boolean(jmx_volc:ColorPlume)">
		<xsl:text>有色噴煙：</xsl:text>
		<xsl:call-template name="plume_convert">
			<xsl:with-param name="syubetu" select="jmx_volc:ColorPlume"/>
		</xsl:call-template><br/>
	</xsl:if>
	<xsl:if test="boolean(jmx_volc:WhitePlume)">
		<xsl:text>白色噴煙：</xsl:text>
		<xsl:call-template name="plume_convert">
			<xsl:with-param name="syubetu" select="jmx_volc:WhitePlume"/>
		</xsl:call-template><br/>
	</xsl:if>
	<xsl:if test="boolean(jmx_volc:WindAboveCrater)">
		<xsl:text>火口直上の風要素の予測時刻：</xsl:text>
		<xsl:call-template name="time_convert">
			<xsl:with-param name="jikoku" select="jmx_volc:WindAboveCrater/jmx_eb:DateTime"/>
		</xsl:call-template><br/>
		<xsl:text>火口直上の風要素：</xsl:text><br />
		<xsl:call-template name="wind_convert_all">
			<xsl:with-param name="syubetu" select="jmx_volc:WindAboveCrater"/>
		</xsl:call-template>
	</xsl:if>
	<xsl:text>付加文：</xsl:text>
    <xsl:choose>
	  <xsl:when test="boolean(jmx_volc:OtherObservation)">
<!--		<xsl:value-of select="jmx_volc:OtherObservation"/>-->
		<xsl:call-template name="loop">
			<xsl:with-param name="honbun" select="jmx_volc:OtherObservation"/>
		</xsl:call-template>
	  </xsl:when>
      <xsl:otherwise>
		<xsl:text>なし</xsl:text>
	  </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- ** ボディ部＞注目情報 -->
<xsl:template match="jmx_volc:Notice">
	<xsl:value-of select="jmx_volc:Notice"/>
</xsl:template>

<!-- ** ボディ部＞自由付加文 -->
<xsl:template match="jmx_volc:Text">
    <h3><xsl:text>自由付加文</xsl:text></h3>
    <p>
	<xsl:call-template name="loop">
		<xsl:with-param name="honbun" select="current()"/>
	</xsl:call-template></p>
</xsl:template>

<!-- ** ボディ部＞本文＞予警報事項 -->
<xsl:template match="jmx_volc:VolcanoActivity">
  <h3><xsl:if test="/jmx:Report/jmx_ib:Head/jmx_ib:EventID=900">
    <xsl:text>主な</xsl:text>
  </xsl:if>
  <xsl:text>火山活動の状況</xsl:text>
  <xsl:if test="/jmx:Report/jmx:Control/jmx:Title='噴火警報・予報' or contains(/jmx:Report/jmx:Control/jmx:Title,'降灰予報')">
    <xsl:text>及び予報警報事項</xsl:text>
  </xsl:if></h3>
  <p>
<!-- 火山活動の状況と予報警報事項の表示 -->
  <xsl:call-template name="loop">
    <xsl:with-param name="honbun" select="current()"/>
  </xsl:call-template>
  </p>
</xsl:template>

<!-- ** ボディ部＞本文＞防災事項 -->
<xsl:template match="jmx_volc:VolcanoPrevention">
  <div>
  <h3>
<!--    <xsl:choose>
    <xsl:when test="/jmx:Report/jmx:Control/jmx:Title='噴火警報・予報' and not(/jmx:Report/jmx_ib:Head/jmx_ib:EventID='901')">
      <xsl:text>３</xsl:text>
    </xsl:when>
    <xsl:otherwise><xsl:text>２</xsl:text></xsl:otherwise>
  </xsl:choose>-->
  <xsl:text>防災上の警戒事項等</xsl:text></h3>
<!-- 警戒事項等の内容表示 -->
    <p><xsl:call-template name="loop">
      <xsl:with-param name="honbun" select="current()"/>
    </xsl:call-template></p>
  </div>
</xsl:template>

<!-- ボディ部＞本文＞次回の発表予告 -->
<xsl:template match="jmx_volc:NextAdvisory">
  <div>
  	<h3><xsl:text>次回の発表予告</xsl:text></h3>
    <p><xsl:call-template name="loop">
      <xsl:with-param name="honbun" select="current()"/>
    </xsl:call-template></p>
  </div>
</xsl:template>

<!-- ボディ部＞本文＞補足 -->
<xsl:template match="jmx_volc:OtherInfo">
  <div>
  	<h3><xsl:text>その他</xsl:text></h3>
    <p><xsl:call-template name="loop">
      <xsl:with-param name="honbun" select="current()"/>
    </xsl:call-template></p>
  </div>
</xsl:template>

<!-- ボディ部＞参考 -->
<xsl:template match="jmx_volc:Appendix">
  <div align="left">
    <h3><xsl:text>補足事項</xsl:text></h3>
    <p><xsl:call-template name="loop">
      <xsl:with-param name="honbun" select="current()"/>
    </xsl:call-template></p>
  </div>
</xsl:template>

<!-- ***** 時刻表記を変換するテンプレート（各項目共通）***** -->
<xsl:template name="time_convert">
<xsl:param name="jikoku"/>
      <xsl:value-of select="substring-before($jikoku,'-')"/><xsl:text>年</xsl:text>
      <xsl:value-of select="substring($jikoku,6,2)"/><xsl:text>月</xsl:text>
      <xsl:value-of select="substring($jikoku,9,2)"/><xsl:text>日</xsl:text>
      <xsl:value-of select="substring($jikoku,12,2)"/><xsl:text>時</xsl:text>
      <xsl:value-of select="substring($jikoku,15,2)"/><xsl:text>分　</xsl:text>
</xsl:template>

<!-- ***** 火山データを変換するテンプレート***** -->
<xsl:template name="volcano_convert">
<xsl:param name="kazan"/>
	<xsl:text>火山名：</xsl:text>
<!--			<xsl:if test="not(position()=1)">、</xsl:if>-->
	<xsl:value-of select="$kazan/jmx_volc:Name"/>
	<xsl:text>（</xsl:text>
	<xsl:value-of select="$kazan/jmx_volc:Code"/><xsl:text>）    </xsl:text>
	<xsl:text>位置：</xsl:text><xsl:value-of select="$kazan/jmx_volc:Coordinate/@description"/><br/>
</xsl:template>

<!-- ***** 噴煙高度データを変換するテンプレート（有色、白色共通）***** -->
<xsl:template name="plume_convert">
<xsl:param name="syubetu"/>
<!-- 火口上噴煙高度 -->
	<xsl:value-of select="$syubetu/jmx_eb:PlumeHeightAboveCrater/@type"/>
	<xsl:value-of select="$syubetu/jmx_eb:PlumeHeightAboveCrater"/>
	<xsl:value-of select="$syubetu/jmx_eb:PlumeHeightAboveCrater/@unit"/>
	<xsl:text>（表記：</xsl:text>
	<xsl:value-of select="$syubetu/jmx_eb:PlumeHeightAboveCrater/@description"/>
	<xsl:text>）	</xsl:text>
<!-- 海抜噴煙高度 -->
	<xsl:value-of select="$syubetu/jmx_eb:PlumeHeightAboveSeaLevel/@type"/>
	<xsl:value-of select="$syubetu/jmx_eb:PlumeHeightAboveSeaLevel"/>
	<xsl:value-of select="$syubetu/jmx_eb:PlumeHeightAboveSeaLevel/@unit"/>
	<xsl:text>（表記：</xsl:text>
	<xsl:value-of select="$syubetu/jmx_eb:PlumeHeightAboveSeaLevel/@description"/>
	<xsl:text>）</xsl:text><br/>
<!-- 流向 -->
	<xsl:value-of select="$syubetu/jmx_eb:PlumeDirection/@type"/>
	<xsl:text>：</xsl:text>
	<xsl:value-of select="$syubetu/jmx_eb:PlumeDirection"/>
</xsl:template>

<!-- ***** 火口直上の風データを変換するテンプレート ***** -->
<xsl:template name="wind_convert_all">
<xsl:param name="syubetu"/>
	<xsl:for-each select="$syubetu/jmx_volc:WindAboveCraterElements">
		<xsl:if test="@heightProperty='代表高度'">
			<xsl:text>（</xsl:text>
			<xsl:value-of select="$syubetu/jmx_volc:WindAboveCraterElements/@heightProperty"/>
			<xsl:text>）</xsl:text>
		</xsl:if>
		<xsl:call-template name="loop_wind">
			<xsl:with-param name="high_wind" select="."/>
		</xsl:call-template><br/>
	</xsl:for-each>
</xsl:template>

<!-- ***** 火口直上の風データを変換するテンプレート ***** -->
<xsl:template name="loop_wind">
<xsl:param name="high_wind"/>
	<xsl:value-of select="$high_wind/jmx_eb:WindHeightAboveSeaLevel/@type"/>
	<xsl:value-of select="$high_wind/jmx_eb:WindHeightAboveSeaLevel"/>
	<xsl:value-of select="$high_wind/jmx_eb:WindHeightAboveSeaLevel/@unit"/>
	<xsl:text>の</xsl:text>
	<xsl:value-of select="$high_wind/jmx_eb:WindDegree/@type"/>
	<xsl:value-of select="$high_wind/jmx_eb:WindDegree"/>
	<xsl:value-of select="$high_wind/jmx_eb:WindDegree/@unit"/>
	<xsl:text>、</xsl:text>
	<xsl:value-of select="$high_wind/jmx_eb:WindSpeed/@type"/>
	<xsl:value-of select="$high_wind/jmx_eb:WindSpeed"/>
	<xsl:value-of select="$high_wind/jmx_eb:WindSpeed/@unit"/>
</xsl:template>

<!-- ***** 各文を改行<br>をつけて出力するテンプレート（各項目共通）***** -->
<xsl:template name="loop">
<xsl:param name="honbun"/>
<!-- 本文がなくなるまで表示する -->
  <xsl:if test="1 &lt;= string-length($honbun)">
<!-- 改行で区切る -->
    <xsl:choose>
      <xsl:when test="contains($honbun,'&#xA;')">
        <xsl:value-of select="substring-before($honbun,'&#xA;')"/><br/>
        <xsl:variable name="sub-honbun" select="substring-after($honbun,'&#xA;')"/>
<!-- 次の表示 -->
        <xsl:call-template name="loop">
          <xsl:with-param name="honbun" select="$sub-honbun"/>
        </xsl:call-template>
      </xsl:when>
<!-- 改行のないとき（最後） -->
      <xsl:otherwise>
        <xsl:value-of select="$honbun"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
