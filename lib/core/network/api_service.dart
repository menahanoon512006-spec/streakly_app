import 'dart:async';
import 'package:http/http.dart' as http;

/// Models representing the core entities from the Streakly / Dawem specification
class UserModel {
  final String userId;
  final String name;
  final String email;
  final String timezone;
  final Map<String, dynamic> notificationPreferences;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    this.timezone = 'UTC+3',
    this.notificationPreferences = const {'reminders': true, 'achievements': true, 'challenges': true},
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId: json['userId'] ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        timezone: json['timezone'] ?? 'UTC+3',
        notificationPreferences: json['notificationPreferences'] ?? {},
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'name': name,
        'email': email,
        'timezone': timezone,
        'notificationPreferences': notificationPreferences,
      };
}

class DailyTaskModel {
  final String taskId;
  final String goalId;
  final int dayNumber;
  final String title;
  final String description;
  final int durationMinutes;
  bool isCompleted;
  final List<String> sourceRefs;

  DailyTaskModel({
    required this.taskId,
    required this.goalId,
    required this.dayNumber,
    required this.title,
    required this.description,
    required this.durationMinutes,
    this.isCompleted = false,
    this.sourceRefs = const [],
  });

  factory DailyTaskModel.fromJson(Map<String, dynamic> json) => DailyTaskModel(
        taskId: json['taskId'] ?? '',
        goalId: json['goalId'] ?? '',
        dayNumber: json['dayNumber'] ?? 1,
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        durationMinutes: json['durationMinutes'] ?? 20,
        isCompleted: json['isCompleted'] ?? false,
        sourceRefs: List<String>.from(json['sourceRefs'] ?? []),
      );

  Map<String, dynamic> toJson() => {
        'taskId': taskId,
        'goalId': goalId,
        'dayNumber': dayNumber,
        'title': title,
        'description': description,
        'durationMinutes': durationMinutes,
        'isCompleted': isCompleted,
        'sourceRefs': sourceRefs,
      };
}

class GoalModel {
  final String goalId;
  final String title;
  final String description;
  final int durationDays;
  final int dailyMinutes;
  final DateTime startDate;
  final String level;
  int completedDays;
  final String status;
  final String? attachedPdf;
  final List<DailyTaskModel> tasks;

  GoalModel({
    required this.goalId,
    required this.title,
    required this.description,
    required this.durationDays,
    required this.dailyMinutes,
    required this.startDate,
    this.level = 'Beginner',
    this.completedDays = 0,
    this.status = 'IN_PROGRESS',
    this.attachedPdf,
    this.tasks = const [],
  });

  double get progressPercentage {
    if (durationDays == 0) return 0.0;
    return (completedDays / durationDays).clamp(0.0, 1.0);
  }

  factory GoalModel.fromJson(Map<String, dynamic> json) => GoalModel(
        goalId: json['goalId'] ?? '',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        durationDays: json['durationDays'] ?? 30,
        dailyMinutes: json['dailyMinutes'] ?? 60,
        startDate: DateTime.tryParse(json['startDate'] ?? '') ?? DateTime.now(),
        level: json['level'] ?? 'Beginner',
        completedDays: json['completedDays'] ?? 0,
        status: json['status'] ?? 'IN_PROGRESS',
        attachedPdf: json['attachedPdf'],
        tasks: (json['tasks'] as List<dynamic>?)
                ?.map((e) => DailyTaskModel.fromJson(e))
                .toList() ??
            [],
      );
}

class BadgeModel {
  final String badgeId;
  final String name;
  final String description;
  final String iconRef;
  final bool isEarned;
  final DateTime? awardedAt;

  BadgeModel({
    required this.badgeId,
    required this.name,
    required this.description,
    required this.iconRef,
    this.isEarned = false,
    this.awardedAt,
  });
}

class ChallengeModel {
  final String challengeId;
  final String title;
  final String goalType;
  final int participantCount;
  final int rewardXp;
  final int daysLeft;
  bool isJoined;
  int userProgress;

  ChallengeModel({
    required this.challengeId,
    required this.title,
    required this.goalType,
    required this.participantCount,
    required this.rewardXp,
    required this.daysLeft,
    this.isJoined = false,
    this.userProgress = 0,
  });
}

/// Service handling API integration with AWS Lambda / API Gateway and local simulation
class ApiService {
  final String baseUrl;
  final http.Client client = http.Client();

