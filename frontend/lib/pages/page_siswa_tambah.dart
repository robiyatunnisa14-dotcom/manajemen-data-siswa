import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/main.dart'; // untuk baseUrl

class PageSiswaTambah extends StatefulWidget {
  const PageSiswaTambah({super.key});

  @override
  State<PageSiswaTambah> createState() => _PageSiswaTambahState();
}

class _PageSiswaTambahState extends State<PageSiswaTambah> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nipd;
  late final TextEditingController _nama;
  late final TextEditingController _alamat;
  late final TextEditingController _kelas;
  late final TextEditingController _jurusan;

  String? _jk; // jenis kelamin
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nipd = TextEditingController();
    _nama = TextEditingController();
    _alamat = TextEditingController();
    _kelas = TextEditingController();
    _jurusan = TextEditingController();
  }

  @override
  void dispose() {
    _nipd.dispose();
    _nama.dispose();
    _alamat.dispose();
    _kelas.dispose();
    _jurusan.dispose();
    super.dispose();
  }

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

  // Gaya kotak input
  InputDecoration _dekorasi(String label, IconData ikon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(ikon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF6B8CCE), width: 2),
      ),
    );
  }

  String? _wajib(String? v, String label) =>
      (v == null || v.trim().isEmpty) ? '$label wajib diisi' : null;

  // ---------- SIMPAN (dengan konfirmasi) ----------
  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    final ya = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        icon: const CircleAvatar(
          radius: 30,
          backgroundColor: Color(0xFFE6ECF9),
          child: Icon(Icons.save_outlined, size: 32, color: Color(0xFF6B8CCE)),
        ),
        title: const Text('Tambah Siswa', textAlign: TextAlign.center),
        content: Text(
          'Tambahkan "${_nama.text.trim()}" ke data siswa?',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF6B8CCE)),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Ya, Simpan'),
          ),
        ],
      ),
    );
    if (ya != true) return;

    final body = jsonEncode({
      'nipd': _nipd.text.trim(),
      'nama_lengkap': _nama.text.trim(),
      'jenis_kelamin': _jk,
      'alamat': _alamat.text.trim(),
      'kelas': _kelas.text.trim(),
      'jurusan': _jurusan.text.trim(),
    });
    const headers = {'Content-Type': 'application/json'};

    setState(() => _loading = true);
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/siswa'),
        headers: headers,
        body: body,
      )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(res.body);
      if (!mounted) return;

      if ((res.statusCode == 200 || res.statusCode == 201) &&
          data['status'] == true) {
        _pesan(data['message'] ?? 'Data siswa berhasil ditambahkan');
        Navigator.pop(context, true); // kembali ke list, list akan dimuat ulang
      } else {
        _pesan(data['message'] ?? 'Gagal menyimpan data siswa', error: true);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text(
          'Tambah Siswa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF6B8CCE),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // ---------- NIPD ----------
                  TextFormField(
                    controller: _nipd,
                    keyboardType: TextInputType.number,
                    decoration: _dekorasi('NIPD', Icons.badge_outlined),
                    validator: (v) {
                      final e = _wajib(v, 'NIPD');
                      if (e != null) return e;
                      if (!RegExp(r'^\d+$').hasMatch(v!.trim())) {
                        return 'NIPD hanya boleh angka';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // ---------- NAMA ----------
                  TextFormField(
                    controller: _nama,
                    textCapitalization: TextCapitalization.words,
                    decoration:
                        _dekorasi('Nama Lengkap', Icons.person_outline),
                    validator: (v) {
                      final e = _wajib(v, 'Nama');
                      if (e != null) return e;
                      if (!RegExp(r"^[a-zA-Z\s.'-]+$").hasMatch(v!.trim())) {
                        return 'Nama hanya boleh berisi huruf';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // ---------- JENIS KELAMIN ----------
                  DropdownButtonFormField<String>(
                    value: _jk,
                    decoration: _dekorasi('Jenis Kelamin', Icons.wc_outlined),
                    items: const [
                      DropdownMenuItem(
                          value: 'L', child: Text('Laki-laki')),
                      DropdownMenuItem(
                          value: 'P', child: Text('Perempuan')),
                    ],
                    onChanged: (v) => setState(() => _jk = v),
                    validator: (v) =>
                        v == null ? 'Jenis kelamin wajib dipilih' : null,
                  ),
                  const SizedBox(height: 16),

                  // ---------- ALAMAT ----------
                  TextFormField(
                    controller: _alamat,
                    maxLines: 3,
                    decoration: _dekorasi('Alamat', Icons.home_outlined),
                    validator: (v) => _wajib(v, 'Alamat'),
                  ),
                  const SizedBox(height: 16),

                  // ---------- KELAS & JURUSAN ----------
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _kelas,
                          decoration: _dekorasi('Kelas', Icons.class_outlined),
                          validator: (v) => _wajib(v, 'Kelas'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _jurusan,
                          decoration:
                              _dekorasi('Jurusan', Icons.menu_book_outlined),
                          validator: (v) => _wajib(v, 'Jurusan'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // ---------- TOMBOL SIMPAN ----------
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF6B8CCE),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _loading ? null : _simpan,
                      icon: _loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2.5, color: Colors.white),
                            )
                          : const Icon(Icons.save_rounded),
                      label: const Text(
                        'Simpan',
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}