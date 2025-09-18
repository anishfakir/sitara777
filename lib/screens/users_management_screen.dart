import 'package:flutter/material.dart';
import 'utils/app_theme.dart';
import 'widgets/loading_indicator.dart';

class UsersManagementScreen extends StatefulWidget {
  @override
  _UsersManagementScreenState createState() => _UsersManagementScreenState();
}

class _UsersManagementScreenState extends State<UsersManagementScreen> {
  bool _isLoading = false;
  List<Map<String, dynamic>> _users = [
    {
      'id': '1',
      'name': 'John Doe',
      'email': 'john@example.com',
      'phone': '9876543210',
      'balance': 500.0,
      'status': 'active',
    },
    {
      'id': '2',
      'name': 'Jane Smith',
      'email': 'jane@example.com',
      'phone': '9876543211',
      'balance': 1200.0,
      'status': 'active',
    },
    {
      'id': '3',
      'name': 'Robert Johnson',
      'email': 'robert@example.com',
      'phone': '9876543212',
      'balance': 750.0,
      'status': 'inactive',
    },
  ];

  void _toggleUserStatus(int index) {
    setState(() {
      _users[index]['status'] = _users[index]['status'] == 'active' ? 'inactive' : 'active';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(child: LoadingIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search users...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      final user = _users[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.person),
                            backgroundColor: AppTheme.primaryColor,
                          ),
                          title: Text(user['name']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user['email']),
                              Text('₹${user['balance'].toStringAsFixed(2)}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: user['status'] == 'active'
                                      ? AppTheme.primaryGreen
                                      : AppTheme.errorColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  user['status'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Edit user functionality
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  user['status'] == 'active' ? Icons.block : Icons.check,
                                ),
                                onPressed: () => _toggleUserStatus(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}