import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/main.dart'; // untuk baseUrl

class PageSiswaHapus extends StatefulWidget {
  final Map<String, dynamic> siswa; // data siswa yang akan dihapus
  const PageSiswaHapus({super.key, required this.siswa});

  @override
  State<PageSiswaHapus> createState() => _PageSiswaHapusState();
}

class _PageSiswaHapusState extends State<PageSiswaHapus> {
  bool _loading = false;

  // Pesan kecil di bawah layar: hijau = berhasil, merah = gagal
  void _pesan(String teks, {bool error = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: error ? Color(0xFFD96C6C) : Color(0xFF5DAE8B),
        content: Text(teks),
      ));
  }

  // ---------- HAPUS ----------
  Future<void> _hapus() async {
    setState(() => _loading = true);
    try {
      final res = await http
          .delete(Uri.parse('$baseUrl/siswa/${widget.siswa['id']}'))
          .timeout(const Duration(seconds: 10));
      final data = jsonDecode(res.body);
      if (!mounted) return;

      if (res.statusCode == 200 && data['status'] == true) {
        _pesan(data['message'] ?? 'Data siswa berhasil dihapus');
        Navigator.pop(context, true); // kembali ke list, list akan dimuat ulang
      } else {
        _pesan(data['message'] ?? 'Gagal menghapus siswa', error: true);
      }
    } catch (e) {
      if (mounted) {
        _pesan(
          'Tidak dapat terhubung ke server. Pastikan backend menyala dan alamat benar.',
          error: true,
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // Satu baris keterangan (ikon, judul kecil, isi)
  Widget _baris(IconData ikon, String label, String nilai) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(ikon, size: 20, color: Colors.grey.shade500),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                const SizedBox(height: 2),
                Text(nilai,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.siswa;
    final nama = '${s['nama_lengkap']}';

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Hapus Siswa',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFFE07A7A),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // ---------- PERINGATAN ----------
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBE4E4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          color: Color(0xFFE07A7A), size: 32),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Data yang dihapus tidak dapat dikembalikan. Pastikan data di bawah ini memang yang ingin dihapus.',
                          style: TextStyle(color: Color(0xFF9B4A4A)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ---------- DETAIL SISWA ----------
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 34,
                          backgroundColor: const Color(0xFFFBE4E4),
                          child: Text(
                            nama.isNotEmpty ? nama[0].toUpperCase() : '?',
                            style: const TextStyle(
                                color: Color(0xFFE07A7A),
                                fontSize: 28,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(nama,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const Divider(height: 28),
                        _baris(Icons.badge_outlined, 'NIPD', '${s['nipd']}'),
                        _baris(Icons.wc_outlined, 'Jenis Kelamin',
                            (s['jenis_kelamin'] == 'L' ? 'Laki-laki' : 'Perempuan')),
                        _baris(Icons.class_outlined, 'Kelas', '${s['kelas']}'),
                        _baris(Icons.menu_book_outlined, 'Jurusan',
                            '${s['jurusan']}'),
                        _baris(Icons.home_outlined, 'Alamat', '${s['alamat']}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ---------- TOMBOL ----------
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed:
                              _loading ? null : () => Navigator.pop(context, false),
                          child: const Text('Batal'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: Color(0xFFE07A7A),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: _loading ? null : _hapus,
                          icon: _loading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.5, color: Colors.white),
                                )
                              : const Icon(Icons.delete_outline_rounded),
                          label: const Text('Ya, Hapus',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}