import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/user_card.dart';
import '../models/user.dart';

class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({Key? key}) : super(key: key);

  @override
  _UserSearchScreenState createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final _apiService = ApiService();
  final _idController = TextEditingController();
  bool isLoading = false;
  User? user;

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  Future<void> _searchUser() async {
    final id = _idController.text;
    if (id.isEmpty) {
      _showError('Masukkan ID pengguna');
      return;
    }

    setState(() => isLoading = true);
    try {
      final result = await _apiService.getUserById(id);
      setState(() {
        user = result;
        isLoading = false;
      });
      if (result == null) {
        _showError('Pengguna tidak ditemukan');
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Pengguna'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: 'ID Pengguna',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchUser,
                ),
              ),
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _searchUser(),
            ),
            const SizedBox(height: 24),
            if (isLoading)
              const CircularProgressIndicator()
            else if (user != null)
              UserCard(user: user!, detailed: true),
          ],
        ),
      ),
    );
  }
}