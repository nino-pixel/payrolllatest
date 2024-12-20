import 'package:flutter/material.dart';

class UserProfile {
  final String name;
  final String email;
  final String phone;

  UserProfile({
    required this.name,
    required this.email,
    required this.phone,
  });
}

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
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _emailController = TextEditingController(text: widget.profile.email);
    _phoneController = TextEditingController(text: widget.profile.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profile'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final updatedProfile = UserProfile(
              name: _nameController.text,
              email: _emailController.text,
              phone: _phoneController.text,
            );

            Navigator.of(context).pop(updatedProfile); // Pass updated profile back
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
