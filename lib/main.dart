import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:xprojects_news_task/core/local_data_source/user_preference_source.dart';
import 'package:xprojects_news_task/core/di/di.dart' as di;
import 'package:xprojects_news_task/features/layout/presentation/controller/cubit/layout_cubit.dart';
import 'package:xprojects_news_task/features/layout/presentation/page/layout_page.dart';

void main() async {
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
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(
        useMaterial3: true,
        splashColor: Colors.transparent
      ),
      home: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocProvider(
              create: (context) => di.sl<LayoutCubit>(),

              child: const LayoutPage());
        },
      ),
    );
  }
}
