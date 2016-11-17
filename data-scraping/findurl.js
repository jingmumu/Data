/*
  直接爬取并出现错误
*/
//用mongodb实现并行爬取
//
//

var request = require('request');
var fs = require('fs');
var path = require('path');
var cheerio = require('cheerio');

var urlBase = 'http://www.imdb.com';
var urlXiaoqu = urlBase + '/chart/top?ref_=nv_mv_250_6';

/*request.get(urlXiaoqu, function(e, res, body) {
  if (!e && res.statusCode == 200) {
    var $ = cheerio.load(body);
    var urls = findALLURL($);
    console.log(urls);
    //urls = genURLs(urls);
    var file = fs.createWriteStream('allurl.js');
    file.on('error', function(err) { console.log("Error when output to file!"); // error handling  });
    file.write('module.exports = [');
    urls.forEach(function(v) { file.write('\''+v +'\','+ '\n'); });
    file.write('];');
    file.end();
  }
});*/

function findALLURL($){
  var hrefs = [];
  var url;
  $('.lister-list').find('.titleColumn a').each(function(i, node){
    url = $(node).attr('href');
    //console.log(urlBase+url);
    //url = path.join(urlBase, url);
    url= urlBase+url;
    hrefs.push(url);
  });
  //hrefs = filterUrl(hrefs);
  return hrefs;
}


function filterUrl(arr){
  var newArr = [];
  for(var i = 0; i < arr.length; i++){
    var url = arr[i];
    if(!url || url.indexOf('xiaoqu') === -1) continue;
    newArr.push(url);
  }
  return newArr;
}

function genURLs(arr){
  var newArr = [];
  var url, newUrl;
  for(var i = 0; i <= arr.length; i ++){
    url = arr[i];
    if(!url) continue;
    for(var j = 0; j < 101; j ++){
      newUrl = path.join(url, 'd' +  j);
      newArr.push(newUrl);
    }
  }
  return newArr;
}

module.exports = function(cb) {
  request.get(urlXiaoqu, function(e, res, body) {
    if (!e && res.statusCode == 200) {
      var $ = cheerio.load(body);
      var urls = findALLURL($);
      //urls = genURLs(urls);
      cb(urls);
    }
  });
};
