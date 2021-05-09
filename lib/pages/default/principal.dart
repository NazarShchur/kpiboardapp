import 'package:kpiboardapp/api/impl/user_api_impl.dart';
import 'package:kpiboardapp/entity/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<User> principal() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return UserApiImpl().findByUsername(prefs.getString("username"));
}