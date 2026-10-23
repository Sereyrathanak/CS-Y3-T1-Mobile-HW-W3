// import 'dart:math';

import 'package:lms_layered_architecture_example/model/course.dart';
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


    lms.addCourse(courseId: 'C01',courseName: 'Mobile Development',);

    expect(lms.courses.length, 1);
    expect(lms.courses.first.id, 'C01');
    expect(lms.courses.first.name, 'Mobile Development');

    lms.removeCourse(courseId: 'C01');
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

  test('Reject nonexistent student enrollment', () {
    final lms = LmsSystem();

    lms.addCourse(courseId: 'C01',courseName: 'Mobile Development',);

    expect(
      () => lms.enrollStudent(studentId: 'S99',courseId: 'C01',),
      throwsException,
    );
  });

  test('Reject nonexistent course enrollment', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S01',studentName: 'ronan',);

    expect(
      () => lms.enrollStudent(studentId: 'S01',courseId: 'C99',),
      throwsException,
    );
  });

  test('Reject duplicate enrollment', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S01',studentName: 'ronan',);
    lms.addCourse(courseId: 'C01',courseName: 'Mobile Development',);
    lms.enrollStudent(studentId: 'S01', courseId: 'C01',);

    expect(
      () => lms.enrollStudent(studentId: 'S01',courseId: 'C01',),
      throwsException,
    );

    // Verify that only one enrollment exists
    expect(lms.courses.first.studentIds.length, 1);
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

    lms.addStudent(studentId: 'S01',studentName: 'ronan',);

    lms.addCourse(courseId: 'C01', courseName: 'Mobile Development',);
    lms.enrollStudent(studentId: 'S01',courseId: 'C01', );

    expect(lms.courses.first.studentIds.contains('S01'), true);
    expect(lms.courses.first.studentIds.length, 1);
  });


  test("Remove an existing enrollment", (){
    final lms = LmsSystem(); 

    lms.addStudent(studentId: "S01", studentName: "ronan"); 
    lms.addCourse(courseId: "C01", courseName: "Mobile Development");
    lms.enrollStudent(studentId: "S01", courseId: "C01"); 
    lms.discardStudentFromCourse(studentId: "S01", courseId: "C01");

    expect(
      lms.courses.first.studentIds.contains("S01"), 
      false,
    );
  }); 

  test("Reject removal of nonexistent enrollment", (){
    final lms = LmsSystem(); 
    
    lms.addStudent(studentId: "S01", studentName: "Rathanak"); 
    lms.addCourse(courseId: "C01", courseName: "Flutter"); 
    

    expect(
      () => lms.discardStudentFromCourse(studentId: "S01", courseId: "C01"), 
      throwsException,
    
    );
  }); 

  test("Student and course still exist after enrollment removal", (){
    final lms = LmsSystem(); 

    lms.addStudent(studentId: "S02", studentName: "juju"); 
    lms.addCourse(courseId: "C02", courseName: "Frontend Development"); 
    lms.enrollStudent(studentId: "S02", courseId: "C02"); 
    lms.discardStudentFromCourse(studentId: "S02", courseId: "C02"); 

    expect(lms.courses.length, 1); 
    expect(lms.courses.first.id, "C02"); 
    expect(lms.courses.first.studentIds.isEmpty, true); 
  });

  test("Removing enrollment also removes associated results", (){
    final lms = LmsSystem(); 

    lms.addStudent(studentId: "S03", studentName: "Jenny"); 
    lms.addCourse(courseId: "C03", courseName: "Backend Development"); 
    lms.enrollStudent(studentId: "S03", courseId: "C03"); 
    lms.addResult(studentId: "S03", courseId: "C03", score: 85); 

  });

  test('Remove student enrolled in multiple courses', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S01',studentName: 'ronan');

    lms.addStudent(studentId: 'S02',studentName: 'dara',);


    lms.addCourse(courseId: 'C01',courseName: 'Mobile Development',);
    lms.addCourse(courseId: 'C02',courseName: 'Web Development',);
    lms.enrollStudent(studentId: 'S01',courseId: 'C01',);
    lms.enrollStudent(studentId: 'S01',courseId: 'C02',);
    lms.enrollStudent(studentId: 'S02',courseId: 'C01',);
    lms.removeStudent(studentId: 'S01');
  
    expect(
      lms.students.any((s) => s.id == 'S01'),
      false,
    );

    for (Course course in lms.courses) {
      expect(
        course.studentIds.contains('S01'),
        false,
      );
    }
    expect(lms.courses.length, 2);
    expect(lms.students.length, 1);
    expect(lms.students.first.id, 'S02');

    expect(
      lms.courses.first.studentIds.contains('S02'),
      true,
    );
  });

  test('Add valid result', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S01',studentName: 'ronan',);
    lms.addCourse(courseId: 'C01',courseName: 'Mobile Development',);
    lms.enrollStudent(studentId: 'S01',courseId: 'C01',);
    lms.addResult(studentId: 'S01',courseId: 'C01',score: 85,);

    expect(lms.results.length, 1);
    expect(lms.results.first.studentId, 'S01');
    expect(lms.results.first.courseId, 'C01');
    expect(lms.results.first.score, 85);
  });

  test('Reject result for nonexistent student', () {
    final lms = LmsSystem();

    lms.addCourse(courseId: 'C01',courseName: 'Mobile Development',);

    expect(
      () => lms.addResult(studentId: 'S99',courseId: 'C01',score: 85,),
      throwsException,
    );

    expect(lms.results.length, 0);
  });

  test('Reject result for nonexistent course', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S01',studentName: 'ronan',);

    expect(
      () => lms.addResult(studentId: 'S01',courseId: 'C99',score: 85,),
      throwsException,
    );

    expect(lms.results.length, 0);
  });

  test('Reject result for student not enrolled', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S01',studentName: 'ronan',);


    lms.addCourse(courseId: 'C01',courseName: 'Mobile Development',);

    expect(
      () => lms.addResult(studentId: 'S01',courseId: 'C01',score: 85,),
      throwsException,
    );

    expect(lms.results.length, 0);
  });

  test('Reject invalid score', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S01',studentName: 'ronan',);
    lms.addCourse(courseId: 'C01',courseName: 'Mobile Development',);
    lms.enrollStudent(studentId: 'S01',courseId: 'C01',);

    expect(
      () => lms.addResult(studentId: 'S01',courseId: 'C01',score: 150,),
      throwsException,
    );

    expect(lms.results.length, 0);
});

 }
