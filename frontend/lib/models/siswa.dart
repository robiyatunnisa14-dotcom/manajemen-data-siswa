
class Siswa {
  final int id;
  final String nipd;
  final String namaLengkap;
  final String jenisKelamin;
  final String kelas;
  final String jurusan;

  Siswa({
    required this.id,
    required this.nipd,
    required this.namaLengkap,
    required this.jenisKelamin,
    required this.kelas,
    required this.jurusan,
  });

  factory Siswa.fromJson(Map<String, dynamic> json) {
    return Siswa(
      id: int.parse(json['id'].toString()),
      nipd: json['nipd'].toString(),
      namaLengkap: json['nama_lengkap'].toString(),
      jenisKelamin: json['jenis_kelamin'].toString(),
      kelas: json['kelas'].toString(),
      jurusan: json['jurusan'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nipd': nipd,
      'nama_lengkap': namaLengkap,
      'jenis_kelamin': jenisKelamin,
      'kelas': kelas,
      'jurusan': jurusan,
    };
  }
}
