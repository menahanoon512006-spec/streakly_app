import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/app_state.dart';
import '../splash/splash_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // نافذة الإعدادات الشاملة والتفاعلية (اللغة، الصوت، الاهتزاز، الكاش)
  void _showGeneralSettingsDialog(BuildContext context, AppState appState) {
    final isArabic = appState.currentLanguage == 'Arabic';
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              backgroundColor: appState.isDarkMode ? const Color(0xFF1E1E2C) : Colors.white,
              title: Row(
                children: [
                  const Icon(Icons.settings, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Text(
                    isArabic ? "الإعدادات العامة" : "Settings",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: appState.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 1. خيار تغيير اللغة
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.language, color: Colors.blueAccent),
                        title: Text(
                          isArabic ? "لغة التطبيق" : "App Language",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: appState.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          isArabic ? "العربية" : "English",
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        trailing: DropdownButton<String>(
                          value: appState.currentLanguage,
                          dropdownColor: appState.isDarkMode ? const Color(0xFF2A2A3C) : Colors.white,
                          style: TextStyle(color: appState.isDarkMode ? Colors.white : Colors.black),
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(value: "English", child: Text("English")),
                            DropdownMenuItem(value: "Arabic", child: Text("العربية")),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              appState.setLanguage(val);
                              setState(() {});
                            }
                          },
                        ),
                      ),
                      const Divider(height: 1),

                      // 2. المؤثرات الصوتية
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        secondary: const Icon(Icons.volume_up_outlined, color: Colors.orangeAccent),
                        title: Text(
                          isArabic ? "المؤثرات الصوتية" : "Sound Effects",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: appState.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          isArabic ? "تشغيل الأصوات عند إتمام المهام" : "Play sounds on task completion",
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        value: appState.isSoundEnabled,
                        activeThumbColor: AppColors.primary,
                        onChanged: (val) {
                          appState.toggleSoundEffects(val);
                          setState(() {});
                        },
                      ),
                      const Divider(height: 1),

                      // 3. الاهتزاز اللمسي
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        secondary: const Icon(Icons.vibration, color: Colors.purpleAccent),
                        title: Text(
                          isArabic ? "الاهتزاز اللمسي" : "Haptic Feedback",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: appState.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          isArabic ? "اهتزاز عند الضغط على الأزرار" : "Vibrate on button presses",
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        value: appState.isHapticEnabled,
                        activeThumbColor: AppColors.primary,
                        onChanged: (val) {
                          appState.toggleHapticFeedback(val);
                          setState(() {});
                        },
                      ),
                      const Divider(height: 1),

                      // 4. مسح التخزين المؤقت
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.cleaning_services_outlined, color: Colors.redAccent),
                        title: Text(
                          isArabic ? "مسح التخزين المؤقت" : "Clear Cache",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: appState.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          isArabic ? "توفير مساحة التخزين الداخلية" : "Free up local storage space",
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isArabic ? "تم مسح التخزين المؤقت بنجاح!" : "Cache cleared successfully!",
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    isArabic ? "حفظ وإغلاق" : "Save & Close",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showNotificationDialog(BuildContext context, AppState appState) {
    final isArabic = appState.currentLanguage == 'Arabic';
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              backgroundColor: appState.isDarkMode ? const Color(0xFF1E1E2C) : Colors.white,
              title: Row(
                children: [
                  const Icon(Icons.notifications_active_outlined, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Text(
                    isArabic ? "إشعارات التطبيق" : "Push Notifications",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: appState.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isArabic 
                        ? "مُهيأة عبر Amazon SNS و EventBridge Scheduler للتذكيرات الفورية." 
                        : "Configured via Amazon SNS & EventBridge Scheduler for timely reminders.",
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: Text(
                      isArabic ? "تذكيرات المهام اليومية" : "Daily Task Reminders",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: appState.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    subtitle: Text(isArabic ? "التذكير قبل انتهاء الموعد اليومي" : "Get reminded before daily deadline", style: const TextStyle(fontSize: 12)),
                    value: appState.notifReminders,
                    activeThumbColor: AppColors.primary,
                    onChanged: (val) {
                      appState.updateNotificationSetting('reminders', val);
                      setState(() {});
                    },
                  ),
                  SwitchListTile(
                    title: Text(
                      isArabic ? "شارات السلسلة والإنجازات" : "Streak & Milestone Badges",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: appState.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    subtitle: Text(isArabic ? "تنبيه عندما تكون السلسلة في خطر" : "Alert when streak is at risk", style: const TextStyle(fontSize: 12)),
                    value: appState.notifAchievements,
                    activeThumbColor: AppColors.primary,
                    onChanged: (val) {
                      appState.updateNotificationSetting('achievements', val);
                      setState(() {});
                    },
                  ),
                  SwitchListTile(
                    title: Text(
                      isArabic ? "تحديثات التحديات الجماعية" : "Social Challenge Updates",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: appState.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    subtitle: Text(isArabic ? "إنجازات الأصدقاء وتغيرات المتصدرين" : "Peer completions and leaderboard shifts", style: const TextStyle(fontSize: 12)),
                    value: appState.notifChallenges,
                    activeThumbColor: AppColors.primary,
                    onChanged: (val) {
                      appState.updateNotificationSetting('challenges', val);
                      setState(() {});
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(isArabic ? "تم" : "Done", style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showPrivacyDialog(BuildContext context, AppState appState) {
    final isArabic = appState.currentLanguage == 'Arabic';
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              backgroundColor: appState.isDarkMode ? const Color(0xFF1E1E2C) : Colors.white,
              title: Row(
                children: [
                  const Icon(Icons.lock_outline, color: AppColors.dawemOrange),
                  const SizedBox(width: 10),
                  Text(
                    isArabic ? "الخصوصية والبيانات" : "Privacy & Data",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: appState.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isArabic ? "إدارة ظهورك الاجتماعي وتفضيلات بيانات حسابك." : "Manage your social visibility and account data preferences.",
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: Text(
                      isArabic ? "الملف الشخصي العام" : "Public Profile",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: appState.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    subtitle: Text(isArabic ? "السماح للآخرين برؤية ملفك على لوحة المتصدرين" : "Allow peers to see your profile on leaderboards", style: const TextStyle(fontSize: 12)),
                    value: appState.privacyPublicProfile,
                    activeThumbColor: AppColors.dawemOrange,
                    onChanged: (val) {
                      appState.updatePrivacySetting('publicProfile', val);
                      setState(() {});
                    },
                  ),
                  SwitchListTile(
                    title: Text(
                      isArabic ? "مشاركة نشاط التحديات" : "Share Challenge Activity",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: appState.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    subtitle: Text(isArabic ? "مشاركة إتمام الأهداف مع أعضاء التحدي" : "Share goal completions with challenge members", style: const TextStyle(fontSize: 12)),
                    value: appState.privacyShareActivity,
                    activeThumbColor: AppColors.dawemOrange,
                    onChanged: (val) {
                      appState.updatePrivacySetting('shareActivity', val);
                      setState(() {});
                    },
                  ),
                  SwitchListTile(
                    title: Text(
                      isArabic ? "إظهار عداد السلسلة" : "Show Streak Counter",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: appState.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    subtitle: Text(isArabic ? "عرض أيام السلسلة الخاصة بك للعامة" : "Display your current daily streak publicly", style: const TextStyle(fontSize: 12)),
                    value: appState.privacyShowStreak,
                    activeThumbColor: AppColors.dawemOrange,
                    onChanged: (val) {
                      appState.updatePrivacySetting('showStreak', val);
                      setState(() {});
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(isArabic ? "تم" : "Done", style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.dawemOrange)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _handleLogout(BuildContext context, AppState appState) {
    final isArabic = appState.currentLanguage == 'Arabic';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(isArabic ? "تسجيل الخروج" : "Log Out"),
        content: Text(isArabic ? "هل أنت متأكد من تسجيل الخروج من تطبيق داوم؟" : "Are you sure you want to log out of Dawem?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isArabic ? "إلغاء" : "Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              appState.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const SplashScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              minimumSize: const Size(100, 42),
            ),
            child: Text(isArabic ? "خروج" : "Log Out", style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDark = appState.isDarkMode;
    final user = appState.user;
    final earnedBadges = appState.badges.where((b) => b.isEarned).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          appState.currentLanguage == 'Arabic' ? "الملف الشخصي" : "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? AppColors.darkSurfaceSecondary : const Color(0xFFE2E8F0),
                  border: Border.all(
                    color: isDark ? AppColors.darkCardBorder : Colors.white,
                    width: 4,
                  ),
                ),
                child: Icon(
                  Icons.person,
                  size: 56,
                  color: isDark ? AppColors.darkTextMuted : const Color(0xFF94A3B8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              user.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user.email,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isDark ? AppColors.darkCardBorder : AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('🔥', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 4),
                            Text(
                              "${appState.currentStreak}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          appState.currentLanguage == 'Arabic' ? "الأيام المتتالية" : "Streak",
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(height: 36, width: 1, color: isDark ? AppColors.darkCardBorder : AppColors.border),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('⭐', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 4),
                            Text(
                              "${appState.totalXP}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "XP",
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(height: 36, width: 1, color: isDark ? AppColors.darkCardBorder : AppColors.border),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('🏆', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 4),
                            Text(
                              "${earnedBadges.length}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          appState.currentLanguage == 'Arabic' ? "الأوسمة" : "Badges",
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isDark ? AppColors.darkCardBorder : AppColors.border),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF312E81).withValues(alpha: 0.5) : const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isDark ? Icons.dark_mode : Icons.light_mode,
                        color: isDark ? const Color(0xFFA5B4FC) : AppColors.primary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      appState.currentLanguage == 'Arabic' 
                          ? (isDark ? "الوضع الداكن (مفعل)" : "الوضع الداكن (معطل)")
                          : (isDark ? "Dark Mode (Enabled)" : "Dark Mode (Disabled)"),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      appState.currentLanguage == 'Arabic' 
                          ? (isDark ? "مظهر داوم الداكن" : "المظهر الفاتح الكلاسيكي")
                          : (isDark ? "Dawem Dark Theme" : "Classic Light Theme"),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                    value: isDark,
                    activeThumbColor: AppColors.neonGreen,
                    onChanged: (val) => appState.toggleTheme(),
                  ),
                  Divider(height: 1, indent: 60, color: isDark ? AppColors.darkBorderLight : AppColors.borderLight),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E3A8A).withValues(alpha: 0.4) : const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.notifications_outlined, color: AppColors.primary, size: 20),
                    ),
                    title: Text(
                      appState.currentLanguage == 'Arabic' ? "الإشعارات" : "Notifications",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                    ),
                    trailing: Icon(Icons.chevron_right, color: isDark ? AppColors.darkTextMuted : AppColors.textMuted),
                    onTap: () => _showNotificationDialog(context, appState),
                  ),
                  Divider(height: 1, indent: 60, color: isDark ? AppColors.darkBorderLight : AppColors.borderLight),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF064E3B).withValues(alpha: 0.4) : const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.settings_outlined,
                        color: isDark ? AppColors.neonGreen : AppColors.dawemGreenDark,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      appState.currentLanguage == 'Arabic' ? "الإعدادات العامة" : "Settings",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                    ),
                    trailing: Icon(Icons.chevron_right, color: isDark ? AppColors.darkTextMuted : AppColors.textMuted),
                    onTap: () => _showGeneralSettingsDialog(context, appState),
                  ),
                  Divider(height: 1, indent: 60, color: isDark ? AppColors.darkBorderLight : AppColors.borderLight),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF78350F).withValues(alpha: 0.4) : const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.lock_outline, color: AppColors.dawemOrange, size: 20),
                    ),
                    title: Text(
                      appState.currentLanguage == 'Arabic' ? "الخصوصية" : "Privacy",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                    ),
                    trailing: Icon(Icons.chevron_right, color: isDark ? AppColors.darkTextMuted : AppColors.textMuted),
                    onTap: () => _showPrivacyDialog(context, appState),
                  ),
                  Divider(height: 1, indent: 60, color: isDark ? AppColors.darkBorderLight : AppColors.borderLight),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF7F1D1D).withValues(alpha: 0.4) : const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.logout, color: AppColors.error, size: 20),
                    ),
                    title: Text(
                      appState.currentLanguage == 'Arabic' ? "تسجيل الخروج" : "Logout",
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.error),
                    ),
                    trailing: Icon(Icons.chevron_right, color: isDark ? AppColors.darkTextMuted : AppColors.textMuted),
                    onTap: () => _handleLogout(context, appState),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}