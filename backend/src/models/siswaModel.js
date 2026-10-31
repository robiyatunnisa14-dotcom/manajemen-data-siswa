const db = require('../config/db');

const getAll = async () => {
  const [rows] = await db.query('SELECT * FROM siswa ORDER BY id');
  return rows;
};

const getById = async (id) => {
  const [rows] = await db.query('SELECT * FROM siswa WHERE id = ?', [id]);
  return rows[0];
};

const create = async (d) => {
  const [result] = await db.query(
    `INSERT INTO siswa (nipd, nama_lengkap, jenis_kelamin, alamat, kelas, jurusan)
     VALUES (?, ?, ?, ?, ?, ?)`,
    [d.nipd, d.nama_lengkap, d.jenis_kelamin, d.alamat, d.kelas, d.jurusan]
  );
  return result.insertId;
};

const update = async (id, d) => {
  const [result] = await db.query(
    `UPDATE siswa
     SET nipd = ?, nama_lengkap = ?, jenis_kelamin = ?, alamat = ?, kelas = ?, jurusan = ?
     WHERE id = ?`,
    [d.nipd, d.nama_lengkap, d.jenis_kelamin, d.alamat, d.kelas, d.jurusan, id]
  );
  return result.affectedRows;
};

const remove = async (id) => {
  const [result] = await db.query('DELETE FROM siswa WHERE id = ?', [id]);
  return result.affectedRows;
};

module.exports = { getAll, getById, create, update, remove };