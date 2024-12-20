import 'package:flutter/material.dart';
mport '../../../data/models/user_profile.dart';
mport '../../../data/models/profile_change_request.dart';
mport '../../../data/services/profile_service.dart';
class EditProfileDialog extends StatefulWidget {
 final UserProfile profile;
  const EditProfileDialog({
   Key? key,
   required this.profile,
 }) : super(key: key);
  @override
 State<EditProfileDialog> createState() => _EditProfileDialogState();

class _EditProfileDialogState extends State<EditProfileDialog> {
 // Controllers
 late final TextEditingController _emailController;
 late final TextEditingController _phoneController;
 late final TextEditingController _emergencyNameController;
 late final TextEditingController _emergencyPhoneController;
 late final TextEditingController _emergencyRelationController;
  // Focus Nodes
 final _emailFocus = FocusNode();
 final _phoneFocus = FocusNode();
 final _emergencyNameFocus = FocusNode();
 final _emergencyPhoneFocus = FocusNode();
 final _emergencyRelationFocus = FocusNode();
  bool _isLoading = false;
 String? _errorMessage;
  @override
 void initState() {
   super.initState();
   // Initialize controllers with current values
   _emailController = TextEditingController(text: widget.profile.email);
   _phoneController = TextEditingController(text: widget.profile.phone);
   _emergencyNameController = TextEditingController(text: widget.profile.emergencyContact.name);
   _emergencyPhoneController = TextEditingController(text: widget.profile.emergencyContact.phone);
   _emergencyRelationController = TextEditingController(text: widget.profile.emergencyContact.relationship);
 }
  @override
 void dispose() {
   // Dispose controllers
   _emailController.dispose();
   _phoneController.dispose();
   _emergencyNameController.dispose();
   _emergencyPhoneController.dispose();
   _emergencyRelationController.dispose();
    // Dispose focus nodes
   _emailFocus.dispose();
   _phoneFocus.dispose();
   _emergencyNameFocus.dispose();
   _emergencyPhoneFocus.dispose();
   _emergencyRelationFocus.dispose();
   super.dispose();
 }
  // Validate email format
 bool _isValidEmail(String email) {
   return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
 }
  // Validate phone format (simple validation)
 bool _isValidPhone(String phone) {
   return phone.length >= 10 && RegExp(r'^\+?[\d\s-]+$').hasMatch(phone);
 }
  Future<void> _submitChanges() async {
   // Validate inputs first
   if (!_isValidEmail(_emailController.text)) {
     setState(() => _errorMessage = 'Please enter a valid email address');
     _emailFocus.requestFocus();
     return;
   }
    if (!_isValidPhone(_phoneController.text)) {
     setState(() => _errorMessage = 'Please enter a valid phone number');
     _phoneFocus.requestFocus();
     return;
   }
    setState(() {
     _isLoading = true;
     _errorMessage = null;
   });
    try {
     // Check and submit email changes
     if (_emailController.text != widget.profile.email) {
       await ProfileService.submitProfileChangeRequest(
         employeeId: widget.profile.employeeId,
         field: ProfileChangeField.email,
         currentValue: widget.profile.email,
         newValue: _emailController.text,
       );
     }
      // Check and submit phone changes
     if (_phoneController.text != widget.profile.phone) {
       await ProfileService.submitProfileChangeRequest(
         employeeId: widget.profile.employeeId,
         field: ProfileChangeField.phone,
         currentValue: widget.profile.phone,
         newValue: _phoneController.text,
       );
     }
      // Check and submit emergency contact changes
     if (_emergencyNameController.text != widget.profile.emergencyContact.name) {
       await ProfileService.submitProfileChangeRequest(
         employeeId: widget.profile.employeeId,
         field: ProfileChangeField.emergencyContactName,
         currentValue: widget.profile.emergencyContact.name,
         newValue: _emergencyNameController.text,
       );
     }
      if (_emergencyPhoneController.text != widget.profile.emergencyContact.phone) {
       await ProfileService.submitProfileChangeRequest(
         employeeId: widget.profile.employeeId,
         field: ProfileChangeField.emergencyContactPhone,
         currentValue: widget.profile.emergencyContact.phone,
         newValue: _emergencyPhoneController.text,
       );
     }
      if (_emergencyRelationController.text != widget.profile.emergencyContact.relationship) {
       await ProfileService.submitProfileChangeRequest(
         employeeId: widget.profile.employeeId,
         field: ProfileChangeField.emergencyContactRelationship,
         currentValue: widget.profile.emergencyContact.relationship,
         newValue: _emergencyRelationController.text,
       );
     }
      if (mounted) {
       Navigator.of(context).pop(true);
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(
           content: Text('Change requests submitted for approval'),
           backgroundColor: Colors.green,
         ),
       );
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
         child: Column(
           mainAxisSize: MainAxisSize.min,
           crossAxisAlignment: CrossAxisAlignment.stretch,
           children: [
             const Text(
               'Edit Profile',
               style: TextStyle(
                 fontSize: 20,
                 fontWeight: FontWeight.bold,
               ),
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
              // Contact Information Section
             const Text(
               'Contact Information',
               style: TextStyle(
                 fontSize: 16,
                 fontWeight: FontWeight.w500,
               ),
             ),
             const SizedBox(height: 8),
             TextField(
               controller: _emailController,
               focusNode: _emailFocus,
               decoration: const InputDecoration(
                 labelText: 'Email',
                 helperText: 'Requires approval',
                 border: OutlineInputBorder(),
               ),
               keyboardType: TextInputType.emailAddress,
             ),
             const SizedBox(height: 16),
             TextField(
               controller: _phoneController,
               focusNode: _phoneFocus,
               decoration: const InputDecoration(
                 labelText: 'Phone',
                 helperText: 'Requires approval',
                 border: OutlineInputBorder(),
               ),
               keyboardType: TextInputType.phone,
             ),
              const SizedBox(height: 24),
              // Emergency Contact Section
             const Text(
               'Emergency Contact',
               style: TextStyle(
                 fontSize: 16,
                 fontWeight: FontWeight.w500,
               ),
             ),
             const SizedBox(height: 8),
             TextField(
               controller: _emergencyNameController,
               focusNode: _emergencyNameFocus,
               decoration: const InputDecoration(
                 labelText: 'Name',
                 helperText: 'Requires approval',
                 border: OutlineInputBorder(),
               ),
             ),
             const SizedBox(height: 16),
             TextField(
               controller: _emergencyPhoneController,
               focusNode: _emergencyPhoneFocus,
               decoration: const InputDecoration(
                 labelText: 'Phone',
                 helperText: 'Requires approval',
                 border: OutlineInputBorder(),
               ),
               keyboardType: TextInputType.phone,
             ),
             const SizedBox(height: 16),
             TextField(
               controller: _emergencyRelationController,
               focusNode: _emergencyRelationFocus,
               decoration: const InputDecoration(
                 labelText: 'Relationship',
                 helperText: 'Requires approval',
                 border: OutlineInputBorder(),
               ),
             ),
              const SizedBox(height: 24),
              // Action Buttons
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
   );
 }
