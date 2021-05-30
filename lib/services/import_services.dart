part of 'services.dart';

class ImportServices {
  static SharedPreferences _sharedPref;

  static Future<Import> getCurrentImport() async {
    _sharedPref = await SharedPreferences.getInstance();
    String value = _sharedPref.getString("import");
    switch (value) {
      case 'both':
        return Import.bothImported;
        break;
      case 'bothNotImported':
        return Import.bothNotImported;
        break;
      case 'pascabayar':
        return Import.pascabayarImported;
        break;
      case 'prabayar':
        return Import.prabayarImported;
        break;
      default:
        return Import.bothNotImported;
    }
  }

  static Future<void> saveImport(Import import) async {
    _sharedPref = await SharedPreferences.getInstance();
    String value;
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

  static Future<String> getPrefixIdpel() async {
    _sharedPref = await SharedPreferences.getInstance();
    return _sharedPref.getString("idPel");
  }

  static Future<void> savePrefixIdpel(String idPel) async {
    _sharedPref = await SharedPreferences.getInstance();
    await _sharedPref.setString("idPel", idPel);
  }

  static Future<List<String>> getListFormat() async {
    _sharedPref = await SharedPreferences.getInstance();
    return _sharedPref.getStringList("format");
  }

  static Future<void> saveListFormat(List<String> format) async {
    _sharedPref = await SharedPreferences.getInstance();
    await _sharedPref.setStringList("format", format);
  }
}
