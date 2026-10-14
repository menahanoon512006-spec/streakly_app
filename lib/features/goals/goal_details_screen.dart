import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/network/api_service.dart';
import '../../providers/app_state.dart';

class GoalDetailsScreen extends StatefulWidget {
  final GoalModel goal;

  const GoalDetailsScreen({super.key, required this.goal});

  @override
  State<GoalDetailsScreen> createState() => _GoalDetailsScreenState();
}

class _GoalDetailsScreenState extends State<GoalDetailsScreen> {
  bool _isGeneratingAi = false;

  Future<void> _handleGenerateAiPlan() async {
    setState(() => _isGeneratingAi = true);
    final appState = Provider.of<AppState>(context, listen: false);
    final isArabic = appState.currentLanguage == 'Arabic';

    try {
      await appState.generateAiPlan(widget.goal.goalId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isArabic 
                  ? "تم توليد خطة الذكاء الاصطناعي عبر Amazon Bedrock RAG! +30 نقطة ⭐"
                  : "AI Plan generated using Amazon Bedrock RAG! +30 XP ⭐",
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isArabic ? "خطأ في التوليد: ${e.toString()}" : "Generation error: ${e.toString()}"),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isGeneratingAi = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isArabic = appState.currentLanguage == 'Arabic';
    
    // Find the latest goal state in AppState
    final liveGoal = appState.goals.firstWhere(
      (g) => g.goalId == widget.goal.goalId,
      orElse: () => widget.goal,
    );
    final tasks = liveGoal.tasks;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          liveGoal.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.edit_outlined),
                        title: Text(isArabic ? 'تعديل تفاصيل الهدف' : 'Edit Goal Details'),
                        onTap: () => Navigator.pop(context),
                      ),
                      ListTile(
                        leading: const Icon(Icons.share_outlined),
                        title: Text(isArabic ? 'مشاركة التقدم في التحدي الاجتماعي' : 'Share Progress to Social Challenge'),
                        onTap: () => Navigator.pop(context),
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete_outline, color: AppColors.error),
                        title: Text(isArabic ? 'أرشفة الهدف' : 'Archive Goal', style: const TextStyle(color: AppColors.error)),
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isArabic 
                            ? "مكتمل ${(liveGoal.progressPercentage * 100).toInt()}%"
                            : "${(liveGoal.progressPercentage * 100).toInt()}% Complete",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        isArabic 
                            ? "${liveGoal.completedDays} / ${liveGoal.durationDays} يوم"
                            : "${liveGoal.completedDays} / ${liveGoal.durationDays} Days",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: liveGoal.progressPercentage,
                      backgroundColor: const Color(0xFFF1F2F9),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      minHeight: 10,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Streak & XP Badges Row
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🔥', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Text(
                          isArabic 
                              ? "${appState.currentStreak} أيام متتالية"
                              : "${appState.currentStreak} Day Streak",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('⭐', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Text(
                          "${appState.totalXP} XP",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Grounded RAG info badge if file attached
            if (liveGoal.attachedPdf != null)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isArabic 
                            ? "مستند إلى ${liveGoal.attachedPdf} عبر قاعدة معرفة Bedrock"
                            : "Grounded in ${liveGoal.attachedPdf} via Bedrock Knowledge Base",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF1E40AF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Today's Tasks
            Text(
              isArabic ? "مهام اليوم" : "Today's Tasks",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            // Tasks List
            if (tasks.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    isArabic ? "لم يتم إنشاء مهام بعد. انشئ خطة ذكية بالأسفل!" : "No tasks created yet. Generate an AI plan below!",
                    style: const TextStyle(color: AppColors.textSecondary),
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: task.isCompleted
                            ? AppColors.success.withValues(alpha: 0.3)
                            : AppColors.border,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      leading: GestureDetector(
                        onTap: () {
                          appState.toggleTask(task.taskId);
                        },
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: task.isCompleted ? AppColors.success : Colors.transparent,
                            border: Border.all(
                              color: task.isCompleted ? AppColors.success : AppColors.textMuted,
                              width: 2,
                            ),
                          ),
                          child: task.isCompleted
                              ? const Icon(Icons.check, size: 16, color: Colors.white)
                              : null,
                        ),
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: task.isCompleted ? AppColors.textMuted : AppColors.textPrimary,
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      subtitle: Text(
                        task.isCompleted 
                            ? (isArabic ? "مكتملة" : "Completed")
                            : (isArabic ? "لم تبدأ بعد" : "Not started"),
                        style: TextStyle(
                          fontSize: 12,
                          color: task.isCompleted ? AppColors.success : AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: task.sourceRefs.isNotEmpty
                          ? const Icon(Icons.menu_book_outlined, size: 18, color: AppColors.primary)
                          : null,
                    ),
                  );
                },
              ),

            const SizedBox(height: 32),

            // "Generate AI Plan" Button
            ElevatedButton(
              onPressed: _isGeneratingAi ? null : _handleGenerateAiPlan,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _isGeneratingAi
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          isArabic ? "جاري توليد خطة الذكاء الاصطناعي..." : "Generating RAG Plan...",
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.auto_awesome, size: 20, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          isArabic ? "توليد خطة بالذكاء الاصطناعي" : "Generate AI Plan",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
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
