<?xml version="1.0" encoding="UTF-8" ?>

<!--
  ======================================================================
  本スタイルシートは、気象庁防災情報XMLフォーマット形式電文中の全ての情報コンテンツを出力するもので、
  システム処理の動作確認など、電文処理の参考資料としてお使い下さい。
  なお、本スタイルシートについては、システムに直接組み込む等の方法でご利用になることは避けていただくなど、
  ご利用に当たっては十分に注意していただきますよう、よろしくお願いいたします。

  Copyright (c) 気象庁 2012 All rights reserved.

  【対象情報】
  特殊気象報（トクシュ）、特殊気象報（フレ）

  【更新履歴】
  2012年03月29日　Ver.1.0
  ======================================================================
-->

<xsl:stylesheet xmlns:jmx="http://xml.kishou.go.jp/jmaxml1/"
xmlns:jmx_eb="http://xml.kishou.go.jp/jmaxml1/elementBasis1/"
xmlns:jmx_ib="http://xml.kishou.go.jp/jmaxml1/informationBasis1/"
xmlns:jmx_mete="http://xml.kishou.go.jp/jmaxml1/body/meteorology1/"
xmlns:jmx_add="http://xml.kishou.go.jp/jmaxml1/addition1/"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0">

<xsl:output method="html" encoding="UTF-8" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" />

<xsl:template match="/">
  <html>
  <xsl:apply-templates select="jmx:Report" />
  </html>
</xsl:template>

