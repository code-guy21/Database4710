var mysql = require('mysql');
var express = require('express')
var fs = require('fs');
var url = require('url');
var path = require("path");
var bodyParser = require('body-parser');

var router = express.Router();
var app = express()
var port = 8080;


app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json());

app.use(express.static(__dirname + "/public"));
app.engine('html',require('ejs').renderFile);
app.set('views',__dirname+'/views');
app.set('view engine','ejs');

var connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'UCF2017-',
  database: 'university'
});

connection.connect(function(error){
  if(!!error){
    console.log('Error');
  }
  else{
    console.log('Connected');
  }

});

app.get('/',function(req,res){
  res.sendFile(path.join(__dirname, '/views/Main.html'));
});

app.get('/login', function(req, res) {
    res.sendFile(path.join(__dirname, '/views/Login.html'));
});

app.get('/about', function(req, res) {
    res.sendFile(path.join(__dirname, '/views/AboutUs.html'));
});

app.get('/register', function(req, res) {
    res.sendFile(path.join(__dirname, '/views/Register.html'));
});

app.get('/admin', function(req, res) {
    res.sendFile(path.join(__dirname, '/views/AdminRegister.html'));
});

app.get('/home', function(req, res) {
    res.sendFile(path.join(__dirname, '/views/Home.html'));
});

app.get('/lookup', function(req, res) {
    res.sendFile(path.join(__dirname, '/views/EventLookup.html'));
});

app.get('/addevent', function(req, res) {
    res.sendFile(path.join(__dirname, '/views/AddEvent.html'));
});

app.get('/rsorequest', function(req, res) {
    res.sendFile(path.join(__dirname, '/views/MakeRSORequest.html'));
});

app.get('/eventinfo', function(req, res) {
    res.sendFile(path.join(__dirname, '/views/EventInfo.html'));
});

app.post('/home', function(req, res) {

    var uname = req.body.uname;
    var password = req.body.password;

    connection.query("SELECT s_password FROM student WHERE s_username=?",uname, function(error,value){
    if(error){
      console.log('Error in the query');
    }
    if(value.length > 0){
        if(value[0].s_password == password){

          res.redirect('/home');
          console.log('Login Successful');
          console.log(value[0].s_password);
          //res.write(value[0].s_password);
        }
        else{
          console.log('Login was not successful');
          res.redirect('/login');
        }
    }
    else{
      console.log('Login was not successful');
      res.redirect('/login');
    }
  });

});

app.post('/lookup', function(req, res) {

    var cname = req.body.coorname;

    connection.query("SELECT e_name FROM event WHERE e_name=?",cname, function(error,value){
    if(error){
      console.log('Error in the query');
    }
    if(value.length > 0){
        
    }
  });

});


app.post('/addevent', function(req, res) {

    res.sendFile(path.join(__dirname, '/views/Home.html'));

    var title = req.body.EventTitle;
    var descrip = req.body.EventDiscrp;
    var dstart = req.body.EventDateStart;
    var tstart = req.body.EventTimeStart;
    var date = req.body.EventDateEnd;
    var end = req.body.EventTimeEnd;
    var cname = req.body.EventCoorName;
    var cemail = req.body.EventCoorEmail;
    var cphone = req.body.EventCoorPhone;

    var submission = {
      e_title: title,
      e_description: descrip,
      e_startdate: dstart,
      e_starttime: tstart,
      e_enddate: date,
      e_endtime: end,
      e_name: cname,
      e_email: cemail,
      e_phone: cphone,
      u_id: 1,
      s_id: 6,
    };

    var query = connection.query('insert into event set ?', submission, function (err, result) {
      if (err) {
        console.error(err);
        return;
      }
      console.error(result);
    });
});

app.post('/', function(req, res) {

    res.sendFile(path.join(__dirname, '/views/Login.html'));

    var fname = req.body.fname;
    var lname = req.body.lname;
    var uname = req.body.uname;
    var password = req.body.password;
    var email = req.body.email;

    var submission = {
      s_firstname: fname,
      s_lastname: lname,
      s_username: uname,
      s_password: password,
      s_email: email,
      u_id: 1,
    };

    var query = connection.query('insert into student set ?', submission, function (err, result) {
      if (err) {
        console.error(err);
        return;
      }
      console.error(result);
    });
});

app.listen(port,function(){
  console.log('Server is listening at http://localhost:8080');
})
