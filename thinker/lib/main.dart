import 'package:flutter/material.dart';
import 'package:thinker/CardView.dart';
import 'package:thinker/Widgets/StartPage.dart';
import 'package:thinker/login.dart';
import 'package:thinker/utils/google_sign_in.dart';
import 'onboarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  bool firstRun = true;

  // Future<void> _getIsNewDevice() async {
  //   bool firstRun = await IsFirstRun.isFirstRun();
  // }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.black.withOpacity(0),
            ),
          ),
          // home: firstRun ? OnBoardScreen() : LogIn(),
          home: StartPage(),
          // home: CardView(),
        ),
      );
}
