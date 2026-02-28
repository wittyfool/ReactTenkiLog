<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:jmx="http://xml.kishou.go.jp/jmaxml1/"
  xmlns:jmx_ib="http://xml.kishou.go.jp/jmaxml1/informationBasis1/"
  xmlns:jmx_eb="http://xml.kishou.go.jp/jmaxml1/elementBasis1/"
  xmlns:jmx_mete="http://xml.kishou.go.jp/jmaxml1/body/meteorology1/"
  xmlns:jmx_add="http://xml.kishou.go.jp/jmaxml1/addition1/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  version="1.0">

<!--
  ======================================================================
  本スタイルシートは、気象庁防災情報XMLフォーマット形式電文中の全ての情報コンテンツを出力するもので、システム処理の動作確認など、電文処理の参考資料としてお使い下さい。

  なお、本スタイルシートについては、システムに直接組み込む等の方法でご利用になることは避けていただくなど、ご利用に当たっては十分に注意していただきますよう、よろしくお願いいたします。

  Copyright (c) 気象庁 2012 All rights reserved.
  
　【対象情報】
　全般・地方気象情報（社会的に影響の大きい天候に関する情報）

  【更新履歴】
  2012年03月29日　Ver.1.0
  2019年04月24日　Ver.1.1 5月1日より施行される新元号への対応
  2024年02月16日　Ver.1.1 コメント行の【対象情報】より「府県気象情報（社会的に影響の大きい天候に関する情報）」を削除
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
	<title>天候情報</title>
	</head>
	<body>
  <table border="1" width="75%" align="center" font-size="12pt">
  <tr><td style='font-family: monospace'>

  <!-- 電文基本要素 -->
  <xsl:apply-templates select="/jmx:Report/jmx_ib:Head" mode="Basic"/>
  <br/>


  <!-- 見出し -->
  <xsl:text>（見出し）</xsl:text>
  <br/>
  <xsl:call-template name="mkDanraku">
    <xsl:with-param name="str"
      select="//jmx_ib:Headline/jmx_ib:Text"/>
    <xsl:with-param name="jisage" select="1"/>
  </xsl:call-template>
  <br/>

  <!-- 本文 -->
  <xsl:text>（本文）</xsl:text>
  <br/>
  <xsl:apply-templates select="//jmx_mete:MeteorologicalInfo//jmx_mete:Text"
      mode="honbun"/>

  <!-- 梅雨の場合の参考事項 -->
  <xsl:variable name="tuyuSankoStrNormal">
    <xsl:apply-templates select="//jmx_mete:EventDatePart" mode="tuyuSanko">
      <xsl:with-param name="tgt" select="'normal'"/>
    </xsl:apply-templates>
  </xsl:variable>
  <xsl:if test="string-length($tuyuSankoStrNormal) &gt; 0">
    <br/>
    <xsl:text>（参考事項）</xsl:text>
    <br/>
    <xsl:call-template name="mkDanraku">
      <xsl:with-param name="str" select="$tuyuSankoStrNormal"/>
    </xsl:call-template>
    <xsl:if test="contains($tuyuSankoStrNormal, $BR)">
      <br/>
    </xsl:if>
  </xsl:if>
  <xsl:variable name="tuyuSankoStrLastYear">
    <xsl:apply-templates select="//jmx_mete:EventDatePart" mode="tuyuSanko">
      <xsl:with-param name="tgt" select="'lastYear'"/>
    </xsl:apply-templates>
  </xsl:variable>
  <xsl:if test="string-length($tuyuSankoStrLastYear) &gt; 0">
    <xsl:call-template name="mkDanraku">
      <xsl:with-param name="str" select="$tuyuSankoStrLastYear"/>
    </xsl:call-template>
  </xsl:if>

  <!-- 実況値の表 -->
  <xsl:apply-templates
    select="//jmx_mete:MeteorologicalInfo[@type='アメダス' or @type='気象官署及び特別地域気象観測所']"
    mode="jikkyoTbl">
  </xsl:apply-templates>

  <!-- 末文 -->
  <xsl:variable name="commentTxt" select="//jmx_mete:Comment/jmx_mete:Text"/>
  <xsl:if test="string-length($commentTxt) &gt; 0">
    <br/>
    <xsl:call-template name="mkDanrakuWithSpc">
      <xsl:with-param name="str">
        <xsl:call-template name="blank1"/>
        <xsl:value-of select="$commentTxt"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:if>

  <!-- 注意事項 -->
  <xsl:variable name="noticeTxt" select="//jmx_mete:Body/jmx_mete:Notice"/>
  <xsl:if test="string-length($noticeTxt) &gt; 0">
    <br/>
    <xsl:call-template name="mkDanrakuWithSpc">
      <xsl:with-param name="str" select="$noticeTxt"/>
    </xsl:call-template>
  </xsl:if>

  <!-- 末尾の'=' -->
  <xsl:text>=</xsl:text>

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
  <xsl:value-of select="jmx_ib:Title"/>
  <xsl:call-template name="blank1"/>
  <xsl:call-template name="ZenNum">
    <xsl:with-param name="Num" select="concat('第', jmx_ib:Serial, '号')"/>
  </xsl:call-template>
  <br/>

  <!-- 発表日時行 -->
  <xsl:call-template name="ZenNum">
    <xsl:with-param name="Num">
      <xsl:call-template name="DispDateTime1">
        <xsl:with-param name="Jikan" select="jmx_ib:ReportDateTime"/>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
  <xsl:call-template name="blank1"/>

  <!-- 発表官署 -->
  <xsl:value-of select="/jmx:Report/jmx:Control/jmx:PublishingOffice"/>
  <xsl:text>発表</xsl:text>
  <br/>
