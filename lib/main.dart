import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hive/constants.dart';
import 'package:flutter_hive/contact_page.dart';
import 'package:flutter_hive/models/contact.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(ContactAdapter());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Hive',
      home: SplashScreen.navigate(
        name: 'assets/hive_splash.flr',
        startAnimation: 'hive',
        backgroundColor: Color(0xffffffff),
        // until: () => Future.delayed(Duration(seconds: 3)),
        next: (_) => FutureBuilder(
          future: Hive.openBox(CONTACT_BOX),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return ContactPage();
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    Hive.box(CONTACT_BOX).compact();
    Hive.box(CONTACT_BOX).close();
    super.dispose();
  }
}
