
import 'package:flutter/material.dart';

class PageEditSiswa extends StatefulWidget {
  final Map<String, dynamic> siswa;
  final String token;

  const PageEditSiswa({
    super.key,
    required this.siswa,
    required this.token,
  });

  @override
  State<PageEditSiswa> createState() => _PageEditSiswaState();
}

class _PageEditSiswaState extends State<PageEditSiswa> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nipdController;
  late TextEditingController namaController;
  late TextEditingController alamatController;
  late TextEditingController kelasController;
  late TextEditingController jurusanController;

  String? jenisKelamin;

  @override
  void initState() {
    super.initState();

    nipdController = TextEditingController(
      text: widget.siswa['nipd']?.toString() ?? '',
    );

    namaController = TextEditingController(
      text: widget.siswa['nama_lengkap']?.toString() ?? '',
    );

    alamatController = TextEditingController(
      text: widget.siswa['alamat']?.toString() ?? '',
    );

    kelasController = TextEditingController(
      text: widget.siswa['kelas']?.toString() ?? '',
    );

    jurusanController = TextEditingController(
      text: widget.siswa['jurusan']?.toString() ?? '',
    );

    jenisKelamin = widget.siswa['jenis_kelamin']?.toString();
  }

  @override
  void dispose() {
    nipdController.dispose();
    namaController.dispose();
    alamatController.dispose();
    kelasController.dispose();
    jurusanController.dispose();
    super.dispose();
  }

  Widget inputField(
      String label,
      TextEditingController controller,
      IconData icon,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label tidak boleh kosong';
          }
          return null;
        },
      ),
    );
  }

  void simpanPerubahan() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Form berhasil diperiksa. API edit belum dihubungkan.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        title: const Text('Edit Data Siswa'),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Ubah Data Siswa',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 24),

                      inputField(
                        'NIPD',
                        nipdController,
                        Icons.badge_outlined,
                      ),

                      inputField(
                        'Nama Lengkap',
                        namaController,
                        Icons.person_outline,
                      ),

                      DropdownButtonFormField<String>(
                        value: jenisKelamin,
                        decoration: InputDecoration(
                          labelText: 'Jenis Kelamin',
                          prefixIcon: const Icon(Icons.people_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Pilih jenis kelamin';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      inputField(
                        'Alamat',
                        alamatController,
                        Icons.home_outlined,
                      ),

                      inputField(
                        'Kelas',
                        kelasController,
                        Icons.school_outlined,
                      ),

                      inputField(
                        'Jurusan',
                        jurusanController,
                        Icons.menu_book_outlined,
                      ),

                      const SizedBox(height: 10),

                      ElevatedButton.icon(
                        onPressed: simpanPerubahan,
                        icon: const Icon(Icons.save),
                        label: const Text('SIMPAN PERUBAHAN'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('BATAL'),
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