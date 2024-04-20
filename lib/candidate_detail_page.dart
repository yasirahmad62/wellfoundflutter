import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'candidate.dart';

class CandidateDetailPage extends StatelessWidget {
  final CandidateUser candidate;
  final FirebaseStorage storageReference;

  const CandidateDetailPage({Key? key, required this.candidate, required this.storageReference}) : super(key: key);

  Future<String> getDownloadUrl(String fileName) async {
    String fileNameWithExtension = "$fileName.jpeg";
    return await storageReference.ref().child(fileNameWithExtension).getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    // Extract education details from the education history map
    Map<String, dynamic>? educationDetails = candidate.education_history;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Candidate Details',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.0),
          child: Container(
            color: Color(0xFFd94242),
            height: 2.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image of the user
            FutureBuilder<String>(
              future: getDownloadUrl(candidate.photo_url ?? ''),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Icon(Icons.error);
                } else {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(snapshot.data ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 20.0),
            // Basic info
            ListTile(
              title: Text(
                candidate.name ?? 'Name not available',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Row(
                children: [
                  Icon(Icons.work, size: 16),
                  SizedBox(width: 8),
                  Text(
                    candidate.title ?? 'Title not available',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(width: 20),
                  Icon(Icons.location_on, size: 16),
                  SizedBox(width: 8),
                  Text(
                    candidate.city ?? 'Location not available',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            // Education details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Education Details:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    ListTile(
                      leading: Icon(Icons.school),
                      title: Text(
                        'Degree:',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      subtitle: Text(
                        educationDetails?['degree']?.toString() ?? 'Not available',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.date_range),
                      title: Text(
                        'Graduation Year:',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      subtitle: Text(
                        educationDetails?['graduation_year']?.toString() ?? 'Not available',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.account_balance),
                      title: Text(
                        'University:',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      subtitle: Text(
                        educationDetails?['university']?.toString() ?? 'Not available',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),


            SizedBox(height: 20.0),
            // Button to add to connections
            ElevatedButton(
              onPressed: () async {
                try {
                  final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
                  if (currentUserUid != null) {
                    // Reference to the current user's connections node
                    final userRef = FirebaseDatabase.instance.reference().child('users').child(currentUserUid).child('connections');
                    // Get the candidate's ID
                    final candidateId = candidate.id;

                    // Push the candidate ID to the connections node
                    final newConnectionRef = userRef.push();
                    await newConnectionRef.set(candidateId);

                    // Show a success message
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Candidate added to connections'),
                      duration: Duration(seconds: 2),
                    ));
                  }
                } catch (e) {
                  // Show an error message if adding fails
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Failed to add candidate to connections'),
                    duration: Duration(seconds: 2),
                  ));
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                foregroundColor: MaterialStateProperty.all<Color>(Color(0xFFd94242)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              child: Text('Add to Connections'),
            ),


          ],
        ),
      ),
    );
  }
}
