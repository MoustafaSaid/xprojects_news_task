import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences _prefs;
  static const String _languageKey = 'language';
  String _currentLanguage = 'en';

  SettingsCubit(this._prefs) : super(SettingsInitial()) {
    _loadLanguage();
  }

  String get currentLanguage => _currentLanguage;

  void _loadLanguage() {
    _currentLanguage = _prefs.getString(_languageKey) ?? 'en';
    emit(SettingsLoaded(language: _currentLanguage));
  }

  void changeLanguage(String language) {
    _currentLanguage = language;
    _prefs.setString(_languageKey, language);
    emit(SettingsLoaded(language: _currentLanguage));
  }
}
