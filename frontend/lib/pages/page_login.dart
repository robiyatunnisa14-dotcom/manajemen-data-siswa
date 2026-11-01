import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/main.dart'; // untuk baseUrl
import 'package:frontend/pages/page_dashboard.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({super.key});
  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _sembunyi = true; // true = password tertutup, false = terlihat
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  // Pesan kecil di bawah layar: hijau = berhasil, merah = gagal
  void _pesan(String teks, {bool error = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor:
            error ? const Color(0xFFD96C6C) : const Color(0xFF5DAE8B),
        content: Text(teks),
      ));
  }

  // Gaya kotak input (dipakai email dan password)
  InputDecoration _dekorasi(String label, IconData ikon, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(ikon),
      suffixIcon: suffix,
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

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': _email.text.trim(),
              'password': _password.text,
            }),
          )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(res.body);
      if (!mounted) return;

      if (res.statusCode == 200 && data['status'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PageDashboard(nama: '${data['user']['nama']}'),
          ),
        );
      } else {
        _pesan(data['message'] ?? 'Login gagal', error: true);
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // gradasi pastel: biru lembut, lavender, rose muda
          gradient: LinearGradient(
            colors: [Color(0xFF8FA6E0), Color(0xFFB4A5E2), Color(0xFFF2B8C6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.school_rounded,
                          size: 44, color: Color(0xFF6B8CCE)),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Data Siswa',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Masuk untuk melanjutkan',
                      style: TextStyle(color: Colors.white.withAlpha(230)),
                    ),
                    const SizedBox(height: 28),
                    Card(
                      elevation: 4,
                      shadowColor: Colors.black26,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // ---------- EMAIL ----------
                              TextFormField(
                                controller: _email,
                                keyboardType: TextInputType.emailAddress,
                                decoration:
                                    _dekorasi('Email', Icons.email_outlined),
                                validator: (v) {
                                  final t = (v ?? '').trim();
                                  if (t.isEmpty) return 'Email wajib diisi';
                                  if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                                      .hasMatch(t)) {
                                    return 'Format email tidak valid';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // ---------- PASSWORD + ICON MATA ----------
                              TextFormField(
                                controller: _password,
                                obscureText: _sembunyi,
                                onFieldSubmitted: (_) => _login(),
                                decoration: _dekorasi(
                                  'Password',
                                  Icons.lock_outline,
                                  suffix: IconButton(
                                    // mata tercoret = tertutup, mata biasa = terlihat
                                    icon: Icon(
                                      _sembunyi
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() => _sembunyi = !_sembunyi);
                                    },
                                  ),
                                ),
                                validator: (v) => (v == null || v.isEmpty)
                                    ? 'Password wajib diisi'
                                    : null,
                              ),
                              const SizedBox(height: 24),

                              // ---------- TOMBOL MASUK ----------
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: const Color(0xFF6B8CCE),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14)),
                                  ),
                                  onPressed: _loading ? null : _login,
                                  child: _loading
                                      ? const SizedBox(
                                          height: 22,
                                          width: 22,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              color: Colors.white),
                                        )
                                      : const Text(
                                          'Masuk',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
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