import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:wellfoundapplicaiton/post.dart';

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
    print(_user.uid);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feeds'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_user.email ?? ''),
          ),
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _posts.isEmpty
          ? Center(child: Text('No posts yet'))
          :ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_posts[index].title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Author: ${_posts[index].author}'),
                Text('Company: ${_posts[index].company}'),
                Text('Description: ${_posts[index].description}'),
                Text('Location: ${_posts[index].location}'),
                Text('Salary: ${_posts[index].salary}'),
                Text('Timestamp: ${DateTime.fromMillisecondsSinceEpoch(_posts[index].timestamp)}'),
              ],
            ),
            onTap: () {
              // Handle feed item tap
            },
          );
        },
      ),
    );
  }
}
