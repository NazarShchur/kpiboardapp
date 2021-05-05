
import 'package:flutter/material.dart';
import 'package:kpiboardapp/pages/default/login.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: LoginPage(),
    );
  }
}

// class Test extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return TestState();
//   }
// }
//
// class TestState extends State<Test> {
//   List<User> orests;
//   String response;
//
//   @override
//   Widget build(BuildContext context) {
//     var api = "http://192.168.0.102/";
//     return Container(
//       child: Center(
//           child: Column(
//         children: <Widget>[
//           GestureDetector(
//             onTap: () async {
//               var resp = await http.post(api, body: jsonEncode(User.us("Orest").toJson()));
//               setState(() {
//                 response = resp.body;
//                 print(response);
//               });
//             },
//             child: Container(
//               color: Colors.green,
//               width: 100,
//               height: 100,
//             ),
//           ),
//           GestureDetector(
//             onTap: () async {
//               var resp = await http.get(api);
//               print(resp.body);
//               setState(() {
//                 orests = (jsonDecode(resp.body) as List<dynamic>)
//                     .map((el) => User.fromJson(el as Map<String, dynamic>)).toList();
//                 print(orests);
//               });
//             },
//             child: Container(
//               color: Colors.red,
//               width: 100,
//               height: 100,
//             ),
//           ),
//         ],
//       )),
//     );
//   }
// }
