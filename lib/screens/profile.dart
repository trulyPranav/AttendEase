import 'package:attendease/screens/loginpage.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final String name;
  final String dept;
  final String username;
  final double percent;
  const ProfilePage({super.key, required this.name, required this.dept, required this.username,required this.percent});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, //change
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      'PROFILE',
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.w500, fontFamily: GoogleFonts.averiaLibre().fontFamily),
                    ),
                  GestureDetector(
                    onTap: (){logout(context);},
                    child: const Icon(Icons.logout),
                  )
                ],
              ),
              Text('You\'ve got ${widget.percent.toStringAsFixed(1)}% Total Attendance\nAnd this makes you a', style: const TextStyle(fontSize: 18),),
              Center(
                child: AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    ColorizeAnimatedText(role(widget.percent), textStyle: const TextStyle(fontFamily: 'Horizon', fontSize: 80.0), colors: [Colors.blue.shade800,Colors.red.shade800,Colors.white], speed: Durations.long3),
                  ],
                )
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ETLAB USERNAME', style: TextStyle(color: Colors.amber, fontSize: 15,fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      const SizedBox(width: 50,),
                      Text(widget.username, maxLines: 2, style: const TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10,),              
                  const Text('NAME', style: TextStyle(color: Colors.amber, fontSize: 15,fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10,),              
                  Row(
                    children: [
                      const SizedBox(width: 50,),                      
                      Text(widget.name, maxLines: 2, style: const TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10,),              
                  const Text('UNIVERSITY ID', style: TextStyle(color: Colors.amber, fontSize: 15,fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10,),              
                  Row(
                    children: [
                      const SizedBox(width: 50,),                       
                      Text(widget.dept, maxLines: 2, style: const TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              // const SizedBox(height: 100,),
                  const Center(
                    child: Text(
                      'AttendEase',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Horizon',
                        fontSize: 60,
                      ),
                    ),
                  ),              
            ],
          ),
        ),
      ),
    );
  }
  String role (double percent){
    if (percent == 100){
      return 'GOD';
    } else if (percent >= 90) {
    return 'LEGEND';
    } else if (percent >= 85 && percent < 90) {
    return 'ACE';
    } else if (percent >= 80 && percent < 85) {
    return 'PRO';
    } else if (percent >= 75 && percent < 80) {
    return 'COME-BACKER';
    } else {
    return 'MAVELI';
    }
    }
  
  logout(BuildContext context){
    
    Widget back = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade500,
      ),
      onPressed: ()async {Navigator.pop(context);},
      child: const Text('NO', style: TextStyle(fontWeight: FontWeight.bold),));
    
    Widget forward = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade500,
        ),
      onPressed: ()async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('username');
        await prefs.remove('password');
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()),ModalRoute.withName('/'));
      }, 
      child: const Text('YES', style: TextStyle(fontWeight: FontWeight.bold)));

    AlertDialog popper = AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      actionsAlignment: MainAxisAlignment.center,
      content: const Row(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text("Are you sure to LogOut?", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
        ],
        ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      actions: [
        back,
        const SizedBox(width: 20,),
        forward],
    );

    showDialog(context: context, 
      builder: (BuildContext context){
        return Container(child: popper,);});
  }
}
