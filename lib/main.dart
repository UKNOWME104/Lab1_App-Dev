import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/launch_model.dart';


void main() {
  runApp(const MyApp());
}

// Root widget of the app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(title: 'Space Mission Page'),
      debugShowCheckedModeBanner: false,
      // Disable debug banner
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
  Future<List<Launch>> fetchAllLaunches() async {
    final response =
    await http.get(Uri.parse("https://api.spacexdata.com/v3/missions"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      List<Launch> productList = data.map((e) => Launch.fromJson(e)).toList();
      return productList;
    } else {
      throw Exception("Could not find data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Space Missions",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4c00b0),

      ),
      body: FutureBuilder(
        future: fetchAllLaunches(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Launch> launchList = snapshot.data!;
            return ListView.builder(
              itemCount: launchList.length,
              itemBuilder: (context, index) {
                Launch launch = launchList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 5
                  ),
                  child: LaunchElement(launch: launch),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
class LaunchElement extends StatefulWidget {
  final Launch launch;
  const LaunchElement({super.key, required this.launch});

  @override
  State<LaunchElement> createState() => _LaunchElementState();
}

class _LaunchElementState extends State<LaunchElement> {

  bool isFull = false;

  void _toggleFull() {
    setState(() {
      isFull = !isFull;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Name of Mission
            Text(
        widget.launch.missionName!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 26,
          ),
        ),
            //Description of Mission
            Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 6),
              child: Text(widget.launch.description!,
                  overflow: isFull ? null : TextOverflow.ellipsis,
                  maxLines: isFull ? null : 1,
                  style: TextStyle(
                    color: Colors.purple[600],
                    fontSize: 16,
                  )),
            ),


            //Button for more and less
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  backgroundColor:
                  const WidgetStatePropertyAll<Color>(Color(0xFF4c00b0)),
                ),
                onPressed: () {
                  _toggleFull();
                },
                child: isFull
                    ? const Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    "Less",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                  )
                ])
                    : const Row(mainAxisSize: MainAxisSize.min, children: [
                  Text("More",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                  Icon(
                    Icons.arrow_downward,
                    color: Colors.white,
                  )
                ]),
              ),
            ),
            Center(
              child: Wrap(
            children: widget.launch.payloadIds!.map(
                (payload) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: payloadChip(payload),
    ),).toList(),
    ),
            )
          ],
        ),
      ),
    );
  }



  Chip payloadChip(String e) {
    return Chip(
      label: Text(e),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Adjust the radius value to your preference
        ),
      backgroundColor: Colors.primaries[Random().nextInt(Colors.primaries.length)],
    );
  }
}


