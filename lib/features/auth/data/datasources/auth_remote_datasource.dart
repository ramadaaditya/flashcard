import 'package:flashcard/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({
    required String email,
    required String password,
  });

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String displayName,
  });

  Future<void> signOut();
}

/// TODO: Replace with actual API implementation (e.g., Firebase, Supabase)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    // Placeholder: implement with your backend
    throw UnimplementedError('Connect to your auth backend');
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    // Placeholder: implement with your backend
    throw UnimplementedError('Connect to your auth backend');
  }

  @override
  Future<void> signOut() async {
    // Placeholder: implement with your backend
    throw UnimplementedError('Connect to your auth backend');
  }
}