</xsl:template>

<!-- =============== -->
<!-- 本文テンプレート -->
<!-- =============== -->
<xsl:template match="jmx_mete:Text" mode="honbun">
  <xsl:if test="../jmx_mete:Type = '本文'">
    <xsl:call-template name="mkDanrakuWithSpc">
      <xsl:with-param name="str" select="."/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="mkDanrakuWithSpc">
  <xsl:param name="str"/>
  <xsl:variable name="nigyome" select="substring-after($str, $BR)"/>
  <xsl:call-template name="mkDanraku">
    <xsl:with-param name="str" select="$str"/>
    <xsl:with-param name="jisage">
      <xsl:choose>
<!--
        <xsl:when test="starts-with($nigyome, '　　')">
          <xsl:value-of select="-6"/>
        </xsl:when>
-->
        <xsl:when test="starts-with($str, '　')">
          <xsl:value-of select="0"/>
        </xsl:when>
        <xsl:when test="starts-with($str, '（')">
          <xsl:value-of select="0"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ======================== -->
<!-- 梅雨の参考事項テンプレート -->
<!-- ========================= -->
<xsl:template match="jmx_mete:EventDatePart" mode="tuyuSanko">
  <xsl:param name="tgt">dummy</xsl:param>
  <xsl:if test="position() = 1">
    <xsl:call-template name="blank1"/>
      <xsl:choose>
        <xsl:when test="$tgt = 'normal'">
          <xsl:text>平年の</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>昨年の</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    <xsl:value-of select="../jmx_mete:Type"/>
  </xsl:if>
  <xsl:variable name="partArea"
      select="../../../jmx_mete:Areas//jmx_mete:Name"/>
  <xsl:variable name="targetArea"
      select="//jmx_mete:Body/jmx_mete:TargetArea/jmx_mete:Name"/>
  <xsl:choose>
    <xsl:when test="$partArea = $targetArea"/>
    <xsl:otherwise>
      <xsl:value-of select="$BR"/>
      <xsl:call-template name="blank2"/>
      <xsl:value-of select="$partArea"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:call-template name="blank1"/>
  <xsl:choose>
    <xsl:when test="$tgt = 'normal'">
      <xsl:value-of select="jmx_mete:Normal/@description"/>
      <xsl:if test="string-length(jmx_mete:Remark) &gt; 0 and
                     contains(jmx_mete:Remark, '平年')">
        <xsl:if test="string-length(jmx_mete:LastYear/@description) &gt; 0">
          <xsl:call-template name="blank1"/>
        </xsl:if>
        <xsl:value-of select="jmx_mete:Remark"/>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="jmx_mete:LastYear/@description"/>
      <xsl:if test="string-length(jmx_mete:Remark) &gt; 0 and
                     not(contains(jmx_mete:Remark, '平年'))">
        <xsl:if test="string-length(jmx_mete:LastYear/@description) &gt; 0">
          <xsl:value-of select="$BR"/>
          <xsl:call-template name="blank1"/>
        </xsl:if>
        <xsl:value-of select="jmx_mete:Remark"/>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<!-- ==================== -->
