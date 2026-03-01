import React, { Component } from 'react';
import './App.css';
import Modal from 'react-modal';
require('babel-polyfill');

const customStyles = {
  content : {
    top                   : '5%',
    left                  : '5%',
    right                 : '5%',
    bottom                : '5%',
    padding: '0',
  },
};

var console = {
  log : function(){}
};

var to_json = require('xmljson').to_json;

function readArg(key){
    let get_params = new URLSearchParams( window.location.search.toString() );

    if(null === get_params.get(key)){
      return "";
    }
    return get_params.get(key);
}
// 電文URLから電文種別コードを取り出し、対応するCSSクラス名を返す
function getTelegramClass(url){
    const match = url.match(/_([A-Z]{2,4}\d+)_/);
    if(!match) return 'telegram-other';
    const prefix = match[1].substring(0, 2);
    // 電文種別の先頭2文字をCSSクラスにマッピング
    const classMap = {
        'VP': 'telegram-weather',    // 天気予報
        'VW': 'telegram-warning',    // 気象警報・注意報
        'VX': 'telegram-earthquake', // 地震
        'VF': 'telegram-volcano',    // 火山
        'VM': 'telegram-ocean',      // 海洋
        'VA': 'telegram-aviation',   // 航空
    };
    return classMap[prefix] || 'telegram-other';
}
export { getTelegramClass };

// 電文種別コード（先頭4文字）から対応するローカル XSL ファイル名を返す
const TELEGRAM_XSL_MAP = {
  'VPFW': '190501_shukan.xsl',        // 府県週間天気予報
  'VPFD': '190501_yoho.xsl',          // 府県天気予報
  'VPTW': '190501_yoho.xsl',          // 地域時系列予報
  'VPZJ': '251222_keihoR6.xsl',       // 気象警報・注意報（R06）
  'VPWW': '251222_jikeiretsuR6.xsl',  // 気象警報・注意報時系列情報（R06）
  'VPCW': '250318_ippanho.xsl',       // 全般・地方気象情報
  'VPCI': '250318_ippanho.xsl',       // 府県気象情報
  'VPTI': '190501_typhoon.xsl',       // 台風解析・予報情報
  'VPTS': '190501_tatsumaki.xsl',     // 竜巻注意情報
  'VYFH': '190501_dosya.xsl',         // 土砂災害警戒情報
  'VPLS': '190501_kiroame.xsl',       // 記録的短時間大雨情報
  'VZSA': '190501_tenkizu.xsl',       // 地上実況図
  'VZBD': '190501_tenkizu.xsl',       // 地上24時間予想図
  'VZBE': '190501_tenkizu.xsl',       // 地上48時間予想図
  'VCWG': '190501_chihoumikeiho.xsl', // 地方海上警報
  'VCWF': '190501_chihoumiyoho.xsl',  // 地方海上予報
  'VFVO': '220929_kazan.xsl',         // 火山に関するお知らせ
  'VFSA': '220929_kazan.xsl',         // 噴火に関する火山観測報
  'VZPS': '190529_kozui.xsl',         // 指定河川洪水予報
  'VXSE': '240821_jishin_tsunami_nankai_decode_all.xsl', // 地震情報
};
function getXslForUrl(url) {
  const m = url.match(/_([A-Z]{4})\d+_/);
  if (!m) return null;
  return TELEGRAM_XSL_MAP[m[1]] || null;
}
export { getXslForUrl };
function dateJST(gmtStr){
    var str = gmtStr.replace(/\./g, ':');
    var jst = new Date(str);
    jst.setHours(jst.getHours() + 9);

    var jstStr = jst.toISOString();
    jstStr =  jstStr.replace(/\.000Z/, "");
    jstStr =  jstStr.replace(/^(20\d\d)-(\d\d)-(\d\d)\D+/, "$2/$3 ");
    jstStr =  jstStr.replace(/^0/, "");
    jstStr =  jstStr.replace(/\/0/, "/");
    jstStr =  jstStr.replace(/:\d{2}$/, "");
    return jstStr;
}
export { dateJST };
// 〇〇地方気象台 → 〇〇 に省略する
function abbreviateOffice(name){
  return name.replace('地方気象台', '');
}
export { abbreviateOffice };
// -------------------------------------------------------------
class MyList extends Component {
  constructor(props){
    super(props);
    this.clickHandler = this._clickHandler.bind(this);
    this.updateHandler = this._updateHandler.bind(this);
    this.modalHandler = this.props.modal;

    this.state = {
      url: this.props.item["link"]["$"]["href"],
      title: this.props.item["title"] + ' ' + this.props.item["author"]["name"],
    };
  }

  _clickHandler(str, title, callback){
    console.log("MyList clicked " + str);
    this.modalHandler(str, title);
    callback();
  }
  _updateHandler(){
    console.log("MyList _updateHandler...");
  }

