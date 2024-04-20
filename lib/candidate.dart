class CandidateUser {
  final String id;
  final String? name;
  final String? photo_url;
  final String? title;
  final Map<String, dynamic>? connections;
  final List<Post>? feed;
  final String? city;
  final Map<String, dynamic>? education_history; // Change to Map<String, dynamic>

  CandidateUser({
    required this.id,
    this.name,
    this.connections,
    this.feed,
    this.photo_url,
    this.title,
    this.city,
    this.education_history,
  });

  factory CandidateUser.fromSnapshot(String id, Map<dynamic, dynamic> snapshot) {
    return CandidateUser(
      id: id,
      name: snapshot['name'] as String?,
      photo_url: snapshot["photo_url"] as String?,
      title: snapshot["title"] as String?,
      connections: snapshot['connections'] != null ? Map<String, dynamic>.from(snapshot['connections'] as Map<dynamic, dynamic>) : null,
      feed: snapshot['feed'] != null ? _parsePosts(snapshot['feed'] as List<dynamic>) : null,
      city: snapshot['city'] as String?,
      education_history: snapshot['education_history'] != null ? Map<String, dynamic>.from(snapshot['education_history'] as Map<dynamic, dynamic>) : null,
    );
  }

  static List<Post> _parsePosts(List<dynamic> feed) {
    return feed.map((post) => Post.fromMap(post)).toList();
  }
}

class EducationHistory {
  final String? degree;
  final String? graduation_year;
  final String? university;

  EducationHistory({
    this.degree,
    this.graduation_year,
    this.university,
  });

  factory EducationHistory.fromMap(Map<String, dynamic> map) { // Change fromMap parameters to Map<String, dynamic>
    return EducationHistory(
      degree: map['degree'],
      graduation_year: map['graduation_year'],
      university: map['university'],
    );
  }
}

class Post {
  final String author;
  final List<String>? benefits;
  final String company;
  final String description;
  final String location;
  final List<String>? requirements;
  final String salary;
  final int timestamp;
  final String title;

  Post({
    required this.author,
    this.benefits,
    required this.company,
    required this.description,
    required this.location,
    this.requirements,
    required this.salary,
    required this.timestamp,
    required this.title,
  });

  factory Post.fromMap(Map<dynamic, dynamic> map) {
    return Post(
      author: map['author'] ?? '',
      benefits: map['benefits'] != null ? List<String>.from(map['benefits']) : null,
      company: map['company'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      requirements: map['requirements'] != null ? List<String>.from(map['requirements']) : null,
      salary: map['salary'] ?? '',
      timestamp: map['timestamp'] ?? 0,
      title: map['title'] ?? '',
    );
  }
}