<!-- 実況値の表テンプレート -->
<!-- ==================== -->
<xsl:template match="jmx_mete:MeteorologicalInfo" mode="jikkyoTbl">

  <!-- 表題 -->
  <br/>
  <xsl:variable name="tblTitle">
    <xsl:value-of select=".//jmx_mete:Text[@type='表題']"/>
  </xsl:variable>
  <xsl:if test="string-length($tblTitle) &gt; 0">
    <xsl:call-template name="mkDanraku">
      <xsl:with-param name="str">
        <xsl:call-template name="blank1"/>
        <xsl:value-of select="$tblTitle"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:if>

  <!-- （官署種別） -->
  <xsl:variable name="kansyoType" select="@type"/>
  <xsl:if
      test="count(../jmx_mete:MeteorologicalInfo[@type!=$kansyoType]) &gt; 0">
    <xsl:call-template name="blank1"/>
    <xsl:value-of select="concat('（', @type, '）')"/>
    <br/>
  </xsl:if>

  <!-- リマーク収集 -->
  <xsl:variable name="remStrs">
    <xsl:apply-templates select="." mode="RemarkStrs"/>
  </xsl:variable>

  <!-- 表の本体 -->
  <xsl:call-template name="uniqYousoList">
    <xsl:with-param name="allItems">
      <xsl:apply-templates select=".//jmx_mete:ClimateValuesPart/@type" mode="yousoTypes"/>
    </xsl:with-param>
    <xsl:with-param name="prevStrs"><xsl:text>:</xsl:text></xsl:with-param>
    <xsl:with-param name="remStrs" select="$remStrs"/>
  </xsl:call-template>

  <!-- 品質マークの説明を収集 -->
  <xsl:variable name="condExplainStr">
<!--
    <xsl:call-template name="condExplain">
      <xsl:with-param name="values">
        <xsl:apply-templates
          select=".//jmx_mete:ClimateValuesPart/jmx_eb:*"
          mode="condMarks"/>
      </xsl:with-param>
    </xsl:call-template>
-->
  </xsl:variable>

  <!-- （記号の説明）タイトル -->
  <xsl:if test="string-length($remStrs) + 
                 string-length($condExplainStr) &gt; 0">
    <xsl:text>（記号の説明）</xsl:text><br/>
  </xsl:if>

  <!-- 品質マークの説明表示 -->
  <xsl:variable name="cesLen" select="string-length($condExplainStr)"/>
  <xsl:if test="$cesLen &gt; 0">
    <xsl:call-template name="mkDanraku">
      <xsl:with-param name="str"
          select="substring($condExplainStr, 1, $cesLen - 1)"/>
    </xsl:call-template>
  </xsl:if>

  <!-- リマーク文の表示 -->
  <xsl:variable name="remsLen" select="string-length($remStrs)"/>
  <xsl:if test="$remsLen &gt; 0">
    <xsl:call-template name="mkDanraku">
      <xsl:with-param name="str"
          select="substring($remStrs, 1, $remsLen - 1)"/>
    </xsl:call-template>
  </xsl:if>

