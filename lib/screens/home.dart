import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Home extends StatefulWidget {
  final String name;
  final Map<String, dynamic> responseData;

  const Home({Key? key, required this.name, required this.responseData}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String userName;
  late String department;
  late String gender;
  late List<Map<String, String>> attendanceData;
  double overallPercentage = 0; // Initialize overallPercentage

  @override
  void initState() {
    super.initState();
    fetchData(widget.responseData);
  }

// Before you go diving to this code; 
// This code is/was full of trial and errors. 
// I really don't know how I pulled the logic.
// But the logic works, and if it works let it work. DON'T CHANGE!

  Future<void> fetchData(Map<String, dynamic> responseData) async {
    // Extract user data
    Map<String, dynamic> userData = responseData['user_data'];
    userName = userData['name'];
    department = userData['department_id'];
    gender = userData['gender'];
    List<dynamic> subjectsData = responseData['subject_data'];
    attendanceData = subjectsData
        .map<Map<String, String>>((subject) => {
              'subject': subject['subject'] as String,
              'attendance': subject['attendance'] as String,
            })
        .toList();
    overallPercentage = calculateOverallPercentage(attendanceData);
    setState(() {});
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome \n         $userName',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),),
                const Text('Hope you enjoy AttendEase! As it says;\nAttend Classes with Ease!'),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Total Attendence Percentage:',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: Stack(
                          children: [
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: CircularProgressIndicator(
                                value: overallPercentage / 100,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                strokeWidth: 5,
                              ),
                            ),
                            Center(
                              child: Text(
                                '${overallPercentage.toStringAsFixed(1)}%',
                                style: const TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),                      
                    ],
                  ),
                ),
                const Text('Subject-Wise Attendance Data:', 
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: attendanceData.length,
                  itemBuilder: (context, index) {
                    String subject = attendanceData[index]['subject'] ?? '';
                    String attendance = attendanceData[index]['attendance'] ?? '';
                    List<String> attendedParts = attendance.split(' ');
                    String attended = attendedParts.isNotEmpty ? attendedParts.first : '0';
                    int total = 0;
                    double percentage = 0;
                    if (subject == 'Total' || subject == 'Percentage') {
                      return const SizedBox.shrink(); // Don't show this, API dumb hehe
                    }
                    if (attendedParts.isNotEmpty && attendedParts.first.contains('/')) {
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
                        color: Colors.grey[200],
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
                                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  attendance,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  total > 0
                                      ? percentage >= 0.75
                                      ? 'Can cut ${(int.parse(attended) / 0.75 - total).floor()} classes safely till 75%'
                                      : 'Need to attend ${(3 * total - 4 * int.parse(attended)).toString()} classes for 75%'
                                      : 'Attendance not entered',
                                      style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: CircularProgressIndicator(
                                    value: percentage / 100,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                    strokeWidth: 5,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    '${percentage.toStringAsFixed(1)}%',
                                    style: const TextStyle(fontSize: 16, color: Colors.black),
                                  ),
                                ),
                              ],
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
