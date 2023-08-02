const mysql = require("mysql");
const connection = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "password",
  database: "app",
});

connection.connect((err) => {
  if (err) {
    console.error("error connecting: " + err.stack);
    return;
  }
  // console.log("connected as id " + connection.threadId);

  // const username = "bob";
  // const password = "world";
  // connection.query(
  //   "INSERT INTO users (username, password) VALUES (?, ?)",
  //   [username, password],
  //   (err, results) => {
  //     if (err) {
  //       console.error("error: " + err.stack);
  //       return;
  //     }
  //     console.log("insert " + results.affectedRows + " rows");
  //   }
  // );
  connection.query("SELECT * FROM users", (err, results) => {
    if (err) {
      console.error("error: " + err.stack);
      return;
    }
    callback(results);
  });

  // connection.end((err) => {
  //   if (err) {
  //     console.error("error connecting: " + err.stack);
  //     return;
  //   }
  //   console.log("Finished");
  // });
});
