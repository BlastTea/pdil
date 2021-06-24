part of 'services.dart';

class InputService {
  static late SharedPreferences _sharedPref;
  
  static Future<bool?> getInputPageState() async {
    _sharedPref = await SharedPreferences.getInstance();
    return _sharedPref.getBool('inputPageState');
  }

  static void saveInputPageState(bool _isPasca) async {
    _sharedPref = await SharedPreferences.getInstance();
    _sharedPref.setBool('inputPageState', _isPasca);
  }
}