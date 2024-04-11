import "package:flutter/material.dart";
import 'package:clay_containers/clay_containers.dart';
// import 'package:flutter/cupertino.dart';

class LoginScreen extends StatefulWidget {
 const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

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
              height: MediaQuery.of(context).size.height * 0.91,
              width: MediaQuery.of(context).size.width * 1,
              child: Column(
                children: [
                  const SizedBox(height: 450,),
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
                          showCursor: true,
                          cursorColor: Theme.of(context).primaryColor,
                          controller: fieldTextPassword,
                          keyboardType: TextInputType.visiblePassword,
                          style: const TextStyle(fontSize: 16.0),
                          textAlign: TextAlign.center,
                          onSaved: (String? value) {},
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
                    width: MediaQuery.of(context).size.width/3,
                    parentColor: Colors.white,
                    surfaceColor: Colors.grey[400],
                    spread: 2,
                    depth: 5,
                    emboss: true,
                    child: Icon(
                      Icons.navigate_next_outlined,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}