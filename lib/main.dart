import 'package:flutter/material.dart';
import 'package:flutter_application_1/ListElement.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

// Root widget of the app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(title: 'List of Jobs'),
      debugShowCheckedModeBanner: false, // Disable debug banner
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Jobs',
              style: GoogleFonts.robotoSerif(
                fontSize: 22,
                fontWeight: FontWeight.bold, // Bold text for app title
              ),
            ),
            const Icon(
              Icons.notifications_outlined,
              size: 30, // Notification icon
            ),
          ],
        ),
      ),
      body: ListElement(), // Display the list of jobs
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline, size: 30), // Icon for Jobs
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 30), // Icon for Profile
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined, size: 30), // Icon for Settings
            label: 'Settings',
          ),
        ],
        selectedLabelStyle: GoogleFonts.roboto(fontSize: 12), // Font size for label
      ),
    );
  }
}
