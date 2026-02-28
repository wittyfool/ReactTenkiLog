<?xml version="1.0" encoding="UTF-8"?>

<!--
  ======================================================================
  本スタイルシートは、気象庁防災情報XMLフォーマット形式電文中の全ての情
  報コンテンツを出力するもので、システム処理の動作確認など、電文処理の参
  考資料としてお使い下さい。

  なお、本スタイルシートについては、システムに直接組み込む等の方法でご利
  用になることは避けていただくなど、ご利用に当たっては十分に注意していた
  だきますよう、よろしくお願いいたします。

  Copyright (c) 気象庁 2021 All rights reserved.
  
  【対象情報】
  震度速報
  地震情報
  緊急地震速報
  津波情報
  津波警報・注意報・予報
  地震・津波に関するお知らせ
  沖合の津波観測に関する情報
  南海トラフ地震臨時情報
  南海トラフ地震関連解説情報
  長周期地震動に関する観測情報
  北海道・三陸沖後発地震注意情報

  【更新履歴】
  2012年03月29日　Ver.1.0
  2012年06月15日　Ver.1.1　津波に関連する情報等の変更に伴う更新
  2019年04月24日　Ver.1.2　5月1日より施行される新元号への対応
  2019年11月28日　Ver.1.3　南海トラフ地震に関連する情報の追加
  2021年07月30日　Ver.1.4　緊急地震速報電文の一部変更と新設に伴う更新
  2021年12月22日　Ver.1.5　長周期地震動に関する観測情報の新設に伴う更新
  2024年08月21日　Ver.1.6　北海道・三陸沖後発地震注意情報の新設に伴う更新
  ======================================================================
-->

<xsl:stylesheet 
xmlns:jmx="http://xml.kishou.go.jp/jmaxml1/"
xmlns:jmx_ib="http://xml.kishou.go.jp/jmaxml1/informationBasis1/" 
xmlns:jmx_eb="http://xml.kishou.go.jp/jmaxml1/elementBasis1/" 
xmlns:jmx_seis="http://xml.kishou.go.jp/jmaxml1/body/seismology1/" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" encoding="UTF-8" indent="yes" />

<xsl:template match="/">

  <h3>＊＊＊＊＊＊＊　管理部　＊＊＊＊＊＊＊</h3>
  <xsl:apply-templates select="/jmx:Report/jmx:Control" mode="Basic" />
  <h3>＊＊＊＊＊＊＊　管理部　＊＊＊＊＊＊＊</h3>

  <h3>＊＊＊＊＊＊＊　ヘッダ部　＊＊＊＊＊＊</h3>
  <xsl:apply-templates select="/jmx:Report/jmx_ib:Head" mode="Head" />
  <h3>＊＊＊＊＊＊＊　ヘッダ部　＊＊＊＊＊＊</h3>

  <h3>＊＊＊＊＊＊＊　内容部　＊＊＊＊＊＊＊</h3>
  <xsl:apply-templates select="/jmx:Report/jmx_seis:Body" mode="Body" />
  <h3>＊＊＊＊＊＊＊　内容部　＊＊＊＊＊＊＊</h3>

</xsl:template>

<!-- 管理部の翻訳 -->
<xsl:template match="/jmx:Report/jmx:Control" mode="Basic">

  <table>

    <tr>
      <td style="white-space: nowrap; vertical-align: top">［情報名称］</td>
      <td style="white-space: nowrap; vertical-align: top">
        <xsl:value-of select="jmx:Title" />
      </td>
    </tr>

    <tr>
      <td style="white-space: nowrap; vertical-align: top">［発表時刻］</td>
      <td style="white-space: nowrap; vertical-align: top">
        <xsl:call-template name="DispDateTime">
          <xsl:with-param name="Jikan" select="jmx:DateTime" />
          <xsl:with-param name="Significant">yyyy-mm-ddThh:mm:ss</xsl:with-param>
          <xsl:with-param name="TimeZone">UTC</xsl:with-param>
        </xsl:call-template>
      </td>
    </tr>

    <tr>
      <td style="white-space: nowrap; vertical-align: top">［運用種別］</td>
      <td style="white-space: nowrap; vertical-align: top">
        <xsl:value-of select="jmx:Status" />
      </td>
    </tr>

    <tr>
      <td style="white-space: nowrap; vertical-align: top">［編集官署名］</td>
      <td style="white-space: nowrap; vertical-align: top">
        <xsl:value-of select="jmx:EditorialOffice" />
      </td>
    </tr>

    <tr>
      <td style="white-space: nowrap; vertical-align: top">［発表官署名］</td>
      <td style="white-space: nowrap; vertical-align: top">
        <xsl:value-of select="jmx:PublishingOffice" />
      </td>
    </tr>

  </table>
  <br />

</xsl:template>

