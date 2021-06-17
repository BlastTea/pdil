part of 'services.dart';

class SearchServices {
  static SharedPreferences _sharedPref;

  static Future<List<String>> getCurrentHistorys() async {
    _sharedPref = await SharedPreferences.getInstance();
    return _sharedPref.getStringList('currentSuggestion');
  }

  static void saveCurrentHistorys(List<String> historys) async {
    _sharedPref = await SharedPreferences.getInstance();
    _sharedPref.setStringList('currentSuggestion', historys);
  }

  static Future<void> removeCurrentHistorys() async {
    _sharedPref = await SharedPreferences.getInstance();
    _sharedPref.remove('currentSuggestion');
  }
}
