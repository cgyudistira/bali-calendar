import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/strings.dart';
import '../../core/constants/colors.dart';
import '../providers/navigation_provider.dart';
import 'home_screen.dart';
import 'holy_days_screen.dart';
import 'weton_checker_screen.dart';
import 'ai_recommender_screen.dart';

/// Main screen with bottom navigation
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Keep screens in memory to preserve state
  final List<Widget> _screens = const [
    HomeScreen(),
    HolyDaysScreen(),
    WetonCheckerScreen(),
    AIRecommenderScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        return Scaffold(
          body: IndexedStack(
            index: navigationProvider.currentIndex,
            children: _screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: navigationProvider.currentIndex,
            onTap: (index) {
              navigationProvider.setCurrentIndex(index);
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textSecondary,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: AppStrings.navHome,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.celebration),
                label: AppStrings.navHolyDays,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.cake),
                label: AppStrings.navWeton,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.auto_awesome),
                label: AppStrings.navAIRecommender,
              ),
            ],
          ),
        );
      },
    );
  }
}
