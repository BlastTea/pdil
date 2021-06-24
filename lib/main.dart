import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdil/blocs/blocs.dart';
import 'package:pdil/services/navigation_helper.dart';
import 'package:pdil/services/services.dart';

import 'utils/utils.dart';
import 'views/pages/pages.dart';

void main() async {
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PdilBloc()),
        BlocProvider(create: (_) => ErrorCheckBloc()),
        BlocProvider(create: (_) => InputDataBloc()),
        BlocProvider(create: (_) => ExportDataBloc()),
        BlocProvider(create: (_) => FontSizeBloc()..add(FetchFontSize())),
        BlocProvider(create: (_) => ImportBloc()..add(ImportCurrentImport())),
        BlocProvider(create: (_) => BottomNavigationBloc()),
        BlocProvider(create: (_) => FabSaveBloc()),
        BlocProvider(create: (_) => FabBloc()),
        BlocProvider(create: (_) => CustomerDataBloc()),
        BlocProvider(create: (_) => ToggleButtonBloc()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'PDIL',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xFFF1F5FF),
          primaryColor: primaryColor,
          iconTheme: IconThemeData(
            color: primaryColor,
          ),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
