var mysql = require('mysql');

var connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'UCF2017-',
  database: 'articles'
});

connection.connect();

var article = {
  author: 'Alex Booker',
  title: 'Git tutorial',
  body: 'foo bar'
};

var article = {
  author: 'Miguel',
  title: 'Boss',
  body: 'What up boy!?'
};

var query = connection.query('insert into articles set ?', article, function (err, result) {
  if (err) {
    console.error(err);
    return;
  }
  console.error(result);
});
