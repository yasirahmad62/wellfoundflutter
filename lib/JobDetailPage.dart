import 'package:flutter/material.dart';
import 'JobPosting.dart';

class JobDetailPage extends StatelessWidget {
  final JobPosting jobPosting;

  JobDetailPage({required this.jobPosting});

  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Job Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jobPosting.jobTitle,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Image.network(
                      "https://firebasestorage.googleapis.com/v0/b/wellfoundapplicatio.appspot.com/o/descriptive_logo.png?alt=media&token=d402d159-e2f5-43e7-b8b1-11aac37c7506",
                      height: 60,
                      width: 80,
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${jobPosting.companyInfo}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 16.0,
                                color: Colors.grey),
                            SizedBox(width: 4.0),
                            Text(jobPosting.location),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text('Employment Type: ${jobPosting.employmentType}'),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text('Salary Range: ${jobPosting.salaryRange}'),
                SizedBox(height: 16),
                Text('Deadline: ${jobPosting.deadline.toString()}'),
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.description, size: 24, color: Colors.black),
                    SizedBox(width: 8),
                    Text(
                      'Description:',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  jobPosting.jobDescription,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
