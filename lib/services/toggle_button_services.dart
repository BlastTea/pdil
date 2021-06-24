part of 'services.dart';

class ToggleButtonServices {
  static late SharedPreferences _sharedPref;

  static final String _keyShowData = 'ShowData';
  static final String _keyInputData = 'InputData';

  static Future<bool> getShowData() async {
    _sharedPref = await SharedPreferences.getInstance();
    return _sharedPref.getBool(_keyShowData) ?? true;
  }

  static void saveShowData(bool isPasca) async {
    _sharedPref = await SharedPreferences.getInstance();
    await _sharedPref.setBool(_keyShowData, isPasca);
  }

  static Future<bool> getInputData() async {
    _sharedPref = await SharedPreferences.getInstance();
    return _sharedPref.getBool(_keyInputData) ?? true;
  }
  
  static void saveInputData(bool isPasca) async {
    _sharedPref = await SharedPreferences.getInstance();
    await _sharedPref.setBool(_keyInputData, isPasca);
  }

}