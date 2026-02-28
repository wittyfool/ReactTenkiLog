<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:jmx="http://xml.kishou.go.jp/jmaxml1/"
  xmlns:jmx_ib="http://xml.kishou.go.jp/jmaxml1/informationBasis1/"
  xmlns:jmx_eb="http://xml.kishou.go.jp/jmaxml1/elementBasis1/"
  xmlns:jmx_mete="http://xml.kishou.go.jp/jmaxml1/body/meteorology1/"
  xmlns:jmx_add="http://xml.kishou.go.jp/jmaxml1/addition1/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0">

<!--
  ======================================================================
  本スタイルシートは、気象庁防災情報XMLフォーマット形式電文中の全ての情報コンテンツを出力するもので、システム処理の動作確認など、電文処理の参考資料としてお使い下さい。

  なお、本スタイルシートについては、システムに直接組み込む等の方法でご利用になることは避けていただくなど、ご利用に当たっては十分に注意していただきますよう、よろしくお願いいたします。

  Copyright (c) 気象庁 2012 All rights reserved.
  
　【対象情報】
　全般・地方季節予報

  【更新履歴】
  2012年03月29日　Ver.1.0
  2019年04月24日　Ver.1.1 5月1日より施行される新元号への対応
  2021年03月31日　Ver.1.2 1か月予報の予報期間末日が正しい日付で出力されるよう修正
  ======================================================================
-->

<xsl:output method="html" indent="yes"/>

<xsl:variable name="BRie" select="'&#x0a;'" />
<xsl:variable name="BRchrome">
  <xsl:text>
</xsl:text>
</xsl:variable>

<xsl:variable name="BR">
  <xsl:choose>
    <xsl:when test="contains(//jmx_mete:Text, $BRie)">
      <xsl:value-of select="$BRie"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$BRchrome"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<xsl:variable name="Title" select="/jmx:Report/jmx_ib:Head/jmx_ib:Title"/>
<xsl:variable name="HeadLine"
  select="/jmx:Report/jmx_ib:Head/jmx_ib:Headline/jmx_ib:Text"/>

<xsl:template match="/">
	<html>
	<head>
	<title>季節予報</title>
	</head>
	<body>
  <table border="1" width="75%" align="center" font-size="12pt">
  <tr><td style='font-family: monospace'>

  <!-- 電文基本要素 -->
    <xsl:apply-templates select="/jmx:Report/jmx_ib:Head" mode="Basic"/>
    <br/>

  <!-- 概況 -->
  <xsl:apply-templates
      select="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos"/>

  <!-- なお書き（暖・寒候期予報） -->  
    <xsl:call-template name="mkDanraku">
      <xsl:with-param name="str"
          select="/jmx:Report//jmx_mete:AdditionalNotice"/>
      <xsl:with-param name="jisage" select="1"/>
    </xsl:call-template>
    <br/>

  <!-- 確率の表 -->
    <xsl:choose>
      <xsl:when test="contains($Title, '３か月予報')">
        <xsl:call-template name="ThreeMonthTbl">
          <xsl:with-param name="kind" select="'気温'"/>
        </xsl:call-template>
        <xsl:call-template name="ThreeMonthTbl">
          <xsl:with-param name="kind" select="'降水量'"/>
        </xsl:call-template>
        <xsl:call-template name="ThreeMonthTbl">
          <xsl:with-param name="kind" select="'降雪量'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="Komidashi">
          <xsl:with-param name="value">
            <xsl:text>確率</xsl:text>
          </xsl:with-param>
        </xsl:call-template>
        <br/>
        <xsl:text>期間　　　　要素　　　地域　　　　　　　　　</xsl:text>
        <xsl:text>低・少　平年並　高・多％</xsl:text>
        <br/>
        <xsl:apply-templates
            select="//jmx_mete:MeteorologicalInfo//jmx_eb:ClimateProbabilityValues"
            mode="Simple">
          <xsl:sort select="@kind"/>
        </xsl:apply-templates>
        <br/>
        <xsl:apply-templates
            select="//jmx_mete:TimeSeriesInfo//jmx_eb:ClimateProbabilityValues[@kind='気温']"
            mode="Simple">
          <xsl:sort select="@refID"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>

  <!-- 予報の対象期間（１か月予報） -->
    <xsl:if test="contains($Title, '１か月予報')">
      <br/>
      <xsl:call-template name="Komidashi">
        <xsl:with-param name="value">
          <xsl:text>予報の対象期間</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
      <br/>
      <xsl:apply-templates
          select="//jmx_mete:MeteorologicalInfo/jmx_mete:DateTime"
          mode="kikanName"/>
      <xsl:apply-templates
          select="//jmx_mete:TimeDefine/jmx_mete:DateTime" mode="kikanName">
        <xsl:sort select="@timeId"/>
      </xsl:apply-templates>
      <br/>
    </xsl:if>

  <!-- 次回発表予定等、末尾の'=' -->
    <xsl:variable name="notice" select="//jmx_mete:Notice"/>
    <xsl:variable name="noticeOfSche" select="//jmx_mete:NoticeOfSchedule"/>
    <xsl:call-template name="mkDanraku">
      <xsl:with-param name="str">
        <xsl:call-template name="Komidashi">
          <xsl:with-param name="value">
            <xsl:text>次回発表予定等</xsl:text>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates select="//jmx_mete:NextForecastSchedule">
        </xsl:apply-templates>
        <xsl:if test="string-length($notice) = 0 and
                       string-length($noticeOfSche) = 0">
          <xsl:text>=</xsl:text>
        </xsl:if>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:if test="string-length($noticeOfSche) &gt; 0">
      <xsl:call-template name="mkDanraku">
        <xsl:with-param name="str">
          <xsl:value-of select="$noticeOfSche"/>
          <xsl:if test="string-length($notice) = 0">
            <xsl:text>=</xsl:text>
          </xsl:if>
        </xsl:with-param>
        <xsl:with-param name="jisage" select="1"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="string-length($notice) &gt; 0">
      <br/>
      <xsl:call-template name="mkDanraku">
        <xsl:with-param name="str" select="concat($notice, '=')"/>
      </xsl:call-template>
    </xsl:if>

  </td></tr>
  </table>
	</body>
	</html>

</xsl:template>


