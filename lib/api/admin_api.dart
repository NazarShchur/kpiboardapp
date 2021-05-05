import 'package:kpiboardapp/entity/User.dart';
import 'package:kpiboardapp/entity/role.dart';

abstract class AdminApi {
  Future<List<User>> findAllUsers();
  Future<void> setUserRole(Role role, int id);
}