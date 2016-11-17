
var fs = require('fs');
var request = require('request');
var cheerio = require('cheerio');


var result=[];

function parser(e, res, body){
    var $ = cheerio.load(body);
    var title, release, rating, number_of_rating_users,director,star1,star2,star3,duration,budget,gross;
    var json = { title : "", release : "", rating : "",number_of_rating_users:"",director:"",star1:"",star2:"",star3:"",duration:"",budget:"",gross:""};

    $('.title_wrapper').filter(function(){
        var data = $(this);
            //title = data.children().first().text();
            title =  $('.title_wrapper h1').text().replace(/\(\d+\)/g,"").replace(/\s\s+/g,"");   
            release = $('#titleYear').children().first().text();

            json.title = title;
            json.release = release;
    })

    $('.ratingValue').filter(function(){
        var data = $(this);
        rating = data.children().first().text();
        number_of_rating_users=$('.imdbRating .small').text();

        json.rating = rating;
        json.number_of_rating_users=number_of_rating_users;

    })

    $('.plot_summary ').filter(function(){
        var data = $(this);
        director = data.children().first().next().children().first().next().text().replace(/\n/g,"").replace(/\s\s+/g,"");
        star1=data.children().first().next().next().next().children().first().next().children().first().text();
        star2=data.children().first().next().next().next().children().first().next().next().children().first().text();
        star3=data.children().first().next().next().next().children().first().next().next().next().children().first().text();
        json.director = director;
        json.star1=star1;
        json.star2=star2;
        json.star3=star3;

    })

    $('#titleDetails .txt-block').filter(function(){
        var data = $(this);
        subheading = data.children().first().text();
        if(subheading=="Budget:"){
            budget=data.text().replace("Budget: ","").replace("(estimated)","").replace(/\s/g,"").replace(/\n/g,"");
        }

        else if(subheading=="Gross:"){
            gross=data.text().replace("Gross: ","").replace(/\s/g,"").replace(/\(\w+\)/g,"").replace(/\n/g,"");
        }
        else if(subheading=="Runtime:"){
            duration=$('#titleDetails .txt-block time').text().replace(/\smin/g,"").replace(/\s/g,"").replace(/\n/g,"");
        }
        
        json.budget = budget;
        json.gross=gross;
        json.duration=duration;
    })
    
    result.push(json);
    save(result); 
}

function save(ds){
    fs.writeFile('output.json', JSON.stringify(ds, null, 4), function(err){

                console.log('File successfully written! - Check your project directory for the output.json file');

            })
    }

module.exports = parser;


