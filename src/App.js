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
function dateJST(gmtStr){
    var str = gmtStr.replace(/\./g, ':');
    var jst = new Date(str);
    jst.setHours(jst.getHours() + 9);

    var jstStr = jst.toISOString();
    jstStr =  jstStr.replace(/\.000Z/, "");
    jstStr =  jstStr.replace(/^(20\d\d)-(\d\d)-(\d\d)\D+/, "$2/$3 ");
    jstStr =  jstStr.replace(/^0/, "");
    jstStr =  jstStr.replace(/\/0/, "/");
    return jstStr;
}
// ------------------------------------------------------

class Feed extends Component {
    constructor(props){
      super(props);

      if(this.props.handler !== undefined){
        this.clickHandler = this.props.handler.bind(this);
      } else {
        this.clickHandler = this._clickHandler.bind(this);
      }

      //
      if(this.props.update !== undefined){
        this.updateHandler = this.props.update.bind(this);
      } else {
        this.updateHandler = this._updateHandler.bind(this);
      }
    }

    _clickHandler(str, callback){
        console.log("clicked " + str);
    }
    _updateHandler(){
        console.log("_updateHandler...");
    }

    render(){
        return (
            <li onClick={()=>{this.clickHandler(this.props.url, this.updateHandler)}}
                style={{ color: '#66f', cursor: 'pointer'}}>
                {this.props.text} </li>
        );
    }
}

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
    return (
        <ul>
            <li key={this.props.item["id"]}>
	      <span class="datetime">
              {dateJST(this.props.item["updated"])}
	      </span>
              <span> </span>
              <span
	    	class="xmldata"
                style={{ color: '#66f', cursor: 'pointer'}}
                onClick={()=>{this.clickHandler(this.state.url, this.state.title, this.updateHandler)}} >
              {this.props.item["title"]}
              </span>
              <span> </span>
              {this.props.item["author"]["name"]}

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

  openModal(str, title){
    // ここがキモ
    //
    var replaced_url;

    // replaced_url = str.replace(/https?:\/\/www\.data\.jma\.go\.jp\/developer\/xml/, 'https://nt2.nt55.net/jmadata_xml');
    replaced_url = str.replace(/https?:\/\/www\.data\.jma\.go\.jp\/developer\/xml/, 'https://tenki.nt55.net/jmadata_xml');
    console.log("*** openModal *** : going to fetch url=" + str + ' -- ' + replaced_url);

    fetch(replaced_url)
      .then( res => res.text())
      .then(
        (result) => {
            console.log("openModal: fetch OK");
            var obj;
            to_json(result, function(error,data){
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
              modalIsOpen: true,
              content: json_repl,
              title: title,
              telegramClass: getTelegramClass(str),
              telegramUrl: str,
            });
        },
        (error) => {
            console.log("openModal: fetch NG");
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

        <Modal
          isOpen={this.state.modalIsOpen}
          onRequestClose={this.closeModal}
          style={customStyles}
          contentLabel="telegramModal"
          >
          <div className="modalHeader">
            <button onClick={this.closeModal}> 閉じる </button>
            <h3> {this.state.title} </h3>
            {/^https?:\/\//.test(this.state.telegramUrl) && (
              <div className="telegramUrl"><a href={this.state.telegramUrl} target="_blank" rel="noopener noreferrer">{this.state.telegramUrl.split('/').filter(Boolean).pop()}</a></div>
            )}
          </div>
          <div className="modalContentWrap">
            <div className={`modalContent ${this.state.telegramClass || ''}`}><pre>{this.state.content}</pre></div>
          </div>
        </Modal>

<div className="selectSpec" style={{ textAlign: 'left' }}>
<div className="selectSpecHF">
高頻度
<ul>
<Feed url="regular" text="定時" handler={this.urlHandler} update={this.readData}/>
<Feed url="extra" text="随時" handler={this.urlHandler} update={this.readData}/>
<Feed url="eqvol" text="地震火山" handler={this.urlHandler} update={this.readData}/>
<Feed url="other" text="その他" handler={this.urlHandler} update={this.readData}/>
</ul>
</div>

<div className="selectSpecLF">
長期
<ul>
<Feed url="regular_l" text="定時" handler={this.urlHandler} update={this.readData}/>
<Feed url="extra_l" text="随時" handler={this.urlHandler} update={this.readData}/>
<Feed url="eqvol_l" text="地震火山" handler={this.urlHandler} update={this.readData}/>
<Feed url="other_l" text="その他" handler={this.urlHandler} update={this.readData}/>
</ul>

</div>
</div>

        <div> {this.state.message} </div>

        <ul>
          {
            this.state.items.map((item) => (
            <MyList key={item["id"]} item={item} modal={this.openModal}/>
           ) )
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
