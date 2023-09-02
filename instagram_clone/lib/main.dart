import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/screens/signUp_screen.dart';
import './utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    //for the web
    await Firebase.initializeApp(
      options:const FirebaseOptions(apiKey: "AIzaSyDOSj7kTOELiZP5nDTJUFl9LqfBr1xTzRY", appId: "1:1062957047719:web:344b19c284b87660d66082", messagingSenderId: "1062957047719", projectId: "instagram-clone-1b322",storageBucket: "instagram-clone-1b322.appspot.com"),
    );
  }else{
    //for the mobile application
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      // home:ResponsiveLayout(mobileScreenLayout: MobileScreenLayout(),webScreenLayout: WebScreenLayout(),),
      home: const SignupScreen(),
    );
  }
}
