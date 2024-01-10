import 'package:flutter/material.dart';
import 'database_helper.dart';

class ReadDataScreen extends StatelessWidget {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Read Data'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _dbHelper.getAllItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> itemList = snapshot.data ?? [];
            return ListView.builder(
              itemCount: itemList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(itemList[index]['name']),
                  subtitle: Text(itemList[index]['description']),
                );
              },
            );
          }
        },
      ),
    );
  }
}