  ApiService({this.baseUrl = 'https://api.streakly.aws.cloud'});

  // In-memory data store for immediate dynamic preview
  static final List<GoalModel> _mockGoals = [
    GoalModel(
      goalId: 'g-101',
      title: 'Learn Python',
      description: 'Master fundamentals, control flow, functions and object-oriented programming.',
      durationDays: 30,
      dailyMinutes: 60,
      startDate: DateTime.now().subtract(const Duration(days: 12)),
      completedDays: 12,
      level: 'Intermediate',
      attachedPdf: 'python_crash_course.pdf',
      tasks: [
        DailyTaskModel(
          taskId: 't-1',
          goalId: 'g-101',
          dayNumber: 13,
          title: 'Learn Variables & Data Types',
          description: 'Explore primitives, strings, integers, and dynamic typing.',
          durationMinutes: 20,
          isCompleted: true,
          sourceRefs: ['Chapter 1 - Python Basics.pdf, p. 12-18'],
        ),
        DailyTaskModel(
          taskId: 't-2',
          goalId: 'g-101',
          dayNumber: 13,
          title: 'Practice Loops & Iteration',
          description: 'Write for-loops, while-loops, and list comprehensions.',
          durationMinutes: 20,
          isCompleted: false,
          sourceRefs: ['Chapter 2 - Control Structures.pdf, p. 25-30'],
        ),
        DailyTaskModel(
          taskId: 't-3',
          goalId: 'g-101',
          dayNumber: 13,
          title: 'Solve 5 Practice Questions',
          description: 'Solidify your understanding by solving algorithmic problems.',
          durationMinutes: 10,
          isCompleted: false,
          sourceRefs: ['Exercises 2.4 - 2.8'],
        ),
      ],
    ),
    GoalModel(
      goalId: 'g-102',
      title: 'Mobile App Architecture',
      description: 'Clean Architecture with Flutter, State Management & TDD.',
      durationDays: 21,
      dailyMinutes: 45,
      startDate: DateTime.now().subtract(const Duration(days: 5)),
      completedDays: 5,
      level: 'Advanced',
      tasks: [
        DailyTaskModel(
          taskId: 't-4',
          goalId: 'g-102',
          dayNumber: 6,
          title: 'Study Repository Pattern',
          description: 'Decouple data sources from domain logic cleanly.',
          durationMinutes: 30,
          isCompleted: true,
        ),
        DailyTaskModel(
          taskId: 't-5',
          goalId: 'g-102',
          dayNumber: 6,
          title: 'Implement Network Interceptors',
          description: 'Handle token refreshing and error states gracefully.',
          durationMinutes: 15,
          isCompleted: false,
        ),
      ],
    ),
  ];

  static final List<ChallengeModel> _mockChallenges = [
    ChallengeModel(
      challengeId: 'c-1',
      title: '30-Day Coding Sprint',
      goalType: 'Programming',
      participantCount: 1420,
      rewardXp: 500,
      daysLeft: 18,
      isJoined: true,
      userProgress: 40,
    ),
    ChallengeModel(
      challengeId: 'c-2',
      title: 'Morning Reading Club',
      goalType: 'Reading',
      participantCount: 890,
      rewardXp: 300,
      daysLeft: 25,
      isJoined: false,
      userProgress: 0,
    ),
    ChallengeModel(
      challengeId: 'c-3',
      title: 'Deep Focus & Consistency',
      goalType: 'Habit',
      participantCount: 2310,
      rewardXp: 750,
      daysLeft: 12,
      isJoined: true,
      userProgress: 65,
    ),
  ];

