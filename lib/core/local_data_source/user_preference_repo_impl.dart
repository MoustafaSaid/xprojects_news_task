
import 'package:xprojects_news_task/core/local_data_source/user_preference_repo.dart';
import 'package:xprojects_news_task/core/local_data_source/user_preference_source.dart';


class UserPreferenceRepoImpl implements UserPreferenceRepo {
  final UserPreferenceSource userPreference;
  UserPreferenceRepoImpl({required this.userPreference});


  @override
  String getLanguage() {
    String value = userPreference.getStringValue(
      key: UserPreferenceConstants.language,
    );
    return value.isNotEmpty ? value : 'en';
  }

  @override
  Future<void> insertLanguage({required String value}) async {
    return await userPreference.insertStringValue(
      key: UserPreferenceConstants.language,
      value: value,
    );
  }


}
