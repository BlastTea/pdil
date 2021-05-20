part of 'pages.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentNav = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ClippedBottomBar(
        items: [
          ClippedBottomBarItem(Icons.list_rounded),
          ClippedBottomBarItem(Icons.home),
          ClippedBottomBarItem(Icons.settings),
        ],
        index: _currentNav,
        onTap: (index) {
          setState(() {
            _currentNav = index;
          });
        },
      ),
      body: Center(
        child: [
          SettingsPage(),
          InputPage(),
          SettingsPage(),
        ][_currentNav],
      ),
    );
  }
}
