import 'package:flutter/material.dart';
import '../models/siswa.dart';
import '../services/siswa_service.dart';

class SiswaPage extends StatefulWidget {
  const SiswaPage({super.key});

  @override
  State<SiswaPage> createState() => _SiswaPageState();
}

class _SiswaPageState extends State<SiswaPage> {
  late Future<List<Siswa>> futureSiswa;

  @override
  void initState() {
    super.initState();
    futureSiswa = SiswaService.getAllSiswa();
  }

  void refreshData() {
    setState(() {
      futureSiswa = SiswaService.getAllSiswa();
    });
  }

  Future<void> tampilkanForm({Siswa? siswa}) async {
    final formKey = GlobalKey<FormState>();

    final nipdController = TextEditingController(
      text: siswa?.nipd ?? '',
    );
    final namaController = TextEditingController(
      text: siswa?.namaLengkap ?? '',
    );
    final kelasController = TextEditingController(
      text: siswa?.kelas ?? '',
    );
    final jurusanController = TextEditingController(
      text: siswa?.jurusan ?? '',
    );

    String jenisKelamin = siswa?.jenisKelamin ?? 'Laki-laki';

    final data = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, ubahDialog) {
            return AlertDialog(
              title: Text(
                siswa == null ? 'Tambah Siswa' : 'Edit Siswa',
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nipdController,
                        decoration: const InputDecoration(
                          labelText: 'NIPD',
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'NIPD wajib diisi'
                                : null,
                      ),
                      TextFormField(
                        controller: namaController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Lengkap',
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Nama wajib diisi'
                                : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: jenisKelamin,
                        decoration: const InputDecoration(
                          labelText: 'Jenis Kelamin',
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
                          if (value != null) {
                            ubahDialog(() {
                              jenisKelamin = value;
                            });
                          }
                        },
                      ),
                      TextFormField(
                        controller: kelasController,
                        decoration: const InputDecoration(
                          labelText: 'Kelas',
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Kelas wajib diisi'
                                : null,
                      ),
                      TextFormField(
                        controller: jurusanController,
                        decoration: const InputDecoration(
                          labelText: 'Jurusan',
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Jurusan wajib diisi'
                                : null,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(dialogContext, {
                        'nipd': nipdController.text.trim(),
                        'nama_lengkap': namaController.text.trim(),
                        'jenis_kelamin': jenisKelamin,
                        'kelas': kelasController.text.trim(),
                        'jurusan': jurusanController.text.trim(),
                      });
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );

    nipdController.dispose();
    namaController.dispose();
    kelasController.dispose();
    jurusanController.dispose();

    if (data == null) return;

    try {
      if (siswa == null) {
        await SiswaService.tambahSiswa(data);
      } else {
        await SiswaService.editSiswa(siswa.id, data);
      }

      if (!mounted) return;

      refreshData();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            siswa == null
                ? 'Siswa berhasil ditambahkan'
                : 'Data siswa berhasil diubah',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> hapusData(Siswa siswa) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Siswa'),
        content: Text(
          'Yakin ingin menghapus ${siswa.namaLengkap}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (yakin != true) return;

    try {
      await SiswaService.hapusSiswa(siswa.id);

      if (!mounted) return;

      refreshData();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Siswa berhasil dihapus'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FC),
      appBar: AppBar(
        title: const Text('Manajemen Data Siswa'),
        backgroundColor: const Color(0xFF1769E8),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Siswa>>(
        future: futureSiswa,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 45,
                    ),
                    const SizedBox(height: 10),
                    Text('Gagal mengambil data:\n${snapshot.error}'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: refreshData,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final siswaList = snapshot.data ?? [];

          if (siswaList.isEmpty) {
            return const Center(
              child: Text('Belum ada data siswa'),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              refreshData();
              await futureSiswa;
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: siswaList.length,
              itemBuilder: (context, index) {
                final siswa = siswaList[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          siswa.namaLengkap,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('NIPD: ${siswa.nipd}'),
                        Text('Jenis Kelamin: ${siswa.jenisKelamin}'),
                        Text('Kelas: ${siswa.kelas}'),
                        Text('Jurusan: ${siswa.jurusan}'),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                tampilkanForm(siswa: siswa);
                              },
                              icon: const Icon(Icons.edit),
                              label: const Text('Edit'),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                hapusData(siswa);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              label: const Text(
                                'Hapus',
                                style: TextStyle(color: Colors.red),
                              ),
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
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => tampilkanForm(),
        backgroundColor: const Color(0xFF1769E8),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Siswa'),
      ),
    );
  }
}
