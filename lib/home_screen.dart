import 'package:flutter/material.dart';
import 'settings_screen.dart';
import 'app_store_screen.dart';
import 'models/app_info.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  List<AppInfo> installedApps = [
    AppInfo(name: "Settings", author: "", version: "", icon: "assets/icons/settings.png"),
    AppInfo(name: "App Store", author: "", version: "", icon: "assets/icons/app_store.png"),
  ];

  List<String> repositories = [];

  bool isControlCenterOpen = false;
  late AnimationController _controller;
  late Animation<double> _animation;

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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 50),
                        ListTile(
                          leading: Icon(Icons.brightness_4, color: Colors.white),
                          title: Text('Dark Mode'),
                          trailing: Switch(
                            value: false, // Replace with actual dark mode state
                            onChanged: (value) {
                              setState(() {
                                // Toggle dark mode logic
                              });
                            },
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
                        // Add more controls here
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: installedApps.length,
              itemBuilder: (context, index) {
                final app = installedApps[index];
                return GestureDetector(
                  onTap: () {
                    if (app.name == "Settings") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsScreen(
                            repositories: repositories,
                            onRepositoriesChanged: (updatedRepos) {
                              setState(() {
                                repositories = updatedRepos;
                              });
                            },
                          ),
                        ),
                      );
                    } else if (app.name == "App Store") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppStoreScreen(
                            repositories: repositories,
                            onAddRepository: () {
                              setState(() {
                                // Handle adding repository
                              });
                            },
                          ),
                        ),
                      );
                    } else {
                      // Handle opening other apps
                    }
                  },
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
