
class Student {
  final int? id;
  final String name;
  final String studentCode;
  final String major;

  Student({
    this.id,
    required this.name,
    required this.studentCode,
    required this.major,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'student_code': studentCode,
      'major': major,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as int?,
      name: map['name'] as String,
      studentCode: map['student_code'] as String,
      major: map['major'] as String,
    );
  }
}