  render(){
    const dateStr = dateJST(this.props.item["updated"]);
    const [datePart, timePart] = dateStr.split(' ');
    return (
        <ul>
            <li key={this.props.item["id"]}>
	      <span className="datetime">
                <span style={{ visibility: this.props.showDate ? 'visible' : 'hidden' }} aria-hidden={!this.props.showDate}>{datePart} </span>
                {timePart}
	      </span>
              <span> </span>
              <span
	    	className="xmldata"
                style={{ color: '#66f', cursor: 'pointer'}}
                onClick={()=>{this.clickHandler(this.state.url, this.state.title, this.updateHandler)}} >
              {this.props.item["title"]}
              </span>
              <span> </span>
              {abbreviateOffice(this.props.item["author"]["name"])}

            </li>
        </ul>
    );
  }
}

class App extends Component {
  constructor(props){
    super(props);
    this.state = {
      filter: {
        telegram: readArg("telegram"),
        date: readArg("date"),
        kansho: readArg("kansho"),
      },
      items: [],
      url : "/feed/regular.xml",
      message: '...',
      modalIsOpen: false,
      modalLoading: false,
    }

    // tricky but necessary
    this.onChange = this.onChange.bind(this);
    this.urlHandler = this._urlHandler.bind(this);
    this.readData = this._readData.bind(this);

    //
    this.openModal = this.openModal.bind(this);
    this.afterOpenModal = this.afterOpenModal.bind(this);
    this.closeModal = this.closeModal.bind(this);

  }

  _setJsonContent(xmlText, str, title) {
    var obj;
    to_json(xmlText, function(error, data) {
      obj = data;
    });
    var json_str = JSON.stringify(obj, null, " ");
    const regex = /.+:/gm;
    const reg2 = /^\s*[{}]/gm;
    const reg3 = /^\s*\/\/.*/gm;
    const reg4 = /[",]/gm;
    const reg5 = /^\s*\n/gm;
    var json_repl = json_str
      .replace(regex, ' ')
      .replace(reg2, '')
      .replace(reg3, '')
      .replace(reg4, '')
      .replace(reg5, '');
    this.setState({
      modalLoading: false,
      modalIsOpen: true,
      content: json_repl,
      contentHtml: null,
      title: title,
      telegramClass: getTelegramClass(str),
      telegramUrl: str,
    });
  }

  openModal(str, title){
    // ここがキモ
    //
    var replaced_url;

    this.setState({ modalLoading: true });

    // replaced_url = str.replace(/https?:\/\/www\.data\.jma\.go\.jp\/developer\/xml/, 'https://nt2.nt55.net/jmadata_xml');
    replaced_url = str.replace(/https?:\/\/www\.data\.jma\.go\.jp\/developer\/xml/, 'https://tenki.nt55.net/jmadata_xml');
    console.log("*** openModal *** : going to fetch url=" + str + ' -- ' + replaced_url);

    fetch(replaced_url)
      .then( res => res.text())
      .then(
        (result) => {
            console.log("openModal: fetch OK");
            // xml-stylesheet PI からローカル XSL ファイルを探す。
            // PI がない場合は電文コードからマッピングする。
            const piMatch = result.match(/<\?xml-stylesheet[^?]*href="([^"]+)"[^?]*\?>/);
            const xslFilename = piMatch
              ? piMatch[1].split('/').pop()
              : getXslForUrl(str);
            if (xslFilename) {
              const localXslUrl = '/xsl/' + xslFilename;
              fetch(localXslUrl)
                .then(xslRes => {
                  if (!xslRes.ok) throw new Error('XSL not found: ' + xslFilename);
                  return xslRes.text();
                })
                .then(xslText => {
                  const parser = new DOMParser();
                  const xmlDoc = parser.parseFromString(result, 'application/xml');
                  const xslDoc = parser.parseFromString(xslText, 'application/xml');
                  const xsltProcessor = new XSLTProcessor();
                  xsltProcessor.importStylesheet(xslDoc);
                  const resultFrag = xsltProcessor.transformToFragment(xmlDoc, document);
                  const div = document.createElement('div');
                  div.appendChild(resultFrag);
                  this.setState({
                    modalLoading: false,
                    modalIsOpen: true,
                    content: null,
                    contentHtml: div.innerHTML,
                    title: title,
                    telegramClass: getTelegramClass(str),
                    telegramUrl: str,
                  });
                })
                .catch(() => {
                  this._setJsonContent(result, str, title);
                });
            } else {
              this._setJsonContent(result, str, title);
            }
        },
        (error) => {
            console.log("openModal: fetch NG");
            this.setState({ modalLoading: false });
        }
      );
  }


  afterOpenModal(){
  }
  closeModal(){
    this.setState({modalIsOpen: false});
  }


  componentDidMount(){
    this._readData();
    Modal.setAppElement( document.getElementById('AppId'));
  }

  _urlHandler(url, func){
    //var fullUrl = "https://tenki.nt55.net/feed/" + url + ".xml";
    var fullUrl = "/feed/" + url + ".xml";
    console.log("urlHandler="+fullUrl);
    this.setState({
      url: fullUrl,
      message: 'Updating...',
    }, function(){
      console.log('callback here')
      // readData();
      func();
    });
  }

