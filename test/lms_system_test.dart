import 'package:test/test.dart';
// import '../service/lms_system.dart';
import 'package:lms_layered_architecture_example/service/lms_system.dart';

void main() {
  test('creates a student', () {
    final lms = LmsSystem();

    // Create a student
    lms.addStudent(studentId: 'S1', studentName: "ronan");
    expect(lms.students.first.name, 'ronan');
    
    // Remove the student
    lms.removeStudent(studentId: 'S1');
    expect(lms.students.length, 0);
  });

  
  test('Add and remove a course', () {
    final lms = LmsSystem();

    // Step 1: Add a course
    lms.addCourse(
      courseId: 'C01',
      courseName: 'Mobile Development',
    );

    // Step 2: Check if course exists
    expect(lms.courses.length, 1);
    expect(lms.courses.first.id, 'C01');
    expect(lms.courses.first.name, 'Mobile Development');

    // Step 3: Remove the course
    lms.removeCourse(courseId: 'C01');

    // Step 4: Verify course is removed
    expect(lms.courses.length, 0);
  });


  test('Reject duplicate course ID', () {
    final lms = LmsSystem();
    lms.addCourse(courseId: 'C01',courseName: 'Mobile Development',);

    expect(() => lms.addCourse(courseId: 'C01',courseName: 'Web Development',),
      throwsException,
    );
    expect(lms.courses.length, 1);
    expect(lms.courses.first.name, 'Mobile Development');
  });

  test('Reject removal of nonexistent course', () {
    final lms = LmsSystem();
    expect(
      () => lms.removeCourse(courseId: 'C99'),
      throwsException,
    );

    expect(lms.courses.length, 0);
  });


  test('Enroll an existing student in an existing course', () {
  final lms = LmsSystem();

  // Step 1: Create a student
  lms.addStudent(
    studentId: 'S01',
    studentName: 'ronan',
  );

  lms.addCourse(courseId: 'C01', courseName: 'Mobile Development',);
  lms.enrollStudent(studentId: 'S01',courseId: 'C01', );

  expect(lms.courses.first.studentIds.contains('S01'), true);
  expect(lms.courses.first.studentIds.length, 1);
  });

 }
