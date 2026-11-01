const express = require('express');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const userModel = require('./models/userModel');
const siswaRoutes = require('./routes/siswaRoutes');

const app = express();

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
    res.json({ status: true, message: 'API berjalan' });
});

// LOGIN
app.post('/login', async (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({ status: false, message: 'Email dan password harus diisi' });
    }

    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
        return res.status(400).json({ status: false, message: 'Format email tidak valid' });
    }

    const pesanGagal = { status: false, message: 'Email atau password salah' };

    try {
        const user = await userModel.getByEmail(email);

        if (!user) {
            return res.status(401).json(pesanGagal);
        }

        const tersimpan = String(user.password);

        // Bisa password ter-hash (bcrypt) maupun teks biasa
        const cocok = tersimpan.startsWith('$2')
            ? await bcrypt.compare(password, tersimpan)
            : password === tersimpan;

        if (!cocok) {
            return res.status(401).json(pesanGagal);
        }

        res.status(200).json({
            status: true,
            message: 'Login berhasil',
            user: { id: user.id, nama: user.nama, email: user.email }
        });
    } catch (error) {
        console.error('ERROR LOGIN:', error);
        res.status(500).json({ status: false, message: 'Terjadi kesalahan pada server' });
    }
});

// CRUD SISWA
app.use('/siswa', siswaRoutes);

app.use((req, res) => {
    res.status(404).json({ status: false, message: 'Endpoint tidak ditemukan' });
});

module.exports = app;