import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'User Data',
      home: UserList(),
    );
  }
}

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  UserListState createState() => UserListState();
}

class UserListState extends State<UserList> {
  List<dynamic> users = [];
  String errorMessage = '';

  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:5500/'));
    print(response);
    if (response.statusCode == 200) {
      setState(() {
        users = json.decode(response.body);
        errorMessage = '';
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Data'),
      ),
      body: DataTable(
        columns: const <DataColumn>[
          DataColumn(label: Text('First Name')),
          DataColumn(label: Text('Last Name')),
          DataColumn(label: Text('Email')),
        ],
        rows: users
            .map(
              (user) => DataRow(
                cells: <DataCell>[
                  DataCell(Text(user['first_name'])),
                  DataCell(Text(user['last_name'])),
                  DataCell(Text(user['email'])),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
