import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileDrawer extends StatelessWidget {
  final String username;
  final String avatar;
  final VoidCallback onChangeAvatar;

  const ProfileDrawer({
    Key? key,
    required this.username,
    required this.avatar,
    required this.onChangeAvatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueAccent),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Text(
                    avatar,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  username,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Change Avatar"),
            onTap: () {
              onChangeAvatar();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              context.go('/signin');
            },
          ),
        ],
      ),
    );
  }
}
