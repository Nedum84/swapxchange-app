import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swapxchange/binding/allcontroller_binding.dart';
import 'package:swapxchange/ui/home/tabs/dashboard/register_notification.dart';
import 'package:swapxchange/ui/splash/splashscreen.dart';
import 'package:swapxchange/utils/colors.dart';

void main() async {
  //initialize the binding
  WidgetsFlutterBinding.ensureInitialized();
  //initialize the binding
  await Firebase.initializeApp();

  //Register notification
  registerNotification();

  //For header start up color
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
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
      title: 'SwapXchange',
      theme: ThemeData(
        primaryColor: KColors.PRIMARY,
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.montserratTextTheme(textTheme),
        // primaryColorBrightness: Brightness.dark,
      ),
      defaultTransition: Transition.rightToLeft,
      initialBinding: AllControllerBinding(),
      home: SplashScreen(),
      // home: Dashboard(),
    );
  }
}
