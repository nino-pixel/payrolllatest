import 'package:flutter/material.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/models/profile_change_request.dart';
import '../../../data/services/profile_service.dart';

class _EditProfileDialogState extends State<EditProfileDialog> {
  final UserProfile profile;

  const EditProfileDialog({
    Key? key,
    required this.profile,
  }) : super(key: key);

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emergencyNameController;
  late final TextEditingController _emergencyPhoneController;
  late final TextEditingController _emergencyRelationController;

  final _formKey = GlobalKey<FormState>();
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
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      bool hasChanges = false;

      // Check and submit email changes
      if (_emailController.text != widget.profile.email) {
        await ProfileService.submitProfileChangeRequest(
          employeeId: widget.profile.employeeId,
          field: ProfileChangeField.email,
          currentValue: widget.profile.email,
          newValue: _emailController.text,
        );
        hasChanges = true;
      }

      // Check and submit phone changes
      if (_phoneController.text != widget.profile.phone) {
        await ProfileService.submitProfileChangeRequest(
          employeeId: widget.profile.employeeId,
          field: ProfileChangeField.phone,
          currentValue: widget.profile.phone,
          newValue: _phoneController.text,
        );
        hasChanges = true;
      }

      // Check and submit emergency contact changes
      if (_emergencyNameController.text != widget.profile.emergencyContact.name) {
        await ProfileService.submitProfileChangeRequest(
          employeeId: widget.profile.employeeId,
          field: ProfileChangeField.emergencyContactName,
          currentValue: widget.profile.emergencyContact.name,
          newValue: _emergencyNameController.text,
        );
        hasChanges = true;
      }

      if (_emergencyPhoneController.text != widget.profile.emergencyContact.phone) {
        await ProfileService.submitProfileChangeRequest(
          employeeId: widget.profile.employeeId,
          field: ProfileChangeField.emergencyContactPhone,
          currentValue: widget.profile.emergencyContact.phone,
          newValue: _emergencyPhoneController.text,
        );
        hasChanges = true;
      }

      if (_emergencyRelationController.text != widget.profile.emergencyContact.relationship) {
        await ProfileService.submitProfileChangeRequest(
          employeeId: widget.profile.employeeId,
          field: ProfileChangeField.emergencyContactRelationship,
          currentValue: widget.profile.emergencyContact.relationship,
          newValue: _emergencyRelationController.text,
        );
        hasChanges = true;
      }

      if (!hasChanges) {
        setState(() => _errorMessage = 'No changes detected');
        return;
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red.shade900),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    helperText: 'Requires approval',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    helperText: 'Requires approval',
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number is required';
                    }
                    if (!RegExp(r'^\+?[\d\s-]+$').hasMatch(value)) {
                      return 'Enter a valid phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                const Text(
                  'Emergency Contact',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _emergencyNameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    helperText: 'Requires approval',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Emergency contact name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _emergencyPhoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    helperText: 'Requires approval',
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Emergency contact phone is required';
                    }
                    if (!RegExp(r'^\+?[\d\s-]+$').hasMatch(value)) {
                      return 'Enter a valid phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _emergencyRelationController,
                  decoration: const InputDecoration(
                    labelText: 'Relationship',
                    helperText: 'Requires approval',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Relationship is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}