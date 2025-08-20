import 'package:flutter/material.dart';
import '../services/auth_services.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = AuthService();
  final _emailCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();

  bool _loading = true;
  bool _loggedIn = false;
  String? _email;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final loggedIn = await _auth.isLoggedIn();
    final email = await _auth.getEmail();
    setState(() {
      _loggedIn = loggedIn;
      _email = email;
      _loading = false;
    });
  }

  Future<void> _doLoginOrSignup() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) return;
    await _auth.loginOrSignup(email);
    _loadState();
  }

  Future<void> _logout() async {
    await _auth.logout();
    _loadState();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: _loggedIn ? _buildProfileView() : _buildLoginForm(),
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text("Login / Sign up",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            controller: _emailCtrl,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _pwdCtrl,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _doLoginOrSignup,
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileView() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Welcome, $_email",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
          )
        ],
      ),
    );
  }
}
