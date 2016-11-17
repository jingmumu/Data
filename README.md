---
title: "Imdb Movie Scraping Project"
author: "Jing Hua"
date: "November 16,2016"
---


#Description
This project is based on Ningyi Zhou's spider project.
I expanded v9.js(pool,parser,urls) to scrape top rated imdb movies from imdb website.

Base URL is: http://www.imdb.com/chart/top?ref_=nv_mv_250_6
Then, I got all movie urls in this page's movie lists(totally 250).
With these 250 movie urls, I use Request Pool method to scrape movie data one by one.

At the same time, output movie data to a json file.

Finally, I got the output.json to store all top movie data, including movie title, movie release year, movie director, movies cast stars, duration time, budget, and gross.

#Files explanation
server.js: main js file  
server.pool.js: Request Pool to send request one by one  
server.parser.js: File used to scrape DOM information using useful selectors. Important thing is that I use regular expressions to process some informal texts.  

#Code samples
```
#get movie title and release year
$('.title_wrapper').filter(function(){
        var data = $(this);
            //title = data.children().first().text();
            title =  $('.title_wrapper h1').text().replace(/\(\d+\)/g,"").replace(/\s/g,"");    
            release = $('#titleYear').children().first().text();

            json.title = title;
            json.release = release;
    })
```

#Reference
Ningyi Zhou Git Hub [link][1]  
imdb website [link][2]
[1]: https://github.com/zhouningyi/full_stack_demos
[2]: http://www.imdb.com/chart/top?ref_=nv_mv_250_6