</xsl:template>

<!-- ................... -->
<!-- 表の本体テンプレート -->
<xsl:template match="jmx_mete:ClimateValuesPart/@type" mode="yousoTypes"> <!-- "X:" -->
  <xsl:value-of select="."/>
  <xsl:text>:</xsl:text>
</xsl:template>

<xsl:template name="uniqYousoList">
  <xsl:param name="allItems"/> <!-- ex. "A:B:C:D:" -->
  <xsl:param name="prevStrs"/> <!-- ex. ":C:B:" -->
  <xsl:param name="remStrs"/>
  <xsl:if test="contains($allItems, ':')">
    <xsl:variable name="kouhoStr"  select="substring-before($allItems, ':')"/> <!-- "A" -->
    <xsl:variable name="nokoriStr" select="substring-after($allItems, ':')"/>  <!-- "B:C:D:" -->
    <xsl:choose>
      <xsl:when test="contains($prevStrs, concat(':', $kouhoStr, ':'))"> <!-- ":A:"? -->
        <!-- 取り出したタイプは処理済み、残りを処理する -->
        <xsl:call-template name="uniqYousoList">
          <xsl:with-param name="allItems" select="$nokoriStr"/>
          <xsl:with-param name="prevStrs" select="$prevStrs"/>
          <xsl:with-param name="remStrs" select="$remStrs"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- 取り出したタイプは初出、処理する -->
        <xsl:call-template name="tableOfTheType">
          <xsl:with-param name="type" select="$kouhoStr"/>
          <xsl:with-param name="remStrs" select="$remStrs"/>
        </xsl:call-template>
        <!-- 処理済みの列に加え、残りを処理する -->
        <xsl:call-template name="uniqYousoList">
          <xsl:with-param name="allItems" select="$nokoriStr"/> <!-- "B:C:D: -->
          <xsl:with-param name="prevStrs" select="concat($prevStrs, $kouhoStr, ':')"/> <!-- ":C:B:A:" -->
          <xsl:with-param name="remStrs" select="$remStrs"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template name="tableOfTheType">
  <xsl:param name="type"/>
  <xsl:param name="remStrs"/>
  <xsl:for-each select=".//jmx_mete:ClimateValuesPart[@type=$type]">
    <!-- 要素名 -->
    <xsl:if test="position() = 1">
      <xsl:call-template name="blanks">
        <xsl:with-param name="n" select="8"/>
      </xsl:call-template>
      <xsl:apply-templates select="./jmx_eb:*" mode="tblColumn">
        <xsl:sort select="position()"/>
        <xsl:with-param name="isTitle" select="1"/>
      </xsl:apply-templates>
      <br/>
    </xsl:if>
    <!-- 各地点の値 -->
    <xsl:apply-templates select="." mode="yousoTbl">
      <xsl:with-param name="remStrs" select="$remStrs"/>
      <xsl:with-param name="yousoType" select="$type"/>
    </xsl:apply-templates>
  </xsl:for-each>
</xsl:template>

<!-- 品質情報マーク収集 -->
<xsl:template match="*" mode="condMarks">
  <xsl:call-template name="dispValueWithCondition">
    <xsl:with-param name="value" select="."/>
    <xsl:with-param name="condition" select="@condition"/>
  </xsl:call-template>
</xsl:template>

