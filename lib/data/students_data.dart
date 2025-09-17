import 'dart:math';
import '../models/student.dart';

final List<String> _names = [
  'Alice Johnson', 'Bob Smith', 'Charlie Brown', 'Diana Prince', 'Ethan Clark',
  'Fiona Lewis', 'George Hall', 'Hannah King', 'Ian Moore', 'Julia Scott'
];

final List<String> _departments = [
  'Computer Science', 'Information Technology'
];

final List<String> _domains = [
  'AI/ML', 'Data Science', 'Cybersecurity', 'Web Development'
];

final Random _rand = Random(42);

List<StudentModel> generateSampleStudents({int count = 10}) {
  return List.generate(count, (index) {
    final name = _names[index % _names.length];
    final dept = _departments[_rand.nextInt(_departments.length)];
    final sem = 1 + _rand.nextInt(8); // 1..8
    final domain1 = _domains[_rand.nextInt(_domains.length)];
    String domain2 = _domains[_rand.nextInt(_domains.length)];
    if (domain2 == domain1) {
      domain2 = _domains[(_domains.indexOf(domain1) + 1) % _domains.length];
    }
    final id = '24${dept == 'Computer Science' ? 'BCE' : 'BIT'}${(100 + index).toString()}';
    final email = name.toLowerCase().replaceAll(' ', '.') + '@nirmauni.ac.in';
    return StudentModel(
      id: id,
      name: name,
      department: dept,
      email: email,
      domains: [domain1, domain2],
      currentSemester: sem,
    );
  });
}

final List<StudentModel> sampleStudents = generateSampleStudents();


