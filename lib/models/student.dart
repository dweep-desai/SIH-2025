class StudentModel {
  final String id; // roll no
  final String name;
  final String department;
  final String email;
  final List<String> domains; // area(s) of interest
  final int currentSemester; // 1..8

  const StudentModel({
    required this.id,
    required this.name,
    required this.department,
    required this.email,
    required this.domains,
    required this.currentSemester,
  });
}