<!-- 品質マークの説明テンプレート -->
<xsl:template name="condExplain">
  <xsl:param name="values"/>
  <xsl:if test="contains($values, '）')">
    <xsl:text>）：欠測を含みます。</xsl:text>
    <xsl:value-of select="$BR"/>
  </xsl:if>
  <xsl:if test="contains($values, '］')">
    <xsl:text>］：欠測を含み、平年との比較ができません。</xsl:text>
    <xsl:value-of select="$BR"/>
  </xsl:if>
  <xsl:if test="contains($values, '＃')">
    <xsl:text>＃：値に信頼性がなく、統計計算に利用できません。</xsl:text>
    <xsl:value-of select="$BR"/>
  </xsl:if>
  <xsl:if test="contains($values, '×')">
    <xsl:text>×：欠測です。</xsl:text>
    <xsl:value-of select="$BR"/>
  </xsl:if>
  <xsl:if test="contains($values, '／／')">
    <xsl:text>／／：期間の不足等の理由により、統計値がありません。</xsl:text>
    <xsl:value-of select="$BR"/>
  </xsl:if>
</xsl:template>

<!-- ...................... -->
<!-- リマーク収集テンプレート -->
<xsl:template match="jmx_mete:MeteorologicalInfo" mode="RemarkStrs">
  <xsl:call-template name="uniqRemStr">
    <xsl:with-param name="nums">
      <xsl:apply-templates select=".//jmx_mete:Remark" mode="RemNums"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="jmx_mete:Remark" mode="RemNums">
  <xsl:value-of select="position()"/>
  <xsl:text> </xsl:text>
</xsl:template>

<xsl:variable
  name="footNoteChars">＊＠☆★○●◎◇◆□■△▲▽▼∴§♂♀＄＆</xsl:variable>

<xsl:template name="uniqRemStr">
  <xsl:param name="nums"/>
  <xsl:param name="prevStrs"/>
  <xsl:param name="counts">1</xsl:param>
  <xsl:variable name="pos" select="substring-before($nums, ' ')"/>
  <xsl:if test="$pos &gt; 0">
    <xsl:variable name="kohoStr">
      <xsl:for-each select=".//jmx_mete:Remark">
        <xsl:if test="position() = $pos">
           <xsl:value-of select="."/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="newStr">
      <xsl:choose>
        <xsl:when test="contains($prevStrs, $kohoStr)"/>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$counts &gt; string-length($footNoteChars)">
              <xsl:text>※</xsl:text>
              <xsl:call-template name="ZenNum">
                <xsl:with-param name="Num"
                  select="$counts - string-length($footNoteChars)"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                  select="substring($footNoteChars, $counts, 1)"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text>：</xsl:text>  
          <xsl:value-of select="$kohoStr"/>
         </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="string-length($newStr) &gt; 0">
        <xsl:value-of select="$newStr"/>
        <xsl:value-of select="$BR"/>
        <xsl:call-template name="uniqRemStr">
          <xsl:with-param name="nums" select="substring-after($nums, ' ')"/>
          <xsl:with-param name="counts" select="$counts + 1"/>
          <xsl:with-param name="prevStrs">
            <xsl:value-of select="$prevStrs"/>
            <xsl:value-of select="$newStr"/>
            <xsl:value-of select="$BR"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="uniqRemStr">
          <xsl:with-param name="nums" select="substring-after($nums, ' ')"/>
          <xsl:with-param name="counts" select="$counts"/>
          <xsl:with-param name="prevStrs" select="$prevStrs"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<!-- ................... -->
<!-- 表の本体テンプレート -->
<xsl:template match="jmx_mete:ClimateValuesPart" mode="yousoTbl">
  <xsl:param name="remStrs"/>
  <xsl:param name="yousoType"/>
  <xsl:if test="$yousoType = @type">

    <!-- 官署名 -->
    <xsl:variable name="kansyoName"
        select="../../../jmx_mete:Station/jmx_mete:Name"/>
    <xsl:value-of select="$kansyoName"/>
    <xsl:call-template name="blanks">
      <xsl:with-param name="n" select="8 - string-length($kansyoName)"/>
    </xsl:call-template>

    <!-- 値表示 -->
    <xsl:variable name="valuesStr">
      <xsl:apply-templates select="jmx_eb:*" mode="tblColumn">
        <xsl:sort select="position()"/>
      </xsl:apply-templates>

      <!-- リマーク記号 -->
      <xsl:if test="string-length(jmx_mete:Remark) &gt; 0">
        <xsl:variable name="kStr">
          <xsl:value-of select="substring-before($remStrs,
                                    concat('：', jmx_mete:Remark))"/>
        </xsl:variable>
        <xsl:call-template name="lastItem">
          <xsl:with-param name="str" select="$kStr"/>
          <xsl:with-param name="key" select="$BR"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:variable>
    <xsl:call-template name="delLastSpcs">
      <xsl:with-param name="line" select="$valuesStr"/>
    </xsl:call-template>
    <br/>

  </xsl:if>

