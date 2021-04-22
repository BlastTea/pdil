part of 'services.dart';

class FontSizeServices {
  static SharedPreferences _sharedPref;

  static Future<void> saveFontSize(double fontSize) async {
    _sharedPref = await SharedPreferences.getInstance();
    return _sharedPref.setDouble("fontSize", fontSize);
  }

  static Future<double> getFontSize() async {
    _sharedPref = await SharedPreferences.getInstance();
    return _sharedPref.getDouble("fontSize");
  }
}