<!-- ヘッダ部の翻訳 -->
<xsl:template match="/jmx:Report/jmx_ib:Head" mode="Head">

  <table>

    <tr>
      <td style="white-space: nowrap; vertical-align: top">［標題］</td>
      <td style="white-space: nowrap; vertical-align: top">
        <xsl:value-of select="jmx_ib:Title" />
      </td>
    </tr>

    <tr>
      <td style="white-space: nowrap; vertical-align: top">［発表時刻］</td>
      <td style="white-space: nowrap; vertical-align: top">
        <xsl:choose>
          <xsl:when test="contains(jmx_ib:Title,'緊急地震速報')">
            <xsl:call-template name="DispDateTime">
              <xsl:with-param name="Jikan" select="jmx_ib:ReportDateTime" />
              <xsl:with-param name="Significant">yyyy-mm-ddThh:mm:ss</xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="DispDateTime">
              <xsl:with-param name="Jikan" select="jmx_ib:ReportDateTime" />
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>

    <tr>
      <td style="white-space: nowrap; vertical-align: top">［基点時刻］</td>
      <td style="white-space: nowrap; vertical-align: top">
        <xsl:choose>
          <xsl:when test="contains(jmx_ib:Title,'緊急地震速報')">
            <xsl:call-template name="DispDateTime">
              <xsl:with-param name="Jikan" select="jmx_ib:TargetDateTime" />
              <xsl:with-param name="Significant">yyyy-mm-ddThh:mm:ss</xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="jmx_ib:TargetDateTime=''">不明</xsl:when>
          <xsl:when test="jmx_ib:TargetDTDubious!=''">
            <xsl:choose>
              <xsl:when test="contains(jmx_ib:TargetDTDubious,'年頃')">
                <xsl:call-template name="DispDateTime">
                  <xsl:with-param name="Jikan" select="jmx_ib:TargetDateTime" />
                  <xsl:with-param name="Significant">yyyy</xsl:with-param>
                </xsl:call-template>
              </xsl:when>
              <xsl:when test="contains(jmx_ib:TargetDTDubious,'月頃')">
                <xsl:call-template name="DispDateTime">
                  <xsl:with-param name="Jikan" select="jmx_ib:TargetDateTime" />
                  <xsl:with-param name="Significant">yyyy-mm</xsl:with-param>
                </xsl:call-template>
              </xsl:when>
              <xsl:when test="contains(jmx_ib:TargetDTDubious,'日頃')">
                <xsl:call-template name="DispDateTime">
                  <xsl:with-param name="Jikan" select="jmx_ib:TargetDateTime" />
                  <xsl:with-param name="Significant">yyyy-mm-dd</xsl:with-param>
                </xsl:call-template>
              </xsl:when>
              <xsl:when test="contains(jmx_ib:TargetDTDubious,'時頃')">
                <xsl:call-template name="DispDateTime">
                  <xsl:with-param name="Jikan" select="jmx_ib:TargetDateTime" />
                  <xsl:with-param name="Significant">yyyy-mm-ddThh</xsl:with-param>
                </xsl:call-template>
              </xsl:when>
              <xsl:when test="contains(jmx_ib:TargetDTDubious,'分頃')">
                <xsl:call-template name="DispDateTime">
                  <xsl:with-param name="Jikan" select="jmx_ib:TargetDateTime" />
                  <xsl:with-param name="Significant">yyyy-mm-ddThh:mm</xsl:with-param>
                </xsl:call-template>
              </xsl:when>
              <xsl:when test="contains(jmx_ib:TargetDTDubious,'秒頃')">
                <xsl:call-template name="DispDateTime">
                  <xsl:with-param name="Jikan" select="jmx_ib:TargetDateTime" />
                  <xsl:with-param name="Significant">yyyy-mm-ddThh:mm:ss</xsl:with-param>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="DispDateTime">
                  <xsl:with-param name="Jikan" select="jmx_ib:TargetDateTime" />
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text>頃</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="DispDateTime">
              <xsl:with-param name="Jikan" select="jmx_ib:TargetDateTime" />
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>

    <xsl:if test="jmx_ib:ValidDateTime!=''">
    <tr>
      <td style="white-space: nowrap; vertical-align: top">［失効時刻］</td>
      <td style="white-space: nowrap; vertical-align: top">
        <xsl:if test="jmx_ib:TargetDTDubious!=''">
          <xsl:call-template name="DispDateTime">
            <xsl:with-param name="Jikan" select="jmx_ib:ValidDateTime" />
          </xsl:call-template>
        </xsl:if>
      </td>
    </tr>
    </xsl:if>

    <xsl:if test="jmx_ib:EventID!=''">
    <tr>
      <td style="white-space: nowrap; vertical-align: top">［識別情報］</td>
      <td style="white-space: nowrap; vertical-align: top">
        <xsl:value-of select="jmx_ib:EventID" />
      </td>
    </tr>
    </xsl:if>

    <tr>
      <td style="white-space: nowrap; vertical-align: top">［情報形態］</td>
      <td style="white-space: nowrap; vertical-align: top">
        <xsl:value-of select="jmx_ib:InfoType" />
      </td>
    </tr>

    <xsl:if test="jmx_ib:Serial!=''">
    <tr>
      <td style="white-space: nowrap; vertical-align: top">［情報番号］</td>
      <td style="white-space: nowrap; vertical-align: top">
        <xsl:value-of select="jmx_ib:Serial" />
      </td>
    </tr>
    </xsl:if>

    <tr>
      <td style="white-space: nowrap; vertical-align: top">［スキーマの運用種別情報］</td>
      <td style="white-space: nowrap; vertical-align: top">
        <xsl:value-of select="jmx_ib:InfoKind" />
      </td>
    </tr>

    <tr>
      <td style="white-space: nowrap; vertical-align: top">［スキーマの運用種別情報のバージョン番号］</td>
      <td style="white-space: nowrap; vertical-align: top">
        <xsl:value-of select="jmx_ib:InfoKindVersion" />
      </td>
    </tr>

  </table>
  <br />

  <xsl:if test="jmx_ib:Headline/jmx_ib:Text!=''">

    <h4>【見出し文】</h4>

    <div>
      <xsl:call-template name="mkBR">
        <xsl:with-param name="value" select="jmx_ib:Headline/jmx_ib:Text" />
      </xsl:call-template>
    </div>
    <br />

  </xsl:if>

  <xsl:if test="jmx_ib:Headline/jmx_ib:Information!=''">

    <h4>【防災気象情報事項】</h4>

    <xsl:for-each select="jmx_ib:Headline/jmx_ib:Information">

      <div>
        <xsl:text>［</xsl:text>
        <xsl:value-of select="@type" />
        <xsl:text>］</xsl:text>
      </div>
      <br />

      <xsl:for-each select="jmx_ib:Item">

        <table>

          <tr>
            <td style="white-space: nowrap; vertical-align: top">〔防災気象情報要素〕</td>
            <td style="white-space: nowrap; vertical-align: top">
              <xsl:value-of select="jmx_ib:Kind/jmx_ib:Name" />
              <xsl:if test="jmx_ib:Kind/jmx_ib:Name='緊急地震速報（警報）' and position()='2' and jmx_ib:Kind/jmx_ib:Name!=jmx_ib:LastKind/jmx_ib:Name">
                <xsl:call-template name="blank1" />
                <xsl:text>≪追加≫</xsl:text>
              </xsl:if>
            </td>
          </tr>

          <tr>
            <td style="white-space: nowrap; vertical-align: top">〔対象地域・地点〕</td>
            <td style="vertical-align: top">
              <xsl:for-each select="jmx_ib:Areas/jmx_ib:Area">
                <xsl:value-of select="jmx_ib:Name" />
                <xsl:if test="position()!=last()">
                  <xsl:call-template name="blank1" />
                </xsl:if>
              </xsl:for-each>
            </td>
          </tr>

        </table>
        <br />

      </xsl:for-each>

    </xsl:for-each>

  </xsl:if>

</xsl:template>

