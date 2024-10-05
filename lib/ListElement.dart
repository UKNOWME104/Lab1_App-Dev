import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

class ListElement extends StatefulWidget {
  const ListElement({super.key});

  @override
  State<ListElement> createState() => _ListElementState();
}

class _ListElementState extends State<ListElement> {

  // Fetch jobs from API
  Future<List<Job>> fetchAllJobs() async {
    final response = await http.get(Uri.parse('https://mpa0771a40ef48fcdfb7.free.beeceptor.com/jobs'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(utf8.decode(response.body.codeUnits));
      List<dynamic> jobsList = jsonResponse['data'];
      return jobsList.map((job) => Job.fromJson(job['job'])).toList();
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<Job>>(
        future: fetchAllJobs(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return const Text('Error');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final job = snapshot.data![index];
                String timeAgo = timeago.format(job.updatedDate);

                return Card(
                  key: ValueKey(index),
                  margin: const EdgeInsets.all(12.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Company logo with rounded corners
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                job.companyLogo,
                                width: 70,
                                height: 70,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    job.title,
                                    style: GoogleFonts.robotoSerif(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    job.companyName,
                                    style: GoogleFonts.robotoSerif(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '${job.location}, ${job.workPlace}, ${job.jobType}',
                                    style: GoogleFonts.robotoSerif(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            timeAgo,
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

// Job model class
class Job {
  final String title;
  final String location;
  final String companyName;
  final String companyLogo;
  final String jobType;
  final String workPlace;
  final DateTime updatedDate;

  Job({
    required this.title,
    required this.location,
    required this.companyName,
    required this.companyLogo,
    required this.jobType,
    required this.workPlace,
    required this.updatedDate,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      title: json['title'] ?? 'No Title',
      companyName: json['company']?['name'] ?? 'No Company',
      companyLogo: json['company']?['logo'] ?? 'Default',
      location: json['location']?['name_en'] ?? 'Unknown Location',
      workPlace: json['workplace_preference']?['name_en'] ?? 'Default',
      jobType: json['type']?['name_en'] ?? 'N/A',
      updatedDate: DateTime.parse(json['updated_date']),
    );
  }
}
