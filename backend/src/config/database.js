require('dotenv').config();
const mysql = require('mysql2');

const db = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
});

db.getConnection((err, conn) => {
    if (err) {
        console.error('Database gagal terhubung:', err.message);
    } else {
        console.log('Database terhubung');
        conn.release();
    }
});

module.exports = db;