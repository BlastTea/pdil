part of 'pages.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
      builder: (_, stateBottomNavigationBar) {
        if (stateBottomNavigationBar is BottomNavigationResult) {
          int _currentNav = stateBottomNavigationBar.currentNav;
          return Scaffold(
            floatingActionButton: _currentNav == 1
                ? BlocBuilder<FabBloc, FabState>(
                    builder: (_, stateFab) {
                      if (stateFab is FabShowed) {
                        return FloatingActionButton(
                          backgroundColor: primaryColor,
                          onPressed: () {
                            context.read<FabSaveBloc>().add(FabSaveOnPressed());
                            context.read<FabBloc>().add(HideFab());
                          },
                          child: Icon(Icons.save, color: whiteColor),
                        );
                      }
                      return Container();
                    },
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
        return Container();
      },
    );
  }
}
