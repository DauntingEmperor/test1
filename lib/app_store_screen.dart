import 'package:flutter/material.dart';

class AppStoreScreen extends StatelessWidget {
  final List<String> repositories;
  final Function onAddRepository;

  AppStoreScreen({required this.repositories, required this.onAddRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Store'),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: repositories.length,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            child: ListTile(
              leading: Icon(Icons.store),
              title: Text(repositories[index]),
              onTap: () {
                // Handle repository selection
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onAddRepository(),
        child: Icon(Icons.add),
        backgroundColor: Colors.black,
      ),
    );
  }
}
