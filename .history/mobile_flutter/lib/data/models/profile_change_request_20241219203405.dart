enum ProfileChangeStatus {
  pending,
  approved,
  rejected
}

enum ProfileChangeField {
  email,
  phone,
  emergencyContact,
  address
}

class ProfileChangeRequest {
  final String id;
  final String employeeId;
  final ProfileChangeField field;
  final dynamic oldValue;
  final dynamic newValue;
  final DateTime requestDate;
  final ProfileChangeStatus status;
  final String? rejectionReason;

  ProfileChangeRequest({
    required this.id,
    required this.employeeId,
    required this.field,
    required this.oldValue,
    required this.newValue,
    required this.requestDate,
    this.status = ProfileChangeStatus.pending,
    this.rejectionReason,
  });
}