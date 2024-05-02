import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    fetchData(widget.responseData);
  }

  Future<void> fetchData(Map<String, dynamic> responseData) async {
    // Extract user data
    Map<String, dynamic> userData = responseData['user_data'];
    userName = userData['name'];
    department = userData['department_id'];
    gender = userData['gender'];

    // Extract attendance data
    List<dynamic> subjectsData = responseData['subject_data'];
    attendanceData = subjectsData
        .map<Map<String, String>>((subject) => {
              'subject': subject['subject'] as String,
              'attendance': subject['attendance'] as String,
            })
        .toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Welcome, ${widget.name}!'),
                const SizedBox(height: 20),
                Text('User Name: $userName'),
                Text('Department: $department'),
                Text('Gender: $gender'),
                const SizedBox(height: 20),
                Text('Attendance Data:'),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: attendanceData.length,
                  itemBuilder: (context, index) {
                    // Extracting values from attendanceData
                    String subject = attendanceData[index]['subject'] ?? ''; // Provide a default value if null
                    String attendance = attendanceData[index]['attendance'] ?? '';
                    List<String> attendedParts = attendance.split(' ');
                    String attended = attendedParts.isNotEmpty ? attendedParts.first : '0';
                    int total = 0;
                    double percentage = 0;

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
                                      ? 'Can cut ${(int.parse(attended) / 0.75 - total).floor()} classes'
                                      : 'Need to attend ${(3 * total - 4 * int.parse(attended)).toString()} classes'
                                      : 'Attendance not entered',
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
