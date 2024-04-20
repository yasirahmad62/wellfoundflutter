import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:wellfoundapplicaiton/JobListing.dart';
import 'package:wellfoundapplicaiton/post.dart';
import 'candidatepage.dart';

class FeedsPage extends StatefulWidget {
  const FeedsPage({Key? key}) : super(key: key);

  @override
  _FeedsPageState createState() => _FeedsPageState();
}

class _FeedsPageState extends State<FeedsPage> {
  late User _user;
  List<String> _connectedUserIds = [];
  List<Post> _posts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _fetchConnectedUserIds();
  }

  Future<void> _fetchConnectedUserIds() async {
    DatabaseReference userRef = FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(_user.uid);

    userRef.child('connections').onValue.listen((event) {
      // Use event.snapshot to access the DataSnapshot
      DataSnapshot snapshot = event.snapshot;
      print('Snapshot value: ${snapshot.value}');
      if (snapshot.value != null && snapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> dataMap = snapshot.value as Map<dynamic, dynamic>;
        List<String> connectedUserIds = [];
        dataMap.forEach((key, value) {
          if (key is String && value is String) {
            connectedUserIds.add(value);
          }
        });
        setState(() {
          _connectedUserIds = connectedUserIds;
        });
        print(connectedUserIds);

        _fetchConnectedUsersPosts();
      } else {
        print('Snapshot value is null or not a map');
      }
    }, onError: (error) {
      print('Error fetching connected user IDs: $error');
    });
  }

  Future<void> _fetchConnectedUsersPosts() async {
    List<Post> posts = [];
    for (var userId in _connectedUserIds) {
      DatabaseReference userFeedRef = FirebaseDatabase.instance
          .reference()
          .child('users')
          .child(userId)
          .child('feed');
      // Use `once()` to retrieve a single snapshot of the data
      DataSnapshot feedSnapshot = await userFeedRef.once().then((snapshot) {
        return snapshot.snapshot;
      });

      if (feedSnapshot.value != null) {
        // Explicitly cast feedSnapshot.value to List<dynamic>
        List<dynamic> feedDataList = (feedSnapshot.value as List<dynamic>);
        feedDataList.forEach((feedItem) {
          if (feedItem is Map<Object?, Object?>) {
            // Cast keys and values to String and dynamic
            Map<String, dynamic> feedMap = feedItem.map((key, value) =>
                MapEntry(key.toString(), value)); // Cast keys to String
            // Now feedMap is of type Map<String, dynamic>
            // Now you can use feedMap to create your Post object
            posts.add(Post.fromMap(feedMap));
          }
        });
      } else {
        print('Feed data is null');
      }
    }

    setState(() {
      _posts.addAll(posts);
      _loading = false;
    });
  }
  @override
  String getTimeDifference(int timestamp) {
    if (timestamp == null) return '';

    final postTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(postTime);

    if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '7+';
    }
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Feeds',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        bottom: PreferredSize(
          child: Container(
            color: Color(0xFFd94242),
            height: 2.0,
          ),
          preferredSize: Size.fromHeight(2.0),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Image.network(
            'https://firebasestorage.googleapis.com/v0/b/wellfoundapplicatio.appspot.com/o/app_logo.jpeg?alt=media&token=a4f478a0-47ac-4bd1-af36-22aa216f82b3',
            width: 40,
            height: 40,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              // Navigate to user profile page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JobListingPage()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Jobs',
                style: TextStyle(color: Colors.white), // Set text color to white
              ),
            ),
          ),
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _posts.isEmpty
          ? Center(child: Text('No posts yet'))
          : SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Posted by ${_posts[index].author}',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${_posts[index].title} at ${_posts[index].company}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            _posts[index].description,
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child:Row(
                                children: [
                                  Chip(label: Text(_posts[index].location)),
                                  SizedBox(width: 8),
                                  Chip(label: Text(_posts[index].salary)),
                                  SizedBox(width: 8),
                                  Chip(label: Text(getTimeDifference(_posts[index].timestamp))),
                                ],
                              ),

                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CandidatePage()),
          );
        },
        child: Icon(Icons.add),
      ),
      backgroundColor: Colors.white, // Background color of the scaffold
    );
  }

}