</xsl:template>

<xsl:template name="delLastSpcs">
  <xsl:param name="line"/>
  <xsl:variable name="len" select="string-length($line)"/>
  <xsl:choose>
    <xsl:when test="substring($line, $len, 1) = '　'">
      <xsl:call-template name="delLastSpcs">
        <xsl:with-param name="line" select="substring($line, 1, $len - 1)"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$line"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="lastItem">
  <xsl:param name="str"/>
  <xsl:param name="key"/>
  <xsl:choose>
    <xsl:when test="contains($str, $key)">
      <xsl:call-template name="lastItem">
        <xsl:with-param name="str" select="substring-after($str, $key)"/>
        <xsl:with-param name="key" select="$key"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$str"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ................. -->
<!-- 値表示テンプレート -->
<xsl:template match="jmx_eb:*" mode="tblColumn">
  <xsl:param name="isTitle"/>
  <xsl:variable name="colType">
    <xsl:choose>
      <xsl:when test="contains(@type, '平年値')">
        <xsl:value-of select="'平年値'"/>
      </xsl:when>
      <xsl:when test="contains(@type, '平年')">
        <xsl:value-of select="'平年差（比）'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'実況値'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="colWidth">
    <xsl:choose>
      <xsl:when test="$colType='平年値'">7</xsl:when>
      <xsl:when test="$colType='平年差（比）'">8</xsl:when>
      <xsl:otherwise>10</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="colTxt">
    <xsl:choose>
      <xsl:when test="$isTitle = 1">
        <xsl:choose>
          <xsl:when test="$colType='平年値'">平年値</xsl:when>
          <xsl:when test="$colType='平年差（比）'">
            <xsl:value-of select="concat('平年',
                                      substring-after(@type, '平年'))"/>
          </xsl:when>
          <xsl:otherwise>
             <xsl:value-of select="@type"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="concat('（', translate(@unit, 'hcm%', 'ｈｃｍ％'),
                                       '）')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="ZenNum">
          <xsl:with-param name="Num">
            <!-- 値と品質の表示 -->
            <xsl:call-template name="dispValueWithCondition">
              <xsl:with-param name="value" select="."/>
              <xsl:with-param name="condition" select="@condition"/>
              <xsl:with-param name="withPlus"
                select="contains(@type, '気温') and $colType = '平年差（比）'"/>
            </xsl:call-template>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:call-template name="blanks">
    <xsl:with-param name="n" select="$colWidth - string-length($colTxt)"/>
  </xsl:call-template>
  <xsl:value-of select="$colTxt"/>
</xsl:template>

<!-- ........................ -->
<!-- 値と品質の表示テンプレート -->
<xsl:template name="dispValueWithCondition">
  <xsl:param name="value"/>
  <xsl:param name="condition"/>
  <xsl:param name="withPlus"/>
  <xsl:variable name="valStr">
    <xsl:choose>
      <xsl:when test="contains($condition, '現象なし')">
        <xsl:text>－</xsl:text>
      </xsl:when>
      <xsl:when test="$condition = '値なし'">
        <xsl:text>／／</xsl:text>
      </xsl:when>
      <xsl:when test="$condition = '欠測'">
        <xsl:text>×</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$withPlus and $value &gt; 0">
          <xsl:text>＋</xsl:text>
        </xsl:if>
        <xsl:value-of select="$value"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="condMark">
    <xsl:choose>
      <xsl:when test="contains($condition, '非常に疑わしい')">
        <xsl:text>＃</xsl:text>
      </xsl:when>
      <xsl:when test="contains($condition, '資料不足')">
        <xsl:text>］</xsl:text>
      </xsl:when>
      <xsl:when test="contains($condition, '準正常')">
        <xsl:text>）</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="blank1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="concat($valStr, $condMark)"/>
