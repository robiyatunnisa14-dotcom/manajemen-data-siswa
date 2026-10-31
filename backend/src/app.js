const express = require('express');
const cors = require('cors');
const siswaRoutes = require('./routes/siswaRoutes');

const app = express();

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.json({ message: 'API Manajemen Data Siswa berjalan' });
});

app.use('/api/siswa', siswaRoutes);

app.use((req, res) => {
  res.status(404).json({ success: false, message: 'Route tidak ditemukan' });
});

module.exports = app;