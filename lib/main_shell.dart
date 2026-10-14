import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_colors.dart';
import 'providers/app_state.dart';
import 'features/home/home_screen.dart';
import 'features/goals/goals_screen.dart';
import 'features/challenges/challenges_screen.dart';
import 'features/profile/profile_screen.dart';

class MainShell extends StatefulWidget {
  final int initialIndex;

  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;

  final List<Widget> _screens = const [
    HomeScreen(),
    GoalsScreen(),
    ChallengesScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDark = appState.isDarkMode;
    final isArabic = appState.currentLanguage == 'Arabic';

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark
                  ? AppColors.darkCardBorder
                  : AppColors.border.withValues(alpha: 0.6),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          selectedItemColor: isDark ? AppColors.neonGreen : AppColors.primary,
          unselectedItemColor: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: isArabic ? 'الرئيسية' : 'Home',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.track_changes_outlined),
              activeIcon: const Icon(Icons.track_changes),
              label: isArabic ? 'الأهداف' : 'Goals',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.emoji_events_outlined),
              activeIcon: const Icon(Icons.emoji_events),
              label: isArabic ? 'التحديات' : 'Challenges',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person),
              label: isArabic ? 'الملف الشخصي' : 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}