import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:attendease/screens/profile.dart';
import 'package:attendease/screens/settings.dart';

class Home extends StatefulWidget {
  final String name;

  const Home({super.key, required this.name});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String api = "https://fetcherapi.onrender.com";
  late String userName;
  late String department;
  late String gender;
  late List<Map<String, String>> attendanceData;
  double overallPercentage = 0;
  double selectedThreshold = 0.75; // Default selected percentage
  int flag = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Before you go diving to this code;
  // This code is/was full of trial and errors.
  // I really don't know how I pulled the logic.
  // But the logic works, and if it works let it work. DON'T CHANGE!

  Future<void> fetchData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? username = pref.getString("username");
    String? password = pref.getString("password");

    if (username != null && password != null) {
      Map<String, dynamic> update = {
        "username": username,
        "password": password.toString(),
      };
      final url = Uri.parse(api);
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          body: jsonEncode(update));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        Map<String, dynamic> userData = responseData['user_data'];
        userName = userData['name'];
        department = userData['department_id'];
        gender = userData['gender'];
        setState(() {
          List<dynamic> subjectsData = responseData['subject_data'];
          attendanceData = subjectsData
              .map<Map<String, String>>((subject) => {
                    'subject': subject['subject'] as String,
                    'attendance': subject['attendance'] as String,
                  })
              .toList();
          overallPercentage = calculateOverallPercentage(attendanceData);
        });
        setState(() {
          flag = 1;
        });
      } else {
        print("Failed to fetch attendance data: ${response.statusCode}");
      }
    }
  }

  double calculateOverallPercentage(List<Map<String, String>> attendanceData) {
    int totalAttended = 0;
    int totalClasses = 0;

    for (var subjectData in attendanceData) {
      String attendance = subjectData['attendance'] ?? '';
      List<String> parts = attendance.split('/');
      if (parts.length == 2) {
        totalAttended += int.parse(parts[0]);
        totalClasses += int.parse(parts[1].split(' ')[0]); // Extract total classes from the second part
      }
    }

    return totalClasses > 0 ? totalAttended / totalClasses * 100 : 0;
  }

  String attendanceRequirement(int totalClasses, int attendedClasses) {
    double threshold = selectedThreshold * 100;
    int requiredClass;
    if (attendedClasses >= totalClasses * selectedThreshold) {
      return 'Can skip ${((attendedClasses / selectedThreshold) - totalClasses).floor()} classes till $threshold%';
    } else {
      if (threshold == 90) {
        requiredClass = (9 * totalClasses) - (8 * attendedClasses);
        return 'Need to attend $requiredClass classes for $threshold%';
      } else if (threshold == 85) {
        requiredClass = (7 * totalClasses) - (6 * attendedClasses);
        return 'Need to attend $requiredClass classes for $threshold%';
      } else if (threshold == 80) {
        requiredClass = (5 * totalClasses) - (4 * attendedClasses);
        return 'Need to attend $requiredClass classes for $threshold%';
      } else {
        requiredClass = (3 * totalClasses) - (4 * attendedClasses);
        return 'Need to attend $requiredClass classes for $threshold%';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (flag == 0) {
      return Scaffold(
        bottomNavigationBar: const BottomAppBar(
            surfaceTintColor: Colors.white,
            child: Center(
                child: Text(
              'Please Wait. Its Worth It :)',
              style: TextStyle(fontSize: 15),
            ))),
        body: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 20.0, height: 100.0),
              const Text(
                'Be',
                style: TextStyle(fontSize: 43.0),
              ),
              const SizedBox(width: 20.0, height: 100.0),
              DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 40.0,
                  fontFamily: 'Horizon',
                ),
                child: AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    RotateAnimatedText('AWESOME',
                        textStyle: const TextStyle(color: Colors.white)),
                    RotateAnimatedText('OPTIMISTIC',
                        textStyle: const TextStyle(color: Colors.white)),
                    RotateAnimatedText('DIFFERENT',
                        textStyle: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'HOME',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w500),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: const ProfilePage(),
                                        type: PageTransitionType.rightToLeft));
                              },
                              child: const Icon(Icons.account_circle_rounded,
                                  size: 35.0)),
                          const SizedBox(width: 15,),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: const Settings(),
                                        type: PageTransitionType.rightToLeft));
                              },
                              child: const Icon(Icons.settings, size: 35.0)),
                        ],
                      ),
                    ],
                  ),
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
                  const Text('Hope you enjoy AttendEase! As it says;\nAttend Classes with Ease!'),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Attendance Percentage:',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: Center(
                            child: CircularPercentIndicator(
                                radius: 40.0,
                                animation: true,
                                animationDuration: 3000,
                                lineWidth: 6,
                                circularStrokeCap: CircularStrokeCap.round,
                                percent: overallPercentage / 100,
                                progressColor: progColor(overallPercentage),
                                center: Text(
                                  '${overallPercentage.toStringAsFixed(1)}%',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'Subject-Wise Attendance Data:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      const Expanded(
                        flex: 3,
                        child: Text(
                          'Selected your target percentage:',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: DropdownButton<double>(
                          iconEnabledColor: Colors.white,
                          iconDisabledColor: Colors.black,
                          borderRadius: BorderRadius.circular(7),
                          autofocus: true,
                          isDense: true,
                          value: selectedThreshold,
                          onChanged: (newValue) {
                            setState(() {
                              selectedThreshold = newValue!;
                            });
                          },
                          items: const <DropdownMenuItem<double>>[
                            DropdownMenuItem(
                              value: 0.75,
                              child: Text('75%'),
                            ),
                            DropdownMenuItem(
                              value: 0.8,
                              child: Text('80%'),
                            ),
                            DropdownMenuItem(
                              value: 0.85,
                              child: Text('85%'),
                            ),
                            DropdownMenuItem(
                              value: 0.9,
                              child: Text('90%'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: attendanceData.length,
                    itemBuilder: (context, index) {
                      String subject = attendanceData[index]['subject'] ?? '';
                      String attendance =
                          attendanceData[index]['attendance'] ?? '';
                      List<String> attendedParts = attendance.split(' ');
                      String attended =
                          attendedParts.isNotEmpty ? attendedParts.first : '0';
                      int total = 0;
                      double percentage = 0;
                      if (subject == 'Total' || subject == 'Percentage') {
                        return const SizedBox.shrink();
                      }
                      if (attendedParts.isNotEmpty &&
                          attendedParts.first.contains('/')) {
                        List<String> parts = attendedParts.first.split('/');
                        if (parts.length == 2) {
                          attended = parts.first;
                          total = int.tryParse(parts.last.replaceAll(RegExp(r'[()]'), '')) ?? 0;
                          percentage = double.tryParse(attendedParts.last.replaceAll(RegExp(r'[()]'), '').replaceAll('%', '')) ?? 0 / 100;
                        }
                      }
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    subject,
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    attendance,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    total > 0
                                        ? attendanceRequirement(total, int.parse(attended))
                                        : 'Attendance not entered',
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: Center(
                                child: CircularPercentIndicator(
                                    radius: 40.0,
                                    animation: true,
                                    animationDuration: 3000,
                                    lineWidth: 6,
                                    circularStrokeCap: CircularStrokeCap.round,
                                    percent: percentage / 100,
                                    progressColor: progColor(percentage),
                                    center: Text(
                                      '${percentage.toStringAsFixed(1)}%',
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Color progColor(percentage) {
    if (percentage >= 90) {
      return Colors.green;
    } else if (percentage >= 85 && percentage < 90) {
      return Colors.green.shade400;
    } else if (percentage >= 80 && percentage < 85) {
      return Colors.green.shade200;
    } else if (percentage >= 75 && percentage < 80) {
      return Colors.red.shade300;
    } else {
      return Colors.red;
    }
  }
}
