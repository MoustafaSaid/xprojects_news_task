import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:xprojects_news_task/core/constants/strings/strings_constants.dart';
import 'package:xprojects_news_task/core/theme/font/font_styles.dart';
import '../controller/settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        if (state is SettingsLoaded) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringsConstants.searchLanguage.tr(),
                      style: FontStyles.font22blackW800,
                    ),
                    SizedBox(height: 16.h),
                    Card(
                      color: Colors.white,
                      child: ListTile(
                        title: Text(StringsConstants.english.tr(),
                            style: FontStyles.font16blackW400),
                        trailing: Radio<String>(
                          value: 'en',
                          groupValue: state.language,
                          onChanged: (value) async {
                            if (value != null) {
                              await context.setLocale(const Locale('en', 'US'));
                              if (!context.mounted) return;
                              await context
                                  .read<SettingsCubit>()
                                  .changeLanguage(value);
                            }
                          },
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.white,
                      child: ListTile(
                        title: Text(StringsConstants.arabic.tr(),
                            style: FontStyles.font16blackW400),
                        trailing: Radio<String>(
                          value: 'ar',
                          groupValue: state.language,
                          onChanged: (value) async {
                            if (value != null) {
                              await context.setLocale(const Locale('ar', 'EG'));
                              if (!context.mounted) return;
                              await context
                                  .read<SettingsCubit>()
                                  .changeLanguage(value);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
