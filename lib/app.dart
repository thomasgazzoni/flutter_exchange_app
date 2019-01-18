import 'package:exchange_app/home.dart';
import 'package:exchange_app/logic/market/market_bloc.dart';
import 'package:exchange_app/logic/market/market_provider.dart';
import 'package:exchange_app/utils/translations.dart';
import 'package:flutter/material.dart';
import 'package:exchange_app/config/ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  final materialApp = MarketProvider(
      marketBloc: MarketBloc(),
      child: MaterialApp(
          title: UiConfig.appName,
          theme: ThemeData(
              primaryColor: Color.fromRGBO(157, 14, 35, 1.00),
              fontFamily: UiConfig.fontFamily,
              primarySwatch: Colors.grey),
          debugShowCheckedModeBanner: false,
          showPerformanceOverlay: false,
          home: HomePage(),
          localizationsDelegates: [
            TranslationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            Locale("en", "US"),
            Locale("zh", "ZH"),
          ],
          routes: <String, WidgetBuilder>{}));

  @override
  Widget build(BuildContext context) {
    return materialApp;
  }
}
