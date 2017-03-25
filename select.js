var mysql = require('mysql');
var express = require('express')
var app = express()
var http = require('http');
var port = 1337;

var connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'UCF2017-',
  database: 'articles'
});

connection.connect(function(error){
  if(!!error){
    console.log('Error');
  }
  else{
    console.log('Connected');
  }

});


// website.com/articles?id=1
// website.com/articles?id=1; drop table articles;

var num = '1';

/*var query = connection.query('select * from articles where id = ' + id ,function(err, result) {
  console.log(result);
});*/

http.createServer(function(req,resp){

  resp.writeHead(200,{"Content-Type":"text/plain"});
  resp.write("Hello my name is ");

  connection.query("SELECT * FROM articles WHERE id=?",num, function(error,value){
    if(!!error){
      console.log('Error in the query');
    }
    else{
      console.log('Successful query');
      console.log(value[0]);
      resp.write(value[0].author);
      resp.end();
    }
  });

}).listen(port);

/*app.get('/', function(req,resp){
  resp.writeHead(200,{"Content-Type":"text/plain"});
  resp.write("Hello my name is ");

  connection.query("SELECT * FROM articles WHERE id=?",num, function(error,value){
    if(!!error){
      console.log('Error in the query');
    }
    else{
      console.log('Successful query');
      console.log(value[0]);
      resp.write(value[0].author);
      resp.end();
    }
  });

}).listen(port);*/
