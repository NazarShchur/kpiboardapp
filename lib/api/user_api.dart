import 'package:kpiboardapp/entity/User.dart';

abstract class UserApi {
  Future<User> findByUsername(String username);
}