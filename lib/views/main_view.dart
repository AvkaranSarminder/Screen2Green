import 'package:flutter/material.dart';
import 'garden_page.dart';
import 'my_plant_page.dart';
import 'focus_page.dart';
import 'journey_page.dart';
import 'profile_page.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainView> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Seamless transition using animateToPage
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
        },
        children: const [
          GardenPage(),
          MyPlantPage(),
          FocusPage(),
          JourneyPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Necessary for more than 3 items
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        // Text styling
        selectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: 'LeagueSpartan',
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontFamily: 'LeagueSpartan',
        ),
        // Icon scaling
        selectedIconTheme: const IconThemeData(size: 30),
        unselectedIconTheme: const IconThemeData(size: 24),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_vintage),
            label: 'Garden',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.eco), label: 'My Plant'),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Focus'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Journey'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
