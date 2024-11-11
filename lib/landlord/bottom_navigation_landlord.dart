import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/add_screen.dart';
import '../common/chat_screen.dart';
import '../common/profile_screen.dart';
import '../theme/colors.dart';

class BottomNavigationLandlord extends StatefulWidget {
  final int? selectedIndex;
  const BottomNavigationLandlord({super.key, this.selectedIndex});

  @override
  State<BottomNavigationLandlord> createState() => _BottomNavigationLandlordState();
}

class _BottomNavigationLandlordState extends State<BottomNavigationLandlord> {
  // Index value that will help to change the screen on the tap of a different index of bottom navigation
  int _indexValue = 0;

  @override
  void initState() {
    super.initState();
    // Assign a default value if widget.selectedIndex is null
    _indexValue = widget.selectedIndex ?? 0;
  }

  // List of screens to be shown on the tap of each item
  final List<Widget> _screenList = [
    const ChatScreen(),
    AddScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screenList[_indexValue],
      // Passing index value so the screen will change dynamically
      bottomNavigationBar: CurvedNavigationBar(
        index: _indexValue,
        // Update index on tap
        onTap: (index) {
          setState(() {
            _indexValue = index;
          });
        },
        items: [
          // Using _buildNavItem to customize nav items
          _buildNavItem(Icons.chat, "Chat"),
          _buildNavItem(Icons.add_circle_outline_sharp, "Add"),
          _buildNavItem(Icons.person, "Profile"),
        ],
        color: AppColors().green,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: AppColors().blue,
        animationDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  // Method to build bottom navigation icons with custom design
  Widget _buildNavItem(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SizedBox(
        width: 45,
        height: 45,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Icon(icon, size: 30, color: Colors.white),
            Positioned(
              bottom: 0,
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: "Poppins-Semibold",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