<!-- ====================== -->
<!-- 電文基本要素テンプレート -->
<!-- ====================== -->
<xsl:template match="/jmx:Report/jmx_ib:Head" mode="Basic">

  <!-- 発表状況 -->
    <xsl:if test="contains(jmx_ib:InfoType,'訂正')">
      <xsl:call-template name="blank1"/>
      <xsl:text>（訂正）</xsl:text>
    </xsl:if>
  <br/>
  <hr/>

  <!-- 標題行 -->
  <xsl:call-template name="DispTitle">
    <xsl:with-param name="TitleStr" select="jmx_ib:Title"/>
  </xsl:call-template>
  <br/>

  <!-- 予報期間行 -->
  <xsl:text>予報期間</xsl:text>
  <xsl:call-template name="blank1"/>
  <xsl:variable name="kikanStart" select="jmx_ib:TargetDateTime"/>
  <xsl:variable name="kikanEnd">
    <xsl:call-template name="DateCalc">
      <xsl:with-param name="Hizuke" select="jmx_ib:TargetDateTime"/>
      <xsl:with-param name="Duration" select="jmx_ib:TargetDuration"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="contains($Title, '１か月予報')">
      <xsl:call-template name="DispDateTime02">
        <xsl:with-param name="Jikan" select="$kikanStart"/>
      </xsl:call-template>
      <xsl:text>から</xsl:text>
      <xsl:call-template name="DispDateTime02">
        <xsl:with-param name="Jikan" select="$kikanEnd"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="DispDateTime01">
        <xsl:with-param name="Jikan" select="$kikanStart"/>
      </xsl:call-template>
      <xsl:text>から</xsl:text>
      <xsl:call-template name="DispDateTime01">
        <xsl:with-param name="Jikan" select="$kikanEnd"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
  <br/>

  <!-- 発表年月日行 -->
  <xsl:call-template name="DispDateTime0">
  <xsl:with-param name="Jikan" select="jmx_ib:ReportDateTime"/>
  </xsl:call-template>
  <br/>
  <!-- 発表官署行 -->
  <xsl:call-template name="DispPublishingOffice">
  <xsl:with-param name="OfficeStr"
     select="/jmx:Report/jmx:Control/jmx:PublishingOffice"/>
  </xsl:call-template>
  <xsl:call-template name="blank1"/>
  <xsl:text>発表</xsl:text>
  <br/>
</xsl:template>

<!-- ................... -->
<!-- 標題表示テンプレート -->
<xsl:template name="DispTitle">
  <xsl:param name="TitleStr">dummy</xsl:param>
  <xsl:choose>
  <xsl:when test="starts-with($TitleStr, '全般')">
    <xsl:text>全般</xsl:text>
    <xsl:call-template name="blank1"/>
    <xsl:call-template name="ZenNum">
      <xsl:with-param name="Num" select="substring-after($TitleStr, '全般')"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="SepareteWithSpc">
    <xsl:with-param name="TargetString" select="$TitleStr"/>
    <xsl:with-param name="Anchor">地方 </xsl:with-param>
    </xsl:call-template>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ...................... -->
<!-- 発表官署表示テンプレート -->
<xsl:template name="DispPublishingOffice">
  <xsl:param name="OfficeStr">dummy</xsl:param>
  <xsl:choose>
    <xsl:when test="starts-with($OfficeStr, '気象庁')">
      <xsl:call-template name="SepareteWithSpc">
        <xsl:with-param name="TargetString" select="$OfficeStr"/>
        <xsl:with-param name="Anchor">気象庁 </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$OfficeStr"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- =============== -->
<!-- 概況テンプレート -->
<!-- =============== -->
<xsl:template match="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos">

  <!-- 全期間の概況 -->
  <xsl:call-template name="mkDanraku">
    <xsl:with-param name="str">
      <xsl:apply-templates
        select="jmx_mete:MeteorologicalInfo" mode="Gaikyo"/>

      <!-- 梅雨期間の概況 -->
      <xsl:call-template name="desu2kuten">
        <xsl:with-param name="str">
          <xsl:apply-templates
              select="jmx_mete:MeteorologicalInfo" mode="Gaikyo1"/>
        </xsl:with-param>
      </xsl:call-template>

    </xsl:with-param>
    <xsl:with-param name="jisage" select="1"/>
  </xsl:call-template>

  <!-- 時系列の概況 -->
  <xsl:choose>
    <xsl:when test="contains($Title, '１か月予報')">
      <xsl:variable name="timeSeriesGaikyo">
        <xsl:call-template name="timeSeriesCompress">
          <xsl:with-param name="fullStr">
            <xsl:apply-templates
                select="jmx_mete:TimeSeriesInfo//jmx_mete:TimeDefine"
                mode="Gaikyo2">
              <xsl:sort select="@timeId"/>
            </xsl:apply-templates>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:call-template name="mkDanraku">
        <xsl:with-param name="str">
          <xsl:text>週別の気温は、</xsl:text>
          <xsl:value-of select="$timeSeriesGaikyo"/>
        </xsl:with-param>
        <xsl:with-param name="jisage" select="1"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates
          select="jmx_mete:TimeSeriesInfo//jmx_mete:TimeDefine" mode="Gaikyo2">
        <xsl:sort select="@timeId"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<!-- ................................... -->
<!-- 時系列の縮退（１か月予報）テンプレート -->
<xsl:template name="timeSeriesCompress">
  <xsl:param name="fullStr"/>
  <xsl:param name="resultStr"/>
  <xsl:choose>
    <xsl:when test="string-length($fullStr) &gt; 0">
      <xsl:variable name="testKikan" select="substring-before($fullStr, '!')"/>
      <xsl:if test="string-length($testKikan) &gt; 0">
        <xsl:variable name="testPart"
            select="substring-before(substring-after($fullStr, '!'), '。')"/>
        <xsl:if test="string-length($testPart) &gt; 0">
          <xsl:variable name="testStr" select="concat('!', $testPart, '。')"/>
          <xsl:choose>
            <xsl:when test="contains($resultStr, $testStr)">
              <xsl:variable name="beforePart"
                  select="substring-before($resultStr, $testStr)"/>
              <xsl:variable name="prePart">
                <xsl:if test="contains($beforePart, '。')">
                  <xsl:value-of
                      select="substring-before($beforePart, '。')"/>
                  <xsl:text>。</xsl:text>
                </xsl:if>
              </xsl:variable>
              <xsl:variable name="matchKikan">
                <xsl:choose>
                  <xsl:when test="contains($beforePart, '。')">
                    <xsl:value-of
                      select="substring-after($beforePart, '。')"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$beforePart"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:variable name="afterPart"
                  select="substring-after($resultStr, $testStr)"/>
              <xsl:call-template name="timeSeriesCompress">
                <xsl:with-param name="fullStr"
                  select="substring-after($fullStr, $testStr)"/>
                <xsl:with-param name="resultStr">
                  <xsl:value-of select="$prePart"/>
                  <xsl:value-of select="$matchKikan"/>
                  <xsl:text>and</xsl:text>
                  <xsl:value-of select="$testKikan"/>
                  <xsl:value-of select="$testStr"/>
                  <xsl:value-of select="$afterPart"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="timeSeriesCompress">
                <xsl:with-param name="fullStr"
                  select="substring-after($fullStr, $testStr)"/>
                <xsl:with-param name="resultStr">
                  <xsl:value-of select="$resultStr"/>
                  <xsl:value-of select="substring-before($fullStr, $testStr)"/>
                  <xsl:value-of select="$testStr"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="kigou2Kotoba">
        <xsl:with-param name="str" select="$resultStr"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="kigou2Kotoba">
  <xsl:param name="str"/>
  <xsl:variable name="firstPhrase" select="substring-after($str, '!')"/>
  <xsl:choose>
    <xsl:when test="contains($firstPhrase, '!')">
      <xsl:variable name="and2TO">
        <xsl:call-template name="replaceAll">
          <xsl:with-param name="str" select="$str"/>
          <xsl:with-param name="key" select="'and'"/>
          <xsl:with-param name="rep" select="'と'"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:call-template name="replaceAll">
        <xsl:with-param name="str" select="$and2TO"/>
        <xsl:with-param name="key" select="'!'"/>
        <xsl:with-param name="rep" select="'は'"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="replaceAll">
        <xsl:with-param name="str" select="substring-before($str, '!')"/>
        <xsl:with-param name="key" select="'and'"/>
        <xsl:with-param name="rep" select="'・'"/>
      </xsl:call-template>
      <xsl:text>のいずれの期間も、</xsl:text>
      <xsl:value-of select="$firstPhrase"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="replaceAll">
  <xsl:param name="str"/>
  <xsl:param name="key"/>
  <xsl:param name="rep"/>
  <xsl:choose>
    <xsl:when test="contains($str, $key)">
      <xsl:value-of select="substring-before($str, $key)"/>
      <xsl:value-of select="$rep"/>
      <xsl:call-template name="replaceAll">
        <xsl:with-param name="str" select="substring-after($str, $key)"/>
        <xsl:with-param name="key" select="$key"/>
        <xsl:with-param name="rep" select="$rep"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$str"/>
    </xsl:otherwise> 
  </xsl:choose>
