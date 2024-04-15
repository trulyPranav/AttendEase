import 'package:flutter/material.dart';
import 'package:attendease/screens/loginpage.dart';

class Home extends StatefulWidget {
  Home({required this.name});
  String name;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Placeholder(),
      ),
    );
  }
}