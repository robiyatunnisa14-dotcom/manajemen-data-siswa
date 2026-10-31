const Siswa = require('../models/siswaModel');

const WAJIB = ['nipd', 'nama_lengkap', 'jenis_kelamin', 'kelas', 'jurusan'];

const cekFieldKosong = (body) => WAJIB.filter((f) => !body[f]);

const handleError = (res, err) => {
  if (err.code === 'ER_DUP_ENTRY') {
    return res.status(409).json({ success: false, message: 'NIPD sudah terdaftar' });
  }
  console.error(err);
  return res.status(500).json({ success: false, message: 'Terjadi kesalahan pada server' });
};

exports.getAllSiswa = async (req, res) => {
  try {
    const data = await Siswa.getAll();
    res.json({ success: true, message: 'Data siswa berhasil diambil', data });
  } catch (err) {
    handleError(res, err);
  }
};

exports.getSiswaById = async (req, res) => {
  try {
    const data = await Siswa.getById(req.params.id);
    if (!data) {
      return res.status(404).json({ success: false, message: 'Siswa tidak ditemukan' });
    }
    res.json({ success: true, message: 'Data siswa berhasil diambil', data });
  } catch (err) {
    handleError(res, err);
  }
};

exports.createSiswa = async (req, res) => {
  try {
    const kosong = cekFieldKosong(req.body);
    if (kosong.length > 0) {
      return res
        .status(400)
        .json({ success: false, message: `Field wajib diisi: ${kosong.join(', ')}` });
    }
    const id = await Siswa.create(req.body);
    const data = await Siswa.getById(id);
    res.status(201).json({ success: true, message: 'Siswa berhasil ditambahkan', data });
  } catch (err) {
    handleError(res, err);
  }
};

exports.updateSiswa = async (req, res) => {
  try {
    const kosong = cekFieldKosong(req.body);
    if (kosong.length > 0) {
      return res
        .status(400)
        .json({ success: false, message: `Field wajib diisi: ${kosong.join(', ')}` });
    }
    const terubah = await Siswa.update(req.params.id, req.body);
    if (terubah === 0) {
      return res.status(404).json({ success: false, message: 'Siswa tidak ditemukan' });
    }
    const data = await Siswa.getById(req.params.id);
    res.json({ success: true, message: 'Data siswa berhasil diubah', data });
  } catch (err) {
    handleError(res, err);
  }
};

exports.deleteSiswa = async (req, res) => {
  try {
    const terhapus = await Siswa.remove(req.params.id);
    if (terhapus === 0) {
      return res.status(404).json({ success: false, message: 'Siswa tidak ditemukan' });
    }
    res.json({ success: true, message: 'Siswa berhasil dihapus' });
  } catch (err) {
    handleError(res, err);
  }
};