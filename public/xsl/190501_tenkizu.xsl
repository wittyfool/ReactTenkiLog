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
  地上実況図、地上２４時間予想図、地上４８時間予想図
  アジア太平洋地上実況図、アジア太平洋海上悪天２４時間予想図、アジア太平洋海上悪天４８時間予想図

  【更新履歴】
  2012年05月10日　Ver.1.0
  2013年05月23日　ver.1.1 アジア太平洋地上実況図、アジア太平洋海上悪天２４時間予想図、アジア太平洋海上悪天４８時間予想図に対応
  2019年04月24日　Ver.1.2 5月1日より施行される新元号への対応
  ======================================================================
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:j="http://xml.kishou.go.jp/jmaxml1/" 
 xmlns:b="http://xml.kishou.go.jp/jmaxml1/body/meteorology1/"
 xmlns:ib="http://xml.kishou.go.jp/jmaxml1/informationBasis1/"
 xmlns:eb="http://xml.kishou.go.jp/jmaxml1/elementBasis1/"
 xmlns:xlink="http://www.w3.org/1999/xlink" >

<xsl:output method="html" encoding="Shift_JIS"/>

<!-- メインテンプレート -->

<xsl:template match="/">

<html><head></head><body><pre>


<!-- 時刻等を取得 -->
<xsl:apply-templates select="j:Report/ib:Head" mode="title"/>

<xsl:value-of select="j:Report/j:Control/j:PublishingOffice"/><xsl:text>発表</xsl:text>
<xsl:call-template name="CR"/>
<xsl:value-of select="j:Report/b:Body/b:MeteorologicalInfos/b:MeteorologicalInfo/b:DateTime/@type"/>
<xsl:text>：</xsl:text>
<xsl:value-of select="j:Report/b:Body/b:MeteorologicalInfos/b:MeteorologicalInfo/b:DateTime"/>


<!-- 擾乱を取得 -->

【擾乱】
<xsl:apply-templates select="j:Report/b:Body/b:MeteorologicalInfos/b:MeteorologicalInfo/b:Item[b:Kind/b:Property/b:Type='台風']" mode="typn" />
<xsl:apply-templates select="j:Report/b:Body/b:MeteorologicalInfos/b:MeteorologicalInfo/b:Item[b:Kind/b:Property/b:Type='熱帯低気圧']" mode="jouran" />
<xsl:apply-templates select="j:Report/b:Body/b:MeteorologicalInfos/b:MeteorologicalInfo/b:Item[b:Kind/b:Property/b:Type='低気圧']" mode="jouran" />
<xsl:apply-templates select="j:Report/b:Body/b:MeteorologicalInfos/b:MeteorologicalInfo/b:Item[b:Kind/b:Property/b:Type='低圧部']" mode="jouran" />
<xsl:apply-templates select="j:Report/b:Body/b:MeteorologicalInfos/b:MeteorologicalInfo/b:Item[b:Kind/b:Property/b:Type='高気圧']" mode="jouran" />

【等圧線】
<!-- 等圧線を取得(９８０、１０００、１０２０hPa)　"and"　以降を除けば全部の等圧線 -->
<xsl:apply-templates select="j:Report/b:Body/b:MeteorologicalInfos/b:MeteorologicalInfo/b:Item[b:Kind/b:Property/b:Type='等圧線' and b:Kind/b:Property/b:IsobarPart/eb:Pressure='980']" mode="isobar" />
<xsl:apply-templates select="j:Report/b:Body/b:MeteorologicalInfos/b:MeteorologicalInfo/b:Item[b:Kind/b:Property/b:Type='等圧線' and b:Kind/b:Property/b:IsobarPart/eb:Pressure='1000']" mode="isobar" />
<xsl:apply-templates select="j:Report/b:Body/b:MeteorologicalInfos/b:MeteorologicalInfo/b:Item[b:Kind/b:Property/b:Type='等圧線' and b:Kind/b:Property/b:IsobarPart/eb:Pressure='1020']" mode="isobar" />

