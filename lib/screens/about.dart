import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _SettingsState();
}

class _SettingsState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ABOUT',
                    style: TextStyle(
                    fontSize: 30, fontWeight: FontWeight.w500, fontFamily: GoogleFonts.averiaLibre().fontFamily),
                  ),
                  const SizedBox(height: 10,),                  
                  const Text('AttendEase is all about students being free. Students should be allowed the flexibility of the classes they attend. And this is the same reason why AttendEase exists!', style: TextStyle(fontSize: 15),textAlign: TextAlign.justify,),
                  const SizedBox(height: 20,),
                  const Text('NOTE:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  const Text('AttendEase will not ever endorse the skipping of classes. Students must take responsibility for their actions', style: TextStyle(fontSize: 15),textAlign: TextAlign.justify,),
                ],
              ),
               Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('DEVELOPER', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17,color: Colors.amber),), 
                  const Text('Pranav M, SCTCE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  Row(
                    children: [
                      const Text('Follow me here!:'),
                      const SizedBox(width: 20,),
                      GestureDetector(
                        onTap: () async{
                          final Uri url = Uri.parse("https://github.com/trulyPranav");
                          await launchUrl(url);
                        },
                        child: const ImageIcon(AssetImage('assets/github.png'), size: 45, ),
                      ),
                      const SizedBox(width: 10,),
                      GestureDetector(
                        onTap: () async{
                          final Uri url = Uri.parse("https://instagram.com/pranav072_");
                          await launchUrl(url);
                        },
                        child: const ImageIcon(AssetImage('assets/insta.png'), size: 60, ),
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () async{
                      final Uri url = Uri.parse("https://github.com/trulyPranav/AttendEase");
                      await launchUrl(url);
                    },
                    child: const Text('Click Here for Project Source Code.\nStar the Repo! It\'ll do noting but motivate!\nFeel free to PR and contribute!', style: TextStyle(fontSize: 15,decoration: TextDecoration.underline),),
                  ),
                ],
              ),
              Center(
                child: ElevatedButton
                (
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700
                ),
                onPressed: (){okbie(context);},
                child: const Text('Click!')),
              )
            ],
          ),
        ),
      ),
    );
  }
  okbie(BuildContext context){
    Widget getOut =  ElevatedButton(onPressed: () async{
      Navigator.pop(context);
    }, child: const Text('Go Back', style: TextStyle(fontWeight: FontWeight.bold)));

    Widget yesDone = ElevatedButton(onPressed: () async{
      final Uri url = Uri.parse("upi://pay?pa=pranavm265@okaxis&pn=Pranav M&aid=uGICAgMCyyNLGQw");
      await launchUrl(url);
    }, child: const Text('Sure! Let\'s Go!', style: TextStyle(fontWeight: FontWeight.bold)));

    AlertDialog allIsWell = AlertDialog(
    actionsAlignment: MainAxisAlignment.center,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    title: const Center(child: Text("Buy me a Coffee :)",style: TextStyle(fontWeight: FontWeight.bold),)),
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    content: const Text("A huge amount of time and resources is invested in building these projects; Supporting will help to develop further versions of the application with even more features along with support for IOS :)"),
    actions: [
      getOut,
      SizedBox(width:  MediaQuery.of(context).size.width / 18,),
      yesDone,
    ],
  );

  showDialog(context: context, builder: (BuildContext context) => Container(child: allIsWell,));
  }
}

