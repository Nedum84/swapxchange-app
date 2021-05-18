import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:swapxchange/binding/allcontroller_binding.dart';
import 'package:swapxchange/controllers/product_controller.dart';
import 'package:swapxchange/ui/splash/splashscreen.dart';

void main() async {
  // await GetStorage.init('SwapXchangeContainer'); //get storage initialization
  await GetStorage.init(); //get storage initialization
  //initialize the binding
  // WidgetsFlutterBinding.ensureInitialized();
  //initialize the binding
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialBinding: AllControllerBinding(),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {
    // UserPrefs.setUserId(newId: Random().nextInt(123434).toString());
    Get.to(() => SplashScreen(), transition: Transition.downToUp);
    // Get.snackbar(
    //   'title',
    //   'message',
    //   animationDuration: Duration(seconds: 2),
    //   snackPosition: SnackPosition.TOP,
    //   snackStyle: SnackStyle.GROUNDED,
    // );
    // Get.defaultDialog(
    //   content: Container(
    //     color: Colors.black26,
    //     child: Text('Hellobs'),
    //   ),
    // );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // UserPrefs.pref.listenKey(
    //   UserPrefs.USER_ID,
    //   (newVal) => {print('User changed $newVal')},
    // );
    // UserPrefs.pref.listen(
    //   () {
    //     print('Hellow world');
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text(
            //   UserPrefs.getUserId,
            // ),
            Text(
              'You have:',
            ),
            Obx(() {
              return Text(
                Get.find<ProductController>().inc.toString(),
                style: Theme.of(context).textTheme.headline4,
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
