import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/app_info.dart';

class AppStoreScreen extends StatefulWidget {
  final List<String> repositories;
  final VoidCallback onAddRepository;

  AppStoreScreen({required this.repositories, required this.onAddRepository});

  @override
  _AppStoreScreenState createState() => _AppStoreScreenState();
}

class _AppStoreScreenState extends State<AppStoreScreen> {
  late Future<List<AppInfo>> futureApps;

  @override
  void initState() {
    super.initState();
    futureApps = fetchApps(widget.repositories);
  }

  Future<List<AppInfo>> fetchApps(List<String> repositories) async {
    List<AppInfo> apps = [];
    for (var repoUrl in repositories) {
      final response = await http.get(Uri.parse(repoUrl));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        Repository repo = Repository.fromJson(jsonResponse);
        if (repo.apps != null) {
          apps.addAll(repo.apps!);
        }
      } else {
        print('Failed to load repository from $repoUrl');
      }
    }
    return apps;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Store'),
      ),
      body: FutureBuilder<List<AppInfo>>(
        future: futureApps,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var app = snapshot.data![index];
                return ListTile(
                  leading: Image.network('https://example.com/icons/${app.icon}'),
                  title: Text(app.name),
                  subtitle: Text(app.author),
                  trailing: Text(app.version),
                  onTap: () {
                    // Handle app installation
                  },
                );
              },
            );
          } else {
            return Center(child: Text("No apps available"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.onAddRepository(); // Trigger adding repository
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
