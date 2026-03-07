import 'package:flashcard/core/utils/typedefs.dart';
import 'package:flashcard/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  ResultFuture<User> signIn({
    required String email,
    required String password,
  });

  ResultFuture<User> signUp({
    required String email,
    required String password,
    required String displayName,
  });

  ResultVoid signOut();

  ResultFuture<User> getCurrentUser();

  ResultFuture<bool> isSignedIn();
}