</xsl:template>

<!-- ............................... -->
<!-- 梅雨期間の概況文の連結テンプレート -->
<xsl:template name="desu2kuten">
  <xsl:param name="str"/>
  <xsl:choose>
    <xsl:when test="contains($str, 'です。')">
      <xsl:variable name="remain" select="substring-after($str, 'です。')"/>
      <xsl:choose>
        <xsl:when test="string-length($remain) &gt; 0">
          <xsl:value-of select="substring-before($str, 'です。')"/>
          <xsl:text>、</xsl:text>
          <xsl:call-template name="desu2kuten">
            <xsl:with-param name="str">
              <xsl:choose>
                <xsl:when test="contains($remain, '降水量は、')">
                  <xsl:value-of
                      select="substring-after($remain, '降水量は、')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$remain"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$str"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$str"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ...................... -->
<!-- 全期間の概況テンプレート -->
<xsl:template match="jmx_mete:MeteorologicalInfo" mode="Gaikyo">
  <xsl:choose>
    <xsl:when test="starts-with(jmx_mete:Name, '梅雨の時期')"/>
    <xsl:otherwise>
      <xsl:if test="contains($Title, '１か月予報')">
        <xsl:call-template name="Komidashi">
          <xsl:with-param name="value" select="jmx_mete:Name"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="string-length($HeadLine) &gt; 0">
        <xsl:call-template name="Komidashi">
          <xsl:with-param name="value">特に注意を要する事項</xsl:with-param>
        </xsl:call-template>
        <xsl:value-of select="concat($HeadLine, $BR, $BR)"/>
      </xsl:if>
      <xsl:call-template name="Komidashi">
        <xsl:with-param name="value"
            select="concat('予想される', jmx_mete:Name, 'の天候')"/>
      </xsl:call-template>
      <xsl:apply-templates select=".//jmx_mete:ClimateFeaturePart"
          mode="ClimateFeature">
        <xsl:with-param name="kikanName" select="jmx_mete:Name"/>
          <xsl:with-param name="withType" select="1"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ........................ -->
<!-- 梅雨期間の概況テンプレート -->
<xsl:template match="jmx_mete:MeteorologicalInfo" mode="Gaikyo1">
  <xsl:if test="starts-with(jmx_mete:Name, '梅雨の時期')">
    <xsl:apply-templates select=".//jmx_mete:ClimateFeaturePart"
        mode="ClimateFeature">
      <xsl:with-param name="kikanName" select="jmx_mete:Name"/>
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>

<!-- ...................... -->
<!-- 時系列の概況テンプレート -->
<xsl:template
    match="jmx_mete:TimeSeriesInfo//jmx_mete:TimeDefine" mode="Gaikyo2">
  <xsl:variable name="id" select="@timeId"/>
  <xsl:variable name="str">
    <xsl:apply-templates
        select="/jmx:Report//jmx_mete:TimeSeriesInfo//jmx_mete:ClimateFeaturePart"
        mode="ClimateFeature">
      <xsl:with-param name="kikanName" select="jmx_mete:Name"/>
      <xsl:with-param name="id" select="$id"/>
    </xsl:apply-templates>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="contains($Title, '１か月予報')">
      <xsl:value-of select="$str"/>
    </xsl:when>
    <xsl:otherwise>
      <br/>
      <xsl:call-template name="mkDanraku">
        <xsl:with-param name="str" select="$str"/>
        <xsl:with-param name="jisage" select="2"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ...................... -->
<!-- 概況内容共通テンプレート -->
<xsl:template
    match="jmx_mete:ClimateFeaturePart"
    mode="ClimateFeature">
  <xsl:param name="kikanName"/>
  <xsl:param name="id"/>
  <xsl:param name="withType">0</xsl:param>

  <!-- のうがき -->
  <xsl:choose>
    <xsl:when test="$withType = 1">
      <xsl:value-of select="$kikanName"/>
      <xsl:text>の</xsl:text>
      <xsl:value-of select="../jmx_mete:Type"/>
      <xsl:text>は以下の通りです。</xsl:text>
      <xsl:value-of select="$BR"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="contains($Title, '３か月予報') and $id &gt; 0">
        <xsl:value-of select="$kikanName"/>
        <xsl:call-template name="blank1"/>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>

  <!-- 予想される天候 -->
  <xsl:variable name="tenkoStr">
    <xsl:choose>
      <xsl:when test="$id &gt; 0">
        <xsl:value-of select="jmx_eb:GeneralSituationText[@refID=$id]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of  select="jmx_eb:GeneralSituationText"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$tenkoStr"/>
  <xsl:choose>
    <xsl:when test="string-length($tenkoStr) = 0 or
                     (contains($Title, '１か月予報') and $id &gt; 0)"/>
    <xsl:otherwise>
      <xsl:value-of select="$BR"/>
    </xsl:otherwise>
  </xsl:choose>

  <!-- 特徴のある確率 -->
  <xsl:variable name="signProbStr">
    <xsl:apply-templates select="jmx_eb:SignificantClimateElement"
        mode="ElemText">
      <xsl:with-param name="id" select="$id"/>
      <xsl:with-param name="kikanName" select="$kikanName"/>
    </xsl:apply-templates>
  </xsl:variable>
  <xsl:if test="string-length($signProbStr) &gt; 0">
    <!-- 始まりのフレーズ -->
    <xsl:if test="$id = ''">
      <xsl:choose>
        <xsl:when test="contains($Title, '１か月予報')">
          <xsl:text>向こう１か月の</xsl:text>
        </xsl:when>
        <xsl:when test="starts-with($kikanName, '梅雨の時期')">
          <xsl:value-of select="$kikanName"/>
          <xsl:text>の降水量は、</xsl:text>
         </xsl:when>
        <xsl:otherwise>
          <xsl:text>この期間の</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:value-of select="$signProbStr"/>
  </xsl:if>

</xsl:template>

