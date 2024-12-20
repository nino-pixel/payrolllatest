import 'dart:io';
import '../models/user_profile.dart';
import '../models/profile_change_request.dart';

class ProfileService {
  // Get user profile
  static Future<UserProfile> getUserProfile(String employeeId) async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      
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
    } catch (e) {
      throw Exception('Failed to load profile: $e');
    }
  }

  // Submit profile change request
  static Future<void> submitProfileChangeRequest({
    required String employeeId,
    required ProfileChangeField field,
    required String currentValue,
    required String newValue,
  }) async {
    try {
      // TODO: Replace with actual API call
      print('Submitting change request:');
      print('Employee ID: $employeeId');
      print('Field: ${field.name}');
      print('Current Value: $currentValue');
      print('New Value: $newValue');
      
      await Future.delayed(const Duration(seconds: 1));
      
      // Simulate validation
      switch (field) {
        case ProfileChangeField.email:
          if (!newValue.contains('@')) {
            throw Exception('Invalid email format');
          }
          break;
        case ProfileChangeField.phone:
        case ProfileChangeField.emergencyContactPhone:
          if (!RegExp(r'^\+?[\d\s-]+$').hasMatch(newValue)) {
            throw Exception('Invalid phone number format');
          }
          break;
        default:
          if (newValue.isEmpty) {
            throw Exception('Value cannot be empty');
          }
      }
    } catch (e) {
      throw Exception('Failed to submit change request: $e');
    }
  }

  // Get pending profile changes
  static Future<List<ProfileChangeRequest>> getPendingChanges(String employeeId) async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      
      return [
        ProfileChangeRequest(
          id: 'CHG001',
          employeeId: employeeId,
          field: ProfileChangeField.phone,
          oldValue: '+63 912 345 6789',
          newValue: '+63 917 123 4567',
          requestDate: DateTime.now().subtract(const Duration(days: 1)),
        ),
        ProfileChangeRequest(
          id: 'CHG002',
          employeeId: employeeId,
          field: ProfileChangeField.emergencyContactPhone,
          oldValue: '+63 912 345 6789',
          newValue: '+63 918 765 4321',
          requestDate: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ];
    } catch (e) {
      throw Exception('Failed to load pending changes: $e');
    }
  }

  // Update profile picture
  static Future<void> updateProfilePicture(String employeeId, File imageFile) async {
    try {
      // TODO: Replace with actual API call
      print('Uploading profile picture for employee: $employeeId');
      
      // Simulate file upload validation
      if (imageFile.lengthSync() > 5 * 1024 * 1024) { // 5MB limit
        throw Exception('Image file size must be less than 5MB');
      }
      
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      throw Exception('Failed to update profile picture: $e');
    }
  }

  // Cancel profile change request
  static Future<void> cancelChangeRequest(String requestId) async {
    try {
      // TODO: Replace with actual API call
      print('Cancelling change request: $requestId');
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      throw Exception('Failed to cancel change request: $e');
    }
  }

  // Change password
  static Future<void> changePassword({
    required String employeeId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      // TODO: Replace with actual API call
      print('Changing password for employee: $employeeId');
      
      // Simulate password validation
      if (currentPassword == 'wrongpassword') {
        throw Exception('Current password is incorrect');
      }
      
      if (newPassword.length < 8) {
        throw Exception('New password must be at least 8 characters long');
      }
      
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }
}