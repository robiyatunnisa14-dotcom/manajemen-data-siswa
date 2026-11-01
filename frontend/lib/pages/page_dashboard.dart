import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/pages/page_login.dart';
import 'package:frontend/pages/page_siswa.dart';

class PageDashboard extends StatelessWidget {
  final String nama;
  const PageDashboard({super.key, required this.nama});

  // Dialog konfirmasi keluar aplikasi
  Future<void> _keluar(BuildContext context) async {
    final ya = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        icon: const CircleAvatar(
          radius: 30,
          backgroundColor: Color(0xFFFBE4E4),
          child: Icon(Icons.logout_rounded, size: 32, color: Color(0xFFE07A7A)),
        ),
        title: const Text('Keluar Aplikasi', textAlign: TextAlign.center),
        content: Text(
          kIsWeb
              ? 'Anda akan keluar dan kembali ke halaman login. Lanjutkan?'
              : 'Apakah Anda yakin ingin keluar dari aplikasi?',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Color(0xFFE07A7A)),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Ya, Keluar'),
          ),
        ],
      ),
    );

    if (ya != true || !context.mounted) return;

    if (kIsWeb) {
      // Web: kembali ke halaman login
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const PageLogin()),
        (_) => false,
      );
    } else {
      // HP: tutup aplikasi (standar Android)
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // tombol back di HP juga memunculkan konfirmasi
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _keluar(context);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        body: Column(
          children: [
            // ---------- HEADER ----------
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                  24, MediaQuery.of(context).padding.top + 28, 24, 40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6B8CCE), Color(0xFF9B86D0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat datang 👋',
                    style: TextStyle(
                        color: Colors.white.withAlpha(220), fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    nama,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Dashboard Manajemen Data Siswa',
                    style: TextStyle(color: Colors.white.withAlpha(200)),
                  ),
                ],
              ),
            ),

            // ---------- MENU ----------
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      _MenuCard(
                        ikon: Icons.groups_rounded,
                        judul: 'Lihat Data Siswa',
                        deskripsi: 'Lihat, tambah, ubah, dan hapus data siswa',
                        warna: const Color(0xFF6B8CCE),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const PageSiswa()),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _MenuCard(
                        ikon: Icons.logout_rounded,
                        judul: 'Keluar Aplikasi',
                        deskripsi: 'Akhiri sesi dan keluar dari aplikasi',
                        warna: Color(0xFFE07A7A),
                        onTap: () => _keluar(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Kartu menu (dipakai 2x di atas)
class _MenuCard extends StatelessWidget {
  final IconData ikon;
  final String judul, deskripsi;
  final Color warna;
  final VoidCallback onTap;

  const _MenuCard({
    required this.ikon,
    required this.judul,
    required this.deskripsi,
    required this.warna,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: warna.withAlpha(60),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: warna.withAlpha(30),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(ikon, size: 30, color: warna),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      judul,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(deskripsi,
                        style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}