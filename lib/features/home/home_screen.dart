import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/app_state.dart';
import '../goals/create_goal_screen.dart';
import '../goals/goal_details_screen.dart';
import '../goals/goals_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showDeleteConfirmation(BuildContext context, AppState appState, String goalId, String goalTitle) {
    final isDark = appState.isDarkMode;
    final isArabic = appState.currentLanguage == 'Arabic';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isArabic ? "حذف الهدف؟" : "Delete Goal?",
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          isArabic 
              ? "هل أنت متأكد من حذف هدف '$goalTitle'؟ سيؤدي هذا إلى إزالة المهام المرتبطة به."
              : "Are you sure you want to delete '$goalTitle'? This will remove associated tasks.",
          style: TextStyle(
            color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              isArabic ? "إلغاء" : "Cancel",
              style: TextStyle(
                color: isDark ? Colors.white70 : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              appState.deleteGoal(goalId);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isArabic ? "تم حذف الهدف '$goalTitle'" : "Goal '$goalTitle' deleted"),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.error,
                ),
              );
            },
            child: Text(isArabic ? "حذف" : "Delete", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
    final activeGoal = appState.activeGoal;
    final tasks = appState.todayTasks;
    final isArabic = appState.currentLanguage == 'Arabic';

    final userName = user.name.isNotEmpty ? user.name : (isArabic ? "مستخدم" : "User");

    final cardColor = isDark ? const Color(0xFF111827) : Colors.white;
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.12) : AppColors.border;
    final textColor = isDark ? Colors.white : AppColors.textPrimary;
    final secondaryTextColor = isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          isArabic ? "صباح الخير،\n$userName" : "Good Morning,\n$userName",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textColor,
            height: 1.2,
          ),
        ),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: Icon(Icons.notifications_none_outlined, size: 28, color: textColor),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isArabic ? "لا توجد إشعارات جديدة" : "No new notifications"),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              Positioned(
                top: 10,
                right: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Streak & XP Indicators
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFFFF3E0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('🔥', style: TextStyle(fontSize: 20)),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${appState.currentStreak}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  isArabic ? "أيام متتالية" : "Day Streak",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: secondaryTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFFEF9C3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('⭐', style: TextStyle(fontSize: 20)),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${appState.totalXP}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "XP",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: secondaryTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Current Goal Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isArabic ? "الهدف الحالي" : "Current Goal",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const GoalsScreen()),
                    );
                  },
                  child: Text(
                    isArabic ? "عرض الكل" : "See All",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Current Goal Card
            if (activeGoal != null)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => GoalDetailsScreen(goal: activeGoal),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFEEF2FF),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              "🎯",
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activeGoal.title,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  isArabic 
                                      ? "${activeGoal.completedDays} / ${activeGoal.durationDays} يوم"
                                      : "${activeGoal.completedDays} / ${activeGoal.durationDays} Days",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: secondaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Percentage Tag
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "${(activeGoal.progressPercentage * 100).toInt()}%",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Trash Delete Icon
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(
                              Icons.delete_outline,
                              color: AppColors.error,
                              size: 22,
                            ),
                            onPressed: () {
                              _showDeleteConfirmation(
                                context,
                                appState,
                                activeGoal.goalId,
                                activeGoal.title,
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: activeGoal.progressPercentage,
                          backgroundColor: isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF1F2F9),
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor),
                ),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(Icons.flag_outlined, size: 40, color: AppColors.textMuted),
                      const SizedBox(height: 10),
                      Text(
                        isArabic ? "لا توجد أهداف بعد" : "No goals yet",
                        style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
                      ),
                      const SizedBox(height: 6),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const CreateGoalScreen()),
                          );
                        },
                        child: Text(isArabic ? "إنشاء هدف" : "Create Goal"),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 30),

            // Today's Tasks Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isArabic ? "مهام اليوم" : "Today's Tasks",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  isArabic ? "عرض الكل" : "View All",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Tasks List
            if (tasks.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    isArabic ? "لا توجد مهام اليوم. أنشئ هدفاً للبدء!" : "No tasks for today. Create a goal to get started!",
                    style: TextStyle(color: secondaryTextColor),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tasks.length,
                separatorBuilder: (_, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: task.isCompleted
                            ? AppColors.success.withValues(alpha: 0.3)
                            : borderColor,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      leading: GestureDetector(
                        onTap: () {
                          appState.toggleTask(task.taskId);
                          if (!task.isCompleted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(isArabic ? "تم إتمام '${task.title}'! +25 نقطة ⭐" : "Completed '${task.title}'! +25 XP ⭐"),
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: AppColors.success,
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: task.isCompleted ? AppColors.success : Colors.transparent,
                            border: Border.all(
                              color: task.isCompleted ? AppColors.success : AppColors.textMuted,
                              width: 2,
                            ),
                          ),
                          child: task.isCompleted
                              ? const Icon(Icons.check, size: 18, color: Colors.white)
                              : null,
                        ),
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: task.isCompleted ? AppColors.textMuted : textColor,
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.access_time, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text(
                            isArabic ? "${task.durationMinutes} دقيقة" : "${task.durationMinutes} min",
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 40),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CreateGoalScreen()),
          );
        },
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}