<!-- ........................ -->
<!-- 特徴のある確率テンプレート -->
<xsl:template match="jmx_eb:SignificantClimateElement" mode="ElemText">
  <xsl:param name="kikanName"/>
  <xsl:param name="id"/>

  <xsl:variable name="significantStr">
    <!-- 「(要素名)は、?」を除く -->
    <xsl:call-template name="delTop">
      <xsl:with-param name="term" select="'、'"/>
      <xsl:with-param name="str">
        <xsl:call-template name="delBefore">
          <xsl:with-param name="term" select="concat(@kind, 'は')"/>
          <xsl:with-param name="str">
            <!-- 「((期間名)|この期間)(の|は)?、?」を除く -->
            <xsl:call-template name="delTop">
              <xsl:with-param name="term" select="'、'"/>
              <xsl:with-param name="str">
                <xsl:call-template name="delTop">
                  <xsl:with-param name="term" select="'は'"/>
                  <xsl:with-param name="str">
                    <xsl:call-template name="delTop">
                      <xsl:with-param name="term" select="'の'"/>
                      <xsl:with-param name="str">
                        <xsl:call-template name="delBefore">
                          <xsl:with-param name="term"
                              select="'この期間'"/>
                          <xsl:with-param name="str">
                            <xsl:call-template name="delBefore">
                              <xsl:with-param name="term"
                                  select="$kikanName"/>
                              <xsl:with-param name="str">
                                <xsl:choose>
                                  <xsl:when test="$id = ''">
                                    <xsl:value-of select="jmx_eb:Text"/>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:value-of
                                      select="jmx_eb:Text[@refID=$id]"/>
                                  </xsl:otherwise>
                                </xsl:choose>
                              </xsl:with-param>
                            </xsl:call-template>
                          </xsl:with-param>
                        </xsl:call-template>
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="string-length($significantStr) &gt; 0">
    <!-- 期間名または要素名を付け直す -->
    <xsl:choose>
      <xsl:when test="$id &gt; 0 and contains($Title, '１か月予報')">
        <xsl:value-of select="concat($kikanName, '!')"/>
      </xsl:when>
      <xsl:when test="$id = '' and @kind = '気温'">
        <xsl:text>平均気温は、</xsl:text>
      </xsl:when>
      <xsl:when test="@kind = '降雪量'">
        <xsl:text>日本海側の降雪量は、</xsl:text>
      </xsl:when>
      <!-- 梅雨の場合は地名-->
      <xsl:when test="contains($kikanName, '梅雨の時期')">
        <xsl:variable name="partArea"
           select="../../../../jmx_mete:Areas//jmx_mete:Name"/>
        <xsl:variable name="targetArea"
            select="//jmx_mete:Body/jmx_mete:TargetArea/jmx_mete:Name"/>
        <xsl:choose>
          <xsl:when test="$partArea = $targetArea"/>
          <xsl:otherwise>
            <xsl:value-of select="$partArea"/>
            <xsl:text>で</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat(@kind, 'は、')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>

  <xsl:value-of select="$significantStr"/>

</xsl:template>

<!-- str に現れる term 以前の部分を削除する -->
<xsl:template name="delBefore">
  <xsl:param name="str"/>
  <xsl:param name="term"/>
  <xsl:choose>
    <xsl:when test="string-length($term) = 0">
      <xsl:value-of select="$str"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="contains($str, $term)">
          <xsl:value-of select="substring-after($str, $term)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$str"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- str が term で始まる場合、そこを削除する -->
<xsl:template name="delTop">
  <xsl:param name="str"/>
  <xsl:param name="term"/>
  <xsl:choose>
    <xsl:when test="string-length($term) = 0">
      <xsl:value-of select="$str"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="starts-with($str, $term)">
          <xsl:value-of select="substring-after($str, $term)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$str"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- .......................... -->
<!-- 確率の表（一般）テンプレート -->
<xsl:template match="jmx_eb:ClimateProbabilityValues" mode="Simple">
  <xsl:variable name="kikanName" select="../../../../../jmx_mete:Name"/>
  <xsl:choose>
    <xsl:when test="contains($kikanName, '１か月')">
      <xsl:text>１か月</xsl:text>
      <xsl:call-template name="blank3"/>
    </xsl:when>
    <xsl:when test="@refID &gt; 0">
      <xsl:variable name="id" select="@refID"/>
      <xsl:variable name="k"
          select="/jmx:Report//jmx_mete:TimeDefine[@timeId=$id]/jmx_mete:Name"/>
      <xsl:value-of select="$k"/>
      <xsl:call-template name="blanks">
        <xsl:with-param name="n" select="6 - string-length($k)"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="kikanNameShort">
        <xsl:variable name="start" select="../../../../../jmx_mete:DateTime"/>
        <xsl:variable name="kikan" select="../../../../../jmx_mete:Duration"/>
        <xsl:call-template name="ZenNum">
          <xsl:with-param name="Num"
            select="number(substring($start, 6, 2))"/>
        </xsl:call-template>
        <xsl:text>～</xsl:text>
        <xsl:call-template name="DispDateTime01">
          <xsl:with-param name="Jikan">
            <xsl:call-template name="DateCalc">
              <xsl:with-param name="Hizuke"   select="$start"/>
              <xsl:with-param name="Duration" select="$kikan"/>
            </xsl:call-template>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="$kikanNameShort"/>
      <xsl:call-template name="blanks">
        <xsl:with-param name="n" select="6 - string-length($kikanNameShort)"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:value-of select="@kind"/>
  <xsl:call-template name="blanks">
    <xsl:with-param name="n" select="5 - string-length(@kind)"/>
  </xsl:call-template>
  <xsl:variable name="areaName">
    <xsl:call-template name="areaStdName">
      <xsl:with-param name="areaName"
        select="../../../../jmx_mete:Areas//jmx_mete:Name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="$areaName"/>
  <xsl:call-template name="blanks">
    <xsl:with-param name="n" select="15 - string-length($areaName)"/>
  </xsl:call-template>
  <xsl:call-template name="ZenNum">
    <xsl:with-param name="Num" select="jmx_eb:ProbabilityOfBelowNormal"/>
  </xsl:call-template>
  <xsl:call-template name="blank1"/>
  <xsl:call-template name="ZenNum">
    <xsl:with-param name="Num" select="jmx_eb:ProbabilityOfNormal"/>
  </xsl:call-template>
  <xsl:call-template name="blank1"/>
  <xsl:call-template name="ZenNum">
    <xsl:with-param name="Num" select="jmx_eb:ProbabilityOfAboveNormal"/>
  </xsl:call-template>
  <br/>
</xsl:template>

<!-- .............................. -->
<!-- 予報対象地域名の略称（標準の表） -->
<xsl:template name="areaStdName">
  <xsl:param name="areaName"/>
  <xsl:choose>
    <xsl:when test="contains($areaName, 'を除く）')">
      <xsl:value-of select="substring-before($areaName, '（')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$areaName"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ............................... -->
