// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors

import "package:flutter/material.dart";
import "package:attendease/screens/home.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:attendease/screens/loginpage.dart";

class SplashScreen extends StatefulWidget {
//  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
  void removeAfter(Future Function(BuildContext? context) initialization) {}

}

class _SplashScreenState extends State<SplashScreen> {
  String api = "https://fetcherapi.onrender.com";
  @override
  void initState() {
    super.initState();
    loginCheck();
  }    
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
  Future loginCheck() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // ignore: await_only_futures
    String? username = await pref.getString("username");
//    String? password = await pref.getString("password");
    if(username!=null){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  Home(name: username.toString())),
      );      
    }
    else{
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen(),),
        (route) => false
      );
    }
  }
}