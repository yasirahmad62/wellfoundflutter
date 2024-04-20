import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'JobDetailPage.dart';
import 'JobPosting.dart';
import 'JobPostingForm.dart';

class JobListingPage extends StatefulWidget {
  @override
  _JobListingPageState createState() => _JobListingPageState();
}

class _JobListingPageState extends State<JobListingPage> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List<JobPosting> jobPostings = [];

  @override
  void initState() {
    super.initState();
    fetchJobPostings();
  }

  Future<void> fetchJobPostings() async {
    try {
      DatabaseReference jobRef = databaseReference.child('jobposting');
      DataSnapshot snapshot = await jobRef.once().then((snapshot) {
        return snapshot.snapshot;
      });
      if (snapshot.value != null) {
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
        List<JobPosting> postings = [];
        values.forEach((key, value) {
          JobPosting posting = JobPosting(
            jobTitle: value['jobTitle'] ?? "",
            jobDescription: value['jobDescription'] ?? "",
            companyInfo: value['companyInfo'] ?? "",
            location: value['location'] ?? "",
            imageUrl: value['imageUrl'] ?? "",
            employmentType: value['employmentType'] ?? "",
            requiredQualifications: (value['requiredQualifications'] is Iterable)
                ? List<String>.from(value['requiredQualifications'])
                : [],
            preferredQualifications: (value['preferredQualifications'] is Iterable)
                ? List<String>.from(value['preferredQualifications'])
                : [],
            salaryRange: value['salaryRange'] ?? "",
            benefits: (value['benefits'] is Iterable) ? List<String>.from(value['benefits']) : [],
            deadline: value['deadline'] != null ? DateTime.parse(value['deadline']) : DateTime.now(),
          );
          postings.add(posting);
        });
        setState(() {
          jobPostings = postings;
        });
      } else {
        print('No job postings found');
      }
    } catch (error) {
      print('Error fetching job postings: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Job Listings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white), // Set icon color to white
      ),
      body: ListView.builder(
        itemCount: jobPostings.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                title: Text(jobPostings[index].jobTitle),
                subtitle: Row(
                  children: [
                    Icon(Icons.location_on, size: 16.0, color: Colors.grey),
                    SizedBox(width: 4.0),
                    Text(jobPostings[index].location),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobDetailPage(jobPosting: jobPostings[index]),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => JobPostingForm()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: JobListingPage(),
  ));
}