<!-- 確率の表（３か月予報）テンプレート -->
<xsl:template name="ThreeMonthTbl">
  <xsl:param name="kind"/>

  <xsl:variable name="tblStr">
    <xsl:apply-templates
        select="//jmx_eb:ClimateProbabilityValues[@kind=$kind]"
        mode="ThreeMonths">
      <xsl:sort select="../../../../jmx_mete:Areas//jmx_mete:Code"/>
      <xsl:sort select="@refID"/>
    </xsl:apply-templates>
  </xsl:variable>
  <xsl:if test="string-length($tblStr) &gt; 0">
    <xsl:text>＜</xsl:text>
    <xsl:value-of select="$kind"/>
    <xsl:text>＞</xsl:text>
    <xsl:call-template name="blanks">
      <xsl:with-param name="n" select="5 - string-length($kind)"/>
    </xsl:call-template>

    <xsl:text>３か月</xsl:text>
    <xsl:variable name="kikanNames">
      <xsl:apply-templates
          select="//jmx_mete:TimeSeriesInfo//jmx_eb:ClimateProbabilityValues[@kind=$kind]"
          mode="ThreeMonthsTblLabel"/>
    </xsl:variable>
    <xsl:if test="string-length($kikanNames) &gt; 0">
      <xsl:call-template name="blank4"/>
      <xsl:value-of select="$kikanNames"/>
    </xsl:if>
    <br/>

    <xsl:text>地域　　　　　</xsl:text>
    <xsl:choose>
      <xsl:when test="$kind = '気温'">
        <xsl:call-template name="indicatorLine">
          <xsl:with-param name="kind" select="$kind"/>
          <xsl:with-param name="label" select="'低　並　高'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="indicatorLine">
          <xsl:with-param name="kind" select="$kind"/>
          <xsl:with-param name="label" select="'少　並　多'"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>％</xsl:text>
    <br/>
    <xsl:call-template name="mkDanraku">
      <xsl:with-param name="str" select="$tblStr"/>
    </xsl:call-template>
    <br/>
  </xsl:if>
</xsl:template>


<!-- .......................................... -->
<!-- 確率の表（３か月予報）用 期間名称テンプレート -->
<xsl:template name="indicatorLine">
  <xsl:param name="kind"/>
  <xsl:param name="label"/>
  <xsl:value-of select="$label"/>
  <xsl:variable name="labelStr">
    <xsl:apply-templates
        select="//jmx_mete:TimeSeriesInfo//jmx_eb:ClimateProbabilityValues[@kind=$kind]"
        mode="ThreeMonthsTblLabel">
      <xsl:with-param name="type" select="$label"/>
    </xsl:apply-templates>
  </xsl:variable>
  <xsl:if test="string-length($labelStr) &gt; 0">
    <xsl:call-template name="blank2"/>
    <xsl:value-of select="$labelStr"/>
  </xsl:if>
</xsl:template>

<xsl:template
    match="jmx_eb:ClimateProbabilityValues"
    mode="ThreeMonthsTblLabel">
  <xsl:param name="type"/>
  <xsl:variable name="id" select="@refID"/>
  <xsl:if test="position() &lt; 4">
    <xsl:variable name="label">
      <xsl:choose>
        <xsl:when test="string-length($type) &gt; 0">
          <xsl:value-of select="$type"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of
            select="//jmx_mete:TimeDefine[@timeId=$id]/jmx_mete:Name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$label"/>
    <xsl:if test="position() &lt; 3">
      <xsl:call-template name="blanks">
        <xsl:with-param name="n" select="7 - string-length($label)"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- ........................................ -->
<!-- 確率の表（３か月予報）用 １行分テンプレート -->
<xsl:template
    match="jmx_eb:ClimateProbabilityValues"
    mode="ThreeMonths">
  <xsl:variable name="areaName">
    <xsl:call-template name="areaShortName">
      <xsl:with-param name="areaName"
          select="../../../../jmx_mete:Areas//jmx_mete:Name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="number(@refID) &gt; 0"/>
    <xsl:otherwise>
      <xsl:value-of select="$BR"/>
      <xsl:value-of select="$areaName"/>
      <xsl:call-template name="blanks">
        <xsl:with-param name="n" select="6 - string-length($areaName)"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:call-template name="blank1"/>
  <xsl:call-template name="ZenNum">
    <xsl:with-param name="Num">
      <xsl:value-of select="jmx_eb:ProbabilityOfBelowNormal"/>
      <xsl:value-of select="jmx_eb:ProbabilityOfNormal"/>
      <xsl:value-of select="jmx_eb:ProbabilityOfAboveNormal"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ........................................ -->
<!-- 予報対象地域名の略称（３か月予報の表で用いる） -->
<xsl:template name="areaShortName">
  <xsl:param name="areaName"/>
  <xsl:choose>
    <xsl:when test="contains($areaName, '日本日本海側') or
                     $areaName = '北海道日本海側'">
      <xsl:value-of select="substring-before($areaName, '日本海側')"/>
      <xsl:text>（日）</xsl:text>
    </xsl:when>
    <xsl:when test="contains($areaName, '日本太平洋側') or
                     $areaName = '北海道太平洋側'">
      <xsl:value-of select="substring-before($areaName, '太平洋側')"/>
      <xsl:text>（太）</xsl:text>
    </xsl:when>
    <xsl:when test="$areaName = '北海道オホーツク海側'">
      <xsl:text>北海道（オ）</xsl:text>
    </xsl:when>
    <xsl:when test="contains($areaName, '九州北部地方')">
      <xsl:text>九州北部地方</xsl:text>
    </xsl:when>
    <xsl:when test="$areaName = '九州南部・奄美地方'">
      <xsl:text>九州南部奄美</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$areaName"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ..................................... -->
<!-- 予報の対象期間（１か月予報）テンプレート -->
<xsl:template match="jmx_mete:DateTime" mode="kikanName">
  <xsl:variable name="midashi">
    <xsl:choose>
      <xsl:when test="../@timeId &gt; 0">
        <xsl:value-of select="../jmx_mete:Name"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>１か月</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$midashi"/>
  <xsl:call-template name="blanks">
    <xsl:with-param name="n" select="6 - string-length($midashi)"/>
  </xsl:call-template>
  <xsl:text>：</xsl:text>
  <xsl:call-template name="DispDateTime03">
    <xsl:with-param name="Jikan" select="."/>
  </xsl:call-template>
  <xsl:text>～</xsl:text>
  <xsl:call-template name="DispDateTime03">
    <xsl:with-param name="Jikan">
      <xsl:call-template name="DateCalc">
        <xsl:with-param name="Hizuke" select="."/>
        <xsl:with-param name="Duration" select="../jmx_mete:Duration"/>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
  <br/>
</xsl:template>

<!-- ........................ -->
<!-- 次回発表予定等テンプレート -->
<xsl:template match="jmx_mete:NextForecastSchedule">
  <xsl:value-of select="$BR"/>
  <xsl:variable name="txt" select="jmx_mete:Text"/>
  <xsl:if test="not(contains($txt, @target))">
    <xsl:value-of select="@target"/>
    <xsl:text>：</xsl:text>
  </xsl:if>
  <xsl:value-of select="jmx_mete:Text"/>
</xsl:template>

<!-- ============================ -->
<!-- 「＜(小見出し)＞(改行)」を出力 -->
<!-- ============================ -->
<xsl:template name="Komidashi">
  <xsl:param name="value"/>
  <xsl:value-of select="concat('＜', $value, '＞', $BR)"/>
</xsl:template>

<!-- ============================================== -->
<!-- アンカー文字列による全角スペース区切りテンプレート -->
<!-- ============================================== -->
<xsl:template name="SepareteWithSpc">
  <xsl:param name="TargetString">dummy1</xsl:param>
  <xsl:param name="Anchor">dummy2</xsl:param>
  <xsl:param name="AnchorBody" select="translate($Anchor, ' ', '')"/>
  <xsl:call-template name="ZenNum">
    <xsl:with-param name="Num"
        select="substring-before($TargetString, $AnchorBody)"/>
  </xsl:call-template>
  <xsl:choose>
  <xsl:when test="starts-with($Anchor, ' ')">
    <xsl:call-template name="blank1"/>
    <xsl:value-of select="$AnchorBody"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="$AnchorBody"/>
    <xsl:call-template name="blank1"/>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:call-template name="ZenNum">
    <xsl:with-param name="Num"
        select="substring-after($TargetString, $AnchorBody)"/>
  </xsl:call-template>
