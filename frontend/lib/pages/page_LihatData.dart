
import 'package:flutter/material.dart';
import 'page_DetailSiswa.dart';

class PageLihatData extends StatelessWidget {
  final String token;

  const PageLihatData({
    super.key,
    required this.token,
  });

  // DATA SEMENTARA
  // Nanti diganti dengan data dari API temanmu.
  final List<Map<String, dynamic>> siswa = const [
    {
      'id': 1,
      'nipd': '2026001',
      'nama_lengkap': 'Robiyatun Nisa',
      'jenis_kelamin': 'Perempuan',
      'alamat': 'Bawang, Banjarnegara',
      'kelas': 'XI RPL 1',
      'jurusan': 'Rekayasa Perangkat Lunak',
    },
    {
      'id': 2,
      'nipd': '2026002',
      'nama_lengkap': 'Faza Musa Alaziz',
      'jenis_kelamin': 'Laki-laki',
      'alamat': 'Banjarnegara',
      'kelas': 'XI RPL 1',
      'jurusan': 'Rekayasa Perangkat Lunak',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        title: const Text('Data Siswa'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: siswa.length,
        itemBuilder: (context, index) {
          final data = siswa[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                data['nama_lengkap'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text('NIPD: ${data['nipd']}'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PageDetailSiswa(
                      siswa: data,
                      token: token,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}