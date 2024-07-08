import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SettingsScreen extends StatelessWidget {
  final List<String> repositories;
  final Function(List<String>) onRepositoriesChanged;
  final Function(String) onSideloadApp;

  SettingsScreen({
    required this.repositories,
    required this.onRepositoriesChanged,
    required this.onSideloadApp,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: EdgeInsets.all(10.0),
        children: [
          _buildSectionHeader("Connections"),
          _buildSettingsTile(
            context,
            icon: Icons.wifi,
            title: "Wi-Fi",
            onTap: () {},
          ),
          _buildSettingsTile(
            context,
            icon: Icons.bluetooth,
            title: "Bluetooth",
            onTap: () {},
          ),
          _buildSettingsTile(
            context,
            icon: Icons.network_cell,
            title: "Mobile networks",
            onTap: () {},
          ),
          SizedBox(height: 20),
          _buildSectionHeader("Personalization"),
          _buildSettingsTile(
            context,
            icon: Icons.wallpaper,
            title: "Wallpaper",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeBackgroundScreen(onBackgroundChanged: (String imagePath) {
                    onSideloadApp(imagePath);
                  }),
                ),
              );
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.color_lens,
            title: "Themes",
            onTap: () {},
          ),
          SizedBox(height: 20),
          _buildSectionHeader("General"),
          _buildSettingsTile(
            context,
            icon: Icons.info,
            title: "About phone",
            onTap: () {},
          ),
          _buildSettingsTile(
            context,
            icon: Icons.system_update,
            title: "Software update",
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, {required IconData icon, required String title, required Function() onTap}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: onTap,
      ),
    );
  }
}

class ChangeBackgroundScreen extends StatelessWidget {
  final Function(String) onBackgroundChanged;

  ChangeBackgroundScreen({required this.onBackgroundChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Background'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final picker = ImagePicker();
            final pickedFile = await picker.pickImage(source: ImageSource.gallery);

            if (pickedFile != null) {
              onBackgroundChanged(pickedFile.path);
              Navigator.pop(context);
            }
          },
          child: Text('Pick an image'),
        ),
      ),
    );
  }
}