  render(){
    var queryStr;
    queryStr = '?telegram=' + this.state.filter['telegram'];
    queryStr = queryStr + '&date=' + this.state.filter['date'];
    queryStr = queryStr + '&kansho=' + this.state.filter['kansho'];

    console.log("App:render ... queryStr=" + queryStr);
    window.history.pushState('', '', queryStr);

    return (
      <div className="App" id="AppId">
        <header className="App-header">
          <h1 className="App-title">天気ログ</h1>
        </header>

        {this.state.modalLoading && (
          <div className="loadingOverlay" role="status" aria-live="polite" aria-label="読み込み中">
            <div className="loadingSpinner"></div>
            <span>読み込み中...</span>
          </div>
        )}

        <Modal
          isOpen={this.state.modalIsOpen}
          onRequestClose={this.closeModal}
          style={customStyles}
          contentLabel="telegramModal"
          >
          <div className="modalHeader">
            <button onClick={this.closeModal}>ｘ</button>
            <h3> {this.state.title} </h3>
            {/^https?:\/\//.test(this.state.telegramUrl) && (
              <div className="telegramUrl"><a href={this.state.telegramUrl} target="_blank" rel="noopener noreferrer">{this.state.telegramUrl.split('/').filter(Boolean).pop()}</a></div>
            )}
          </div>
          <div className="modalContentWrap">
            <div className={`modalContent ${this.state.telegramClass || ''}`}>
              {this.state.contentHtml
                ? <div dangerouslySetInnerHTML={{ __html: this.state.contentHtml }} />
                : <pre>{this.state.content}</pre>}
            </div>
          </div>
        </Modal>

<div className="tabBar">
  {[
    { url: 'regular', label: '定時' },
    { url: 'extra',   label: '随時' },
    { url: 'eqvol',   label: '地震火山' },
    { url: 'other',   label: 'その他' },
  ].map(({ url, label }) => {
    const activeTab = this.state.url.replace(/^\/feed\/(.+)\.xml$/, '$1');
    return (
      <button
        key={url}
        className={`tabBtn${activeTab === url ? ' tabBtn-active' : ''}`}
        onClick={() => { this.urlHandler(url, this.readData); }}
      >
        {label}
      </button>
    );
  })}
</div>

        <div> {this.state.message} </div>

        <ul>
          {
            (() => {
              let lastDate = null;
              return this.state.items.map((item) => {
                const fullDate = dateJST(item["updated"]);
                const dp = fullDate.split(' ')[0];
                const showDate = dp !== lastDate;
                if (showDate) lastDate = dp;
                return <MyList key={item["id"]} item={item} modal={this.openModal} showDate={showDate}/>;
              });
            })()
            }
        </ul>
        <div style={{ textAlign: 'left', fontSize: 'small', margin: '20px' }} >
	    気象庁が公開している防災情報XMLをほとんど加工せずに公開しています
	    (nginx のリバースプロキシー)<br />
          <a href="http://xml.kishou.go.jp/xmlpull.html"> 気象庁防災情報XMLフォーマット形式電文の公開（PULL型）</a>
          </div>
        <div style={{ textAlign: 'left', fontSize: 'small', margin: '20px' }} >
          <a href="https://twitter.com/intent/tweet?screen_name=jQR1Fy33tKoWf1Q&hashtags=天気ログ" target="_blank" rel="noopener noreferrer" > 連絡先 </a>
        </div>
      </div>
    );
  }

  onChange( filter, value ){
    // filter: filter を変更/クリアする
    console.log("parent on change... filter=" + filter + " value=" + value);

    var newStateFilter;

    newStateFilter = { ...this.state.filter };
    newStateFilter[filter] = value;

    this.setState({
      filter: newStateFilter,
    });

  }

  async _readData() {
    console.log('reading data...' + this.state.url);
    fetch( this.state.url )
      .then( res => res.text())
      .then(
        (result) => {

        var obj;
          to_json(result, function (error, data) {
          obj = data;
        });

        var entry = obj.feed.entry;
        //var array = Object.keys(entry).map(function (key) { return entry[key] });
        var array = Object.keys(entry).slice(0,100).map(function (key) { return entry[key] });

        // ---------------------------
        this.setState({
          isLoaded: true,
          error: 'read log: NO-ERROR',
          items: array.slice(0, 100),
          message: '', // 読み込み成功: メッセージをクリア
        });
    })
    // .then(success, error) ではなく .catch() を使う。
    // .then の第2引数はネットワークエラーのみをキャッチし、
    // 直前の成功ハンドラ内でスローされた例外（XMLパース失敗など）は
    // キャッチできない。.catch() を使うことで、成功ハンドラ内の
    // 例外も含めてすべてのエラーを捕捉し、「Updating...」が
    // 表示されたままにならないようにする。
    .catch((error) => {
      console.log('readData error... url=' + this.state.url);
      this.setState({
        isLoaded: false,
        error: 'NG',
        message: '', // エラー時もメッセージをクリアして「Updating...」のままにならないようにする
      });
    });

    return null;
  }
}

export default App;
