import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/user_card.dart';
import '../models/user.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final ApiService _apiService = ApiService();
  List<User> users = [];
  bool isLoading = true;
  int currentPage = 1;
  final int itemsPerPage = 3;
  final int totalPageCount = 4;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      setState(() => isLoading = true);
      final newUsers = await _apiService.getUsers(currentPage, itemsPerPage);
      setState(() {
        users = newUsers;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      _showError('Gagal memuat data: ${e.toString()}');
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
        title: const Text('Daftar Pengguna'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadUsers,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) => UserCard(user: users[index]),
                    ),
                  ),
                  _buildPagination(),
                ],
              ),
            ),
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: currentPage > 1 ? () {
              setState(() => currentPage--);
              _loadUsers();
            } : null,
            child: const Text('Sebelumnya'),
          ),
          Text('$currentPage dari $totalPageCount'),
          ElevatedButton(
            onPressed: currentPage < totalPageCount ? () {
              setState(() => currentPage++);
              _loadUsers();
            } : null,
            child: const Text('Selanjutnya'),
          ),
        ],
      ),
    );
  }
}