<!-- 内容部の翻訳（地震・津波・南海トラフ）-->
<xsl:template match="/jmx:Report/jmx_seis:Body" mode="Body">

  <!-- 命名 -->
  <xsl:if test="jmx_seis:Naming!=''">

    <h4>【命名】</h4>

    <table>

      <tr>
        <td style="white-space: nowrap; vertical-align: top">［命名要素］</td>
        <td style="white-space: nowrap; vertical-align: top">
          <xsl:value-of select="jmx_seis:Naming" />
        </td>
      </tr>

      <xsl:if test="jmx_seis:Naming/@english!=''">
        <tr>
          <td style="white-space: nowrap; vertical-align: top">［英語の命名］</td>
          <td style="white-space: nowrap; vertical-align: top">
            <xsl:value-of select="jmx_seis:Naming/@english" />
          </td>
        </tr>
      </xsl:if>

    </table>
    <br />

  </xsl:if>

  <!-- 津波の観測 -->
  <xsl:if test="jmx_seis:Tsunami/jmx_seis:Observation!=''">

    <h4>【津波観測に関する情報】</h4>

    <table>
      <tr>
        <xsl:if test="jmx_seis:Tsunami/jmx_seis:Observation/jmx_seis:Item/jmx_seis:Area/jmx_seis:Name!=''">
          <td style="white-space: nowrap; vertical-align: top">［津波予報区］</td>
        </xsl:if>
        <td style="white-space: nowrap; vertical-align: top">［潮位観測点］</td>
        <td style="white-space: nowrap; vertical-align: top" colspan="4">［第１波］</td>
        <td style="white-space: nowrap; vertical-align: top" colspan="3">［これまでの最大波］</td>
      </tr>

      <xsl:for-each select="jmx_seis:Tsunami/jmx_seis:Observation/jmx_seis:Item/jmx_seis:Station">
        <tr>
          <xsl:if test="../jmx_seis:Area/jmx_seis:Name!=''">
            <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
              <xsl:value-of select="../jmx_seis:Area/jmx_seis:Name" />
            </td>
          </xsl:if>
          <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
            <xsl:value-of select="jmx_seis:Name" />
              <xsl:if test="jmx_seis:Sensor!=''">
                <xsl:text>（</xsl:text>
                <xsl:value-of select="jmx_seis:Sensor" />
                <xsl:text>）</xsl:text>
              </xsl:if>
          </td>
          <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
            <xsl:if test="jmx_seis:FirstHeight/jmx_seis:ArrivalTime!=''">
              <xsl:call-template name="DispDateTime">
                <xsl:with-param name="Jikan" select="jmx_seis:FirstHeight/jmx_seis:ArrivalTime" />
                <xsl:with-param name="Significant">ddThh:mm</xsl:with-param>
              </xsl:call-template>
            </xsl:if>
          </td>
          <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
            <xsl:if test="jmx_seis:FirstHeight/jmx_eb:TsunamiHeight/@description!=''">
              <xsl:value-of select="jmx_seis:FirstHeight/jmx_eb:TsunamiHeight/@description" />
            </xsl:if>
            <xsl:if test="jmx_seis:FirstHeight/jmx_seis:Condition!=''">
              <xsl:value-of select="jmx_seis:FirstHeight/jmx_seis:Condition" />
            </xsl:if>
          </td>
          <td style="white-space: nowrap; vertical-align: top">
            <xsl:if test="jmx_seis:FirstHeight/jmx_seis:Initial!=''">
              <xsl:value-of select="jmx_seis:FirstHeight/jmx_seis:Initial" />
            </xsl:if>
          </td>
          <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
            <xsl:if test="jmx_seis:FirstHeight/jmx_seis:Revise!=''">
              <xsl:text>≪</xsl:text>
                <xsl:value-of select="jmx_seis:FirstHeight/jmx_seis:Revise" />
              <xsl:text>≫</xsl:text>
            </xsl:if>
          </td>
          <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
            <xsl:choose>
              <xsl:when test="jmx_seis:MaxHeight/jmx_seis:DateTime!=''">
                <xsl:call-template name="DispDateTime">
                  <xsl:with-param name="Jikan" select="jmx_seis:MaxHeight/jmx_seis:DateTime" />
                  <xsl:with-param name="Significant">ddThh:mm</xsl:with-param>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="jmx_seis:MaxHeight/jmx_seis:Condition" />
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td style="white-space: nowrap; vertical-align: top">
            <xsl:if test="jmx_seis:MaxHeight/jmx_eb:TsunamiHeight/@description!=''">
              <xsl:value-of select="jmx_seis:MaxHeight/jmx_eb:TsunamiHeight/@description" />
            </xsl:if>
            <xsl:if test="jmx_seis:MaxHeight/jmx_eb:TsunamiHeight/@condition!=''">
              <xsl:text>（</xsl:text>
              <xsl:value-of select="jmx_seis:MaxHeight/jmx_eb:TsunamiHeight/@condition" />
              <xsl:text>）</xsl:text>
            </xsl:if>
            <xsl:if test="(jmx_seis:MaxHeight/jmx_seis:Condition!='') and (jmx_seis:MaxHeight/jmx_seis:DateTime!='')">
              <xsl:if test="jmx_seis:MaxHeight/jmx_eb:TsunamiHeight/@description!=''">
                <xsl:text>：</xsl:text>
              </xsl:if>
              <xsl:value-of select="jmx_seis:MaxHeight/jmx_seis:Condition" />
            </xsl:if>
          </td>
          <td style="white-space: nowrap; vertical-align: top">
            <xsl:if test="jmx_seis:MaxHeight/jmx_seis:Revise!=''">
              <xsl:text>≪</xsl:text>
              <xsl:value-of select="jmx_seis:MaxHeight/jmx_seis:Revise" />
              <xsl:text>≫</xsl:text>
            </xsl:if>
          </td>
        </tr>
      </xsl:for-each>

    </table>
    <br />

  </xsl:if>

  <!-- 津波の推定 -->
  <xsl:if test="jmx_seis:Tsunami/jmx_seis:Estimation!=''">

    <h4>【沖合の観測値から推定される沿岸の津波の高さ】</h4>

    <table>

      <tr>
        <td style="white-space: nowrap; vertical-align: top">［沿岸地域］</td>
        <td style="white-space: nowrap; vertical-align: top" colspan="2">［第１波の推定到達時刻］</td>
        <xsl:if test="(jmx_seis:Tsunami/jmx_seis:Estimation/jmx_seis:Item/jmx_seis:MaxHeight/jmx_seis:DateTime!='') or (jmx_seis:Tsunami/jmx_seis:Estimation/jmx_seis:Item/jmx_seis:MaxHeight/jmx_seis:Condition!='')">
          <td style="white-space: nowrap; vertical-align: top" colspan="2">［これまでの最大波の推定到達時刻］</td>
        </xsl:if>
        <td style="white-space: nowrap; vertical-align: top" colspan="2">［推定される津波の高さ］</td>
      </tr>

      <xsl:for-each select="jmx_seis:Tsunami/jmx_seis:Estimation/jmx_seis:Item">

        <tr>
          <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
            <xsl:value-of select="jmx_seis:Area/jmx_seis:Name" />
          </td>
          <td style="white-space: nowrap; vertical-align: top">
            <xsl:choose>
              <xsl:when test="jmx_seis:FirstHeight/jmx_seis:ArrivalTime!=''">
                <xsl:call-template name="DispDateTime">
                  <xsl:with-param name="Jikan" select="jmx_seis:FirstHeight/jmx_seis:ArrivalTime" />
                  <xsl:with-param name="Significant">ddThh:mm</xsl:with-param>
                </xsl:call-template>
              </xsl:when>
              <xsl:when test="jmx_seis:FirstHeight/jmx_seis:ArrivalTimeFrom!=''">
                <xsl:call-template name="DispDateTime">
                  <xsl:with-param name="Jikan" select="jmx_seis:FirstHeight/jmx_seis:ArrivalTimeFrom" />
                  <xsl:with-param name="Significant">ddThh:mm</xsl:with-param>
                </xsl:call-template>
                <xsl:if test="jmx_seis:FirstHeight/jmx_seis:ArrivalTimeFrom!=jmx_seis:FirstHeight/jmx_seis:ArrivalTimeTo">
                  <xsl:text>から</xsl:text>
                  <xsl:call-template name="DispDateTime">
                    <xsl:with-param name="Jikan" select="jmx_seis:FirstHeight/jmx_seis:ArrivalTimeTo" />
                    <xsl:with-param name="Significant">ddThh:mm</xsl:with-param>
                  </xsl:call-template>
                </xsl:if>
              </xsl:when>
            </xsl:choose>
            <xsl:if test="jmx_seis:FirstHeight/jmx_seis:Condition!=''">
              <xsl:text>（</xsl:text>
              <xsl:value-of select="jmx_seis:FirstHeight/jmx_seis:Condition" />
              <xsl:text>）</xsl:text>
            </xsl:if>
          </td>
          <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
            <xsl:if test="jmx_seis:FirstHeight/jmx_seis:Revise!=''">
              <xsl:text>≪</xsl:text>
              <xsl:value-of select="jmx_seis:FirstHeight/jmx_seis:Revise" />
              <xsl:text>≫</xsl:text>
            </xsl:if>
          </td>
          <xsl:if test="(../jmx_seis:Item/jmx_seis:MaxHeight/jmx_seis:DateTime!='') or (../jmx_seis:Item/jmx_seis:MaxHeight/jmx_seis:Condition!='')">
            <td style="white-space: nowrap; vertical-align: top">
              <xsl:choose>
                <xsl:when test="jmx_seis:MaxHeight/jmx_seis:DateTime!=''">
                  <xsl:call-template name="DispDateTime">
                    <xsl:with-param name="Jikan" select="jmx_seis:MaxHeight/jmx_seis:DateTime" />
                    <xsl:with-param name="Significant">ddThh:mm</xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="jmx_seis:MaxHeight/jmx_seis:Condition" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
              <xsl:if test="jmx_seis:MaxHeight/jmx_seis:Revise!=''">
                <xsl:text>≪</xsl:text>
                <xsl:value-of select="jmx_seis:MaxHeight/jmx_seis:Revise" />
                <xsl:text>≫</xsl:text>
              </xsl:if>
            </td>
          </xsl:if>
          <td style="white-space: nowrap; vertical-align: top">
            <xsl:choose>
              <xsl:when test="jmx_seis:MaxHeight/jmx_eb:TsunamiHeight/@description!=''">
                <xsl:value-of select="jmx_seis:MaxHeight/jmx_eb:TsunamiHeight/@description" />
                <xsl:if test="jmx_seis:MaxHeight/jmx_seis:Condition!=''">
                  <xsl:text>：</xsl:text>
                  <xsl:value-of select="jmx_seis:MaxHeight/jmx_seis:Condition" />
                </xsl:if>
              </xsl:when>
              <xsl:when test="jmx_seis:MaxHeight/jmx_seis:Condition!=''">
                <xsl:value-of select="jmx_seis:MaxHeight/jmx_seis:Condition" />
              </xsl:when>
              <xsl:when test="jmx_seis:MaxHeight/jmx_seis:TsunamiHeightFrom/@description!=''">
                <xsl:value-of select="jmx_seis:MaxHeight/jmx_seis:TsunamiHeightFrom/@description" />
                <xsl:text>から</xsl:text>
                <xsl:value-of select="jmx_seis:MaxHeight/jmx_seis:TsunamiHeightTo/@description" />
              </xsl:when>
            </xsl:choose>
          </td>
          <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
            <xsl:if test="jmx_seis:MaxHeight/jmx_seis:Revise!=''">
              <xsl:text>≪</xsl:text>
              <xsl:value-of select="jmx_seis:MaxHeight/jmx_seis:Revise" />
              <xsl:text>≫</xsl:text>
            </xsl:if>
          </td>
        </tr>

      </xsl:for-each>

    </table>
    <br />

  </xsl:if>

  <!-- 津波の予測 -->
  <xsl:if test="jmx_seis:Tsunami/jmx_seis:Forecast!=''">

    <h4>【津波警報・注意報・予報】</h4>

    <table>

      <tr>
        <td style="white-space: nowrap; vertical-align: top">［津波予報区］</td>
        <td style="white-space: nowrap; vertical-align: top" colspan="2">［津波警報等の種類］</td>
        <xsl:if test="count(jmx_seis:Tsunami/jmx_seis:Forecast/jmx_seis:Item/jmx_seis:FirstHeight)!='0'">
          <td style="white-space: nowrap; vertical-align: top" colspan="2">［第１波の到達予想時刻］</td>
        </xsl:if>
        <xsl:if test="count(jmx_seis:Tsunami/jmx_seis:Forecast/jmx_seis:Item/jmx_seis:MaxHeight)!='0'">
          <td style="white-space: nowrap; vertical-align: top" colspan="2">［予想される津波の最大波の高さ］</td>
        </xsl:if>
      </tr>

      <xsl:for-each select="jmx_seis:Tsunami/jmx_seis:Forecast/jmx_seis:Item">
        <tr>
          <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
            <xsl:value-of select="jmx_seis:Area/jmx_seis:Name" />
          </td>
          <td style="white-space: nowrap; vertical-align: top">
            <xsl:value-of select="jmx_seis:Category/jmx_seis:Kind/jmx_seis:Name" />
          </td>
          <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
            <xsl:text>（前回：</xsl:text>
            <xsl:value-of select="jmx_seis:Category/jmx_seis:LastKind/jmx_seis:Name" />
            <xsl:text>）</xsl:text>
          </td>
          <xsl:if test="count(../jmx_seis:Item/jmx_seis:FirstHeight)!='0'">
            <td style="white-space: nowrap; vertical-align: top">
              <xsl:if test="jmx_seis:FirstHeight/jmx_seis:ArrivalTime!=''">
                <xsl:call-template name="DispDateTime">
                  <xsl:with-param name="Jikan" select="jmx_seis:FirstHeight/jmx_seis:ArrivalTime" />
                  <xsl:with-param name="Significant">ddThh:mm</xsl:with-param>
                </xsl:call-template>
              </xsl:if>
              <xsl:if test="jmx_seis:FirstHeight/jmx_seis:Condition!=''">
                <xsl:if test="jmx_seis:FirstHeight/jmx_eb:ArrivalTime!=''">
                  <xsl:text>：</xsl:text>
                </xsl:if>
                <xsl:value-of select="jmx_seis:FirstHeight/jmx_seis:Condition" />
              </xsl:if>
            </td>
            <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
              <xsl:if test="jmx_seis:FirstHeight/jmx_seis:Revise!=''">
                <xsl:text>≪</xsl:text>
                <xsl:value-of select="jmx_seis:FirstHeight/jmx_seis:Revise" />
                <xsl:text>≫</xsl:text>
              </xsl:if>
            </td>
          </xsl:if>
          <xsl:if test="count(../jmx_seis:Item/jmx_seis:MaxHeight)!='0'">
            <td style="white-space: nowrap; vertical-align: top">
              <xsl:if test="jmx_seis:MaxHeight/jmx_eb:TsunamiHeight/@description!=''">
                <xsl:value-of select="jmx_seis:MaxHeight/jmx_eb:TsunamiHeight/@description" />
              </xsl:if>
              <xsl:if test="jmx_seis:MaxHeight/jmx_seis:Condition!=''">
                <xsl:if test="jmx_seis:MaxHeight/jmx_eb:TsunamiHeight/@description!=''">
                  <xsl:text>：</xsl:text>
                </xsl:if>
                <xsl:value-of select="jmx_seis:MaxHeight/jmx_seis:Condition" />
              </xsl:if>
            </td>
            <td style="white-space: nowrap; vertical-align: top">
              <xsl:if test="jmx_seis:MaxHeight/jmx_seis:Revise!=''">
                <xsl:text>≪</xsl:text>
                <xsl:value-of select="jmx_seis:MaxHeight/jmx_seis:Revise" />
                <xsl:text>≫</xsl:text>
              </xsl:if>
            </td>
          </xsl:if>
        </tr>
      </xsl:for-each>

    </table>
    <br />

    <xsl:if test="jmx_seis:Tsunami/jmx_seis:Forecast/jmx_seis:Item/jmx_seis:Station!=''">

      <h4>【各地の満潮時刻・津波到達予想時刻に関する情報】</h4>

      <table>

        <tr>
          <td style="white-space: nowrap; vertical-align: top">［津波予報区］</td>
          <td style="white-space: nowrap; vertical-align: top">［潮位観測点］</td>
          <td style="white-space: nowrap; vertical-align: top">［満潮時刻］</td>
          <td style="white-space: nowrap; vertical-align: top" colspan="2">［第１波の到達予想時刻］</td>
        </tr>

        <xsl:for-each select="jmx_seis:Tsunami/jmx_seis:Forecast/jmx_seis:Item/jmx_seis:Station">
          <tr>
            <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
              <xsl:value-of select="../jmx_seis:Area/jmx_seis:Name" />
            </td>
            <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
              <xsl:value-of select="jmx_seis:Name" />
            </td>
            <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
              <xsl:if test="jmx_seis:HighTideDateTime!=''">
                <xsl:call-template name="DispDateTime">
                  <xsl:with-param name="Jikan" select="jmx_seis:HighTideDateTime" />
                  <xsl:with-param name="Significant">ddThh:mm</xsl:with-param>
                </xsl:call-template>
              </xsl:if>
            </td>
            <td style="white-space: nowrap; vertical-align: top">
              <xsl:choose>
                <xsl:when test="jmx_seis:FirstHeight/jmx_seis:ArrivalTime!=''">
                  <xsl:call-template name="DispDateTime">
                    <xsl:with-param name="Jikan" select="jmx_seis:FirstHeight/jmx_seis:ArrivalTime" />
                    <xsl:with-param name="Significant">ddThh:mm</xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
                <xsl:when test="jmx_seis:FirstHeight/jmx_seis:Condition!=''">
                  <xsl:value-of select="jmx_seis:FirstHeight/jmx_seis:Condition" />
                </xsl:when>
              </xsl:choose>
            </td>
            <td style="white-space: nowrap; vertical-align: top">
              <xsl:if test="jmx_seis:FirstHeight/jmx_seis:Revise!=''">
                <xsl:text>≪</xsl:text>
                <xsl:value-of select="jmx_seis:FirstHeight/jmx_seis:Revise" />
                <xsl:text>≫</xsl:text>
              </xsl:if>
            </td>
          </tr>
        </xsl:for-each>

      </table>
      <br />

    </xsl:if>

  </xsl:if>

  <!-- 地震の諸要素 -->
  <xsl:for-each select="jmx_seis:Earthquake">

    <h4>【地震の諸要素】</h4>

    <table>

      <xsl:if test="jmx_seis:OriginTime!=''">
        <tr>
          <td style="white-space: nowrap; vertical-align: top">［地震発生時刻］</td>
          <td style="white-space: nowrap; vertical-align: top">
            <xsl:choose>
              <xsl:when test="contains(/jmx:Report/jmx:Control/jmx:Title,'緊急地震速報')">
                <xsl:call-template name="DispDateTime">
                  <xsl:with-param name="Jikan" select="jmx_seis:OriginTime" />
                  <xsl:with-param name="Significant">yyyy-mm-ddThh:mm:ss</xsl:with-param>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="DispDateTime">
                  <xsl:with-param name="Jikan" select="jmx_seis:OriginTime" />
                  <xsl:with-param name="Significant">yyyy-mm-ddThh:mm</xsl:with-param>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
      </xsl:if>

      <xsl:if test="jmx_seis:ArrivalTime!=''">
        <tr>
          <td style="white-space: nowrap; vertical-align: top">［地震発現時刻］</td>
          <td style="white-space: nowrap; vertical-align: top">
            <xsl:choose>
              <xsl:when test="contains(/jmx:Report/jmx:Control/jmx:Title,'緊急地震速報')">
                <xsl:call-template name="DispDateTime">
                  <xsl:with-param name="Jikan" select="jmx_seis:ArrivalTime" />
                  <xsl:with-param name="Significant">yyyy-mm-ddThh:mm:ss</xsl:with-param>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="DispDateTime">
                  <xsl:with-param name="Jikan" select="jmx_seis:ArrivalTime" />
                  <xsl:with-param name="Significant">yyyy-mm-ddThh:mm</xsl:with-param>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
      </xsl:if>

      <xsl:if test="jmx_seis:Hypocenter!=''">

        <tr>
          <td style="white-space: nowrap; vertical-align: top">［震央地名］</td>
          <td style="white-space: nowrap; vertical-align: top">
            <xsl:value-of select="jmx_seis:Hypocenter/jmx_seis:Area/jmx_seis:Name" />
          </td>
        </tr>

        <xsl:for-each select="jmx_seis:Hypocenter/jmx_seis:Area/jmx_eb:Coordinate">
          <tr>
            <td style="white-space: nowrap; vertical-align: top">
              <xsl:text>［震源要素</xsl:text>
              <xsl:if test="@datum!=''">
                <xsl:text>（</xsl:text>
                <xsl:value-of select="@datum" />
                <xsl:text>）</xsl:text>
              </xsl:if>
              <xsl:text>］</xsl:text>
            </td>
            <td style="white-space: nowrap; vertical-align: top">
              <xsl:value-of select="@description" />
            </td>
          </tr>
        </xsl:for-each>

        <xsl:if test="jmx_seis:Hypocenter/jmx_seis:Area/jmx_seis:ReduceName!=''">
          <tr>
            <td style="white-space: nowrap; vertical-align: top">［短縮用震央地名］</td>
            <td style="white-space: nowrap; vertical-align: top">
              <xsl:value-of select="jmx_seis:Hypocenter/jmx_seis:Area/jmx_seis:ReduceName" />
            </td>
          </tr>
        </xsl:if>

        <xsl:if test="jmx_seis:Hypocenter/jmx_seis:Area/jmx_seis:DetailedName!=''">
          <tr>
            <td style="white-space: nowrap; vertical-align: top">［詳細震央地名］</td>
            <td style="white-space: nowrap; vertical-align: top">
              <xsl:value-of select="jmx_seis:Hypocenter/jmx_seis:Area/jmx_seis:DetailedName" />
            </td>
          </tr>
        </xsl:if>

        <xsl:if test="jmx_seis:Hypocenter/jmx_seis:Area/jmx_seis:NameFromMark!=''">
          <tr>
            <td style="white-space: nowrap; vertical-align: top">［震央補助表現］</td>
            <td style="white-space: nowrap; vertical-align: top">
              <xsl:value-of select="jmx_seis:Hypocenter/jmx_seis:Area/jmx_seis:NameFromMark" />
            </td>
          </tr>
        </xsl:if>

        <xsl:if test="jmx_seis:Hypocenter/jmx_seis:Area/jmx_seis:LandOrSea!=''">
          <tr>
            <td style="white-space: nowrap; vertical-align: top">［内陸判定］</td>
            <td style="white-space: nowrap; vertical-align: top">
              <xsl:value-of select="jmx_seis:Hypocenter/jmx_seis:Area/jmx_seis:LandOrSea" />
            </td>
          </tr>
        </xsl:if>

        <xsl:if test="jmx_seis:Hypocenter/jmx_seis:Source!=''">
          <tr>
            <td style="white-space: nowrap; vertical-align: top">［震源決定機関］</td>
            <td style="white-space: nowrap; vertical-align: top">
              <xsl:value-of select="jmx_seis:Hypocenter/jmx_seis:Source" />
            </td>
          </tr>
        </xsl:if>

        <xsl:if test="jmx_seis:Hypocenter/jmx_seis:Accuracy!=''">

          <tr>
            <td style="white-space: nowrap; vertical-align: top">［震央位置の精度のランク］</td>
            <td style="white-space: nowrap; vertical-align: top">
              <xsl:value-of select="jmx_seis:Hypocenter/jmx_seis:Accuracy/jmx_seis:Epicenter/@rank" />
            </td>
          </tr>

          <tr>
            <td style="white-space: nowrap; vertical-align: top">［震央位置の精度のランク２］</td>
            <td style="white-space: nowrap; vertical-align: top">
              <xsl:value-of select="jmx_seis:Hypocenter/jmx_seis:Accuracy/jmx_seis:Epicenter/@rank2" />
            </td>
           </tr>

          <tr>
            <td style="white-space: nowrap; vertical-align: top">［深さの精度のランク］</td>
            <td style="white-space: nowrap; vertical-align: top">
              <xsl:value-of select="jmx_seis:Hypocenter/jmx_seis:Accuracy/jmx_seis:Depth/@rank" />
            </td>
          </tr>

          <tr>
            <td style="white-space: nowrap; vertical-align: top">［マグニチュードの精度のランク］</td>
            <td style="white-space: nowrap; vertical-align: top">
              <xsl:value-of select="jmx_seis:Hypocenter/jmx_seis:Accuracy/jmx_seis:MagnitudeCalculation/@rank" />
            </td>
          </tr>

          <tr>
            <td style="white-space: nowrap; vertical-align: top">［マグニチュード計算使用観測点数］</td>
            <td style="white-space: nowrap; vertical-align: top">
              <xsl:value-of select="jmx_seis:Hypocenter/jmx_seis:Accuracy/jmx_seis:NumberOfMagnitudeCalculation" />
            </td>
          </tr>

        </xsl:if>

      </xsl:if>

      <xsl:for-each select="jmx_eb:Magnitude">
        <tr>
          <td style="white-space: nowrap; vertical-align: top">
            <xsl:text>［マグニチュード（</xsl:text>
            <xsl:value-of select="@type" />
            <xsl:text>）］</xsl:text>
          </td>
          <td style="white-space: nowrap; vertical-align: top">
            <xsl:value-of select="@description" />
          </td>
        </tr>
      </xsl:for-each>

    </table>
    <br />

  </xsl:for-each>

  <!-- 震度・長周期地震動の予測 -->
  <xsl:if test="jmx_seis:Intensity/jmx_seis:Forecast!=''">

    <h4>【震度・長周期地震動の予測】</h4>

      <table>

        <tr>
          <td style="white-space: nowrap; vertical-align: top">［最大予測震度］</td>
          <td style="white-space: nowrap; vertical-align: top">
            <xsl:call-template name="ForecastIntChange">
              <xsl:with-param name="From" select="jmx_seis:Intensity/jmx_seis:Forecast/jmx_seis:ForecastInt/jmx_seis:From" />
              <xsl:with-param name="To" select="jmx_seis:Intensity/jmx_seis:Forecast/jmx_seis:ForecastInt/jmx_seis:To" />
            </xsl:call-template>
          </td>
        </tr>

        <xsl:if test="jmx_seis:Intensity/jmx_seis:Forecast/jmx_seis:ForecastLgInt!=''">
          <tr>
            <td style="white-space: nowrap; vertical-align: top">［最大予測長周期地震動階級］</td>
            <td style="white-space: nowrap; vertical-align: top">
              <xsl:call-template name="ForecastIntChange">
                <xsl:with-param name="From" select="jmx_seis:Intensity/jmx_seis:Forecast/jmx_seis:ForecastLgInt/jmx_seis:From" />
                <xsl:with-param name="To" select="jmx_seis:Intensity/jmx_seis:Forecast/jmx_seis:ForecastLgInt/jmx_seis:To" />
              </xsl:call-template>
            </td>
          </tr>
        </xsl:if>

      <xsl:if test="jmx_seis:Intensity/jmx_seis:Forecast/jmx_seis:Appendix!=''">

        <tr>
          <td style="white-space: nowrap; vertical-align: top">［最大予測震度変化］</td>
          <td style="white-space: nowrap; vertical-align: top">
            <xsl:value-of select="jmx_seis:Intensity/jmx_seis:Forecast/jmx_seis:Appendix/jmx_seis:MaxIntChange" />
          </td>
        </tr>

        <xsl:if test="jmx_seis:Intensity/jmx_seis:Forecast/jmx_seis:Appendix/jmx_seis:MaxLgIntChange!=''">
          <tr>
            <td style="white-space: nowrap; vertical-align: top">［最大予測長周期地震動階級変化］</td>
            <td style="white-space: nowrap; vertical-align: top">
              <xsl:value-of select="jmx_seis:Intensity/jmx_seis:Forecast/jmx_seis:Appendix/jmx_seis:MaxLgIntChange" />
            </td>
          </tr>
        </xsl:if>

        <tr>
          <td style="white-space: nowrap; vertical-align: top">［最大予測震度変化の理由］</td>
          <td style="white-space: nowrap; vertical-align: top">
            <xsl:value-of select="jmx_seis:Intensity/jmx_seis:Forecast/jmx_seis:Appendix/jmx_seis:MaxIntChangeReason" />
          </td>
        </tr>

        <xsl:if test="jmx_seis:Intensity/jmx_seis:Forecast/jmx_seis:Appendix/jmx_seis:MaxLgIntChangeReason!=''">
          <tr>
            <td style="white-space: nowrap; vertical-align: top">［最大予測長周期地震動階級変化の理由］</td>
            <td style="white-space: nowrap; vertical-align: top">
              <xsl:value-of select="jmx_seis:Intensity/jmx_seis:Forecast/jmx_seis:Appendix/jmx_seis:MaxLgIntChangeReason" />
            </td>
          </tr>
        </xsl:if>

      </xsl:if>

    </table>
    <br />

  </xsl:if>

  <xsl:if test="jmx_seis:Intensity/jmx_seis:Forecast/jmx_seis:Pref!=''">

    <table>

      <tr>
        <td style="white-space: nowrap; vertical-align: top">［都道府県］</td>
        <td style="white-space: nowrap; vertical-align: top">［細分区域］</td>
        <td style="white-space: nowrap; vertical-align: top">［予報カテゴリー］</td>
        <td style="white-space: nowrap; vertical-align: top">［最大予測震度］</td>
        <xsl:if test="jmx_seis:Intensity/jmx_seis:Forecast/jmx_seis:Pref/jmx_seis:Area/jmx_seis:ForecastLgInt!=''">
          <td style="white-space: nowrap; vertical-align: top">［最大予測長周期地震動階級］</td>
        </xsl:if>
        <td style="white-space: nowrap; vertical-align: top">［主要動の到達予想時刻］</td>
      </tr>

      <xsl:for-each select="jmx_seis:Intensity/jmx_seis:Forecast/jmx_seis:Pref">
        <tr>
          <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
            <xsl:value-of select="jmx_seis:Name" />
          </td>
          <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
            <xsl:value-of select="jmx_seis:Area/jmx_seis:Name" />
          </td>
          <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
            <xsl:value-of select="jmx_seis:Area/jmx_seis:Category/jmx_seis:Kind/jmx_seis:Name" />
          </td>
          <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
            <xsl:call-template name="ForecastIntChange">
              <xsl:with-param name="From" select="jmx_seis:Area/jmx_seis:ForecastInt/jmx_seis:From" />
              <xsl:with-param name="To" select="jmx_seis:Area/jmx_seis:ForecastInt/jmx_seis:To" />
            </xsl:call-template>
          </td>
          <xsl:if test="jmx_seis:Area/jmx_seis:ForecastLgInt!=''">
            <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
              <xsl:call-template name="ForecastIntChange">
                <xsl:with-param name="From" select="jmx_seis:Area/jmx_seis:ForecastLgInt/jmx_seis:From" />
                <xsl:with-param name="To" select="jmx_seis:Area/jmx_seis:ForecastLgInt/jmx_seis:To" />
              </xsl:call-template>
            </td>
          </xsl:if>
          <td style="white-space: nowrap; vertical-align: top">
            <xsl:choose>
              <xsl:when test="jmx_seis:Area/jmx_seis:ArrivalTime!=''">
                <xsl:call-template name="DispDateTime">
                  <xsl:with-param name="Jikan" select="jmx_seis:Area/jmx_seis:ArrivalTime" />
                  <xsl:with-param name="Significant">ddThh:mm:ss</xsl:with-param>
                </xsl:call-template>
              </xsl:when>
              <xsl:when test="jmx_seis:Area/jmx_seis:Condition!=''">
                <xsl:value-of select="jmx_seis:Area/jmx_seis:Condition" />
              </xsl:when>
            </xsl:choose>
          </td>
        </tr>
      </xsl:for-each>

    </table>
    <br />

  </xsl:if>

  <!-- 震度・長周期地震動の観測 -->
  <xsl:if test="jmx_seis:Intensity/jmx_seis:Observation!=''">

    <h4>【震度・長周期地震動の観測】</h4>

    <table>

      <tr>
        <td style="white-space: nowrap; vertical-align: top">最大震度</td>
        <td style="white-space: nowrap; vertical-align: top">
          <xsl:call-template name="SIchange">
            <xsl:with-param name="SI" select="jmx_seis:Intensity/jmx_seis:Observation/jmx_seis:MaxInt" />
          </xsl:call-template>
        </td>
      </tr>

      <xsl:if test="jmx_seis:Intensity/jmx_seis:Observation/jmx_seis:MaxLgInt!=''">
        <tr>
          <td style="white-space: nowrap; vertical-align: top">最大長周期地震動階級</td>
          <td style="white-space: nowrap; vertical-align: top">
            <xsl:value-of select="jmx_seis:Intensity/jmx_seis:Observation/jmx_seis:MaxLgInt" />
          </td>
        </tr>
      </xsl:if>

      <xsl:if test="jmx_seis:Intensity/jmx_seis:Observation/jmx_seis:LgCategory!=''">
        <tr>
          <td style="white-space: nowrap; vertical-align: top">観測された長周期地震動階級と震度の状況の分類</td>
          <td style="white-space: nowrap; vertical-align: top">
            <xsl:value-of select="jmx_seis:Intensity/jmx_seis:Observation/jmx_seis:LgCategory" />
          </td>
        </tr>
      </xsl:if>

      <xsl:for-each select="jmx_seis:Intensity/jmx_seis:Observation/jmx_seis:Pref">

        <tr>
          <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
            <xsl:call-template name="blank2" />
            <xsl:value-of select="jmx_seis:Name" />
          </td>
          <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
            <xsl:text>最大震度</xsl:text>
            <xsl:call-template name="SIchange">
              <xsl:with-param name="SI" select="jmx_seis:MaxInt" />
            </xsl:call-template>
          </td>

          <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
            <xsl:if test="jmx_seis:MaxLgInt!=''">
              <xsl:text>最大長周期地震動階級</xsl:text>
              <xsl:value-of select="jmx_seis:MaxLgInt" />
            </xsl:if>
          </td>

          <td style="white-space: nowrap; vertical-align: top">
            <xsl:if test="jmx_seis:Revise!=''">
              <xsl:text>≪</xsl:text>
              <xsl:value-of select="jmx_seis:Revise" />
              <xsl:text>≫</xsl:text>
            </xsl:if>
          </td>
        </tr>

        <xsl:for-each select="jmx_seis:Area">

          <tr>
            <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
              <xsl:call-template name="blank4" />
              <xsl:value-of select="jmx_seis:Name" />
            </td>

            <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
              <xsl:text>最大震度</xsl:text>
              <xsl:call-template name="SIchange">
                <xsl:with-param name="SI" select="jmx_seis:MaxInt" />
              </xsl:call-template>
            </td>

            <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
              <xsl:if test="jmx_seis:MaxLgInt!=''">
                <xsl:text>最大長周期地震動階級</xsl:text>
                <xsl:value-of select="jmx_seis:MaxLgInt" />
              </xsl:if>
            </td>

            <td style="white-space: nowrap; vertical-align: top">
              <xsl:if test="jmx_seis:Revise!=''">
                <xsl:text>≪</xsl:text>
                <xsl:value-of select="jmx_seis:Revise" />
                <xsl:text>≫</xsl:text>
              </xsl:if>
            </td>

          </tr>

          <xsl:if test="jmx_seis:City!=''">

            <xsl:for-each select="jmx_seis:City">

              <tr>
                <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
                  <xsl:call-template name="blank6" />
                  <xsl:value-of select="jmx_seis:Name" />
                </td>

                <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
                  <xsl:text>最大震度</xsl:text>
                  <xsl:call-template name="SIchange">
                    <xsl:with-param name="SI" select="jmx_seis:MaxInt" />
                  </xsl:call-template>
                  <xsl:if test="jmx_seis:Condition!=''">
                    <xsl:text>（</xsl:text>
                    <xsl:value-of select="jmx_seis:Condition" />
                    <xsl:text>）</xsl:text>
                  </xsl:if>
                </td>

                <td style="white-space: nowrap; vertical-align: top">
                  <xsl:if test="jmx_seis:Revise!=''">
                    <xsl:text>≪</xsl:text>
                    <xsl:value-of select="jmx_seis:Revise" />
                    <xsl:text>≫</xsl:text>
                  </xsl:if>
                </td>

              </tr>

              <!-- Pref/Area/City/IntensityStation の場合  -->
              <xsl:for-each select="jmx_seis:IntensityStation">

                <tr>
                  <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
                    <xsl:call-template name="blank8" />
                    <xsl:value-of select="jmx_seis:Name" />
                  </td>
                  <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
                    <xsl:call-template name="blank2" />
                    <xsl:text>震度</xsl:text>
                    <xsl:call-template name="SIchange">
                      <xsl:with-param name="SI" select="jmx_seis:Int" />
                    </xsl:call-template>
                  </td>

                  <td style="white-space: nowrap; vertical-align: top">
                    <xsl:if test="jmx_seis:Revise!=''">
                      <xsl:text>≪</xsl:text>
                      <xsl:value-of select="jmx_seis:Revise" />
                      <xsl:text>≫</xsl:text>
                    </xsl:if>
                  </td>
                </tr>

              </xsl:for-each>

            </xsl:for-each>

          </xsl:if>

            <!-- Pref/Area/IntensityStation の場合  -->
            <xsl:if test="jmx_seis:IntensityStation!=''">
              <xsl:for-each select="jmx_seis:IntensityStation">

                <tr>
                  <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
                    <xsl:call-template name="blank8" />
                    <xsl:value-of select="jmx_seis:Name" />
                  </td>
                  <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
                    <xsl:call-template name="blank2" />
                    <xsl:text>震度</xsl:text>
                    <xsl:call-template name="SIchange">
                      <xsl:with-param name="SI" select="jmx_seis:Int" />
                    </xsl:call-template>
                  </td>

                  <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
                    <xsl:if test="jmx_seis:LgInt!=''">
                      <xsl:call-template name="blank2" />
                      <xsl:text>長周期地震動階級</xsl:text>
                      <xsl:value-of select="jmx_seis:LgInt" />
                    </xsl:if>
                  </td>

                  <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
                    <xsl:if test="jmx_seis:Sva!=''">
                      <xsl:text>絶対速度応答スペクトル（全周期）</xsl:text>
                      <xsl:value-of select="jmx_seis:Sva" />
                      <xsl:value-of select="jmx_seis:Sva/@unit" />
                    </xsl:if>
                  </td>

                  <td style="white-space: nowrap; vertical-align: top">
                    <xsl:if test="jmx_seis:Revise!=''">
                      <xsl:text>≪</xsl:text>
                      <xsl:value-of select="jmx_seis:Revise" />
                      <xsl:text>≫</xsl:text>
                    </xsl:if>
                  </td>
                </tr>

                <!-- 周期別階級 -->
                <xsl:if test="jmx_seis:LgIntPerPeriod!=''">
                  <tr>
                    <td style="white-space: nowrap; vertical-align: top; padding-right: 1em"></td>
                    <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
                      <xsl:text>周期別階級</xsl:text>
                    </td>
                  </tr>
                  <tr>
                    <td style="white-space: nowrap; vertical-align: top; padding-right: 1em"></td>
                      <xsl:for-each select="jmx_seis:LgIntPerPeriod">
                        <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
                          <xsl:call-template name="blank1" />
                          <xsl:value-of select="@PeriodicBand" />
                          <xsl:value-of select="@PeriodUnit" />
                          <xsl:call-template name="blank1" />
                          <xsl:text>階級</xsl:text>
                          <xsl:value-of select="text()" />
                        </td>
                      </xsl:for-each>
                  </tr>
                </xsl:if>

                <!-- 周期別Sva（絶対速度応答スペクトル） -->
                <xsl:if test="jmx_seis:SvaPerPeriod!=''">
                  <tr>
                    <td style="white-space: nowrap; vertical-align: top; padding-right: 1em"></td>
                    <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
                      <xsl:text>周期別絶対速度応答スペクトル</xsl:text>
                    </td>
                  </tr>
                  <tr>
                    <td style="white-space: nowrap; vertical-align: top; padding-right: 1em"></td>
                      <xsl:for-each select="jmx_seis:SvaPerPeriod">
                        <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
                          <xsl:call-template name="blank1" />
                          <xsl:value-of select="@PeriodicBand" />
                          <xsl:value-of select="@PeriodUnit" />
                          <xsl:call-template name="blank1" />
                          <xsl:value-of select="text()" />
                          <xsl:value-of select="@unit" />
                        </td>
                      </xsl:for-each>
                  </tr>
                </xsl:if>

              </xsl:for-each>
            </xsl:if>

        </xsl:for-each>

      </xsl:for-each>

    </table>
    <br />

  </xsl:if>

  <!-- 南海トラフ地震関連情報、北海道・三陸沖後発地震注意情報 -->
  <xsl:if test="jmx_seis:EarthquakeInfo!=''">

      <h4>【<xsl:value-of select="jmx_seis:EarthquakeInfo/@type" />】</h4>

    <table>

      <tr>
        <td style="white-space: nowrap; vertical-align: top">［情報名称］</td>
        <td style="white-space: nowrap; vertical-align: top">
          <xsl:value-of select="jmx_seis:EarthquakeInfo/jmx_seis:InfoKind" />
        </td>
      </tr>

      <xsl:if test="jmx_seis:EarthquakeInfo/jmx_seis:InfoSerial!=''">
        <tr>
          <td style="white-space: nowrap; vertical-align: top">［情報種別番号名］</td>
          <td style="white-space: nowrap; vertical-align: top">
            <xsl:value-of select="jmx_seis:EarthquakeInfo/jmx_seis:InfoSerial/jmx_seis:Name" />
          </td>
        </tr>
      </xsl:if>

      <xsl:if test="jmx_seis:EarthquakeInfo/jmx_seis:InfoSerial!=''">
        <tr>
          <td style="white-space: nowrap; vertical-align: top">［情報種別番号コード］</td>
          <td style="white-space: nowrap; vertical-align: top">
            <xsl:value-of select="jmx_seis:EarthquakeInfo/jmx_seis:InfoSerial/jmx_seis:Code" />
          </td>
        </tr>
      </xsl:if>

    </table>
    <br />

    <div>［本文］</div>
    <br />

    <div>
      <xsl:call-template name="mkBR">
        <xsl:with-param name="value" select="jmx_seis:EarthquakeInfo/jmx_seis:Text" />
      </xsl:call-template>
    </div>
    <br />

  </xsl:if>

  <!-- 地震回数 -->
  <xsl:if test="jmx_seis:EarthquakeCount!=''">

    <h4>【地震回数】</h4>

    <table>

      <tr>
        <td style="white-space: nowrap; vertical-align: top">［回数要素の内容］</td>
        <td style="white-space: nowrap; vertical-align: top">［開始時刻］</td>
        <td style="white-space: nowrap; vertical-align: top">［終了時刻］</td>
        <td style="white-space: nowrap; vertical-align: top">［地震回数］</td>
        <td style="white-space: nowrap; vertical-align: top">［有感地震回数］</td>
      </tr>

      <xsl:for-each select="jmx_seis:EarthquakeCount/jmx_seis:Item">
        <tr>
          <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
            <xsl:value-of select="@type" />
          </td>
          <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
            <xsl:call-template name="DispDateTime">
              <xsl:with-param name="Jikan" select="jmx_seis:StartTime" />
            </xsl:call-template>
          </td>
          <td style="white-space: nowrap; vertical-align: top; padding-right: 1em">
            <xsl:call-template name="DispDateTime">
              <xsl:with-param name="Jikan" select="jmx_seis:EndTime" />
            </xsl:call-template>
          </td>
          <td style="white-space: nowrap; vertical-align: top; text-align: right; padding-right: 1em">
            <xsl:value-of select="jmx_seis:Number" />
          </td>
          <td style="white-space: nowrap; vertical-align: top; text-align: right; padding-right: 1em">
            <xsl:value-of select="jmx_seis:FeltNumber" />
          </td>
        </tr>
      </xsl:for-each>

    </table>
    <br />

  </xsl:if>

  <!-- テキスト要素 -->
  <xsl:if test="jmx_seis:Text!=''">

    <h4>【テキスト要素】</h4>

    <xsl:call-template name="mkBR">
      <xsl:with-param name="value" select="jmx_seis:Text" />
    </xsl:call-template>
    <br />

  </xsl:if>

  <!-- 次回発表予定 -->
  <xsl:if test="jmx_seis:NextAdvisory!=''">

    <h4>【次回発表予定】</h4>

    <xsl:call-template name="mkBR">
      <xsl:with-param name="value" select="jmx_seis:NextAdvisory" />
    </xsl:call-template>
    <br />

  </xsl:if>

  <!-- 参考情報 -->
  <xsl:if test="jmx_seis:EarthquakeInfo/jmx_seis:Appendix!=''">

    <h4>【参考情報】</h4>

    <xsl:call-template name="mkBR">
      <xsl:with-param name="value" select="jmx_seis:EarthquakeInfo/jmx_seis:Appendix" />
    </xsl:call-template>
    <br />

  </xsl:if>

  <!-- 付加文 -->
  <xsl:if test="jmx_seis:Comments!=''">

    <h4>【付加文】</h4>

    <xsl:if test="jmx_seis:Comments/jmx_seis:WarningComment!=''">
      <div>［固定付加文（警報・注意報用）］</div>
      <br />
      <div>
        <xsl:call-template name="mkBR">
          <xsl:with-param name="value" select="jmx_seis:Comments/jmx_seis:WarningComment/jmx_seis:Text" />
        </xsl:call-template>
      </div>
      <br />
    </xsl:if>

    <xsl:if test="jmx_seis:Comments/jmx_seis:ForecastComment!=''">
      <div>［固定付加文（予報用）］</div>
      <br />
      <div>
        <xsl:call-template name="mkBR">
          <xsl:with-param name="value" select="jmx_seis:Comments/jmx_seis:ForecastComment/jmx_seis:Text" />
        </xsl:call-template>
      </div>
      <br />
    </xsl:if>

    <xsl:if test="jmx_seis:Comments/jmx_seis:VarComment!=''">
      <div>［固定付加文（用途限定なし）］</div>
      <br />
      <div>
        <xsl:call-template name="mkBR">
          <xsl:with-param name="value" select="jmx_seis:Comments/jmx_seis:VarComment/jmx_seis:Text" />
        </xsl:call-template>
      </div>
      <br />
    </xsl:if>

    <xsl:if test="jmx_seis:Comments/jmx_seis:FreeFormComment!=''">
      <div>［自由付加文］</div>
      <br />
      <div>
        <xsl:call-template name="mkBR">
          <xsl:with-param name="value" select="jmx_seis:Comments/jmx_seis:FreeFormComment" />
        </xsl:call-template>
      </div>
      <br />
    </xsl:if>

  </xsl:if>

