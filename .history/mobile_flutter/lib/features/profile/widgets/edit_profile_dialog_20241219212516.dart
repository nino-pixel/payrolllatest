import 'package:flutter/material.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/models/profile_change_request.dart';
import '../../../data/services/profile_service.dart';

class EditProfileDialog extends StatefulWidget {
  final UserProfile profile;

  const EditProfileDialog({
    Key? key,
    required this.profile,
  }) : super(key: key);

  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _emergencyNameController;
  late TextEditingController _emergencyPhoneController;
  late TextEditingController _emergencyRelationController;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.profile.email);
    _phoneController = TextEditingController(text: widget.profile.phone);
    _emergencyNameController = TextEditingController(text: widget.profile.emergencyContact.name);
    _emergencyPhoneController = TextEditingController(text: widget.profile.emergencyContact.phone);
    _emergencyRelationController = TextEditingController(text: widget.profile.emergencyContact.relationship);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _emergencyRelationController.dispose();
    super.dispose();
  }

  Future<void> _submitChanges() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Check what fields have changed
      if (_emailController.text != widget.profile.email) {
        await ProfileService.submitProfileChangeRequest(
          employeeId: widget.profile.employeeId,
          field: ProfileChangeField.email,
          currentValue: widget.profile.email,
          newValue: _emailController.text,
        );
      }

      if (_phoneController.text != widget.profile.phone) {
        await ProfileService.submitProfileChangeRequest(
          employeeId: widget.profile.employeeId,
          field: ProfileChangeField.phone,
          currentValue: widget.profile.phone,
          newValue: _phoneController.text,
        );
      }

      if (_emergencyNameController.text != widget.profile.emergencyContact.name) {
        await ProfileService.submitProfileChangeRequest(
          employeeId: widget.profile.employeeId,
          field: ProfileChangeField.emergencyContactName,
          currentValue: widget.profile.emergencyContact.name,
          newValue: _emergencyNameController.text,
        );
      }

      // Add other emergency contact field changes...

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Change request submitted for approval'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profile'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                helperText: 'Requires approval',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                helperText: 'Requires approval',
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            const Text(
              'Emergency Contact',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emergencyNameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                helperText: 'Requires approval',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emergencyPhoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                helperText: 'Requires approval',
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emergencyRelationController,
              decoration: const InputDecoration(
                labelText: 'Relationship',
                helperText: 'Requires approval',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitChanges,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6B2C91),
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('Submit for Approval'),
        ),
      ],
    );
  }
}