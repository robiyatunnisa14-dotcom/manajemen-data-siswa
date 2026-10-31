import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aplikasi_guru/pages/page_dashboard.dart';

// WARNA
const _sage = Color(0xFF668B70);
const _darkGreen = Color(0xFF355641);
const _background = Color(0xFFF5F5EF);
const _peach = Color(0xFFF2D8C9);
const _mint = Color(0xFFDCE8D8);
const _grey = Color(0xFF858B83);

// DATA LOGIN (dipakai halaman lain, mis. untuk header Authorization)
class Session {
  static String? token;
  static int? id;
  static String? nama;
}

class PageLogin extends StatefulWidget {
  const PageLogin({super.key});

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  bool passwordVisible = false;
  bool isLoading = false;

  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  // Web / desktop: localhost | Emulator Android: 10.0.2.2 | HP asli: IP laptop
  String get baseUrl =>
      kIsWeb ? 'http://localhost:3000' : 'http://10.0.2.2:3000';

  // FUNGSI LOGIN API (POST /login)
  Future<void> prosesLogin() async {
    FocusScope.of(context).unfocus();

    if (txtEmail.text.trim().isEmpty || txtPassword.text.isEmpty) {
      tampilkanPesan('Email dan password wajib diisi.');
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': txtEmail.text.trim(),
              'password': txtPassword.text,
            }),
          )
          .timeout(const Duration(seconds: 10));

      // 401 (salah password) tetap berisi JSON { status: false, message }
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) throw const FormatException();
      final data = decoded;

      if (!mounted) return;

      if (data['status'] == true) {
        // simpan token & data user untuk halaman lain
        Session.token = data['token'];
        Session.id = data['user']['id'];
        Session.nama = data['user']['nama'];

        tampilkanPesan('Login berhasil!');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PageDashboard()),
        );
      } else {
        tampilkanPesan(data['message'] ?? 'Email atau password salah');
      }
    } on FormatException {
      tampilkanPesan('Respons API tidak valid.');
    } on TimeoutException {
      tampilkanPesan('Server tidak merespons. Coba lagi.');
    } on http.ClientException {
      tampilkanPesan('Tidak bisa terhubung ke server. Pastikan API sudah jalan.');
    } catch (e) {
      tampilkanPesan('Terjadi kesalahan: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // MENAMPILKAN PESAN
  void tampilkanPesan(String pesan) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(pesan)));
  }

  // STYLE INPUT (dipakai email & password)
  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: _sage),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFFAFAF7),
      contentPadding: const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE8EBE3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _sage, width: 1.5),
      ),
    );
  }

  Widget _dot(Color color) => Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );

  @override
  void dispose() {
    txtEmail.dispose();
    txtPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: _darkGreen.withValues(alpha: 0.07),
                    blurRadius: 25,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // IKON APLIKASI
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE4EEE3),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Icon(
                      Icons.school_outlined,
                      size: 42,
                      color: _sage,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // JUDUL
                  const Text(
                    'Selamat Datang!',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: _darkGreen,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Silakan login untuk melanjutkan',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: _grey),
                  ),

                  const SizedBox(height: 30),

                  // INPUT EMAIL
                  TextField(
                    controller: txtEmail,
                    enabled: !isLoading,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    decoration: _inputDecoration(
                      label: 'Email',
                      icon: Icons.email_outlined,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // INPUT PASSWORD
                  TextField(
                    controller: txtPassword,
                    enabled: !isLoading,
                    obscureText: !passwordVisible,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) {
                      if (!isLoading) prosesLogin();
                    },
                    decoration: _inputDecoration(
                      label: 'Password',
                      icon: Icons.lock_outline,
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: _sage,
                        ),
                        onPressed: isLoading
                            ? null
                            : () => setState(
                                  () => passwordVisible = !passwordVisible,
                                ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // TOMBOL LOGIN
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : prosesLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _sage,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: _sage.withValues(alpha: 0.6),
                        disabledForegroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'LOGIN',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // FOOTER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _dot(_peach),
                      const SizedBox(width: 8),
                      const Text(
                        'Aplikasi Guru',
                        style: TextStyle(color: _grey, fontSize: 13),
                      ),
                      const SizedBox(width: 8),
                      _dot(_mint),
                    ],
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