  static final List<BadgeModel> _mockBadges = [
    BadgeModel(
      badgeId: 'b-1',
      name: 'Daily Starter',
      description: 'Completed your very first task on Streakly.',
      iconRef: 'rocket',
      isEarned: true,
      awardedAt: DateTime.now().subtract(const Duration(days: 12)),
    ),
    BadgeModel(
      badgeId: 'b-2',
      name: '7-Day Streak',
      description: 'Kept the fire burning for 7 consecutive days!',
      iconRef: 'fire',
      isEarned: true,
      awardedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    BadgeModel(
      badgeId: 'b-3',
      name: 'Knowledge Check',
      description: 'Aced an AI-grounded quiz from learning material.',
      iconRef: 'sparkles',
      isEarned: true,
      awardedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    BadgeModel(
      badgeId: 'b-4',
      name: 'Goal Finisher',
      description: 'Successfully reached 100% on a major goal.',
      iconRef: 'trophy',
      isEarned: true,
      awardedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    BadgeModel(
      badgeId: 'b-5',
      name: '30-Day Master',
      description: 'Maintain consistency for 30 consecutive days.',
      iconRef: 'crown',
      isEarned: false,
    ),
  ];

  /// Fetch active goals
  Future<List<GoalModel>> getGoals() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_mockGoals);
  }

  /// Create new Goal
  Future<GoalModel> createGoal({
    required String title,
    required int durationDays,
    required int dailyMinutes,
    String? learningFile,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newGoal = GoalModel(
      goalId: 'g-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: 'Personalized goal roadmap generated for $title.',
      durationDays: durationDays,
      dailyMinutes: dailyMinutes,
      startDate: DateTime.now(),
      completedDays: 0,
      attachedPdf: learningFile,
      tasks: [
        DailyTaskModel(
          taskId: 't-${DateTime.now().millisecondsSinceEpoch}-1',
          goalId: 'g-${DateTime.now().millisecondsSinceEpoch}',
          dayNumber: 1,
          title: 'Introduction & Foundations to $title',
          description: 'Cover foundational prerequisites and setup environment.',
          durationMinutes: (dailyMinutes / 2).round(),
          isCompleted: false,
          sourceRefs: learningFile != null ? ['$learningFile: Overview Chapter'] : [],
        ),
        DailyTaskModel(
          taskId: 't-${DateTime.now().millisecondsSinceEpoch}-2',
          goalId: 'g-${DateTime.now().millisecondsSinceEpoch}',
          dayNumber: 1,
          title: 'Hands-on Practice & Core Concepts',
          description: 'Deep dive into practical application and test exercises.',
          durationMinutes: (dailyMinutes / 2).round(),
          isCompleted: false,
        ),
      ],
    );
    _mockGoals.add(newGoal);
    return newGoal;
  }

  /// Complete a task idempotently and compute streak / XP increment
  Future<Map<String, dynamic>> completeTask(String taskId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    for (var goal in _mockGoals) {
      for (var task in goal.tasks) {
        if (task.taskId == taskId) {
          task.isCompleted = true;
          return {
            'success': true,
            'xpEarned': 25,
            'currentStreak': 7,
            'message': 'Task completed! +25 XP earned 🔥',
          };
        }
      }
    }
    return {'success': false, 'message': 'Task not found'};
  }

  /// Generate RAG AI Plan
  Future<List<DailyTaskModel>> generateAiPlan(String goalId) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    final goal = _mockGoals.firstWhere((g) => g.goalId == goalId, orElse: () => _mockGoals.first);
    final generatedTasks = [
      DailyTaskModel(
        taskId: 'ai-${DateTime.now().millisecondsSinceEpoch}-1',
        goalId: goalId,
        dayNumber: goal.completedDays + 1,
        title: 'Deep Dive: Advanced Patterns in ${goal.title}',
        description: 'Bedrock RAG extraction from knowledge base chunks.',
        durationMinutes: 25,
        sourceRefs: ['Section 4.1 Grounded Syllabus: p. 45-52'],
      ),
      DailyTaskModel(
        taskId: 'ai-${DateTime.now().millisecondsSinceEpoch}-2',
        goalId: goalId,
        dayNumber: goal.completedDays + 1,
        title: 'Algorithmic Problem Set & Interactive Quiz',
        description: 'Grounded quiz testing comprehension of key topics.',
        durationMinutes: 20,
        sourceRefs: ['Quiz Generator API: Bedrock Titan/Claude Grounding'],
      ),
    ];
    goal.tasks.addAll(generatedTasks);
    return generatedTasks;
  }

  /// Fetch Challenges
  Future<List<ChallengeModel>> getChallenges() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_mockChallenges);
  }

  /// Join Challenge
  Future<bool> joinChallenge(String challengeId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final challenge = _mockChallenges.firstWhere((c) => c.challengeId == challengeId);
    challenge.isJoined = true;
    challenge.userProgress = 10;
    return true;
  }

  /// Fetch Badges
  Future<List<BadgeModel>> getBadges() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_mockBadges);
  }
}
