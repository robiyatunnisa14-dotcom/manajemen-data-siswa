
import 'package:flutter/material.dart';

class PageInputdata extends StatefulWidget {
  final String token;

  const PageInputdata({
    super.key,
    required this.token,
  });

  @override
  State<PageInputdata> createState() => _PageInputdataState();
}

class _PageInputdataState extends State<PageInputdata> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nipdController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController kelasController = TextEditingController();
  final TextEditingController jurusanController = TextEditingController();

  String? jenisKelamin;

  @override
  void dispose() {
    nipdController.dispose();
    namaController.dispose();
    alamatController.dispose();
    kelasController.dispose();
    jurusanController.dispose();
    super.dispose();
  }

  Widget inputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label wajib diisi';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF1769E8),
        ),
        filled: true,
        fillColor: const Color(0xFFF9FBFF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xFFD5E3F8),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xFF1769E8),
            width: 2,
          ),
        ),
      ),
    );
  }

  void simpanData() {
    if (_formKey.currentState!.validate()) {
      if (jenisKelamin == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Silakan pilih jenis kelamin'),
          ),
        );
        return;
      }

      // Data belum dikirim ke database.
      // Nanti akan dihubungkan dengan API backend.

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Form berhasil diisi. Koneksi database belum tersedia.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Data Siswa'),
        backgroundColor: const Color(0xFF1769E8),
        foregroundColor: Colors.white,
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEAF3FF),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),

            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 480,
              ),

              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A1769E8),
                      blurRadius: 22,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),

                child: Form(
                  key: _formKey,

                  child: Column(
                    children: [
                      const Icon(
                        Icons.person_add_alt_1_rounded,
                        size: 58,
                        color: Color(0xFF1769E8),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Input Data Siswa',
                        style: TextStyle(
                          color: Color(0xFF10245A),
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Masukkan data siswa dengan benar',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF7185AA),
                        ),
                      ),

                      const SizedBox(height: 28),

                      inputField(
                        label: 'NIPD',
                        icon: Icons.badge_outlined,
                        controller: nipdController,
                      ),

                      const SizedBox(height: 16),

                      inputField(
                        label: 'Nama Lengkap',
                        icon: Icons.person_outline_rounded,
                        controller: namaController,
                      ),

                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value: jenisKelamin,
                        decoration: InputDecoration(
                          labelText: 'Jenis Kelamin',
                          prefixIcon: const Icon(
                            Icons.people_outline,
                            color: Color(0xFF1769E8),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Laki-laki',
                            child: Text('Laki-laki'),
                          ),
                          DropdownMenuItem(
                            value: 'Perempuan',
                            child: Text('Perempuan'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            jenisKelamin = value;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      inputField(
                        label: 'Alamat',
                        icon: Icons.location_on_outlined,
                        controller: alamatController,
                      ),

                      const SizedBox(height: 16),

                      inputField(
                        label: 'Kelas',
                        icon: Icons.class_outlined,
                        controller: kelasController,
                      ),

                      const SizedBox(height: 16),

                      inputField(
                        label: 'Jurusan',
                        icon: Icons.school_outlined,
                        controller: jurusanController,
                      ),

                      const SizedBox(height: 26),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: simpanData,
                              icon: const Icon(Icons.check_rounded),
                              label: const Text('SIMPAN'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1769E8),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.close_rounded),
                              label: const Text('BATAL'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF1769E8),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                side: const BorderSide(
                                  color: Color(0xFF1769E8),
                                ),
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
          ),
        ),
      ),
    );
  }
}