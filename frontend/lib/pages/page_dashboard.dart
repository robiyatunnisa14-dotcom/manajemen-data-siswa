
import 'package:flutter/material.dart';
import 'page_login.dart';
import 'page_InputData.dart';
import 'page_LihatData.dart';

class PageDashboard extends StatelessWidget {
  final String token;
  const PageDashboard({super.key,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEAF3FF), Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 650),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'DATA SMK BINA PUTRA MANDIRI',
                            style: TextStyle(
                              color: Color(0xFF1769E8),
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: const Color(0xFFD9E9FF),
                          child: const Icon(
                            Icons.person_rounded,
                            color: Color(0xFF1769E8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Kartu sambutan
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF1769E8),
                            Color(0xFF50A5FF),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33316FEA),
                            blurRadius: 18,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '👋 Selamat Datang',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Di Aplikasi Data Siswa SMK Bina Putra Mandiri',
                                  style: TextStyle(
                                    color: Colors.white,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.school_rounded,
                            color: Color(0x66FFFFFF),
                            size: 60,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                    const Text(
                      'MENU UTAMA',
                      style: TextStyle(
                        color: Color(0xFF1769E8),
                        letterSpacing: 2,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF10245A),
                      ),
                    ),
                    const SizedBox(height: 20),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        final columns =
                        constraints.maxWidth > 430 ? 2 : 1;
                        final width =
                            (constraints.maxWidth - 14) / columns;

                        return Wrap(
                          spacing: 14,
                          runSpacing: 14,
                          children: [
                            SizedBox(
                              width: width,
                              child: _DashboardCard(
                                title: 'Lihat Data',
                                subtitle: 'Lihat daftar siswa',
                                icon: Icons.menu_book_rounded,
                                color: const Color(0xFF1769E8),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PageLihatData(
                                        token: token,
                                      ),
                                    ),
                                  );

                                },
                              ),
                            ),
                            SizedBox(
                              width: width,
                              child: _DashboardCard(
                                title: 'Input Data',
                                subtitle: 'Tambah data siswa',
                                icon: Icons.person_add_alt_1_rounded,
                                color: const Color(0xFF18A779),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PageInputdata(
                                        token: token,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PageLogin(),
                            ),
                                (route) => false,
                          );
                        },
                        icon: const Icon(Icons.logout_rounded),
                        label: const Text('Keluar Aplikasi'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF1769E8),
                          backgroundColor: Colors.white,
                          side: const BorderSide(
                            color: Color(0xFFD0E0FA),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
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

class _DashboardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE1EBFA)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D285AA8),
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF10245A),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF7185AA),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 12),
              Icon(
                Icons.arrow_forward_rounded,
                color: color,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}