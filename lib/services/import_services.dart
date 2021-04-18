part of 'services.dart';

class ImportServices {

  static SharedPreferences _sharedPref;

  static Future<bool> getCurrentImport() async {
    _sharedPref = await SharedPreferences.getInstance();
    return _sharedPref.getBool("import");
  }

  static Future<void> saveImport(bool isImported) async {
    _sharedPref = await SharedPreferences.getInstance();
    await _sharedPref.setBool("import", isImported);
  }

  static Future<String> getPrefixIdpel() async {
    _sharedPref = await SharedPreferences.getInstance();
    return _sharedPref.getString("idPel");
  }

  static Future<void> savePrefixIdpel(String idPel) async {
    _sharedPref = await SharedPreferences.getInstance();
    await _sharedPref.setString("idPel", idPel);
  }
}