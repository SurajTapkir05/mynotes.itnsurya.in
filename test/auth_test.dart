// import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthMultiFactorException, FirebaseAuthException;
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';

void main() {}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) {
    throw NotInitializedException();
    }
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
     await Future.delayed(const Duration(seconds: 1));
     _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
   if (!isInitialized) {
    throw NotInitializedException();
   }
    if(email == 'foobarbaz') throw UserNotFoundAuthException();
    if(password == 'foo') throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: true, email: 'abc@gmail.com', id: 'my_id');
    _user = user;
    return Future.value(user);

  }

  @override
  Future<void> logOut() async {
    if(!isInitialized) throw NotInitializedException();
    if(_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;

  }

  @override
  Future<void> sendEmailVerification() async {
    if(!isInitialized) throw NotInitializedException(); 
    final user = _user;
    if(user == null ) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true, email: 'abc@gmail.com', id: 'my_id');
    _user = newUser;
    throw UnimplementedError();
  }
}
