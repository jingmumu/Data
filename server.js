/*
  直接爬取并出现错误
*/
//
//

var request = require('request');
var fs = require('fs');
var getURLs = require('./findurl');
var Pool = require('./server.pool');

getURLs(function(urls){
  new Pool(urls).query();
});
//
