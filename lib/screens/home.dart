// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

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