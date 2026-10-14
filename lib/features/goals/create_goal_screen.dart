import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/app_state.dart';
import 'goal_details_screen.dart';

class CreateGoalScreen extends StatefulWidget {
  const CreateGoalScreen({super.key});

  @override
  State<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  int _selectedDuration = 30;
  int _selectedDailyTime = 60; // minutes
  String? _uploadedFileName;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _handlePickFile() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final isArabic = appState.currentLanguage == 'Arabic';

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      );

      if (result != null && result.files.single.name.isNotEmpty) {
        setState(() {
          _uploadedFileName = result.files.single.name;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isArabic ? "تم اختيار: $_uploadedFileName" : "Selected: $_uploadedFileName"),
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isArabic ? "خطأ في اختيار الملف: ${e.toString()}" : "Error picking file: ${e.toString()}"),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _removeUploadedPdf() {
    setState(() {
      _uploadedFileName = null;
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final appState = Provider.of<AppState>(context, listen: false);

    try {
      final newGoal = await appState.createGoal(
        title: _titleController.text.trim(),
        durationDays: _selectedDuration,
        dailyMinutes: _selectedDailyTime,
        learningFile: _uploadedFileName,
      );

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => GoalDetailsScreen(goal: newGoal),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.toString()}"),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDark = appState.isDarkMode;
    final isArabic = appState.currentLanguage == 'Arabic';

    final cardColor = isDark ? const Color(0xFF111827) : Colors.white;
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.12) : const Color(0xFFCBD5E1);
    final textColor = isDark ? Colors.white : AppColors.textPrimary;
    final secondaryTextColor = isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary;

    // خيارات المدة مترجمة
    final List<Map<String, dynamic>> durationOptions = [
      {'label': isArabic ? 'أسبوع واحد (7 أيام)' : '7 Days (1 Week)', 'value': 7},
      {'label': isArabic ? 'أسبوعان (14 يوم)' : '14 Days (2 Weeks)', 'value': 14},
      {'label': isArabic ? '3 أسابيع (21 يوم)' : '21 Days (3 Weeks)', 'value': 21},
      {'label': isArabic ? 'شهر (30 يوم)' : '30 Days (1 Month)', 'value': 30},
      {'label': isArabic ? '45 يوماً (1.5 شهر)' : '45 Days (1.5 Months)', 'value': 45},
      {'label': isArabic ? 'شهران (60 يوم)' : '60 Days (2 Months)', 'value': 60},
      {'label': isArabic ? '3 أشهر (90 يوم)' : '90 Days (3 Months)', 'value': 90},
      {'label': isArabic ? '4 أشهر (120 يوم)' : '120 Days (4 Months)', 'value': 120},
      {'label': isArabic ? '6 أشهر (180 يوم)' : '180 Days (6 Months)', 'value': 180},
      {'label': isArabic ? 'سنة واحدة (365 يوم)' : '365 Days (1 Year)', 'value': 365},
    ];

    // خيارات الوقت اليومي مترجمة
    final List<Map<String, dynamic>> dailyTimeOptions = [
      {'label': isArabic ? '15 دقيقة' : '15 Minutes', 'value': 15},
      {'label': isArabic ? '30 دقيقة' : '30 Minutes', 'value': 30},
      {'label': isArabic ? '45 دقيقة' : '45 Minutes', 'value': 45},
      {'label': isArabic ? 'ساعة واحدة' : '1 Hour', 'value': 60},
      {'label': isArabic ? 'ساعة ونصف' : '1.5 Hours', 'value': 90},
      {'label': isArabic ? 'ساعتان' : '2 Hours', 'value': 120},
      {'label': isArabic ? '3 ساعات' : '3 Hours', 'value': 180},
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          isArabic ? "إنشاء هدف جديد" : "Create New Goal",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textColor),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Goal Objective Title
                Text(
                  isArabic ? "ما الذي تريد تحقيقه؟" : "What do you want to achieve?",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: isArabic ? "مثال: تعلم بايثون، قراءة كتاب..." : "e.g., Learn Python, Read Clean Code",
                    hintStyle: TextStyle(color: isDark ? Colors.white38 : AppColors.textMuted),
                    filled: true,
                    fillColor: cardColor,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return isArabic ? 'يرجى كتابة ما تريد تحقيقه' : 'Please describe what you want to achieve';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // How long?
                Text(
                  isArabic ? "ما هي المدة؟" : "How long?",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  initialValue: _selectedDuration,
                  dropdownColor: cardColor,
                  style: TextStyle(color: textColor, fontSize: 15, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: cardColor,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                  ),
                  icon: Icon(Icons.arrow_drop_down, color: textColor),
                  items: durationOptions.map((opt) {
                    return DropdownMenuItem<int>(
                      value: opt['value'] as int,
                      child: Text(opt['label'] as String, style: TextStyle(color: textColor)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedDuration = val);
                  },
                ),

                const SizedBox(height: 24),

                // Daily Time
                Text(
                  isArabic ? "الوقت اليومي" : "Daily Time",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  initialValue: _selectedDailyTime,
                  dropdownColor: cardColor,
                  style: TextStyle(color: textColor, fontSize: 15, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: cardColor,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                  ),
                  icon: Icon(Icons.arrow_drop_down, color: textColor),
                  items: dailyTimeOptions.map((opt) {
                    return DropdownMenuItem<int>(
                      value: opt['value'] as int,
                      child: Text(opt['label'] as String, style: TextStyle(color: textColor)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedDailyTime = val);
                  },
                ),

                const SizedBox(height: 28),

                // Learning Material Upload Box
                Text(
                  isArabic ? "ملف تعليمي (اختياري)" : "Learning Material (Optional)",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _uploadedFileName == null ? _handlePickFile : null,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _uploadedFileName != null ? AppColors.primary : borderColor,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _uploadedFileName != null ? Icons.picture_as_pdf : Icons.upload_file_outlined,
                          size: 38,
                          color: _uploadedFileName != null
                              ? AppColors.primary
                              : (isDark ? AppColors.neonGreen : AppColors.textSecondary),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _uploadedFileName ?? (isArabic ? "رفع ملف PDF من الجهاز" : "Upload PDF from Device"),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: _uploadedFileName != null ? AppColors.primary : textColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _uploadedFileName != null
                              ? (isArabic ? "مرفق لتوجيه خطة الذكاء الاصطناعي" : "Attached for S3 RAG Grounding")
                              : (isArabic ? "ملفات PDF أو DOCX أو ملاحظات لتوجيه الخطة" : "PDF, DOCX, or Notes to ground AI plan"),
                          style: TextStyle(
                            fontSize: 12,
                            color: secondaryTextColor,
                          ),
                        ),
                        if (_uploadedFileName != null) ...[
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: _removeUploadedPdf,
                            child: Text(
                              isArabic ? "حذف الملف" : "Remove File",
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 36),

                // Create Goal Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size.fromHeight(54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          isArabic ? "إنشاء الهدف" : "Create Goal",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
