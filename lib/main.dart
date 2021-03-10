import 'package:flutter/material.dart';
import 'routes/Routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/cupertino.dart';
void main() {
  runApp(MyApp());
}
final ThemeData mDefaughtTheme=ThemeData(
  primaryColor:Color.fromRGBO(255, 115, 150,1.000),
);
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "肖肖饲养计划",
      localizationsDelegates: [
        //此处
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        const FallbackCupertinoLocalisationsDelegate()
      ],
      supportedLocales: [
        //此处
        const Locale('zh', 'CH'),
        const Locale('en', 'US'),
      ],
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      theme: mDefaughtTheme,
      onGenerateRoute: onGenerateRoute,
    );
  }

}
class FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();
 
  @override
  bool isSupported(Locale locale) => true;
 
  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);
 
  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}