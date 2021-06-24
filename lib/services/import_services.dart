part of 'services.dart';

class ImportServices {
  static late SharedPreferences _sharedPref;

  static Future<Import> getCurrentImport() async {
    _sharedPref = await SharedPreferences.getInstance();
    String? value = _sharedPref.getString("import");
    switch (value) {
      case 'both':
        return Import.bothImported;
      case 'bothNotImported':
        return Import.bothNotImported;
      case 'pascabayar':
        return Import.pascabayarImported;
      case 'prabayar':
        return Import.prabayarImported;
      default:
        return Import.bothNotImported;
    }
  }

  static Future<void> saveImport(Import import) async {
    _sharedPref = await SharedPreferences.getInstance();
    late String value;
    switch (import) {
      case Import.bothImported:
        value = 'both';
        break;
      case Import.bothNotImported:
        value = 'bothNotImported';
        break;
      case Import.pascabayarImported:
        value = 'pascabayar';
        break;
      case Import.prabayarImported:
        value = 'prabayar';
        break;
    }
    await _sharedPref.setString("import", value);
  }

  static Future<String?> getPrefixIdpelPasca() async {
    _sharedPref = await SharedPreferences.getInstance();
    return _sharedPref.getString("idPelPasca");
  }

  static Future<void> savePrefixIdpelPasca(String idPel) async {
    _sharedPref = await SharedPreferences.getInstance();
    await _sharedPref.setString("idPelPasca", idPel);
  }

  static Future<String?> getPrefixIdpelPra() async {
    _sharedPref = await SharedPreferences.getInstance();
    return _sharedPref.getString('idPelPra');
  }

  static Future<void> savePrefixIdpelPra(String idPel) async {
    _sharedPref = await SharedPreferences.getInstance();
    await _sharedPref.setString('idPelPra', idPel);
  }

  static Future<List<String>?> getListFormat() async {
    _sharedPref = await SharedPreferences.getInstance();
    return _sharedPref.getStringList("format");
  }

  static Future<void> saveListFormat(List<String> format) async {
    _sharedPref = await SharedPreferences.getInstance();
    await _sharedPref.setStringList("format", format);
  }
}
