class UserProfile {
  final String employeeId;
  final String fullName;
  final String email;
  final String phone;
  final String position;
  final String department;
  final String profilePicture;
  final DateTime dateHired;
  final String supervisor;
  final String employmentfinal EmergencyContact emergencyContact;
  UserProfile({
   required this.employeeId,
   required this.fullName,
   required this.email,
   required this.phone,
   required this.position,
   required this.department,
   required this.profilePicture,
   required this.dateHired,
   required this.supervisor,
   required this.employmentStatus,
   required this.emergencyContact,
 });

class EmergencyContact {
 final String name;
 final String relationship;
 final String phone;
  EmergencyContact({
   required this.name,
   required this.relationship,
   required this.phone,
 });
