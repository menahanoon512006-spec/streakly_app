import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/app_state.dart';
import 'create_goal_screen.dart';
import 'goal_details_screen.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  int _selectedFilterIndex = 0; // 0: All, 1: In Progress, 2: Completed

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
              ? "هل أنت متأكد من حذف هدف '$goalTitle'؟"
              : "Are you sure you want to delete '$goalTitle'?",
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
                  content: Text(
                    isArabic ? "تم حذف الهدف '$goalTitle'" : "Goal '$goalTitle' deleted",
                  ),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.error,
                ),
              );
            },
            child: Text(
              isArabic ? "حذف" : "Delete",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDark = appState.isDarkMode;
    final isArabic = appState.currentLanguage == 'Arabic';
    final allGoals = appState.goals;

    final filteredGoals = allGoals.where((g) {
      if (_selectedFilterIndex == 1) return g.completedDays < g.durationDays;
      if (_selectedFilterIndex == 2) return g.completedDays >= g.durationDays;
      return true;
    }).toList();

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
          isArabic ? "أهدافي" : "My Goals",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: textColor),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primary, size: 26),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CreateGoalScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip(
                  isArabic ? "الكل (${allGoals.length})" : "All (${allGoals.length})",
                  0,
                  isDark,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  isArabic ? "قيد التنفيذ" : "In Progress",
                  1,
                  isDark,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  isArabic ? "مكتملة" : "Completed",
                  2,
                  isDark,
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Goals List
          Expanded(
            child: filteredGoals.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.track_changes_outlined,
                          size: 52,
                          color: isDark ? Colors.white24 : AppColors.textMuted,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          isArabic ? "لا توجد أهداف في هذا القسم" : "No goals found in this view",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: secondaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const CreateGoalScreen()),
                            );
                          },
                          icon: const Icon(Icons.add, size: 18, color: Colors.white),
                          label: Text(
                            isArabic ? "إنشاء هدف" : "Create Goal",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            minimumSize: const Size(160, 44),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    itemCount: filteredGoals.length,
                    separatorBuilder: (_, index) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final goal = filteredGoals[index];
                      return GestureDetector(
                        onTap: () {
                          appState.selectGoal(goal);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => GoalDetailsScreen(goal: goal),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: borderColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFF3F0FF),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text('🎯', style: TextStyle(fontSize: 20)),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          goal.title,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: textColor,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          isArabic
                                              ? "${goal.completedDays} / ${goal.durationDays} يوم • ${goal.dailyMinutes} د/يوم"
                                              : "${goal.completedDays} / ${goal.durationDays} Days • ${goal.dailyMinutes}m/day",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: secondaryTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      "${(goal.progressPercentage * 100).toInt()}%",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: AppColors.error,
                                      size: 22,
                                    ),
                                    onPressed: () {
                                      _showDeleteConfirmation(context, appState, goal.goalId, goal.title);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: goal.progressPercentage,
                                  backgroundColor: isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF1F2F9),
                                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                                  minHeight: 8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
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

  Widget _buildFilterChip(String label, int index, bool isDark) {
    final isSelected = _selectedFilterIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilterIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? const Color(0xFF1E293B) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? Colors.white.withValues(alpha: 0.12) : AppColors.border),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Colors.white
                : (isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}