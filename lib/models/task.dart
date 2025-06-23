class Task {
  final int id;
  final String title;
  final String description;

  Task({required this.id, required this.title, required this.description});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['ID'], // 🔁 match your API key names
      title: json['Title'],
      description: json['Description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'Title': title, 'Description': description};
  }
}