<xsl:template match="jmx:Report">
  <table border="1">
    <tr>
      <th>Control部　タグ</th>
      <th>内　容</th>
    </tr>
    <tr>
      <td>情報名称（Title）</td>
      <td>
      <xsl:value-of select="/jmx:Report/jmx:Control/jmx:Title" />
      </td>
    </tr>
    <tr>
      <td>電文発信時刻（DateTime）</td>
      <td>
      <xsl:value-of select="/jmx:Report/jmx:Control/jmx:DateTime" />
      </td>
    </tr>
    <tr>
      <td>運用種別（Status）</td>
      <td>
      <xsl:value-of select="/jmx:Report/jmx:Control/jmx:Status" />
      </td>
    </tr>
    <tr>
      <td>編集官署名（EditorialOffice）</td>
      <td>
      <xsl:value-of select="/jmx:Report/jmx:Control/jmx:EditorialOffice" />
      </td>
    </tr>
    <tr>
      <td>発表官署名（PublishingOffice）</td>
      <td>
      <xsl:value-of select="/jmx:Report/jmx:Control/jmx:PublishingOffice" />
      </td>
    </tr>
  </table>
  <br />

  <table border="1">
    <tr>
      <th>Head部　タグ</th>
      <th>内　容</th>
    </tr>
    <tr>
      <td>標題（Title）</td>
      <td>
      <xsl:value-of select="/jmx:Report/jmx_ib:Head/jmx_ib:Title" />
      </td>
    </tr>
    <tr>
      <td>電文発表時刻（ReportDateTime）</td>
      <td>
      <xsl:value-of select="/jmx:Report/jmx_ib:Head/jmx_ib:ReportDateTime" />
      </td>
    </tr>
    <tr>
      <td>観測年月日（TargetDateTime）</td>
      <td>
      <xsl:value-of select="/jmx:Report/jmx_ib:Head/jmx_ib:TargetDateTime" />
      </td>
    </tr>
    <tr>
      <td>電文識別情報（EventID）</td>
      <td>
      <xsl:if test="/jmx:Report/jmx_ib:Head/jmx_ib:EventID=''">-</xsl:if>
      <xsl:value-of select="/jmx:Report/jmx_ib:Head/jmx_ib:EventID" />
      <br />
      </td>
    </tr>
    <tr>
      <td>情報形態（発表/訂正/取消）（InfoType）</td>
      <td>
      <xsl:if test="/jmx:Report/jmx_ib:Head/jmx_ib:InfoType=''">-</xsl:if>
      <xsl:value-of select="/jmx:Report/jmx_ib:Head/jmx_ib:InfoType" />
      <br />
      </td>
    </tr>
    <tr>
      <td>情報番号（常になし）（Serial）</td>
      <td>
      <xsl:if test="/jmx:Report/jmx_ib:Head/jmx_ib:Serial=''">-</xsl:if>
      <xsl:value-of select="/jmx:Report/jmx_ib:Head/jmx_ib:Serial" />
      </td>
    </tr>
    <tr>
      <td>スキーマの運用種別情報（InfoKind）</td>
      <td>
      <xsl:value-of select="/jmx:Report/jmx_ib:Head/jmx_ib:InfoKind" />
      </td>
    </tr>
    <tr>
      <td>スキーマの運用種別情報のバージョン番号（InfoKindVersion）</td>
      <td>
      <xsl:value-of select="/jmx:Report/jmx_ib:Head/jmx_ib:InfoKindVersion" />
      </td>
    </tr>
    <tr>
      <td>見出し文（常になし）（Headline/Text）</td>
      <td>
      <xsl:if test="/jmx:Report/jmx_ib:Head/jmx_ib:Headline/jmx_ib:Text=''">-</xsl:if>
      <xsl:value-of select="/jmx:Report/jmx_ib:Head/jmx_ib:Headline/jmx_ib:Text" />
      <br />
      </td>
    </tr>
  </table>
  <br />
  <br />

  <h2>Body部：
  <xsl:value-of select="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/@type" />⇒

  <xsl:if test="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Kind/jmx_mete:Name!=''">
  <xsl:value-of select="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Kind/jmx_mete:Name" />
  </xsl:if>

  <xsl:if test="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Kind/jmx_mete:Property/jmx_mete:Type!=''">
  <xsl:value-of select="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Kind/jmx_mete:Property/jmx_mete:Type" />
  </xsl:if>

  <xsl:if test="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Kind/jmx_mete:Code!=''">
  [
  <xsl:value-of select="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Kind/jmx_mete:Code" />
  ]
  </xsl:if>
  <xsl:if test="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Kind/jmx_mete:ClassName!=''">
  （種類：
  <xsl:value-of select="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Kind/jmx_mete:ClassName" />
  ）
  </xsl:if>
  </h2>

  <table border="1">
  <!-- カゼ -->
    <xsl:if test="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Kind/jmx_mete:Property/jmx_mete:WindPart!=''">
      <tr>
        <th rowspan="2">官署名<br />[国際地点番号]</th>
        <th rowspan="2">住所</th>
        <th rowspan="2">観測年月日</th>
        <th rowspan="2">気象要素名</th>
        <th colspan="3">最大風速<br /></th>
        <th colspan="3">最大瞬間風速<br /></th>
        <th rowspan="2">記事</th>
      </tr>
      <tr>
        <th>風向<br />(36方位)</th>
        <th>風速<br />(m/s)</th>
        <th>起時</th>
        <th>風向<br />(36方位)</th>
        <th>風速<br />(m/s)</th>
        <th>起時</th>
      </tr>
    </xsl:if>

  <!-- キアツ -->
    <xsl:if test="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Kind/jmx_mete:Property/jmx_mete:PressurePart!=''">
      <tr>
        <th>官署名<br />[国際地点番号]</th>
        <th>住所</th>
        <th>観測年月日</th>
        <th>気象要素名</th>
        <th>最低気圧<br />(hPa)</th>
        <th>最低気圧の起時</th>
        <th>記事</th>
      </tr>
    </xsl:if>

  <!-- 特殊現象 -->
    <xsl:if test="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Kind/jmx_mete:Name!=''">
      <tr>
        <th>官署名<br />[国際地点番号]</th>
        <th>住所</th>
        <th>観測年月日</th>
        <th>項目名</th>
        <th>記事</th>
      </tr>
    </xsl:if>

    <tr>
    <!-- 共通 -->
      <td>
      <xsl:value-of select="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Station/jmx_mete:Name" />
      <br />
      [<xsl:value-of select="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Station/jmx_mete:Code" />]
      </td>
      <td>
      <xsl:value-of select="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Station/jmx_mete:Location" />
      </td>
      <td>
      <xsl:value-of select="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:DateTime" />
      </td>
    
    <!-- 特殊現象 -->
      <xsl:if test="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Kind/jmx_mete:Name!=''">
        <td>
        <xsl:value-of select="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Kind/jmx_mete:Name" />
        </td>
      </xsl:if>

    <!-- カゼ -->
      <xsl:if test="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Kind/jmx_mete:Property/jmx_mete:WindPart!=''">
        <td>
        <xsl:value-of select="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Kind/jmx_mete:Property/jmx_mete:Type" />
        </td>
        <td>
        <xsl:value-of select="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Kind/jmx_mete:Property/jmx_mete:WindPart/jmx_mete:Base/jmx_eb:WindDegree" />
        </td>
        <td>
        <xsl:value-of select="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Kind/jmx_mete:Property/jmx_mete:WindPart/jmx_mete:Base/jmx_eb:WindSpeed" />
        </td>
        <td>
        <xsl:value-of select="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Kind/jmx_mete:Property/jmx_mete:WindPart/jmx_mete:Base/jmx_mete:Time" />
        </td>
        <td>
        <xsl:value-of select="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Kind/jmx_mete:Property/jmx_mete:WindPart/jmx_mete:Temporary/jmx_eb:WindDegree" />
        </td>
        <td>
        <xsl:value-of select="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Kind/jmx_mete:Property/jmx_mete:WindPart/jmx_mete:Temporary/jmx_eb:WindSpeed" />
        </td>
        <td>
        <xsl:value-of select="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Kind/jmx_mete:Property/jmx_mete:WindPart/jmx_mete:Temporary/jmx_mete:Time" />
        </td>
      </xsl:if>

    <!-- キアツ -->
      <xsl:if test="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Kind/jmx_mete:Property/jmx_mete:PressurePart!=''">
        <td>
        <xsl:value-of select="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Kind/jmx_mete:Property/jmx_mete:Type" />
        </td>
        <td>
        <xsl:value-of select="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Kind/jmx_mete:Property/jmx_mete:PressurePart/jmx_mete:Temporary/jmx_eb:Pressure" />
        </td>
        <td>
        <xsl:value-of select="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Kind/jmx_mete:Property/jmx_mete:PressurePart/jmx_mete:Temporary/jmx_mete:Time" />
        </td>
      </xsl:if>

    <!-- 記事 -->
      <td>
      <xsl:value-of select="/jmx:Report/jmx_mete:Body/jmx_mete:AdditionalInfo/jmx_mete:ObservationAddition/jmx_mete:Text" />
      </td>
    </tr>
  </table>
</xsl:template>
</xsl:stylesheet>