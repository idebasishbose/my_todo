class Todo {
  Todo(this.name, this.description, this.completeBy, this.priority);

  int id;
  String name;
  String description;
  String completeBy;
  int priority;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'completeBy': completeBy,
      'priority': priority,
    };
  }

  static Todo fromMap(Map<String, dynamic> map) {
    return Todo(
      map['name'],
      map['description'],
      map['completeBy'],
      map['priority'],
    );
  }
}
