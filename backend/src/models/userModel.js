const db = require('../config/database');

exports.getByEmail = async (email) => {
    const [rows] = await db.promise().query(
        'SELECT * FROM user WHERE email = ?',
        [email]
    );
    return rows[0];
};