import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/network/api_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Central Reactive State Provider managing authentication, gamification, goals, tasks, and streaks.
class AppState extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  // ==========================================
  // 🔊 إعدادات الصوتيات والاهتزاز واللغة
  // ==========================================
  bool isSoundEnabled = true;
  bool isHapticEnabled = true;
  String _currentLanguage = 'English'; // القيمة الافتراضية
  
  String get currentLanguage => _currentLanguage;

  final AudioPlayer _audioPlayer = AudioPlayer();

  // دالة تشغيل صوت النجاح
  Future<void> playSuccessSound() async {
    if (isSoundEnabled) {
      try {
        await _audioPlayer.play(AssetSource('sounds/success.mp3'));
      } catch (e) {
        print("Error playing sound: $e");
      }
    }
  }

  // دالة تشغيل الاهتزاز اللمسي
  void triggerHaptic() {
    if (isHapticEnabled) {
      HapticFeedback.lightImpact();
    }
  }

  // التبديل بين تشغيل/إيقاف الأصوات
  void toggleSoundEffects(bool value) {
    isSoundEnabled = value;
    notifyListeners();
  }

  // التبديل بين تشغيل/إيقاف الاهتزاز
  void toggleHapticFeedback(bool value) {
    isHapticEnabled = value;
    notifyListeners();
  }

  // تحديث لغة التطبيق
  void setLanguage(String lang) {
    _currentLanguage = lang;
    notifyListeners();
  }
  // ==========================================

  /// مسح تحدي بواسطة الـ ID
  void deleteChallenge(String challengeId) {
    _challenges.removeWhere((c) => c.challengeId == challengeId);
    notifyListeners();
  }

  UserModel _user = UserModel(
    userId: '',
    name: '',
    email: '',
  );

  bool _isLoggedIn = false;
  ThemeMode _themeMode = ThemeMode.dark; 
  int _currentStreak = 0; // يبدأ من الصفر
  final int _longestStreak = 0;
  int _totalXP = 0; // يبدأ من الصفر
  bool _isLoading = false;

  List<GoalModel> _goals = []; // قائمة أهداف فارغة تماماً
  GoalModel? _activeGoal;
  
  // التحديات الافتراضية مع دعم التصنيفات للبحث والفلترة
  final List<ChallengeModel> _challenges = [
    ChallengeModel(
      challengeId: 'c1',
      title: 'Morning Reading Club',
      rewardXp: 300,
      isJoined: false,
      goalType: 'Reading',
      participantCount: 15,
      daysLeft: 10,
    ),
    ChallengeModel(
      challengeId: 'c2',
      title: '30-Day Coding Sprint',
      rewardXp: 500,
      isJoined: false,
      goalType: 'Coding',
      participantCount: 32,
      daysLeft: 25,
    ),
  ];
  
  List<BadgeModel> _badges = [];

  // متغيرات خاصة بالبحث والفلترة في صفحة التحديات
  String _challengeSearchQuery = '';
  String _selectedChallengeFilter = 'All';

  // Getters
  UserModel get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  int get currentStreak => _currentStreak;
  int get longestStreak => _longestStreak;
  int get totalXP => _totalXP;
  bool get isLoading => _isLoading;
  List<GoalModel> get goals => _goals;
  GoalModel? get activeGoal => _activeGoal;
  List<BadgeModel> get badges => _badges;
  List<DailyTaskModel> get todayTasks => activeGoal?.tasks ?? [];

  // Getters للبحث والفلترة
  String get challengeSearchQuery => _challengeSearchQuery;
  String get selectedChallengeFilter => _selectedChallengeFilter;

  // قائمة التحديات المفلترة والمعربة ديناميكياً بناءً على اللغة المختارة
  List<ChallengeModel> get challenges {
    final isArabic = _currentLanguage == 'Arabic';

    return _challenges.where((c) {
      final matchesSearch = c.title.toLowerCase().contains(_challengeSearchQuery.toLowerCase()) ||
          (isArabic && _getTranslatedTitle(c.title).toLowerCase().contains(_challengeSearchQuery.toLowerCase()));
      
      final matchesFilter = _selectedChallengeFilter == 'All' || 
          c.goalType.toLowerCase() == _selectedChallengeFilter.toLowerCase() ||
          (isArabic && _translateCategoryToEnglish(_selectedChallengeFilter).toLowerCase() == c.goalType.toLowerCase());
      
      return matchesSearch && matchesFilter;
    }).map((c) {
      if (isArabic) {
        return ChallengeModel(
          challengeId: c.challengeId,
          title: _getTranslatedTitle(c.title),
          rewardXp: c.rewardXp,
          isJoined: c.isJoined,
          goalType: _getTranslatedCategory(c.goalType),
          participantCount: c.participantCount,
          daysLeft: c.daysLeft,
        );
      }
      return c;
    }).toList();
  }

  // دوال مساعدة لترجمة العناوين والتصنيفات للعربية
  String _getTranslatedTitle(String englishTitle) {
    if (englishTitle == 'Morning Reading Club') return 'نادي القراءة الصباحي';
    if (englishTitle == '30-Day Coding Sprint') return 'سباق البرمجة لـ 30 يوماً';
    return englishTitle;
  }

  String _getTranslatedCategory(String englishCategory) {
    if (englishCategory.toLowerCase() == 'reading') return 'قراءة';
    if (englishCategory.toLowerCase() == 'coding') return 'برمجة';
    if (englishCategory.toLowerCase() == 'general') return 'عام';
    return englishCategory;
  }

  String _translateCategoryToEnglish(String arabicCategory) {
    if (arabicCategory == 'قراءة') return 'Reading';
    if (arabicCategory == 'برمجة') return 'Coding';
    if (arabicCategory == 'عام') return 'General';
    if (arabicCategory == 'الكل') return 'All';
    return arabicCategory;
  }

  // تحديث نص البحث
  void setChallengeSearchQuery(String query) {
    _challengeSearchQuery = query;
    notifyListeners();
  }

  // تحديث التصنيف المختار
  void setChallengeFilter(String filter) {
    _selectedChallengeFilter = filter;
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  AppState() {
    _initializeData();
  }

  Future<void> _initializeData() async {
    _setLoading(true);
    _goals = [];
    _activeGoal = null;

    // استرجاع حالة تسجيل الدخول المخزنة محلياً عند بدء التطبيق
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (_isLoggedIn) {
      final storedEmail = prefs.getString('userEmail') ?? '';
      final storedName = prefs.getString('userName') ?? (storedEmail.contains('@') ? storedEmail.split('@').first.capitalize() : 'User');
      _user = UserModel(
        userId: prefs.getString('userId') ?? 'u-${DateTime.now().millisecondsSinceEpoch}',
        name: storedName,
        email: storedEmail,
      );
    }

    _badges = await _apiService.getBadges();
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Sign In with Email & Password (مع التحقق من وجود الحساب مسجلاً مسبقاً)
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    await Future.delayed(const Duration(milliseconds: 700)); 

    final prefs = await SharedPreferences.getInstance();
    final registeredEmail = prefs.getString('registeredEmail');

    // إذا لم يكن الإيميل مسجلاً من قبل، نمنع الدخول ونظهر خطأ
    if (registeredEmail == null || registeredEmail != email) {
      _setLoading(false);
      throw Exception('Account not found. Please sign up first!');
    }

    final userId = prefs.getString('userId') ?? 'u-${DateTime.now().millisecondsSinceEpoch}';
    final userName = prefs.getString('userName') ?? email.split('@').first.capitalize();

    _user = UserModel(
      userId: userId,
      name: userName,
      email: email,
    );
    _isLoggedIn = true;

    // حفظ حالة الدخول الحالية
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userEmail', email);

    _setLoading(false);
    notifyListeners();
    return true;
  }

  /// Sign Up / Register
  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    await Future.delayed(const Duration(milliseconds: 800)); 
    final userId = 'u-${DateTime.now().millisecondsSinceEpoch}';

    _user = UserModel(
      userId: userId,
      name: name,
      email: email,
    );
    _isLoggedIn = true;

    // حفظ البيانات وتسجيل الإيميل كحساب رسمي جديد
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('registeredEmail', email); // حفظ الإيميل المسجل للتحقق منه في Login
    await prefs.setString('userEmail', email);
    await prefs.setString('userName', name);
    await prefs.setString('userId', userId);

    _setLoading(false);
    notifyListeners();
    return true;
  }

  /// Logout
  Future<void> logout() async {
    _isLoggedIn = false;
    _user = UserModel(userId: '', name: '', email: '');
    _goals = [];
    _activeGoal = null;
    _currentStreak = 0;
    _totalXP = 0;
    for (var c in _challenges) {
      c.isJoined = false;
    }

    // مسح البيانات المخزنة محلياً عند الخروج
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }

  /// Toggle completion state of a daily task with gamification reward
  Future<void> toggleTask(String taskId) async {
    DailyTaskModel? targetTask;
    for (var goal in _goals) {
      for (var task in goal.tasks) {
        if (task.taskId == taskId) {
          targetTask = task;
          break;
        }
      }
    }

    if (targetTask == null) return;

    final wasCompleted = targetTask.isCompleted;
    targetTask.isCompleted = !wasCompleted;

    if (!wasCompleted) {
      _totalXP += 25;
      _currentStreak = _currentStreak == 0 ? 1 : _currentStreak; 
      
      playSuccessSound();
      triggerHaptic();
    } else {
      _totalXP = (_totalXP - 25).clamp(0, 999999);
    }

    if (activeGoal != null) {
      final total = activeGoal!.tasks.length;
      final completed = activeGoal!.tasks.where((t) => t.isCompleted).length;
      if (total > 0) {
        activeGoal!.completedDays = (activeGoal!.durationDays * (completed / total)).round().clamp(0, activeGoal!.durationDays);
      }
    }

    notifyListeners();
  }

  /// Create a new Goal
  Future<GoalModel> createGoal({
    required String title,
    required int durationDays,
    required int dailyMinutes,
    String? learningFile,
  }) async {
    _setLoading(true);
    final newGoal = await _apiService.createGoal(
      title: title,
      durationDays: durationDays,
      dailyMinutes: dailyMinutes,
      learningFile: learningFile,
    );
    _goals.insert(0, newGoal);
    _activeGoal = newGoal;
    _totalXP += 50; 
    _currentStreak = _currentStreak == 0 ? 1 : _currentStreak; 
    _setLoading(false);
    notifyListeners();
    return newGoal;
  }

  /// Delete a Goal by ID and clear active goal if deleted
  void deleteGoal(String goalId) {
    _goals.removeWhere((goal) => goal.goalId == goalId);
    if (_activeGoal?.goalId == goalId) {
      _activeGoal = _goals.isNotEmpty ? _goals.first : null;
    }
    notifyListeners();
  }

  /// Select active goal
  void selectGoal(GoalModel goal) {
    _activeGoal = goal;
    notifyListeners();
  }

  /// Generate AI grounded plan with Amazon Bedrock RAG
  Future<void> generateAiPlan(String goalId) async {
    _setLoading(true);
    await _apiService.generateAiPlan(goalId);
    _totalXP += 30; 
    _setLoading(false);
    notifyListeners();
  }

  /// Join a challenge
  Future<void> joinChallenge(String challengeId) async {
    final challenge = _challenges.firstWhere((c) => c.challengeId == challengeId);
    challenge.isJoined = true;
    _totalXP += 40;
    notifyListeners();
  }

  /// إنشاء تحدي جديد بواسطة المستخدم (Create Custom Challenge)
  void createChallenge({
    required String title,
    required String goalType,
    required int rewardXp,
    required int daysLeft,
  }) {
    final newChallenge = ChallengeModel(
      challengeId: 'c-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      rewardXp: rewardXp,
      isJoined: false,
      goalType: goalType,
      participantCount: 1,
      daysLeft: daysLeft,
    );
    _challenges.insert(0, newChallenge);
    notifyListeners();
  }

  // متغيرات حالة الإشعارات صريحة لتجنب أي مشاكل في التحديث
  bool _notifReminders = true;
  bool _notifAchievements = true;
  bool _notifChallenges = true;

  bool get notifReminders => _notifReminders;
  bool get notifAchievements => _notifAchievements;
  bool get notifChallenges => _notifChallenges;

  void updateNotificationSetting(String key, bool value) {
    if (key == 'reminders') _notifReminders = value;
    if (key == 'achievements') _notifAchievements = value;
    if (key == 'challenges') _notifChallenges = value;
    notifyListeners(); 
  }

  /// Update notification preferences
  void updateNotificationPref(String key, bool value) {
    _user.notificationPreferences[key] = value;
    notifyListeners();
  }

  // متغيرات إعدادات الخصوصية
  bool _privacyPublicProfile = true;
  bool _privacyShareActivity = true;
  bool _privacyShowStreak = true;

  bool get privacyPublicProfile => _privacyPublicProfile;
  bool get privacyShareActivity => _privacyShareActivity;
  bool get privacyShowStreak => _privacyShowStreak;

  void updatePrivacySetting(String key, bool value) {
    if (key == 'publicProfile') _privacyPublicProfile = value;
    if (key == 'shareActivity') _privacyShareActivity = value;
    if (key == 'showStreak') _privacyShowStreak = value;
    notifyListeners();
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}