import 'package:flutter/material.dart';
import'../../../data/models/user_profile.dart';
import '../../../data/services/profile_service.dart';
import '../widgets/profile_picture_dialog.dart';
import '../widgets/change_password_dialog.dart';
import '../widgets/edit_profile_dialog.dart';
class ProfileTab extends StatefulWidget {
 const ProfileTab({super.key});
  @override
 State<ProfileTab> createState() => _ProfileTabState();

class _ProfileTabState extends State<ProfileTab> {
 late Future<UserProfile> _profileFuture;
  @override
 void initState() {
   super.initState();
   _loadProfile();
 }
  void _loadProfile() {
   _profileFuture = ProfileService.getUserProfile('EMP001'); // TODO: Get actual employee ID
 }
  @override
 Widget build(BuildContext context) {
   return SingleChildScrollView(
     padding: const EdgeInsets.all(16),
     child: FutureBuilder<UserProfile>(
       future: _profileFuture,
       builder: (context, snapshot) {
         if (snapshot.connectionState == ConnectionState.waiting) {
           return const Center(child: CircularProgressIndicator());
         }
          if (snapshot.hasError) {
           return Center(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Text(
                   'Error loading profile: ${snapshot.error}',
                   style: const TextStyle(color: Colors.red),
                 ),
                 ElevatedButton(
                   onPressed: () {
                     setState(() {
                       _loadProfile();
                     });
                   },
                   child: const Text('Retry'),
                 ),
               ],
             ),
           );
         }
          final profile = snapshot.data!;
          return Column(
           children: [
             // Profile Picture Section
             Stack(
               alignment: Alignment.bottomRight,
               children: [
                 CircleAvatar(
                   radius: 60,
                   backgroundImage: profile.profilePicture.isNotEmpty
                       ? NetworkImage(profile.profilePicture)
                       : null,
                   child: profile.profilePicture.isEmpty
                       ? const Icon(Icons.person, size: 60)
                       : null,
                 ),
                 FloatingActionButton.small(
                   onPressed: () {
                     showDialog(
                       context: context,
                       builder: (context) => ProfilePictureDialog(
                         employeeId: profile.employeeId,
                       ),
                     ).then((changed) {
                       if (changed == true) {
                         setState(() {
                           _loadProfile();
                         });
                       }
                     });
                   },
                   child: const Icon(Icons.camera_alt),
                 ),
               ],
             ),
             const SizedBox(height: 24),
              // Basic Info Card
             Card(
               child: Padding(
                 padding: const EdgeInsets.all(16),
                 children: [
                   const Text(
                     'Basic Information',
                     style: TextStyle(
                       fontSize: 18,
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                   const SizedBox(height: 16),
                   _buildInfoRow('Full Name', profile.fullName),
                   _buildInfoRow('Employee ID', profile.employeeId),
                   _buildInfoRow('Position', profile.position),
                   _buildInfoRow('Department', profile.department),
                   _buildInfoRow('Date Hired', 
                     DateFormat('MMMM dd, yyyy').format(profile.dateHired)),
                   _buildInfoRow('Employment Status', profile.employmentStatus),
                 ],
               ),
             ),
             const SizedBox(height: 16),
              // Contact Info Card
             Card(
               child: Padding(
                 padding: const EdgeInsets.all(16),
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       const Text(
                         'Contact Information',
                         style: TextStyle(
                           fontSize: 18,
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                       IconButton(
                         icon: const Icon(Icons.edit),
                         onPressed: () {
                           showDialog(
                             context: context,
                             builder: (context) => EditProfileDialog(
                               profile: profile,
                             ),
                           ).then((changed) {
                             if (changed == true) {
                               setState(() {
                                 _loadProfile();
                               });
                             }
                           });
                         },
                       ),
                     ],
                   ),
                   const SizedBox(height: 16),
                   _buildInfoRow('Email', profile.email),
                   _buildInfoRow('Phone', profile.phone),
                   const Divider(),
                   const Text(
                     'Emergency Contact',
                     style: TextStyle(
                       fontSize: 16,
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                   const SizedBox(height: 8),
                   _buildInfoRow('Name', profile.emergencyContact.name),
                   _buildInfoRow('Relationship', 
                     profile.emergencyContact.relationship),
                   _buildInfoRow('Phone', profile.emergencyContact.phone),
                 ],
               ),
             ),
             const SizedBox(height: 16),
              // Actions
             ElevatedButton.icon(
               onPressed: () {
                 showDialog(
                   context: context,
                   builder: (context) => ChangePasswordDialog(
                     employeeId: profile.employeeId,
                   ),
                 );
               },
               icon: const Icon(Icons.lock),
               label: const Text('Change Password'),
               style: ElevatedButton.styleFrom(
                 backgroundColor: const Color(0xFF6B2C91),
                 foregroundColor: Colors.white,
               ),
             ),
           ],
         );
       },
     ),
   );
 }
  Widget _buildInfoRow(String label, String value) {
   return Padding(
     padding: const EdgeInsets.symmetric(vertical: 8),
     child: Row(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         SizedBox(
           width: 120,
           child: Text(
             label,
             style: TextStyle(
               color: Colors.grey[600],
               fontWeight: FontWeight.w500,
             ),
           ),
         ),
         Expanded(
           child: Text(
             value,
             style: const TextStyle(
               fontSize: 16,
             ),
           ),
         ),
       ],
     ),
   );
 }
}