part of 'models.dart';

class Pdil {
  String idPel;
  String noMeter;
  String nama;
  String alamat;
  String tarip;
  String daya;
  String noHp;
  String nik;
  String npwp;
  String email;
  String catatan;
  bool isKoreksi;
  String tanggalBaca;

  Pdil({
    this.idPel,
    this.noMeter,
    this.nama,
    this.alamat,
    this.tarip,
    this.daya,
    this.noHp,
    this.nik,
    this.npwp,
    this.email,
    this.catatan,
    this.isKoreksi,
    this.tanggalBaca,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnIdPel: idPel,
      columnNoMeter: noMeter,
      columnNama: nama,
      columnAlamat: alamat,
      columnTarip: tarip,
      columnDaya: daya,
      columnNoHp: noHp,
      columnNik: nik,
      columnNpwp: npwp,
      columnEmail: email,
      columnCatatan: catatan,
      columnIsKoreksi: isKoreksi == true ? 1 : 0,
      columnTanggalBaca: tanggalBaca,
    };
    return map;
  }

  Pdil.fromMap(Map<String, dynamic> map) {
    idPel = map[columnIdPel];
    noMeter = map[columnNoMeter];
    nama = map[columnNama];
    alamat = map[columnAlamat];
    tarip = map[columnTarip];
    daya = map[columnDaya];
    noHp = map[columnNoHp];
    nik = map[columnNik];
    npwp = map[columnNpwp];
    email = map[columnEmail];
    catatan = map[columnCatatan];
    isKoreksi = map[columnIsKoreksi] == 1;
    tanggalBaca = map[columnTanggalBaca];
  }

  List<String> toList({bool isPasca = true, isExport = true}) => [
        idPel,
        if (!isPasca) noMeter,
        nama,
        alamat,
        tarip,
        daya,
        noHp,
        nik,
        npwp,
        email,
        catatan,
        if(!isExport) tanggalBaca,
      ];

  Pdil copyWith({
    String idPel,
    String noMeter,
    String nama,
    String alamat,
    String tarip,
    String daya,
    String noHp,
    String nik,
    String npwp,
    String email,
    String catatan,
    bool isKoreksi,
    String tanggalBaca,
  }) =>
      Pdil(
        idPel: idPel ?? this.idPel,
        noMeter: noMeter ?? this.noMeter,
        nama: nama ?? this.nama,
        alamat: alamat ?? this.alamat,
        tarip: tarip ?? this.tarip,
        daya: daya ?? this.daya,
        noHp: noHp ?? this.noHp,
        nik: nik ?? this.nik,
        npwp: npwp ?? this.npwp,
        email: email ?? this.email,
        catatan: catatan ?? this.catatan,
        isKoreksi: isKoreksi ?? this.isKoreksi,
        tanggalBaca: tanggalBaca ?? this.tanggalBaca,
      );

  /// return true jika semua field atau atribut sama,
  /// jika tidak sama maka akan return false
  bool compareTo(Pdil pdil, {bool isIgnoreIdpel = true}) {
    if (!isIgnoreIdpel && idPel != pdil.idPel) {
      return false;
    } else if (noMeter != pdil.noMeter) {
      return false;
    } else if (nama != pdil.nama) {
      return false;
    } else if (alamat != pdil.alamat) {
      return false;
    } else if (tarip != pdil.tarip) {
      return false;
    } else if (daya != pdil.daya) {
      return false;
    } else if (noHp != pdil.noHp) {
      return false;
    } else if (nik != pdil.nik) {
      return false;
    } else if (npwp != pdil.npwp) {
      return false;
    } else if (email != pdil.email) {
      return false;
    } else if (catatan != pdil.catatan) {
      return false;
    }

    return true;
  }

  @override
  String toString() {
    return 'Pdil(idPel : $idPel, noMeter : $noMeter, nama : $nama, alamat : $alamat, tarif : $tarip, daya : $daya, noHp : $noHp, nik : $nik, npwp : $npwp, email : $email, catatan : $catatan)';
  }
}
