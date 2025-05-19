import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                      'Search Language',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Card(
                      color: Colors.white,
                      child: ListTile(
                        title: Text('English'),
                        trailing: Radio<String>(
                          value: 'en',
                          groupValue: state.language,
                          onChanged: (value) {
                            if (value != null) {
                              context
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
                        title: Text('العربية'),
                        trailing: Radio<String>(
                          value: 'ar',
                          groupValue: state.language,
                          onChanged: (value) {
                            if (value != null) {
                              context
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
