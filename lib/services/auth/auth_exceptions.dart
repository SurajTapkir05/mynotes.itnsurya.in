// Login Exceptions
class UserNotFoundAuthException implements Exception{}

class WrongPasswordAuthException implements Exception{} 

class InvalidCredentialsAuthException implements Exception{}


// Register Exceptions

class WeakPasswordAuthException implements Exception{}

class EmailAlreadyInUseAuthException implements Exception{}

class InvalidEmailAuthException implements Exception{}

class ChannelErrorAuthException implements Exception{}

//Generic Exception

class GenericAuthException implements Exception{}

class UserNotLoggedInAuthException implements Exception{}