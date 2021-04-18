import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdil/blocs/blocs.dart';
import 'package:pdil/services/navigation_helper.dart';

import 'utils/utils.dart';
import 'views/pages/pages.dart';

void main() {
  runApp(MyApp());
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
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'PDIL',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
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
