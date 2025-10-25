import 'package:visio_fit/models/user_model.dart';

class AuthService {
  Future<UserModel?> login(String email, String password) async {
    try {
      // API çağrısı burada yapılacak
      // Şimdilik mock data dönüyoruz
      return UserModel(
        id: '1',
        email: email,
        name: 'Test User',
      );
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<bool> logout() async {
    try {
      // Logout işlemleri
      return true;
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }
} 