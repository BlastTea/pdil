part of 'pages.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FontSizeBloc, FontSizeState>(
        builder: (_, stateFontSize) => (stateFontSize is FontSizeResult)
            ? BlocBuilder<ImportBloc, ImportState>(builder: (_, importState) {
                return FutureBuilder<bool>(
                  future: Future(() async {
                    await Future.delayed(Duration(seconds: 2));
                    return true;
                  }),
                  builder: (_, snap) {
                    if (snap.hasData && snap.data!) {
                      if (importState is ImportBothNotImported) {
                        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                          NavigationHelper.to(PageRouteBuilder(
                            pageBuilder: (_, __, ___) => ImportPage(),
                            barrierDismissible: false,
                            opaque: false,
                            barrierColor: blackColor.withOpacity(0.5),
                          ));
                        });
                      }
                      return HomePage();
                    }

                    return Scaffold(
                      body: Shimmer(
                        linearGradient: shimmerGradient,
                        child: Center(
                          child: ShimmerLoading(
                            isLoading: true,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/Logo_Pdil.png',
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "Penataan Data Induk Langganan",
                                  style:
                                      stateFontSize.subtitle!.copyWith(color: primaryColor, fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              })
            : Container(),
      ),
    );
  }
}
