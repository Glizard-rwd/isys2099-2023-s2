const mysql = require('mysql');
const fs = require('fs');
const { parse } = require('csv-parse');

// update below connection config to match your system
const conn = mysql.createConnection({
	host: 'localhost',
	user: 'root',
	password: 'password',
	database: 'citizen'
});

conn.connect(function(err) {
	if (err) {
		throw err;
	}
	console.log('Connected to DB!');

	// read and insert all cities
	fs.createReadStream('./cities.csv')
		.pipe(parse({ delimiter: ',', from_line: 2 }))
		.on('data', function (row) {
			conn.query("INSERT INTO cities(name, lat, lng, capital, population) VALUES(?, ?, ?, ?, ?)", [row[0], row[1], row[2], row[5], row[7]]);
		})
		.on('end', function () {
			console.log('Finished reading cities.csv and writing cities table');
		})
		.on('error', function (error) {
			console.log(error.message);
		});

	// read and create array of first and last names
	const first_names = fs.readFileSync('./first.csv').toString().split('\n');
	const first_name_max = first_names.length;
	console.log('Finished reading first.csv');
	
	const last_names = fs.readFileSync('./last.csv').toString().split('\n');
	const last_name_max = last_names.length;
	console.log('Finished reading last.csv');
	
	const localtion_max = 1035;
	
	const max_records = 100000;  // number of random records to create
	// you can decrease/increase this number as needed
	conn.beginTransaction((err) => {
		for (let i = 0; i < max_records; i++) {
			let fname = first_names[Math.floor(Math.random() * first_name_max)];
			let lname = last_names[Math.floor(Math.random() * last_name_max)];
		
			let year = 1920 + Math.floor(Math.random() * 100);  // 1920 to 2020
			let month = 1 + Math.floor(Math.random() * 12);  // 1 to 12
			let day = 1 + Math.floor(Math.random() * 31);  // 1 to 31
		
			// special cases
			if (month == 2 && day > 28) {
				day = 28;
			}
			if ([4, 6, 9, 11].includes(month) && day > 30) {
				day = 30;
			}
		
			let birth = `${year}-${month}-${day}`;
		
			let birth_location = 1 + Math.floor(Math.random() * localtion_max);
			let current_location = 1 + Math.floor(Math.random() * localtion_max);
	
			conn.query("INSERT INTO people(first_name, last_name, birth_date, birth_location, current_location) VALUES(?, ?, ?, ?, ?)", [fname, lname, birth, birth_location, current_location]);
		}
		conn.commit((err => {
			if (err) {
				conn.rollback();
			}
			console.log('Finished writing people table');
		}));
	});
});
