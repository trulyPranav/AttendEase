// ignore_for_file: use_build_context_synchronously

import "package:flutter/material.dart";
import 'package:clay_containers/clay_containers.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import "package:attendease/screens/home.dart";
import "package:shared_preferences/shared_preferences.dart";

class LoginScreen extends StatefulWidget {
 const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String api = "https://fetcherapi.onrender.com";
  late String? username;
  late String? password;
  late String name;

  final fieldTextUsername = TextEditingController();
  final fieldTextPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ClayContainer(
              emboss: true,
              depth: 20,
              spread: 5.0,
              borderRadius: 15.0,
              surfaceColor: Colors.grey,
              parentColor: Colors.black87,
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Center(
                    child: Text(
                      'AttendEase',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Horizon',
                        fontSize: 70,
                        color: Colors.black
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius:BorderRadius.circular(20),
                            ),
                            child: TextFormField(
                                showCursor: true,
                                cursorColor: Theme.of(context).primaryColor,
                                controller: fieldTextUsername,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(fontSize: 16.0),
                                textAlign: TextAlign.center,
                                onSaved: (String? value) {},
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                    hintText: 'Etlab ID',
                                    hintStyle: TextStyle(fontWeight: FontWeight.w400),
                                    border: InputBorder.none,),              
                            ),
                          ),
                        ),
                        const SizedBox(height: 5,),
                        Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius:BorderRadius.circular(20),
                            ),
                            child: TextFormField(
                                obscureText: true,
                                showCursor: true,
                                cursorColor: Theme.of(context).primaryColor,
                                controller: fieldTextPassword,
                                keyboardType: TextInputType.visiblePassword,
                                style: const TextStyle(fontSize: 16.0),
                                textAlign: TextAlign.center,
                                onSaved: (value) {},
                                textInputAction: TextInputAction.done,
                                decoration: const InputDecoration(
                                    hintText: 'Password',
                                    hintStyle: TextStyle(fontWeight: FontWeight.w400),
                                    border: InputBorder.none,),              
                            ),
                          ),
                        ),     
                        const SizedBox(height: 20,),
                        ClayContainer(
                          height: MediaQuery.of(context).size.height/20,
                          width: MediaQuery.of(context).size.width/4,
                          parentColor: Colors.white,
                          surfaceColor: Colors.grey[400],
                          spread: 2,
                          depth: 5,
                          emboss: true,
                          child: ElevatedButton(
                            onPressed: () async {
                              usernameLogin(fieldTextUsername.text,fieldTextPassword.text);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(5),
                              shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black.withOpacity(0.6),
                            ),
                            child : const Icon(Icons.navigate_next_outlined,),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future usernameLogin(String? username, String? password) async {
 
   showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    },
  );

  Map<String, dynamic> update = {
    "username" : username,
    "password" : password,
  };
  final url = Uri.parse(api);
  final response = await http.post(
    url,
    headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',},
    body: jsonEncode(update)
  );

  Navigator.pop(context);
 // print(response.body);

  if(response.statusCode == 200){
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username',username!);
      await prefs.setString('password',password!);
      Map<String, dynamic> responseData = jsonDecode(response.body);
      await prefs.setString('responseData', jsonEncode(responseData));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home(name: username.toString())));

  }
  else{
      showAlertDialog(context);

      fieldTextPassword.clear();
} }

  showAlertDialog(BuildContext context) {
    Widget retryButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        backgroundColor: Colors.blue.shade500,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(25, 4, 25, 4),
        child: const Text("Retry", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16,color: Colors.black87),),
      ),
      onPressed:  ()async {
        Navigator.pop(context);
      },
    );
   AlertDialog alert = AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      actionsAlignment: MainAxisAlignment.center,
      //contentPadding: EdgeInsets.fromLTRB(100, 10, 100, 10),
      content: const SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Invalid Credentials", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      actions: [
        retryButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
            width: 8,),
          ),
          child: alert,
        );
      },
    );
  }
}

