const mysql = require('mysql');
const express = require('express')
var fs = require('fs');
var app = express()
var port = 8080;

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

var num;

function renderHTML(path, response) {
    fs.readFile(path, null, function(error, data) {
        if (error) {
            response.writeHead(404);
            response.write('File not found!');
        } else {
            response.write(data);
        }
        response.end();
    });
}

app.get('/', function(req,resp){

  renderHTML('login.html', resp);
});

app.get('/index', function(req,resp){

  renderHTML('index.html', resp);
});

app.get('/miguel', function(req,resp){

    num = 5;

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
});

app.get('/alex', function(req,resp){

    num = 1;
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
});


app.listen(port,function(){
  console.log('Server is listening at http://localhost:8080');
})
