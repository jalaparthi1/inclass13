// profile_screen.dart
import 'package:flutter/material.dart';
import 'auth_service.dart';

class ProfileScreen extends StatelessWidget {
  final AuthService authService;

  ProfileScreen({Key? key, required this.authService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Logged in as: ${authService.currentUser?.email ?? "Guest"}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Logic to change password
                String newPassword = await _showPasswordDialog(context);
                if (newPassword.isNotEmpty) {
                  await authService.updatePassword(newPassword);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Password updated successfully')),
                  );
                }
              },
              child: Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _showPasswordDialog(BuildContext context) async {
    String password = '';
    return await showDialog<String>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Change Password'),
              content: TextField(
                obscureText: true,
                onChanged: (value) => password = value,
                decoration: InputDecoration(labelText: 'New Password'),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, ''),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, password);
                  },
                  child: Text('Update'),
                ),
              ],
            );
          },
        ) ??
        '';
  }
}
