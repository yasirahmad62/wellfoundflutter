import 'package:flutter/material.dart';

class PostItem extends StatelessWidget {
  final String author;
  final String title;
  final String description;
  final String location;
  final String salary;
  final String timestamp;

  PostItem({
    required this.author,
    required this.title,
    required this.description,
    required this.location,
    required this.salary,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Posted by $author',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[700],
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: 4.0),
          Container(
            width: 186.0,
            height: 1.0,
            margin: EdgeInsets.only(bottom: 2.0),
            color: Colors.redAccent,
          ),
          SizedBox(height: 8.0),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            description,
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Chip(
                label: Text(location),
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 8.0),
              ),
              SizedBox(width: 8.0),
              Chip(
                label: Text(salary),
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 8.0),
              ),
              SizedBox(width: 8.0),
              Chip(
                label: Text(timestamp),
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 8.0),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