</xsl:template>


<!-- ========================== -->
<!-- 日付表示テンプレート(分単位) -->
<!-- ========================== -->
<xsl:template name="DispDateTime1">
  <xsl:param name="Jikan">dummy</xsl:param>
  <xsl:text>令和</xsl:text>
  <xsl:choose>
   <xsl:when test="substring($Jikan,1,4)='2019'">元</xsl:when>
    <xsl:otherwise>
     <xsl:value-of select="number(substring($Jikan,1,4)) - 2018 "/>
    </xsl:otherwise>
  </xsl:choose>
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

<!-- =============================================== -->
<!-- 段落（１行３４文字）表示テンプレート              -->
<!--   jisage = 0: １行目の字下げ無し                 -->
<!--   jisage = 1: １行目の字下げあり                 -->
<!--   jisage = 2: １段落目は字下げ無し、             -->
<!--               ２段落目以後は１行目の字下げあり    -->
<!--   jisage < 0: ２行目以後のみ |jisage| 分ぶら下げ -->
<!--    ※ 禁則処理は $KinsokuChars で制御する        -->
<!-- =============================================== -->
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
          <xsl:if test="$jisage = 1 and string-length($str) &gt; 0">
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
        <xsl:with-param name="jisage" select="$jisage"/>
      </xsl:call-template>
      <xsl:call-template name="mkDanraku">
        <xsl:with-param name="str" select="substring-after($str, $BR)"/>
        <xsl:with-param name="jisage" select="$jisage2"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="mkLine">
        <xsl:with-param name="danraku" select="$str"/>
        <xsl:with-param name="jisage" select="$jisage"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="mkLine">
  <xsl:param name="danraku">dummy</xsl:param>
  <xsl:param name="jisage"/>
  <xsl:variable name="len" select="string-length($danraku)"/>
  <xsl:choose>
    <xsl:when test="$len = 0">
      <br/>
    </xsl:when>
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
          <xsl:when test="$jisage &lt; 0">
            <xsl:variable name="line" select="substring($danraku, 1, 34)"/>
            <xsl:variable name="commaPos">
              <xsl:call-template name="lastPartPos">
                <xsl:with-param name="str" select="$line"/>
                <xsl:with-param name="part" select="'、'"/>
                <xsl:with-param name="n" select="0"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="$commaPos &lt; 35 and $commaPos &gt; 20">
                <xsl:value-of select="$commaPos"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="34"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="34"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:value-of select="substring($danraku, 1, $kaigyoPos)"/>
      <br/>
      <xsl:call-template name="mkLine">
        <xsl:with-param name="jisage" select="$jisage"/>
        <xsl:with-param name="danraku">
          <xsl:if test="$jisage &lt; 0">
            <xsl:call-template name="blanks">
              <xsl:with-param name="n" select="0 - $jisage"/>
            </xsl:call-template>
          </xsl:if>
          <xsl:value-of select="substring($danraku, $kaigyoPos + 1)"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="lastPartPos">
  <xsl:param name="str"/>
  <xsl:param name="part"/>
  <xsl:param name="n"/>
  <xsl:choose>
    <xsl:when test="not(contains($str, $part))">
      <xsl:value-of select="$n"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="lastPartPos">
        <xsl:with-param name="str" select="substring-after($str, $part)"/>
        <xsl:with-param name="part" select="$part"/>
        <xsl:with-param name="n"
            select="$n + string-length(substring-before($str, $part)) +
                         string-length($part)"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
