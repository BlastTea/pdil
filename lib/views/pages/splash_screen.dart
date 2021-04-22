part of 'pages.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ImportBloc, ImportState>(
        builder: (_, importState) => BlocBuilder<ImportBloc, ImportState>(
          builder: (_, state) {
            return FutureBuilder(
              future: Future(() async {
                await Future.delayed(Duration(seconds: 2));
                return true;
              }),
              builder: (_, snap) {
                if (snap.hasData && snap.data) {
                  if (state is ImportNotImported) {
                    return ImportPage();
                  } else if (state is ImportImported) {
                    return InputPage();
                  }
                }

                return Scaffold(
                  body: Center(
                    child: Text("PDIL", style: title.copyWith(color: primaryColor, fontWeight: FontWeight.w600)),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
