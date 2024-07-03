import 'package:flutter/foundation.dart';

class AppInfo {
  final String name;
  final String author;
  final String version;
  final String icon;

  AppInfo({
    required this.name,
    required this.author,
    required this.version,
    required this.icon,
  });

  factory AppInfo.fromJson(Map<String, dynamic> json) {
    return AppInfo(
      name: json['name'] ?? '',
      author: json['author'] ?? '',
      version: json['version'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}

class Repository {
  final String name;
  final String author;
  final String description;
  final List<AppInfo>? apps; // Make apps nullable

  Repository({
    required this.name,
    required this.author,
    required this.description,
    this.apps, // Update to nullable list
  });

  factory Repository.fromJson(Map<String, dynamic> json) {
    var list = json['apps'] as List?;
    List<AppInfo>? appsList = list?.map((i) => AppInfo.fromJson(i)).toList();

    return Repository(
      name: json['name'] ?? '',
      author: json['author'] ?? '',
      description: json['description'] ?? '',
      apps: appsList,
    );
  }
}
