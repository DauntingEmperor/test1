import 'package:flutter/material.dart';
import 'models/app_info.dart';
import 'settings_screen.dart';
import 'app_store_screen.dart';
import 'browser_screen.dart';

class HomeScreen extends StatefulWidget {
  List<String> repositories;

  HomeScreen({required this.repositories});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  List<AppInfo> installedApps = [
    AppInfo(name: "Settings", author: "", version: "", icon: "assets/icons/settings.png"),
    AppInfo(name: "App Store", author: "", version: "", icon: "assets/icons/app_store.png"),
    AppInfo(name: "Chrome", author: "", version: "", icon: "assets/icons/chrome.png"),
  ];

  bool isControlCenterOpen = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  double _brightnessLevel = 0.5;
  double _volumeLevel = 0.7;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween(begin: -300.0, end: 0.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleControlCenter() {
    setState(() {
      isControlCenterOpen = !isControlCenterOpen;
      if (isControlCenterOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  Future<void> _handlePasteDartCode(String dartCode) async {
    try {
      // Extracting name and icon URL from Dart code
      String appName = '';
      String appIconUrl = '';

      // Extracting app name
      RegExp nameRegex = RegExp(r'class\s+(\w+)\s+extends');
      Match? nameMatch = nameRegex.firstMatch(dartCode);
      if (nameMatch != null && nameMatch.groupCount >= 1) {
        appName = nameMatch.group(1)!;
      } else {
        throw FormatException('Failed to extract app name');
      }

      // Extracting icon URL
      RegExp iconRegex = RegExp(r"icon:\s*'(.*)'");
      Match? iconMatch = iconRegex.firstMatch(dartCode);
      if (iconMatch != null && iconMatch.groupCount >= 1) {
        appIconUrl = iconMatch.group(1)!;
      } else {
        throw FormatException('Failed to extract app icon URL');
      }

      AppInfo newApp = AppInfo(
        name: appName,
        author: 'Anonymous',
        version: '1.0',
        icon: appIconUrl,
      );

      setState(() {
        installedApps.add(newApp);
      });

    } catch (e) {
      print('Error handling Dart code: $e');
      // Handle error
    }
  }

  void _deleteApp(int index) {
    setState(() {
      installedApps.removeAt(index);
    });
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
              onDownloadWebsite: (name, iconUrl) {
                AppInfo newApp = AppInfo(
                  name: name,
                  author: 'Anonymous',
                  version: '1.0',
                  icon: iconUrl,
                );
                setState(() {
                  installedApps.add(newApp);
                });
              },
            ),
          ),
        );
        break;
      default:
        // Handle unknown app or no action
        break;
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
                image: AssetImage('assets/backgrounds/default.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // iOS Control Center
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                right: _animation.value,
                child: GestureDetector(
                  onTap: _toggleControlCenter,
                  child: Container(
                    width: 300,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black.withOpacity(0.7),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 50),
                          ListTile(
                            leading: Icon(Icons.brightness_4, color: Colors.white),
                            title: Text('Brightness'),
                            trailing: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: 200, // Adjust maxWidth as needed
                              ),
                              child: Slider(
                                value: _brightnessLevel,
                                min: 0.0,
                                max: 1.0,
                                onChanged: (value) {
                                  setState(() {
                                    _brightnessLevel = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Divider(color: Colors.white),
                          ListTile(
                            leading: Icon(Icons.volume_up, color: Colors.white),
                            title: Text('Volume'),
                            trailing: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: 200, // Adjust maxWidth as needed
                              ),
                              child: Slider(
                                value: _volumeLevel,
                                min: 0.0,
                                max: 1.0,
                                onChanged: (value) {
                                  setState(() {
                                    _volumeLevel = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Divider(color: Colors.white),
                          ListTile(
                            leading: Icon(Icons.airplanemode_inactive, color: Colors.white),
                            title: Text('Airplane Mode'),
                          ),
                          Divider(color: Colors.white),
                          ListTile(
                            leading: Icon(Icons.bluetooth, color: Colors.white),
                            title: Text('Bluetooth'),
                          ),
                          Divider(color: Colors.white),
                          ListTile(
                            leading: Icon(Icons.wifi, color: Colors.white),
                            title: Text('Wi-Fi'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          // Home Screen Grid
          Padding(
            padding: const EdgeInsets.only(top: 100.0, left: 10.0, right: 10.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: installedApps.length,
              itemBuilder: (context, index) {
                final app = installedApps[index];
                return GestureDetector(
                  onTap: () => _openApp(app.name),
                  onLongPress: () => _deleteApp(index),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          image: DecorationImage(
                            image: AssetImage(app.icon),
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
              },
            ),
          ),
          // Control Center Toggle Button
          Positioned(
            top: 20,
            right: 20,
            child: GestureDetector(
              onTap: _toggleControlCenter,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
