import 'package:flutter/material.dart';
import 'models/app_info.dart';
import 'settings_screen.dart';
import 'app_store_screen.dart';
import 'browser_screen.dart';
import 'file_picker_screen.dart';
import 'gallery_screen.dart';
import 'music_screen.dart';
import 'camera_screen.dart';
import 'contacts_screen.dart';
import 'messages_screen.dart';
import 'calendar_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:reorderables/reorderables.dart';

class HomeScreen extends StatefulWidget {
  List<String> repositories;

  HomeScreen({required this.repositories});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<AppInfo> installedApps = [
    AppInfo(name: "Settings", author: "", version: "", icon: "assets/icons/settings.png"),
    AppInfo(name: "App Store", author: "", version: "", icon: "assets/icons/app_store.png"),
    AppInfo(name: "Chrome", author: "", version: "", icon: "assets/icons/chrome.png"),
    AppInfo(name: "File Picker", author: "", version: "", icon: "assets/icons/file_picker.png"),
    AppInfo(name: "Gallery", author: "", version: "", icon: "assets/icons/gallery.png"),
    AppInfo(name: "Music", author: "", version: "", icon: "assets/icons/music.png"),
    AppInfo(name: "Contacts", author: "", version: "", icon: "assets/icons/contacts.png"),
    AppInfo(name: "Messages", author: "", version: "", icon: "assets/icons/messages.png"),
    AppInfo(name: "Calendar", author: "", version: "", icon: "assets/icons/calendar.png"),
    AppInfo(name: "Camera", author: "", version: "", icon: "assets/icons/camera.png"),
  ];

  String backgroundImage = 'assets/backgrounds/default.png';

  @override
  void initState() {
    super.initState();
    _loadBackgroundImage();
  }

  Future<void> _loadBackgroundImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      backgroundImage = prefs.getString('background_image') ?? 'assets/backgrounds/default.png';
    });
  }

  Future<void> _handlePasteDartCode(String dartCode) async {
    final appName = extractAppNameFromDartCode(dartCode);
    final iconUrl = extractIconUrlFromDartCode(dartCode);
    final iconPath = await _downloadFile(iconUrl, '$appName-icon.png');
    setState(() {
      installedApps.add(AppInfo(
        name: appName,
        author: 'Anonymous',
        version: '1.0',
        icon: iconPath,
      ));
    });
  }

  String extractAppNameFromDartCode(String dartCode) {
    // Parse the Dart code to extract the app name
    return "New App";
  }

  String extractIconUrlFromDartCode(String dartCode) {
    // Parse the Dart code to extract the icon URL
    return "https://example.com/icon.png";
  }

  void _deleteApp(int index) {
    setState(() {
      installedApps.removeAt(index);
    });
  }

  Future<String> _downloadFile(String url, String filename) async {
    final response = await http.get(Uri.parse(url));
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename');
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  void _openApp(String appName) {
    switch (appName) {
      case "Settings":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsScreen(
            repositories: widget.repositories,
            onRepositoriesChanged: (updatedRepositories) {
              setState(() {
                widget.repositories = updatedRepositories;
              });
            },
            onSideloadApp: (dartCode) {
              _handlePasteDartCode(dartCode);
            },
          )),
        );
        break;
      case "App Store":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AppStoreScreen(
            repositories: widget.repositories,
            onAddRepository: () {
              // Handle adding repository
            },
          )),
        );
        break;
      case "Chrome":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BrowserScreen(
              onDownloadWebsite: (name, iconUrl) async {
                final iconPath = await _downloadFile(iconUrl, '$name-icon.png');
                setState(() {
                  installedApps.add(AppInfo(
                    name: name,
                    author: 'Anonymous',
                    version: '1.0',
                    icon: iconPath,
                  ));
                });
              },
            ),
          ),
        );
        break;
      case "File Picker":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FilePickerScreen()),
        );
        break;
      case "Gallery":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GalleryScreen()),
        );
        break;
      case "Music":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MusicScreen()),
        );
        break;
      case "Contacts":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ContactsScreen()),
        );
        break;
      case "Messages":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MessagesScreen()),
        );
        break;
      case "Calendar":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CalendarScreen()),
        );
        break;
      case "Camera":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CameraScreen()),
        );
        break;
      default:
        // Handle unknown app or no action
        break;
    }
  }

  void _changeBackground() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('background_image', pickedFile.path);
      setState(() {
        backgroundImage = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: backgroundImage.startsWith('assets/')
                    ? AssetImage(backgroundImage)
                    : FileImage(File(backgroundImage)) as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 10.0),
            child: ReorderableWrap(
              spacing: 10.0,
              runSpacing: 10.0,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex -= 1;
                  final item = installedApps.removeAt(oldIndex);
                  installedApps.insert(newIndex, item);
                });
              },
              children: List.generate(installedApps.length, (index) {
                final app = installedApps[index];
                return GestureDetector(
                  key: ValueKey(app.name),
                  onTap: () => _openApp(app.name),
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Delete ${app.name}?"),
                        actions: [
                          TextButton(
                            child: Text("Cancel"),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          TextButton(
                            child: Text("Delete"),
                            onPressed: () {
                              _deleteApp(index);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          image: DecorationImage(
                            image: app.icon.startsWith('assets/')
                                ? AssetImage(app.icon)
                                : FileImage(File(app.icon)) as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        app.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