</xsl:template>

<!-- ======== -->
<!-- 日付加算 -->
<!-- ======== -->
<xsl:template name="DateCalc">
  <xsl:param name="Hizuke">dummy</xsl:param>
  <xsl:param name="Duration">dummy</xsl:param>
  <xsl:variable name="offsetStr">
    <xsl:call-template name="OffsetOfMonthAndDay">
      <xsl:with-param name="Duration" select="$Duration"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <!-- 通常処理（月単位計算以外） -->
    <xsl:when test="substring-before($offsetStr, '/')='0'">
      <xsl:call-template name="DateCalcOffcet">
        <xsl:with-param name="Hizuke" select="$Hizuke"/>
        <xsl:with-param name="offsetStr" select="$offsetStr"/>
      </xsl:call-template>
    </xsl:when>
    <!-- 特別処理（月単位計算） -->
    <xsl:otherwise>
      <!-- 先に日計算を行う -->
      <xsl:variable name="date1">
        <xsl:call-template name="DateCalcOffcet">
          <xsl:with-param name="Hizuke" select="$Hizuke"/>
          <xsl:with-param name="offsetStr" select="concat('0/',substring-after($offsetStr, '/'))"/>
        </xsl:call-template>
      </xsl:variable>
      <!-- 次に月計算を行う -->
      <xsl:variable name="date2">
        <xsl:call-template name="DateCalcOffcet">
          <xsl:with-param name="Hizuke" select="$date1"/>
          <xsl:with-param name="offsetStr" select="concat(substring-before($offsetStr, '/'),'/0')"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <!-- date1とdate2の日付に違いがあれば繰り越してしまったので前月末とする（日付分を引く） -->
        <xsl:when test="substring($date1,9,2)!=substring($date2,9,2)">
          <xsl:call-template name="DateCalcOffcet">
            <xsl:with-param name="Hizuke" select="$date2"/>
            <xsl:with-param name="offsetStr" select="concat('0/-',substring($date2,9,2))"/>
          </xsl:call-template>
        </xsl:when>
        <!-- date1とdate2の日付が同じならそのまま出力する -->
        <xsl:otherwise>
          <xsl:value-of select="$date2"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:value-of select="concat('[', $offsetStr, ']')"/>
</xsl:template>
  
<xsl:template name="DateCalcOffcet">
  <xsl:param name="Hizuke"/>
  <xsl:param name="offsetStr"/>
  <xsl:variable name="tusanDay">
    <xsl:call-template name="date2tusan">
      <xsl:with-param name="year"  select="number(substring($Hizuke,1,4))"/>
      <xsl:with-param name="month"
        select="number(substring($Hizuke,6,2)) + 
                number(substring-before($offsetStr, '/'))"/>
      <xsl:with-param name="day"
        select="number(substring($Hizuke,9,2))+ 
                number(substring-after($offsetStr, '/'))"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:call-template name="tusan2date">
    <xsl:with-param name="tusan" select="$tusanDay"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="OffsetOfMonthAndDay">
  <xsl:param name="Duration">P0D</xsl:param>
  <xsl:choose>
    <xsl:when test="starts-with($Duration, 'P')">
      <xsl:variable name="valPart" select="substring-after($Duration, 'P')"/>
      <xsl:choose>
        <xsl:when test="contains($valPart, 'M')">
          <xsl:value-of
            select="concat(substring-before($valPart, 'M'), '/-1')"/>
        </xsl:when>
        <xsl:when test="contains($valPart, 'D')">
          <xsl:value-of
            select="concat('0/', number(substring-before($valPart, 'D')) - 1)"/>
        </xsl:when>
        <xsl:otherwise>0/0</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>0/0</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ========================================================= -->
<!-- 日付計算:1988/1/1 を 1 とした通算日から YYYY-MM-DD に変換 -->
<!-- ========================================================= -->
<xsl:template name="tusan2date">
  <xsl:param name="tusan">0</xsl:param>
  <xsl:call-template name="countYears">
    <xsl:with-param name="remain" select="$tusan"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="countYears">
  <xsl:param name="year">1988</xsl:param>
  <xsl:param name="remain">0</xsl:param>
  <xsl:variable name="daysOfTheYear">
    <xsl:call-template name="daysOfTheYear">
      <xsl:with-param name="year" select="$year"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$remain &gt; $daysOfTheYear">
      <xsl:call-template name="countYears">
        <xsl:with-param name="year" select="$year + 1"/>
        <xsl:with-param name="remain" select="$remain - $daysOfTheYear"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat($year, '-')"/>
      <xsl:call-template name="countMonths">
        <xsl:with-param name="remain" select="$remain"/>
        <xsl:with-param name="daysOfTheYear" select="$daysOfTheYear"/>
      </xsl:call-template>
   </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="countMonths">
  <xsl:param name="month">1</xsl:param>
  <xsl:param name="remain">0</xsl:param>
  <xsl:param name="daysOfTheYear">0</xsl:param>
  <xsl:variable name="daysOfTheMonth">
    <xsl:call-template name="daysOfTheMonth">
      <xsl:with-param name="daysOfTheYear" select="$daysOfTheYear"/>
      <xsl:with-param name="month" select="$month"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$remain &gt; $daysOfTheMonth">
      <xsl:call-template name="countMonths">
        <xsl:with-param name="month" select="$month + 1"/>
        <xsl:with-param name="remain" select="$remain - $daysOfTheMonth"/>
        <xsl:with-param name="daysOfTheYear" select="$daysOfTheYear"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat(floor($month div 10), $month mod 10, '-',
                                     floor($remain div 10), $remain mod 10)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ================================================ -->
<!-- 日付計算:年月日から1988/1/1 を 1 とした通算日に変換 -->
<!-- ================================================ -->
<xsl:template name="date2tusan">
  <xsl:param name="year">1988</xsl:param>
  <xsl:param name="month">1</xsl:param>
  <xsl:param name="day">1</xsl:param>
  <xsl:variable name="normYM">
    <xsl:call-template name="MonthNormarize">
      <xsl:with-param name="year"  select="$year"/>
      <xsl:with-param name="month" select="$month"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="normYear" select="substring-before($normYM, '-')"/>
  <xsl:variable name="normMonth" select="substring-after($normYM, '-')"/>
  <xsl:variable name="yearSekisanDays">
    <xsl:call-template name="yearSekisan">
      <xsl:with-param name="topYear" select="1988"/>
      <xsl:with-param name="endYear" select="$normYear"/>
      <xsl:with-param name="sekisan" select="0"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="monthSekisanDays">
    <xsl:call-template name="monthSekisan">
      <xsl:with-param name="topMonth" select="1"/>
      <xsl:with-param name="endMonth" select="$normMonth"/>
      <xsl:with-param name="sekisan" select="0"/>
      <xsl:with-param name="daysOfTheYear">
        <xsl:call-template name="daysOfTheYear">
          <xsl:with-param name="year" select="$normYear"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="$yearSekisanDays + $monthSekisanDays + $day"/>
</xsl:template>

