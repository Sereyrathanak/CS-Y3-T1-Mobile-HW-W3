// import 'dart:io';

import 'dart:math';

import '../model/course.dart';
import '../model/courseResult.dart';
import '../model/student.dart';

class LmsSystem {
  final List<Student> students = [];
  final List<Course> courses = [];
  final List<CourseResult> results = [];
  int nextResultId = 1; 
 
  void addStudent({required String studentId, required String studentName}) {
    // ! Student shall not exist already

    Student? student = _findStudentOrNull(studentId);
    if (student != null) {
      throw Exception('Student $studentId already exists');
    }
    students.add(Student(id: studentId, name: studentName));
  }
 
 
  void removeStudent({required String studentId}) {
    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }
    // 1- Remove student from the students list
    students.removeWhere((student) => student.id == studentId);

    for (Course course in courses){
      course.studentIds.remove(studentId); 
    }

    results.removeWhere((result) => result.studentId == studentId);
  }

  Student? _findStudentOrNull(String studentId) {
    for (Student s in students) {
      if (s.id == studentId) {
        return s;
      }
    }
    return null;
  } 

  void addCourse({required String courseId, required String courseName}){
    for (Course course in courses){
      if (course.id == courseId){
        throw Exception("Course $courseId are already exist."); 
      }
    }
    courses.add(Course(id: courseId, name: courseName)); 
  }

  Course? _findCourseOrNull(String courseId) {
    for (Course course in courses) {
      if (course.id == courseId) {
        return course;
      }
    }
    return null; 
  }

  void removeCourse({required String courseId}) {
    Course? course = _findCourseOrNull(courseId);
    if (course == null) {
      throw Exception("Course $courseId not found");
    }

    courses.removeWhere((course) => course.id == courseId);
    results.removeWhere((result) => result.courseId == courseId);
  }
  
  void enrollStudent({required String studentId, required String courseId}){
    Student? student = _findStudentOrNull(studentId);
      if (student == null){
        throw Exception("Student $studentId not found ");
      }
    Course? course = _findCourseOrNull(courseId); 
      if (course == null){
        throw Exception("Course $courseId not found"); 
      }
    if(course.studentIds.contains(studentId)){
      throw Exception("Student already enrolled"); 
    }
    course.studentIds.add(studentId); 
  }

  void discardStudentFromCourse({required String studentId, required String courseId,}) {
    Student? student = _findStudentOrNull(studentId);

    if (student == null) {
     throw Exception("Student $studentId not found");
    }

    Course? course = _findCourseOrNull(courseId);
    if (course == null) {
      throw Exception("Course $courseId not found");
    }

    if (!course.studentIds.contains(studentId)) {
      throw Exception("Student is not enrolled in this course");
    }
    course.studentIds.remove(studentId);

    results.removeWhere((result) =>result.studentId == studentId && result.courseId == courseId,
      );
  }

  void addResult({required String studentId, required String courseId,required int score, }){
    Student? student = _findStudentOrNull(studentId); 
    if (student == null){
      throw Exception("Student $studentId not found"); 
    }

    Course? course = _findCourseOrNull(courseId); 
    if (course == null){
      throw Exception("Course $courseId not Found"); 
    }

    if(!course.studentIds.contains(studentId)){
      throw Exception("Student is not enrolled in this course"); 
    }

    if(score < 0 || score > 100){
      throw Exception("Invalid Score"); 
    }

    for (CourseResult result in results){
      if (result.studentId == studentId && result.courseId == courseId){
        throw Exception("Result already exists"); 
      }
    }

    results.add(CourseResult(id: nextResultId, studentId: studentId, courseId: courseId, score: score)); 
  }



    

}