【前線】
<!-- 前線を取得 -->
<xsl:apply-templates select="j:Report/b:Body/b:MeteorologicalInfos/b:MeteorologicalInfo/b:Item[b:Kind/b:Property/b:Type='温暖前線']" mode="front" />
<xsl:apply-templates select="j:Report/b:Body/b:MeteorologicalInfos/b:MeteorologicalInfo/b:Item[b:Kind/b:Property/b:Type='寒冷前線']" mode="front" />
<xsl:apply-templates select="j:Report/b:Body/b:MeteorologicalInfos/b:MeteorologicalInfo/b:Item[b:Kind/b:Property/b:Type='閉塞前線']" mode="front" />
<xsl:apply-templates select="j:Report/b:Body/b:MeteorologicalInfos/b:MeteorologicalInfo/b:Item[b:Kind/b:Property/b:Type='停滞前線']" mode="front" />

【悪天情報　強風】
<!-- 悪天情報（強風）を取得 -->
<xsl:apply-templates select="j:Report/b:Body/b:MeteorologicalInfos[@type='悪天情報']/b:MeteorologicalInfo/b:Item[b:Kind/b:Name='悪天情報（強風）']" mode="gale" />

【悪天情報　霧】
<xsl:apply-templates select="j:Report/b:Body/b:MeteorologicalInfos[@type='悪天情報']/b:MeteorologicalInfo/b:Item[b:Kind/b:Name='悪天情報（霧）' and b:Area/@codeType='全般海上海域名']" mode="fogSea" />
<xsl:apply-templates select="j:Report/b:Body/b:MeteorologicalInfos[@type='悪天情報']/b:MeteorologicalInfo/b:Item[b:Kind/b:Name='悪天情報（霧）' and b:Area/b:Name='霧域']" mode="fogArea" />

【悪天情報　船体着氷】
<xsl:apply-templates select="j:Report/b:Body/b:MeteorologicalInfos[@type='悪天情報']/b:MeteorologicalInfo/b:Item[b:Kind/b:Name='悪天情報（船体着氷）']" mode="icing" />

【悪天情報　海氷】
<xsl:apply-templates select="j:Report/b:Body/b:MeteorologicalInfos[@type='悪天情報']/b:MeteorologicalInfo/b:Item[b:Kind/b:Name='悪天情報（海氷）']" mode="seaIce" />
</pre></body></html>


</xsl:template>
<!-- メインテンプレート終わり -->


<!-- 各要素のテンプレート -->
<!-- 時刻等用のテンプレート -->
<xsl:template match="ib:Head" mode="title">
<xsl:value-of select="ib:Title"/>
<xsl:text>：（ReportDateTime）</xsl:text>
<xsl:value-of select="ib:ReportDateTime"/>
<xsl:text>：（TargetDateTime）</xsl:text>
<xsl:value-of select="ib:TargetDateTime"/>
<xsl:call-template name="CR"/>
</xsl:template>


<!-- 擾乱用のテンプレート -->
<xsl:template match="b:Item" mode="jouran">
<xsl:value-of select="b:Kind/b:Property/b:Type"/>
<xsl:text>　</xsl:text>
<xsl:value-of select="b:Kind/b:Property/b:CenterPart/eb:Coordinate/@type" />
<xsl:value-of select="b:Kind/b:Property/b:CenterPart/eb:Coordinate" />
<xsl:text>：</xsl:text>
<xsl:value-of select="b:Kind/b:Property/b:CenterPart/eb:Direction/@type" />
<xsl:value-of select="b:Kind/b:Property/b:CenterPart/eb:Direction" />
<xsl:text>：</xsl:text>
<xsl:value-of select="b:Kind/b:Property/b:CenterPart/eb:Speed/@type" />
<xsl:value-of select="b:Kind/b:Property/b:CenterPart/eb:Speed" />
<xsl:text>：</xsl:text>
<xsl:value-of select="b:Kind/b:Property/b:CenterPart/eb:Pressure/@type" />
<xsl:value-of select="b:Kind/b:Property/b:CenterPart/eb:Pressure" />
<xsl:call-template name="CR"/>
</xsl:template>


<!-- 台風用のテンプレート -->
<xsl:template match="b:Item" mode="typn">
<xsl:value-of select="b:Kind/b:Property/b:Type"/>
<xsl:text>　</xsl:text>
<xsl:value-of select="b:Kind/b:Property/b:TyphoonNamePart/b:Name"/>
<xsl:text>（</xsl:text>
<xsl:value-of select="b:Kind/b:Property/b:TyphoonNamePart/b:NameKana"/>
<xsl:text>）</xsl:text>
<xsl:value-of select="b:Kind/b:Property/b:TyphoonNamePart/b:Number"/>
<xsl:text>　</xsl:text>

