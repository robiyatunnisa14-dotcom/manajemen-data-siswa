
import 'package:flutter/material.dart';
import 'page_EditSiswa.dart';

class PageDetailSiswa extends StatelessWidget {
  final Map<String, dynamic> siswa;
  final String token;

  const PageDetailSiswa({
    super.key,
    required this.siswa,
    required this.token,
  });

  void konfirmasiHapus(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Data Siswa?'),
          content: Text(
            'Apakah kamu yakin ingin menghapus data ${siswa['nama_lengkap']}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Konfirmasi berhasil. API hapus belum dihubungkan.',
                    ),
                  ),
                );
              },
              child: const Text('Ya, Hapus'),
            ),
          ],
        );
      },
    );
  }

  Widget detailItem(String judul, dynamic isi, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue, size: 25),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isi?.toString() ?? '-',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        title: const Text('Detail Siswa'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 550),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.account_circle,
                      size: 75,
                      color: Colors.blue,
                    ),

                    const SizedBox(height: 12),

                    Text(
                      siswa['nama_lengkap']?.toString() ?? 'Nama Siswa',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Divider(height: 35),

                    detailItem(
                      'NIPD',
                      siswa['nipd'],
                      Icons.badge_outlined,
                    ),

                    detailItem(
                      'Jenis Kelamin',
                      siswa['jenis_kelamin'],
                      Icons.people_outline,
                    ),

                    detailItem(
                      'Alamat',
                      siswa['alamat'],
                      Icons.home_outlined,
                    ),

                    detailItem(
                      'Kelas',
                      siswa['kelas'],
                      Icons.school_outlined,
                    ),

                    detailItem(
                      'Jurusan',
                      siswa['jurusan'],
                      Icons.menu_book_outlined,
                    ),

                    const SizedBox(height: 15),

                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PageEditSiswa(
                              siswa: siswa,
                              token: token,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('EDIT DATA'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),

                    const SizedBox(height: 10),

                    ElevatedButton.icon(
                      onPressed: () {
                        konfirmasiHapus(context);
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text('HAPUS DATA'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}