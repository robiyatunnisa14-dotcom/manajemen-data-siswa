const db = require('../config/database');

exports.getAll = async () => {
    const [rows] = await db.promise().query('SELECT * FROM siswa ORDER BY nama_lengkap ASC');
    return rows;
};

exports.getById = async (id) => {
    const [rows] = await db.promise().query('SELECT * FROM siswa WHERE id = ?', [id]);
    return rows[0];
};

exports.getByNipd = async (nipd) => {
    const [rows] = await db.promise().query('SELECT id FROM siswa WHERE nipd = ?', [nipd]);
    return rows[0];
};

exports.getByNipdLain = async (nipd, id) => {
    const [rows] = await db.promise().query(
        'SELECT id FROM siswa WHERE nipd = ? AND id != ?',
        [nipd, id]
    );
    return rows[0];
};

exports.create = async (d) => {
    const [result] = await db.promise().query(
        'INSERT INTO siswa (nipd, nama_lengkap, jenis_kelamin, alamat, kelas, jurusan) VALUES (?, ?, ?, ?, ?, ?)',
        [d.nipd, d.nama_lengkap, d.jenis_kelamin, d.alamat, d.kelas, d.jurusan]
    );
    return result.insertId;
};

exports.update = async (id, d) => {
    await db.promise().query(
        'UPDATE siswa SET nipd = ?, nama_lengkap = ?, jenis_kelamin = ?, alamat = ?, kelas = ?, jurusan = ? WHERE id = ?',
        [d.nipd, d.nama_lengkap, d.jenis_kelamin, d.alamat, d.kelas, d.jurusan, id]
    );
};

exports.remove = async (id) => {
    const [result] = await db.promise().query('DELETE FROM siswa WHERE id = ?', [id]);
    return result.affectedRows;
};