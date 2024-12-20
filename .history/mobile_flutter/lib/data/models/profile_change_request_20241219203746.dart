enum ProfileChangeStatus {
  pending,
  approved,
  rejecte
}
enum ProfileChangeField {
 email,
 phone,
 emergencyContactName,
 emergencyContactPhone,
 emergencyContactRelationship,
 address

class ProfileChangeRequest {
 final String id;
 final String employeeId;
 final ProfileChangeField field;
 final String oldValue;
 final String newValue;
 final DateTime requestDate;
 final ProfileChangeStatus status;
 final String? rejectionReason;
 final DateTime? reviewedAt;
 final String? reviewedBy;
  ProfileChangeRequest({
   required this.id,
   required this.employeeId,
   required this.field,
   required this.oldValue,
   required this.newValue,
   required this.requestDate,
   this.status = ProfileChangeStatus.pending,
   this.rejectionReason,
   this.reviewedAt,
   this.reviewedBy,
 });
  String get fieldDisplayName {
   switch (field) {
     case ProfileChangeField.email:
       return 'Email Address';
     case ProfileChangeField.phone:
       return 'Phone Number';
     case ProfileChangeField.emergencyContactName:
       return 'Emergency Contact Name';
     case ProfileChangeField.emergencyContactPhone:
       return 'Emergency Contact Phone';
     case ProfileChangeField.emergencyContactRelationship:
       return 'Emergency Contact Relationship';
     case ProfileChangeField.address:
       return 'Address';
   }
 }
