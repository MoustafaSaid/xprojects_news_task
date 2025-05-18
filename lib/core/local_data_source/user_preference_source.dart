import 'package:hive/hive.dart';

class UserPreferenceConstants {
  static const String boxName = 'UserPreferenceBox';
  static const String language = 'language';
}

class UserPreferenceSource {
  final Box userPreferenceBox;

  UserPreferenceSource({required this.userPreferenceBox});

  Future<void> insertStringValue({
    required String key,
    required String value,
  }) async {
    await userPreferenceBox.put(key, value);
  }

  String getStringValue({
    required String key,
  }) {
    return userPreferenceBox.get(key, defaultValue: '');
  }


  Future<void> deleteKey({
    required String key,
  }) async {
    await userPreferenceBox.delete(key);
  }


}
