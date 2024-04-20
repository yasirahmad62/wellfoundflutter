import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'candidate_detail_page.dart';

import 'candidate.dart';

class CandidatePage extends StatefulWidget {
  @override
  _CandidatePageState createState() => _CandidatePageState();
}

class _CandidatePageState extends State<CandidatePage> {
  final databaseReference = FirebaseDatabase.instance.reference();
  final storageReference = FirebaseStorage.instance.ref();


  @override
  void initState() {
    super.initState();
    fetchCandidates();
  }
  List<CandidateUser> candidates = []; // Change the type of the list

  Future<void> fetchCandidates() async {
    DatabaseReference usersRef = databaseReference.child('users');
    await for (DatabaseEvent event in usersRef.once().asStream()) {
      if (event.snapshot != null) {
        Map<dynamic, dynamic>? candidatesMap = event.snapshot!.value as Map<dynamic, dynamic>?;
        if (candidatesMap != null) {
          candidatesMap.forEach((key, value) {
            if (key.startsWith('candidate_id_')) {
              CandidateUser candidate = CandidateUser.fromSnapshot(key, value);
              candidates.add(candidate);
            }
          });
          setState(() {});
        }
      } else {
        print('Snapshot is null');
      }
    }
  }

  Future<String> getDownloadUrl(String fileName) async {
    String fileNameWithExtension = "$fileName.jpeg";
    return await storageReference.child(fileNameWithExtension).getDownloadURL();
  }



  @override @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'People you may know',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white), // Set icon color to white
        ),
        body: ListView.builder(
          itemCount: candidates.length,
          itemBuilder: (context, index) {
            CandidateUser candidate = candidates[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Color(0xFFd94242)), // Border color
                ),
                child: ListTile(
                  leading: FutureBuilder<String>(
                    future: getDownloadUrl(candidate.photo_url ?? ''),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircleAvatar(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return CircleAvatar(
                          child: Icon(Icons.error),
                        );
                      } else {
                        return CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(snapshot.data!),
                        );
                      }
                    },
                  ),
                  title: Text(
                    candidate.name ?? '', // Provide a default value if name is null
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18, // Increase font size
                      fontFamily: 'Roboto', // Use a modern font
                    ),
                  ),
                  subtitle: Text(
                    candidate.title ?? '',
                    style: TextStyle(
                      fontSize: 16, // Adjust subtitle font size
                      fontFamily: 'Roboto', // Use the same font for subtitle
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CandidateDetailPage(candidate: candidate, storageReference: FirebaseStorage.instance),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
    );
  }
  }


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Candidate Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CandidatePage(),
    );
  }
}
