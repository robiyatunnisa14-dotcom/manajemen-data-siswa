const siswaModel = require('../models/siswaModel');

// VALIDASI DATA SISWA
function validasi(body) {
    const {
        nipd,
        nama_lengkap,
        jenis_kelamin,
        alamat,
        kelas,
        jurusan
    } = body;

    if (!nipd || !/^\d+$/.test(String(nipd).trim())) {
        return 'NIPD wajib diisi dan hanya boleh angka';
    }

    if (
        !nama_lengkap ||
        !/^[a-zA-Z\s.'-]+$/.test(String(nama_lengkap).trim())
    ) {
        return 'Nama lengkap wajib diisi dan hanya boleh menggunakan huruf';
    }

    if (!['L', 'P'].includes(jenis_kelamin)) {
        return 'Jenis kelamin harus L atau P';
    }

    if (!alamat || !String(alamat).trim()) {
        return 'Alamat wajib diisi';
    }

    if (!kelas || !String(kelas).trim()) {
        return 'Kelas wajib diisi';
    }

    if (!jurusan || !String(jurusan).trim()) {
        return 'Jurusan wajib diisi';
    }

    return null;
}

// MERAPIKAN DATA
function rapikan(b) {
    return {
        nipd: String(b.nipd).trim(),
        nama_lengkap: String(b.nama_lengkap).trim(),
        jenis_kelamin: b.jenis_kelamin,
        alamat: String(b.alamat).trim(),
        kelas: String(b.kelas).trim(),
        jurusan: String(b.jurusan).trim()
    };
}

// VALIDASI ID
function validasiId(id) {
    return /^\d+$/.test(String(id)) && Number(id) > 0;
}

// GET ALL
exports.getAll = async (req, res) => {
    try {
        const data = await siswaModel.getAll();

        res.status(200).json({
            status: true,
            message: 'Data siswa berhasil diambil',
            data
        });

    } catch (error) {
        console.error('ERROR GET ALL:', error);

        res.status(500).json({
            status: false,
            message: 'Gagal mengambil data siswa'
        });
    }
};

// GET BY ID
exports.getById = async (req, res) => {
    const id = req.params.id;

    if (!validasiId(id)) {
        return res.status(400).json({
            status: false,
            message: 'ID tidak valid'
        });
    }

    try {
        const siswa = await siswaModel.getById(id);

        if (!siswa) {
            return res.status(404).json({
                status: false,
                message: 'Siswa tidak ditemukan'
            });
        }

        res.status(200).json({
            status: true,
            data: siswa
        });

    } catch (error) {
        console.error('ERROR GET ID:', error);

        res.status(500).json({
            status: false,
            message: 'Gagal mengambil data siswa'
        });
    }
};

// POST 
exports.create = async (req, res) => {
    const errorValidasi = validasi(req.body);

    if (errorValidasi) {
        return res.status(400).json({
            status: false,
            message: errorValidasi
        });
    }

    const d = rapikan(req.body);

    try {
        const siswaAda = await siswaModel.getByNipd(d.nipd);

        if (siswaAda) {
            return res.status(400).json({
                status: false,
                message: 'NIPD sudah terdaftar'
            });
        }

        const id = await siswaModel.create(d);

        res.status(201).json({
            status: true,
            message: 'Data siswa berhasil ditambahkan',
            data: {
                id,
                ...d
            }
        });

    } catch (error) {
        console.error('ERROR POST:', error);

        if (error.code === 'ER_DUP_ENTRY') {
            return res.status(400).json({
                status: false,
                message: 'NIPD sudah terdaftar'
            });
        }

        res.status(500).json({
            status: false,
            message: 'Gagal menambahkan siswa'
        });
    }
};

// PUT 
exports.update = async (req, res) => {
    const id = req.params.id;

    if (!validasiId(id)) {
        return res.status(400).json({
            status: false,
            message: 'ID tidak valid'
        });
    }

    const errorValidasi = validasi(req.body);

    if (errorValidasi) {
        return res.status(400).json({
            status: false,
            message: errorValidasi
        });
    }

    const d = rapikan(req.body);

    try {
        const siswaAda = await siswaModel.getById(id);

        if (!siswaAda) {
            return res.status(404).json({
                status: false,
                message: 'Siswa tidak ditemukan'
            });
        }

        const nipdAda = await siswaModel.getByNipdLain(
            d.nipd,
            id
        );

        if (nipdAda) {
            return res.status(400).json({
                status: false,
                message: 'NIPD sudah dipakai siswa lain'
            });
        }

        await siswaModel.update(id, d);

        res.status(200).json({
            status: true,
            message: 'Data siswa berhasil diupdate',
            data: {
                id: Number(id),
                ...d
            }
        });

    } catch (error) {
        console.error('ERROR PUT:', error);

        if (error.code === 'ER_DUP_ENTRY') {
            return res.status(400).json({
                status: false,
                message: 'NIPD sudah dipakai siswa lain'
            });
        }

        res.status(500).json({
            status: false,
            message: 'Gagal mengupdate siswa'
        });
    }
};

// DELETE
exports.remove = async (req, res) => {
    const id = req.params.id;

    if (!validasiId(id)) {
        return res.status(400).json({
            status: false,
            message: 'ID tidak valid'
        });
    }

    try {
        const terhapus = await siswaModel.remove(id);

        if (terhapus === 0) {
            return res.status(404).json({
                status: false,
                message: 'Siswa tidak ditemukan'
            });
        }

        res.status(200).json({
            status: true,
            message: 'Data siswa berhasil dihapus'
        });

    } catch (error) {
        console.error('ERROR DELETE:', error);

        res.status(500).json({
            status: false,
            message: 'Gagal menghapus siswa'
        });
    }
};
