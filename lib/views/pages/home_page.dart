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
      floatingActionButton: _currentNav == 1
          ? FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () {},
              child: Icon(Icons.save, color: whiteColor),
            )
          : null,
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
          CustomerDataPage(),
          InputPage(),
          SettingsPage(),
        ][_currentNav],
      ),
    );
  }
}
