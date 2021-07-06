part of 'services.dart';

class DatePickerService {
  static SharedPreferences? _sharedPref;

  static final _keyStartDate = 'startDate';
  static final _keyEndDate = 'endDate';

  static Future<String?> getStartDate() async {
    _sharedPref = await SharedPreferences.getInstance();
    return _sharedPref!.getString(_keyStartDate);
  }

  static void saveStartDate(String startDate) async {
    _sharedPref = await SharedPreferences.getInstance();
    _sharedPref!.setString(_keyStartDate, startDate);
  }

  static Future<String?> getEndDate() async {
    _sharedPref = await SharedPreferences.getInstance();
    return _sharedPref!.getString(_keyEndDate);
  }

  static void saveEndDate(String endDate) async {
    _sharedPref = await SharedPreferences.getInstance();
    _sharedPref!.setString(_keyEndDate, endDate);
  }
}