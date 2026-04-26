import 'package:flutter/material.dart';
import 'garden_view.dart';
import 'my_plant_view.dart';
import 'focus_view.dart';
import 'journey_view.dart';
import 'profile_view.dart';

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
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/tempor-removebg-preview.png',
          height: 61,
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
        },
        children: const [
          GardenView(),
          MyPlantView(),
          FocusView(),
          JourneyView(),
          ProfileView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          fontFamily: 'LeagueSpartan',
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontFamily: 'LeagueSpartan',
        ),
        selectedIconTheme: const IconThemeData(size: 30),
        unselectedIconTheme: const IconThemeData(size: 24),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_vintage),
            label: 'GARDEN',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.eco), label: 'MY PLANT'),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'FOCUS'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'JOURNEY'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'PROFILE'),
        ],
      ),
    );
  }
}
