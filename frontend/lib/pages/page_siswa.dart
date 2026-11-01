import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/main.dart'; // untuk baseUrl
import 'package:frontend/pages/page_siswa_tambah.dart';
import 'package:frontend/pages/page_siswa_edit.dart';
import 'package:frontend/pages/page_siswa_hapus.dart';

class PageSiswa extends StatefulWidget {
  const PageSiswa({super.key});
  @override
  State<PageSiswa> createState() => _PageSiswaState();
}

class _PageSiswaState extends State<PageSiswa> {
  // Warna avatar bergantian supaya list tidak monoton
  static const _palet = [
    Color(0xFF6B8CCE), // biru lembut
    Color(0xFF9B86D0), // lavender
    Color(0xFF5DAE8B), // hijau mint
    Color(0xFFE3A07F), // peach
    Color(0xFFD97FA0), // rose
  ];

  List<Map<String, dynamic>> _semua = [];
  String _cari = '';
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _muat();
  }

  // ---------- AMBIL DATA ----------
  Future<void> _muat() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/siswa'))
          .timeout(const Duration(seconds: 10));
      final data = jsonDecode(res.body);

      if (res.statusCode == 200 && data['status'] == true) {
        if (mounted) {
          setState(() => _semua = List<Map<String, dynamic>>.from(data['data']));
        }
      } else {
        if (mounted) {
          setState(() => _error = data['message'] ?? 'Gagal mengambil data siswa');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error =
            'Tidak dapat terhubung ke server. Pastikan backend menyala dan alamat benar.');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // ---------- PINDAH KE HALAMAN TAMBAH / EDIT / HAPUS ----------
  // Kalau halaman tujuan menutup dengan hasil true, list dimuat ulang.
  Future<void> _tambah() async {
    final berhasil = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const PageSiswaTambah()),
    );
    if (berhasil == true) _muat();
  }

  Future<void> _edit(Map<String, dynamic> s) async {
    final berhasil = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => PageSiswaEdit(siswa: s)),
    );
    if (berhasil == true) _muat();
  }

  Future<void> _hapus(Map<String, dynamic> s) async {
    final berhasil = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => PageSiswaHapus(siswa: s)),
    );
    if (berhasil == true) _muat();
  }

  @override
  Widget build(BuildContext context) {
    final q = _cari.toLowerCase();
    final tampil = _semua.where((s) {
      return '${s['nama_lengkap']}'.toLowerCase().contains(q) ||
          '${s['nipd']}'.toLowerCase().contains(q) ||
          '${s['kelas']}'.toLowerCase().contains(q) ||
          '${s['jurusan']}'.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Data Siswa',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF6B8CCE),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tambah,
        backgroundColor: const Color(0xFF6B8CCE),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Siswa'),
      ),
      body: Column(
        children: [
          // ---------- KOLOM CARI ----------
          Container(
            color: const Color(0xFF6B8CCE),
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: TextField(
              onChanged: (v) => setState(() => _cari = v),
              decoration: InputDecoration(
                hintText: 'Cari nama, NIPD, kelas, jurusan...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(child: _isi(tampil)),
        ],
      ),
    );
  }

  // Isi halaman: loading, error, kosong, atau list
  Widget _isi(List<Map<String, dynamic>> tampil) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wifi_off_rounded, size: 56, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _muat,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (tampil.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_search_rounded,
                size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            Text(
              _semua.isEmpty ? 'Belum ada data siswa' : 'Data tidak ditemukan',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _muat,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        itemCount: tampil.length,
        itemBuilder: (_, i) {
          final s = tampil[i];
          final nama = '${s['nama_lengkap']}';
          final cowok = s['jenis_kelamin'] == 'L';
          final warna =
              cowok ? const Color(0xFF5E9BC9) : const Color(0xFFD97FA0);
          final av = _palet[i % _palet.length];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 6, 14),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: av.withAlpha(45),
                    child: Text(
                      nama.isNotEmpty ? nama[0].toUpperCase() : '?',
                      style: TextStyle(
                          color: av,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(nama,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text('NIPD: ${s['nipd']}',
                            style: TextStyle(color: Colors.grey.shade600)),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            _Chip('${s['kelas']}', const Color(0xFF6B8CCE)),
                            _Chip('${s['jurusan']}', const Color(0xFF9B86D0)),
                            _Chip(cowok ? 'Laki-laki' : 'Perempuan', warna),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                size: 15, color: Colors.grey.shade500),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${s['alamat']}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        tooltip: 'Edit',
                        icon: const Icon(Icons.edit_outlined,
                            color: Color(0xFF6B8CCE)),
                        onPressed: () => _edit(s),
                      ),
                      IconButton(
                        tooltip: 'Hapus',
                        icon: const Icon(Icons.delete_outline_rounded,
                            color: Color(0xFFE07A7A)),
                        onPressed: () => _hapus(s),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Label kecil berwarna (kelas, jurusan, jenis kelamin)
class _Chip extends StatelessWidget {
  final String teks;
  final Color warna;
  const _Chip(this.teks, this.warna);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: warna.withAlpha(28),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        teks,
        style:
            TextStyle(color: warna, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}