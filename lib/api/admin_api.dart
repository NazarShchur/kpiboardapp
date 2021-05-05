import 'package:kpiboardapp/entity/User.dart';

abstract class AdminApi {
  Future<List<User>> findAllUsers();
}