<xsl:template name="MonthNormarize">
  <xsl:param name="year">1988</xsl:param>
  <xsl:param name="month">1</xsl:param>
  <xsl:choose>
    <xsl:when test="$month &lt; 1">
      <xsl:call-template name="MonthNormarize">
        <xsl:with-param name="year"  select="$year - 1"/>
        <xsl:with-param name="month" select="$month + 12"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$month &gt; 12">
      <xsl:call-template name="MonthNormarize">
        <xsl:with-param name="year"  select="$year + 1"/>
        <xsl:with-param name="month" select="$month - 12"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat($year, '-',
                                     floor($month div 10), $month mod 10)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="yearSekisan">
  <xsl:param name="sekisan">0</xsl:param>
  <xsl:param name="topYear">0</xsl:param>
  <xsl:param name="endYear">0</xsl:param>
  <xsl:choose>
    <xsl:when test="$topYear &lt; $endYear">
      <xsl:variable name="daysOfTheYear">
        <xsl:call-template name="daysOfTheYear">
          <xsl:with-param name="year" select="$topYear"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:call-template name="yearSekisan">
         <xsl:with-param name="sekisan"
           select="$sekisan + number($daysOfTheYear)"/>
      <xsl:with-param name="topYear" select="$topYear + 1"/>
      <xsl:with-param name="endYear" select="$endYear"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$sekisan"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="monthSekisan">
  <xsl:param name="sekisan">0</xsl:param>
  <xsl:param name="topMonth">1</xsl:param>
  <xsl:param name="endMonth">0</xsl:param>
  <xsl:param name="daysOfTheYear">0</xsl:param>
  <xsl:choose>
    <xsl:when test="$topMonth &lt; $endMonth">
      <xsl:variable name="daysOfTheMonth">
        <xsl:call-template name="daysOfTheMonth">
          <xsl:with-param name="daysOfTheYear" select="$daysOfTheYear"/>
          <xsl:with-param name="month" select="$topMonth"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:call-template name="monthSekisan">
        <xsl:with-param name="sekisan"
          select="$sekisan + number($daysOfTheMonth)"/>
        <xsl:with-param name="topMonth" select="$topMonth + 1"/>
        <xsl:with-param name="endMonth" select="$endMonth"/>
        <xsl:with-param name="daysOfTheYear" select="$daysOfTheYear"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$sekisan"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- 日付計算:その年一年間の日数 -->
<xsl:template name="daysOfTheYear">
  <xsl:param name="year">0</xsl:param>
  <xsl:choose>
    <xsl:when test="$year mod 400 = 0">
      <xsl:value-of select="366"/>
    </xsl:when>
    <xsl:when test="$year mod 100 = 0">
      <xsl:value-of select="365"/>
    </xsl:when>
    <xsl:when test="$year mod 4 = 0">
      <xsl:value-of select="366"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="365"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- 日付計算:その月の日数           -->
<xsl:template name="daysOfTheMonth">
  <xsl:param name="daysOfTheYear">0</xsl:param>
  <xsl:param name="month">0</xsl:param>
  <xsl:choose>
    <xsl:when test="($daysOfTheYear = 366) and ($month = 2)">
      <xsl:value-of select="29"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="daysOfMonthAtNormalYear">
        <xsl:with-param name="month" select="$month"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- 日付計算:その月の日数（閏年以外） -->
<xsl:template name="daysOfMonthAtNormalYear">
  <xsl:param name="month">1</xsl:param>
  <xsl:variable name="DaysOfMonthsString">
    ,1/31,2/28,3/31,4/30,5/31,6/30,7/31,8/31,9/30,10/31,11/30,12/31,
  </xsl:variable>
  <xsl:value-of select="substring(
    substring-after($DaysOfMonthsString, concat(',', $month, '/')),
    1, 2)"/>  
</xsl:template>

<!-- ========================================== -->
<!-- 曜日（1988/1/1 を 1 とした通算日指定による） -->
<!-- ========================================== -->
<xsl:template name="kanjiDayOfWeek">
  <xsl:param name="tusanDay">0</xsl:param>
  <xsl:variable name="DaysOfWeekStr">木金土日月火水</xsl:variable>
  <xsl:value-of select="substring($DaysOfWeekStr, ($tusanDay mod 7) + 1, 1)"/>
</xsl:template>

<!-- ========================== -->
<!-- 日付表示テンプレート(日単位) -->
<!-- ========================== -->
<xsl:template name="DispDateTime0">
  <xsl:param name="Jikan">dummy</xsl:param>
  <xsl:text>令和</xsl:text>
  <xsl:if test="number(substring($Jikan,1,4))=2019">
    <xsl:text>元</xsl:text>
  </xsl:if>
  <xsl:if test="number(substring($Jikan,1,4))!=2019">
    <xsl:call-template name="ZenNum">
      <xsl:with-param name="Num" select="number(substring($Jikan,1,4)) - 2018 "/>
    </xsl:call-template>
  </xsl:if>
  <xsl:text>年</xsl:text>
  <xsl:call-template name="ZenNum">
    <xsl:with-param name="Num" select="number(substring($Jikan,6,2))"/>
  </xsl:call-template>
  <xsl:text>月</xsl:text>
  <xsl:call-template name="ZenNum">
    <xsl:with-param name="Num" select="number(substring($Jikan,9,2))"/>
  </xsl:call-template>
  <xsl:text>日</xsl:text>
</xsl:template>

<!-- ======================= -->
<!-- 日付表示テンプレート(月)  -->
<!-- ======================= -->
<xsl:template name="DispDateTime01">
  <xsl:param name="Jikan">dummy</xsl:param>
  <xsl:call-template name="ZenNum">
    <xsl:with-param name="Num" select="number(substring($Jikan,6,2))"/>
  </xsl:call-template>
  <xsl:text>月</xsl:text>
</xsl:template>

<!-- ======================== -->
<!-- 日付表示テンプレート(月日) -->
<!-- ======================== -->
<xsl:template name="DispDateTime02">
  <xsl:param name="Jikan">dummy</xsl:param>
  <xsl:call-template name="ZenNum">
    <xsl:with-param name="Num" select="number(substring($Jikan,6,2))"/>
  </xsl:call-template>
  <xsl:text>月</xsl:text>
  <xsl:call-template name="ZenNum">
    <xsl:with-param name="Num" select="number(substring($Jikan,9,2))"/>
  </xsl:call-template>
  <xsl:text>日</xsl:text>
</xsl:template>

<!-- ================================ -->
<!-- 日付表示テンプレート(月日)曜日付き -->
<!-- ================================ -->
<xsl:template name="DispDateTime03">
  <xsl:param name="Jikan">dummy</xsl:param>
  <xsl:variable name="year"  select="number(substring($Jikan,1,4))"/>
  <xsl:variable name="month" select="number(substring($Jikan,6,2))"/>
  <xsl:variable name="day"   select="number(substring($Jikan,9,2))"/>
  <xsl:call-template name="niketaNum">
    <xsl:with-param name="Num" select="$month"/>
  </xsl:call-template>
  <xsl:text>月</xsl:text>
  <xsl:call-template name="niketaNum">
    <xsl:with-param name="Num" select="$day"/>
  </xsl:call-template>
  <xsl:text>日（</xsl:text>
  <xsl:call-template name="kanjiDayOfWeek">
    <xsl:with-param name="tusanDay">
      <xsl:call-template name="date2tusan">
        <xsl:with-param name="year"  select="$year"/>
        <xsl:with-param name="month" select="$month"/>
        <xsl:with-param name="day"   select="$day"/>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
  <xsl:text>）</xsl:text>
