require('dotenv').config();
const app = require('./src/app');

const PORT = process.env.PORT || 3000;

// 0.0.0.0 supaya bisa diakses dari HP lewat WiFi yang sama
const server = app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server berjalan di http://localhost:${PORT}`);
});

server.on('error', (error) => {
    if (error.code === 'EADDRINUSE') {
        console.error(`Port ${PORT} sudah dipakai server lain (kemungkinan node lama yang belum dimatikan).`);
    } else {
        console.error('Server gagal jalan:', error);
    }
    process.exit(1);
});