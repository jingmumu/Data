//request pool 爬取
//
//

var request = require('request');
var fs = require('fs');
//
var urls=require('./allurl.js');

var poolCount = urls.length;
var timeout = 100;

var parser = require('./server.parser');

function Pool(urls){
  this.urls = urls;
  this.reset();
  this.init();
}

//获取url的函数no use here
function getURL(title) {
  return encodeURI('http://www.imdb.com/title/' + title);
}

Pool.prototype = {
  reset: function(){
    this.spiderIndex = 0;
    this.queryingIndex = 0;
  },
  init: function(){
    this.querying = [];
  },
  process: function(e, res, body){
    if (!e && res.statusCode == 200) {
      parser(e, res, body);
    }
  },
  onProcessed: function(){
    this.queryingIndex--;
    setTimeout(function(){
      this.query();
    }.bind(this), timeout);
  },
  query: function(){
    if (this.queryingIndex > poolCount) return;
    var url = this.urls[this.spiderIndex];
    request.get(url, function(e, res, body){
      this.process(e, res, body);
    }.bind(this));
    this.spiderIndex = this.spiderIndex + 1;
    this.queryingIndex = this.queryingIndex + 1;
    if(this.queryingIndex < poolCount) this.query();
  }
};

module.exports = Pool;