</xsl:template>

<xsl:template name="niketaNum">
  <xsl:param name="Num">0</xsl:param>
  <xsl:if test="$Num &lt; 10">
    <xsl:call-template name="blank1"/>
  </xsl:if>
  <xsl:call-template name="ZenNum">
    <xsl:with-param name="Num" select="$Num"/>
  </xsl:call-template>
</xsl:template>

<!-- ========================== -->
<!-- 日付表示テンプレート(分単位) -->
<!-- ========================== -->
<xsl:template name="DispDateTime1">
  <xsl:param name="Jikan">dummy</xsl:param>
  <xsl:text>令和</xsl:text>
  <xsl:if test="number(substring($Jikan,1,4))=2019">
    <xsl:text>元</xsl:text>
  </xsl:if>
  <xsl:if test="number(substring($Jikan,1,4))!=2019">
    <xsl:call-template name="ZenNum">
      <xsl:with-param name="Num" select="number(substring($Jikan,1,4)) - 2018 "/>
    </xsl:call-template>
  </xsl:if>
  <xsl:text>年</xsl:text>
  <xsl:value-of select="number(substring($Jikan,6,2))"/>
  <xsl:text>月</xsl:text>
  <xsl:value-of select="number(substring($Jikan,9,2))"/>
  <xsl:text>日</xsl:text>
  <xsl:value-of select="substring($Jikan,12,2)"/>
  <xsl:text>時</xsl:text>
  <xsl:value-of select="substring($Jikan,15,2)"/>
  <xsl:text>分</xsl:text>
</xsl:template>

<!-- ========================== -->
<!-- 日付表示テンプレート(秒単位) -->
<!-- ========================== -->
<xsl:template name="DispDateTime2">
  <xsl:param name="Jikan">dummy</xsl:param>
  <xsl:text>令和</xsl:text>
  <xsl:if test="number(substring($Jikan,1,4))=2019">
    <xsl:text>元</xsl:text>
  </xsl:if>
  <xsl:if test="number(substring($Jikan,1,4))!=2019">
    <xsl:call-template name="ZenNum">
      <xsl:with-param name="Num" select="number(substring($Jikan,1,4)) - 2018 "/>
    </xsl:call-template>
  </xsl:if>
  <xsl:text>年</xsl:text>
  <xsl:value-of select="number(substring($Jikan,6,2)) + 0"/>
  <xsl:text>月</xsl:text>
  <xsl:value-of select="number(substring($Jikan,9,2)) + 0"/>
  <xsl:text>日</xsl:text>
  <xsl:value-of select="substring($Jikan,12,2)"/>
  <xsl:text>時</xsl:text>
  <xsl:value-of select="substring($Jikan,15,2)"/>
  <xsl:text>分</xsl:text>
  <xsl:value-of select="substring($Jikan,18,2)"/>
  <xsl:text>秒</xsl:text>
</xsl:template>

<!-- ====================== -->
<!-- 全角数字表示テンプレート -->
<!-- ====================== -->
<xsl:template name="ZenNum">
  <xsl:param name="Num">dummy</xsl:param>
  <xsl:value-of
      select="translate($Num, '.+-%0123456789', '．＋－％０１２３４５６７８９')"/>
</xsl:template>

<!-- ========================== -->
<!-- 全角スペース表示テンプレート -->
<!-- ========================== -->
<xsl:template name="blank1"><xsl:text>　</xsl:text></xsl:template>
<xsl:template name="blank2"><xsl:text>　　</xsl:text></xsl:template>
<xsl:template name="blank3"><xsl:text>　　　</xsl:text></xsl:template>
<xsl:template name="blank4"><xsl:text>　　　　</xsl:text></xsl:template>
<xsl:template name="blank5"><xsl:text>　　　　　</xsl:text></xsl:template>
<xsl:template name="blank6"><xsl:text>　　　　　　</xsl:text></xsl:template>

<xsl:template name="blanks">
  <xsl:param name="n">0</xsl:param>
  <xsl:if test="$n &gt; 0">
    <xsl:call-template name="blank1"/>
    <xsl:call-template name="blanks">
      <xsl:with-param name="n" select="$n - 1"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- ============================================ -->
<!-- 段落（１行３４文字）表示テンプレート           -->
<!--   jisage = 0: １行目の字下げ無し              -->
<!--   jisage = 1: １行目の字下げあり              -->
<!--   jisage = 2: １段落めは字下げ無し、          -->
<!--               ２段落め以後は１行目の字下げあり -->
<!--    ※ 禁則処理は $KinsokuChars で制御する     -->
<!-- ============================================ -->
<xsl:variable name="KinsokuChars" select="''" />
<!--
<xsl:variable name="KinsokuChars" select="'、。'" />
-->

<xsl:template name="mkDanraku">
  <xsl:param name="str">dummy</xsl:param>
  <xsl:param name="jisage">0</xsl:param>
  <xsl:choose>
    <xsl:when test="starts-with($str, '＜')">
      <xsl:call-template name="mkDanraku1">
        <xsl:with-param name="str" select="$str"/>
        <xsl:with-param name="jisage" select="$jisage"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="mkDanraku1">
        <xsl:with-param name="str">
          <xsl:if test="$jisage = 1 and not(starts-with($str, '　')) and 
                         string-length($str) &gt; 0">
            <xsl:call-template name="blank1"/>
          </xsl:if>
          <xsl:value-of select="$str"/>
        </xsl:with-param>
        <xsl:with-param name="jisage" select="$jisage"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="mkDanraku1">
  <xsl:param name="str">dummy</xsl:param>
  <xsl:param name="jisage">0</xsl:param>
  <xsl:variable name="jisage2">
    <xsl:choose>
      <xsl:when test="$jisage = 2">
        <xsl:value-of select="1"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$jisage"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="contains($str, $BR)">
      <xsl:call-template name="mkLine">
        <xsl:with-param name="danraku" select="substring-before($str, $BR)"/>
      </xsl:call-template>
      <xsl:call-template name="mkDanraku">
        <xsl:with-param name="str"
            select="substring-after($str, $BR)"/>
        <xsl:with-param name="jisage" select="$jisage2"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="mkLine">
        <xsl:with-param name="danraku" select="$str"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="mkLine">
  <xsl:param name="danraku">dummy</xsl:param>
  <xsl:variable name="len" select="string-length($danraku)"/>
  <xsl:choose>
    <xsl:when test="$len = 0"/>
    <xsl:when test="$len &lt; 35">
      <xsl:value-of select="$danraku"/>
      <br/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="kaigyoPos">
        <xsl:choose>
          <xsl:when test="string-length($KinsokuChars) &gt; 0 and
                           contains($KinsokuChars,
                             substring(substring($danraku, 35), 1, 1) )">
            <xsl:value-of select="33"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="34"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:value-of select="substring($danraku, 1, $kaigyoPos)"/>
      <br/>
      <xsl:call-template name="mkLine">
        <xsl:with-param name="danraku"
            select="substring($danraku, $kaigyoPos + 1)"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
