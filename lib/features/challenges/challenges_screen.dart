import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // نافذة المتصدرين
  void _showLeaderboardDialog(BuildContext context, AppState appState, String challengeTitle) {
    final isDark = appState.isDarkMode;
    final isArabic = appState.currentLanguage == 'Arabic';

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final currentUserName = appState.privacyPublicProfile ? appState.user.name : (isArabic ? "مستخدم مجهول" : "Anonymous User");
        final currentUserStreak = appState.privacyShowStreak ? "🔥 ${appState.currentStreak} ${isArabic ? 'يوم' : 'd'}" : (isArabic ? "🔥 مخفي" : "🔥 Hidden");
        final currentUserXP = appState.totalXP;

        List<Map<String, dynamic>> leaderboardData = [];

        if (appState.privacyShareActivity) {
          leaderboardData.add({
            "name": currentUserName,
            "score": currentUserXP,
            "streak": currentUserStreak,
            "isMe": true,
          });
        }

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.leaderboard, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        isArabic ? "لوحة متصدرين '$challengeTitle'" : "$challengeTitle Leaderboard",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: isDark ? Colors.grey : Colors.black54),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (leaderboardData.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Center(
                    child: Text(
                      isArabic ? "مشاركة النشاط معطلة في إعدادات الخصوصية." : "Activity sharing is turned off in Privacy settings.",
                      style: TextStyle(color: isDark ? Colors.grey : Colors.black54),
                    ),
                  ),
                )
              else
                ...leaderboardData.asMap().entries.map((entry) {
                  int index = entry.key;
                  var participant = entry.value;
                  final isMe = participant['isMe'] == true;
                  String rankSymbol = "#${index + 1}";

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe 
                          ? Colors.deepPurple.withValues(alpha: 0.2) 
                          : (isDark ? const Color(0xFF0F172A) : Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(12),
                      border: isMe ? Border.all(color: Colors.deepPurple, width: 1.5) : null,
                    ),
                    child: Row(
                      children: [
                        Text(
                          rankSymbol,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            participant['name'].toString(),
                            style: TextStyle(
                              fontWeight: isMe ? FontWeight.bold : FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                        Text(
                          participant['streak'].toString(),
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isDark ? Colors.white70 : Colors.black54),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "${participant['score']} XP",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  // نافذة منبثقة لإنشاء تحدي جديد
  void _showCreateChallengeDialog(BuildContext context, AppState appState) {
    final titleController = TextEditingController();
    final categoryController = TextEditingController(text: 'General');
    int rewardXp = 300;
    int daysLeft = 14;
    final isDark = appState.isDarkMode;
    final isArabic = appState.currentLanguage == 'Arabic';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        title: Text(isArabic ? 'إنشاء تحدي جديد' : 'Create New Challenge', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  labelText: isArabic ? 'عنوان التحدي' : 'Challenge Title',
                  labelStyle: TextStyle(color: isDark ? Colors.grey : Colors.black54),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: isDark ? Colors.grey : Colors.black26)),
                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: categoryController,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  labelText: isArabic ? 'التصنيف (مثل: برمجة، لغات)' : 'Category / Tag (e.g. Coding, Reading)',
                  labelStyle: TextStyle(color: isDark ? Colors.grey : Colors.black54),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: isDark ? Colors.grey : Colors.black26)),
                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isArabic ? 'إلغاء' : 'Cancel', style: TextStyle(color: isDark ? Colors.grey : Colors.black54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                final category = categoryController.text.trim().isEmpty 
                    ? 'General' 
                    : categoryController.text.trim();

                Provider.of<AppState>(context, listen: false).createChallenge(
                  title: titleController.text,
                  goalType: category,
                  rewardXp: rewardXp,
                  daysLeft: daysLeft,
                );
                Navigator.pop(context);
              }
            },
            child: Text(isArabic ? 'إنشاء' : 'Create', style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDark = appState.isDarkMode;
    final allFilteredChallenges = appState.challenges;
    final isArabic = appState.currentLanguage == 'Arabic';
    
    final exploreChallenges = allFilteredChallenges.where((c) => !c.isJoined).toList();
    final joinedChallenges = allFilteredChallenges.where((c) => c.isJoined).toList();

    final availableCategories = <String>{isArabic ? 'الكل' : 'All'};
    for (var c in appState.challenges) {
      if (c.goalType.isNotEmpty) {
        availableCategories.add(c.goalType);
      }
    }

    // الألوان الصريحة بناءً على الوضع (مفتوح أو داكن) لمنع أي تداخل
    final scaffoldBgColor = isDark ? const Color(0xFF12121A) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.grey.shade500; // تم تعديلها لتكون واضحة وفاتحة في الوضع الفاتح
    final realCardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final inputColor = isDark ? const Color(0xFF1E1E2C) : Colors.grey.shade100;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(isArabic ? 'التحديات الجماعية' : 'Social Challenges', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.deepPurple, size: 28),
            onPressed: () => _showCreateChallengeDialog(context, appState),
            tooltip: isArabic ? 'إنشاء تحدي' : 'Create Challenge',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.deepPurple,
          labelColor: textColor,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(text: isArabic ? 'استكشاف (${exploreChallenges.length})' : 'Explore (${exploreChallenges.length})'),
            Tab(text: isArabic ? 'المنضم إليها (${joinedChallenges.length})' : 'Joined (${joinedChallenges.length})'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (val) => appState.setChallengeSearchQuery(val),
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: isArabic ? 'بحث في التحديات...' : 'Search challenges...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              appState.setChallengeSearchQuery('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: inputColor,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: availableCategories.map((filter) {
                      final isSelected = appState.selectedChallengeFilter == filter || (isArabic && appState.selectedChallengeFilter == 'All' && filter == 'الكل');
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: isSelected,
                          selectedColor: Colors.deepPurple,
                          backgroundColor: inputColor,
                          labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.grey),
                          onSelected: (selected) {
                            String targetFilter = filter;
                            if (filter == 'الكل') targetFilter = 'All';
                            appState.setChallengeFilter(targetFilter);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                exploreChallenges.isEmpty
                    ? Center(child: Text(isArabic ? 'لا توجد تحديات متاحة' : 'No challenges found', style: const TextStyle(color: Colors.grey)))
                    : ListView.builder(
                        itemCount: exploreChallenges.length,
                        itemBuilder: (context, index) {
                          final challenge = exploreChallenges[index];
                          return Card(
                            color: realCardBg,
                            elevation: isDark ? 0 : 2,
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: isDark ? BorderSide.none : BorderSide(color: Colors.grey.shade300, width: 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Chip(
                                        label: Text(challenge.goalType),
                                        backgroundColor: Colors.amber.withValues(alpha: 0.2),
                                        labelStyle: const TextStyle(color: Colors.amber, fontSize: 12),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '+${challenge.rewardXp} XP',
                                            style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(width: 8),
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                            onPressed: () => appState.deleteChallenge(challenge.challengeId),
                                            tooltip: isArabic ? 'حذف التحدي' : 'Delete Challenge',
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(challenge.title, style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                                      onPressed: () => appState.joinChallenge(challenge.challengeId),
                                      child: Text(isArabic ? 'انضمام للتحدي' : 'Join Challenge', style: const TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                joinedChallenges.isEmpty
                    ? Center(child: Text(isArabic ? 'لم تنضم لأي تحديات بعد.' : 'You have not joined any challenges yet.', style: const TextStyle(color: Colors.grey)))
                    : ListView.builder(
                        itemCount: joinedChallenges.length,
                        itemBuilder: (context, index) {
                          final challenge = joinedChallenges[index];
                          return Card(
                            color: realCardBg,
                            elevation: isDark ? 0 : 2,
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: isDark ? BorderSide.none : BorderSide(color: Colors.grey.shade300, width: 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Chip(
                                        label: Text(challenge.goalType),
                                        backgroundColor: Colors.amber.withValues(alpha: 0.2),
                                        labelStyle: const TextStyle(color: Colors.amber, fontSize: 12),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '+${challenge.rewardXp} XP',
                                            style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(width: 8),
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                            onPressed: () => appState.deleteChallenge(challenge.challengeId),
                                            tooltip: isArabic ? 'حذف التحدي' : 'Delete Challenge',
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(challenge.title, style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 12),
                                  GestureDetector(
                                    onTap: () => _showLeaderboardDialog(context, appState, challenge.title),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.green),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          '✓ Joined • View Leaderboard',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}