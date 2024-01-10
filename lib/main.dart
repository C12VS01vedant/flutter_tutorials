import 'package:flutter/material.dart';
import 'database_helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('CRUD Flutter App'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Manage Data'),
              Tab(text: 'View Data'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildManageDataTab(),
            _buildViewDataTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildManageDataTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _addItem(),
                child: Text('Add'),
              ),
              ElevatedButton(
                onPressed: () => _readItems(),
                child: Text('Read'),
              ),
              ElevatedButton(
                onPressed: () => _updateItem(),
                child: Text('Update'),
              ),
              ElevatedButton(
                onPressed: () => _deleteItem(),
                child: Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewDataTab() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _dbHelper.getAllItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Map<String, dynamic>> data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(data[index]['name']),
                subtitle: Text(data[index]['description']),
              );
            },
          );
        }
      },
    );
  }

  void _addItem() async {
    Map<String, dynamic> row = {
      'name': _nameController.text,
      'description': _descriptionController.text,
    };
    await _dbHelper.insertItem(row);
    _clearControllers();
  }

  void _readItems() async {
    List<Map<String, dynamic>> rows = await _dbHelper.getAllItems();
    // Handle and display the fetched items as needed
    print(rows);
  }

  void _updateItem() async {
    Map<String, dynamic> row = {
      'id': 1, // Replace with the desired item ID to update
      'name': _nameController.text,
      'description': _descriptionController.text,
    };
    await _dbHelper.updateItem(row);
    _clearControllers();
  }

  void _deleteItem() async {
    int id = 1; // Replace with the desired item ID to delete
    await _dbHelper.deleteItem(id);
    _clearControllers();
  }

  void _clearControllers() {
    _nameController.clear();
    _descriptionController.clear();
  }
}
