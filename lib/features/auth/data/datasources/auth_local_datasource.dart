import 'package:flashcard/core/constants/app_constants.dart';
import 'package:flashcard/core/error/exceptions.dart';
import 'package:flashcard/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<UserModel> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearCache();
  Future<String?> getToken();
  Future<void> cacheToken(String token);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<UserModel> getCachedUser() async {
    final jsonString = sharedPreferences.getString(AppConstants.userDataKey);
    if (jsonString != null) {
      return UserModel.fromJson(jsonString);
    }
    throw const CacheException('No cached user found');
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await sharedPreferences.setString(
      AppConstants.userDataKey,
      user.toJson(),
    );
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(AppConstants.userDataKey);
    await sharedPreferences.remove(AppConstants.userTokenKey);
  }

  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString(AppConstants.userTokenKey);
  }

  @override
  Future<void> cacheToken(String token) async {
    await sharedPreferences.setString(AppConstants.userTokenKey, token);
  }
}
