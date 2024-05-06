import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

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
              Text(
                  'PROFILE',
                  style: TextStyle(
                      fontSize: 30, fontWeight: FontWeight.w500, fontFamily: GoogleFonts.averiaLibre().fontFamily),
                ),
              Text('You\'ve got ${widget.percent.toStringAsFixed(1)}% Total Attendance\nAnd this makes you a', style: const TextStyle(fontSize: 18),),
              Center(child: Text(role(widget.percent),style: TextStyle(fontFamily: 'Horizon',fontSize: 90,color: Colors.blue.shade800),)),
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
}