</xsl:template>

<!-- ============================ -->
<!-- 改行支援テンプレート　　　　 -->
<!-- ============================ -->
<xsl:template name="mkBR">
  <xsl:param name="value">dummy</xsl:param>
  <xsl:choose>
    <xsl:when test="contains($value, '&#xA;')">
      <xsl:value-of select="substring-before($value, '&#xA;')" />
      <br/>
      <xsl:call-template name="mkBR">
        <xsl:with-param name="value" select="substring-after($value, '&#xA;')" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$value" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================ -->
<!-- 震度変換表示テンプレート　　 -->
<!-- ============================ -->
<xsl:template name="SIchange">
  <xsl:param name="SI">dummy</xsl:param>
  <xsl:choose>
    <xsl:when test="contains($SI,'-')">
      <xsl:value-of select="translate($SI,'-','弱')" />
    </xsl:when>
    <xsl:when test="contains($SI,'+')">
      <xsl:value-of select="translate($SI,'+','強')" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$SI" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================ -->
<!-- 予測震度変換表示テンプレート -->
<!-- ============================ -->
<xsl:template name="ForecastIntChange">
  <xsl:param name="From">dummy</xsl:param>
  <xsl:param name="To">dummy</xsl:param>
  <xsl:choose>
    <xsl:when test="contains($From,$To)">
      <xsl:call-template name="SIchange">
        <xsl:with-param name="SI" select="$From" />
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$To='over'">
      <xsl:call-template name="SIchange">
        <xsl:with-param name="SI" select="$From" />
      </xsl:call-template>
      <xsl:text>程度以上</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="SIchange">
        <xsl:with-param name="SI" select="$From" />
      </xsl:call-template>
      <xsl:text>から</xsl:text>
      <xsl:call-template name="SIchange">
        <xsl:with-param name="SI" select="$To" />
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================ -->
<!-- 日付表示テンプレート         -->
<!-- ============================ -->
<xsl:template name="DispDateTime">
  <xsl:param name="Jikan">dummy</xsl:param>
  <xsl:param name="Significant">yyyy-mm-ddThh:mm</xsl:param>
  <xsl:param name="TimeZone">dummy</xsl:param>
  <xsl:if test="contains($Significant,'yyyy')">
    <xsl:choose>
      <xsl:when test="$TimeZone='UTC'">
        <xsl:value-of select="substring($Jikan,1,4)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>令和</xsl:text>
        <xsl:if test="number(substring($Jikan,1,4))=2019">
          <xsl:text>元</xsl:text>
        </xsl:if>
        <xsl:if test="number(substring($Jikan,1,4))!=2019">
          <xsl:value-of select="number(substring($Jikan,1,4)) - 2018 " />
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>年</xsl:text>
  </xsl:if>
  <xsl:if test="contains($Significant,'-mm') or contains($Significant,'mm-')">
    <xsl:value-of select="substring($Jikan,6,2)" />
    <xsl:text>月</xsl:text>
  </xsl:if>
  <xsl:if test="contains($Significant,'dd')">
    <xsl:value-of select="substring($Jikan,9,2)" />
    <xsl:text>日</xsl:text>
  </xsl:if>
  <xsl:if test="contains($Significant,'hh')">
    <xsl:value-of select="substring($Jikan,12,2)" />
    <xsl:text>時</xsl:text>
  </xsl:if>
  <xsl:if test="contains($Significant,':mm') or contains($Significant,'mm:')">
    <xsl:value-of select="substring($Jikan,15,2)" />
    <xsl:text>分</xsl:text>
  </xsl:if>
  <xsl:if test="contains($Significant,'ss')">
    <xsl:value-of select="substring($Jikan,18,2)" />
    <xsl:text>秒</xsl:text>
  </xsl:if>
  <xsl:if test="$TimeZone='UTC'">
    <xsl:text>（ＵＴＣ）</xsl:text>
  </xsl:if>
</xsl:template>

<!-- ============================ -->
<!-- 全角スペース表示テンプレート -->
<!-- ============================ -->
<xsl:template name="blank1"><xsl:text>　</xsl:text></xsl:template>
<xsl:template name="blank2"><xsl:text>　　</xsl:text></xsl:template>
<xsl:template name="blank3"><xsl:text>　　　</xsl:text></xsl:template>
<xsl:template name="blank4"><xsl:text>　　　　</xsl:text></xsl:template>
<xsl:template name="blank5"><xsl:text>　　　　　</xsl:text></xsl:template>
<xsl:template name="blank6"><xsl:text>　　　　　　</xsl:text></xsl:template>
<xsl:template name="blank7"><xsl:text>　　　　　　　</xsl:text></xsl:template>
<xsl:template name="blank8"><xsl:text>　　　　　　　　</xsl:text></xsl:template>

</xsl:stylesheet>

