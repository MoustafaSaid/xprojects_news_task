import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Search Language',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      color: Colors.white,
                      child: ListTile(
                        title: const Text('English'),
                        trailing: Radio<String>(
                          value: 'en',
                          groupValue: state.language,
                          onChanged: (value) {
                            if (value != null) {
                              context.read<SettingsCubit>().changeLanguage(value);
                            }
                          },
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.white,

                      child: ListTile(
                        title: const Text('العربية'),
                        trailing: Radio<String>(
                          value: 'ar',
                          groupValue: state.language,
                          onChanged: (value) {
                            if (value != null) {
                              context.read<SettingsCubit>().changeLanguage(value);
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
