import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:xprojects_news_task/core/local_data_source/user_preference_source.dart';
import 'package:xprojects_news_task/core/di/di.dart' as di;


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final userPreferenceBox = await Hive.openBox(
    UserPreferenceConstants.boxName,
  );
  await EasyLocalization.ensureInitialized();
  await di.init(userPreferenceBox: userPreferenceBox);


  runApp(EasyLocalization(
    startLocale: const Locale("en", "US"),
    supportedLocales: const [Locale("ar", "EG"), Locale("en", "US")],
    fallbackLocale: const Locale("en", "US"),
    path: "assets/translations",
    child: const MyApp(),
      // child:  const MyApp()
  ));}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(

        useMaterial3: true,
      ),
      home: ScreenUtilInit(
        designSize: const Size(375, 812),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (context, child) {

          return MyHomePage();
    },
    ));
  }
}
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
