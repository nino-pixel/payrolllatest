import '../models/user_profile.dart';
import '../models/profile_changes.dart';

class ProfileService {
  static Future<UserProfile> getUserProfile(String employeeId) async {
    // TODO: Implement API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock data
    return UserProfile(
      employeeId: employeeId,
      fullName: 'John Doe',
      email: 'john.doe@company.com',
      phone: '+63 912 345 6789',
      position: 'Software Developer',
      department: 'IT Department',
      profilePicture: '',
      dateHired: DateTime(2023, 3, 15),
      supervisor: 'Jane Smith',
      employmentStatus: 'Full-time',
      emergencyContact: EmergencyContact(
        name: 'Mary Doe',
        relationship: 'Spouse',
        phone: '+63 912 345 6789',
      ),
    );
  }

  static Future<void> updateProfilePicture(String employeeId, String imagePath) async {
    // TODO: Implement API call
    await Future.delayed(const Duration(seconds: 1));
  }

  static Future<void> changePassword(
    String employeeId, 
    String currentPassword, 
    String newPassword
  ) async {
    // TODO: Implement API call
    await Future.delayed(const Duration(seconds: 1));
    
    if (currentPassword == 'wrongpassword') {
      throw Exception('Current password is incorrect');
    }
  }

  static Future<String> submitProfileChangeRequest(
    String employeeId,
    ProfileChangeField field,
    dynamic newValue,
  ) async {
    // TODO: Implement API call
    await Future.delayed(const Duration(seconds: 1));
    return 'REQ${DateTime.now().millisecondsSinceEpoch}';
  }

  static Future<List<ProfileChangeRequest>> getPendingChanges(String employeeId) async {
    // TODO: Implement API call
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }

  static Future<void> cancelChangeRequest(String requestId) async {
    // TODO: Implement API call
    await Future.delayed(const Duration(seconds: 1));
  }
}