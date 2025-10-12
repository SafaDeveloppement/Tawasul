import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tawasul_application/tools/language_manager.dart';
import 'package:tawasul_application/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageSettings extends StatefulWidget {
  const LanguageSettings({super.key});

  @override
  State<LanguageSettings> createState() => _LanguageSettingsState();
}

class _LanguageSettingsState extends State<LanguageSettings> {
  String _selectedLanguage = 'ar';

  @override
  void initState() {
    super.initState();
    _loadCurrentLanguage();
  }

  Future<void> _loadCurrentLanguage() async {
    final currentLang = await LanguageManager.getCurrentLanguageCode();
    setState(() {
      _selectedLanguage = currentLang;
    });
  }

  Future<void> _changeLanguage(String languageCode) async {
    final newLocale = Locale(languageCode);

    // Update app language
    MyApp.setLocale(context, newLocale);

    setState(() {
      _selectedLanguage = languageCode;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          languageCode == 'ar'
              ? 'تم تغيير اللغة إلى العربية'
              : 'Language changed to English',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(t.language, style: const TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Arabic Option
            _buildLanguageOption(
              title: 'العربية',
              subtitle: 'Arabic',
              value: 'ar',
              isSelected: _selectedLanguage == 'ar',
            ),
            SizedBox(height: 16.h),

            // English Option
            _buildLanguageOption(
              title: 'English',
              subtitle: 'الإنجليزية',
              value: 'en',
              isSelected: _selectedLanguage == 'en',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required String title,
    required String subtitle,
    required String value,
    required bool isSelected,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              isSelected ? const Color(0xFF008AD2) : Colors.grey[300],
          child: Text(
            value == 'ar' ? 'ع' : 'EN',
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSelected ? const Color(0xFF008AD2) : Colors.black,
          ),
        ),
        subtitle: Text(subtitle),
        trailing:
            isSelected
                ? const Icon(Icons.check_circle, color: Color(0xFF008AD2))
                : const Icon(Icons.radio_button_unchecked, color: Colors.grey),
        onTap: () => _changeLanguage(value),
      ),
    );
  }
}
