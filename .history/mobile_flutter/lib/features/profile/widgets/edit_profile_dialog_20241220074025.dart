import 'package:flutter/material.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/models/profile_change_request.dart';
import '../../../data/services/profile_service.dart';

import 'package:flutter/material.dart';

class EditProfileDialog extends StatefulWidget {
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

  Future<void> _submitChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
                const SizedBox(height: 16),
                
                // Contact Information
                const Text(
                  'Contact Information',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    helperText: 'Requires approval',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!value.contains('@')) {
                      return 'Enter a valid email address';
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
                    border: OutlineInputBorder(),
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

                // Emergency Contact
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
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _emergencyPhoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    helperText: 'Requires approval',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value?.isEmpty == true) return 'Required';
                    if (!RegExp(r'^\+?[\d\s-]+$').hasMatch(value!)) {
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
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isLoading ? null : () => Navigator.pop(context),
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

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _emergencyRelationController.dispose();
    super.dispose();
  }
}