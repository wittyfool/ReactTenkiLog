<?xml version="1.0" encoding="UTF-8" ?>
<!--
  ======================================================================
  本スタイルシートは、気象庁防災情報XMLフォーマット形式電文中の全ての情報コンテンツを出力するもので、
  システム処理の動作確認など、電文処理の参考資料としてお使い下さい。
  なお、本スタイルシートについては、システムに直接組み込む等の方法でご利用になることは避けていただくなど、
  ご利用に当たっては十分に注意していただきますよう、よろしくお願いいたします。

  Copyright (c) 気象庁 2012 All rights reserved.

　【対象情報】
  特殊気象報（キセツ）

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
  <xsl:value-of select="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Kind/jmx_mete:Name" />
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
    <tr>
      <th>官署名<br />[国際地点番号]</th>
      <th>住所</th>
      <th>項目名</th>
      <th>観測年月日<br />(日まで有効)</th>
      <th>記事</th>
    </tr>
    <tr>
      <td>
      <xsl:value-of select="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Station/jmx_mete:Name" />
      <br />
      [
      <xsl:value-of select="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Station/jmx_mete:Code" />
      ]
      </td>
      <td>
      <xsl:value-of select="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Station/jmx_mete:Location" />
      </td>
      <td>
      <xsl:value-of select="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:Item/jmx_mete:Kind/jmx_mete:Name" />
      </td>
      <td>
      <xsl:value-of select="/jmx:Report/jmx_mete:Body/jmx_mete:MeteorologicalInfos/jmx_mete:MeteorologicalInfo/jmx_mete:DateTime" />
      </td>
      <td>
      <xsl:value-of select="/jmx:Report/jmx_mete:Body/jmx_mete:AdditionalInfo/jmx_mete:ObservationAddition/jmx_mete:Text" />
      </td>
    </tr>
  </table>
</xsl:template>
</xsl:stylesheet>