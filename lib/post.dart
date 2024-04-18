class Post {
  final String author;
  final List<String> benefits;
  final String company;
  final String description;
  final String location;
  final List<String> requirements;
  final String salary;
  final int timestamp;
  final String title;

  Post({
    required this.author,
    required this.benefits,
    required this.company,
    required this.description,
    required this.location,
    required this.requirements,
    required this.salary,
    required this.timestamp,
    required this.title,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      author: map['author'] ?? 'Unknown Author',
      benefits: List<String>.from(map['benefits'] ?? []),
      company: map['company'] ?? 'Unknown Company',
      description: map['description'] ?? 'No Description',
      location: map['location'] ?? 'Unknown Location',
      requirements: List<String>.from(map['requirements'] ?? []),
      salary: map['salary'] ?? 'Unknown Salary',
      timestamp: map['timestamp'] ?? 0,
      title: map['title'] ?? 'No Title',
    );
  }
}