<xsl:value-of select="b:Kind/b:Property/b:CenterPart/eb:Coordinate/@type" />
<xsl:value-of select="b:Kind/b:Property/b:CenterPart/eb:Coordinate" />
<xsl:text>：</xsl:text>
<xsl:value-of select="b:Kind/b:Property/b:CenterPart/eb:Direction/@type" />
<xsl:value-of select="b:Kind/b:Property/b:CenterPart/eb:Direction" />
<xsl:text>：</xsl:text>
<xsl:value-of select="b:Kind/b:Property/b:CenterPart/eb:Speed/@type" />
<xsl:value-of select="b:Kind/b:Property/b:CenterPart/eb:Speed" />
<xsl:text>：</xsl:text>
<xsl:value-of select="b:Kind/b:Property/b:CenterPart/eb:Pressure/@type" />
<xsl:value-of select="b:Kind/b:Property/b:CenterPart/eb:Pressure" />
<xsl:call-template name="CR"/>
</xsl:template>


<!-- 等圧線用のテンプレート -->
<xsl:template match="b:Item" mode="isobar">
<xsl:value-of select="b:Kind/b:Property/b:IsobarPart/eb:Pressure" />
<xsl:value-of select="b:Kind/b:Property/b:IsobarPart/eb:Pressure/@unit" />
<xsl:text>:</xsl:text>
<xsl:value-of select="b:Kind/b:Property/b:IsobarPart/eb:Line" />
<xsl:call-template name="CR"/>
</xsl:template>

<!-- 前線用のテンプレート -->
<xsl:template match="b:Item" mode="front">
<xsl:value-of select="b:Kind/b:Property/b:Type" />
<xsl:text>:</xsl:text>
<xsl:value-of select="b:Kind/b:Property/b:CoordinatePart/eb:Line" />
<xsl:call-template name="CR"/>
</xsl:template>

<!-- 悪天情報（強風）用のテンプレート -->
<xsl:template match="b:Item" mode="gale">
<xsl:value-of select="b:Kind/b:Name"/>
<xsl:value-of select="b:Area/eb:Coordinate"/>
<xsl:text>:</xsl:text>
<xsl:value-of select="b:Kind/b:Property/b:WindPart/eb:WindDegree"/>
<xsl:value-of select="b:Kind/b:Property/b:WindPart/eb:WindDegree/@unit"/>
<xsl:text> </xsl:text>
<xsl:value-of select="b:Kind/b:Property/b:WindPart/eb:WindSpeed"/>
<xsl:value-of select="b:Kind/b:Property/b:WindPart/eb:WindSpeed/@unit"/>
<xsl:call-template name="CR"/>
</xsl:template>

<!-- 悪天情報（霧）海域用のテンプレート -->
<xsl:template match="b:Item" mode="fogSea">
<xsl:value-of select="b:Kind/b:Name"/>
<xsl:text>:</xsl:text>
<xsl:value-of select="b:Area/b:Name"/>
<xsl:call-template name="CR"/>
</xsl:template>

<!-- 悪天情報（霧）領域用のテンプレート -->
<xsl:template match="b:Item" mode="fogArea">
<xsl:value-of select="b:Kind/b:Name"/>
<xsl:text>:</xsl:text>
<xsl:value-of select="b:Area/eb:Polygon"/>
<xsl:call-template name="CR"/>
</xsl:template>

<!-- 悪天情報（船体着氷）用のテンプレート -->
<xsl:template match="b:Item" mode="icing">
<xsl:value-of select="b:Kind/b:Name"/>
<xsl:value-of select="b:Kind/b:Property/b:CoodinatePart/eb:Coodinate/@type"/>
<xsl:text>:</xsl:text>
<xsl:value-of select="b:Area/eb:Coordinate"/>
<xsl:call-template name="CR"/>
</xsl:template>

<!-- 悪天情報（海氷）用のテンプレート -->
<xsl:template match="b:Item" mode="seaIce">
<xsl:value-of select="b:Kind/b:Name"/>
<xsl:value-of select="b:Kind/b:Property/b:CoodinatePart/eb:Coodinate/@type"/>
<xsl:text>:</xsl:text>
<xsl:value-of select="b:Area/eb:Coordinate"/>
<xsl:call-template name="CR"/>
</xsl:template>
<!-- 要素毎テンプレート終わり -->

<!-- 出力調整用の改行 -->
<xsl:template name="CR">
<xsl:text>
</xsl:text>
</xsl:template>
</xsl:stylesheet>