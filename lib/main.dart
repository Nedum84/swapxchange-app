import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swapxchange/binding/allcontroller_binding.dart';
import 'package:swapxchange/ui/splash/splashscreen.dart';

void main() async {
  //initialize the binding
  WidgetsFlutterBinding.ensureInitialized();
  //initialize the binding
  await Firebase.initializeApp();

  //For header start up color
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      // customise here
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.montserratTextTheme(textTheme),
      ),
      defaultTransition: Transition.rightToLeft,
      initialBinding: AllControllerBinding(),
      home: SplashScreen(),
      // home: Dashboard(),
    );
  }
}
