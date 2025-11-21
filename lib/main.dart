import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/strings.dart';
import 'domain/services/saka_service.dart';
import 'domain/services/pawukon_service.dart';
import 'domain/services/holy_day_service.dart';
import 'domain/services/bali_calendar_service.dart';
import 'domain/services/weton_service.dart';
import 'data/repositories/settings_repository.dart';
import 'presentation/providers/calendar_provider.dart';
import 'presentation/providers/holy_days_provider.dart';
import 'presentation/providers/weton_provider.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  final sakaService = SakaService();
  final pawukonService = PawukonService();
  final holyDayService = HolyDayService();
  final wetonService = WetonService(pawukonService);
  final baliCalendarService = BaliCalendarService(sakaService, pawukonService);
  final settingsRepository = SettingsRepository();
  
  // Load holy days data
  await holyDayService.loadHolyDays();
  
  // Set holy day service in calendar service
  baliCalendarService.setHolyDayService(holyDayService);
  
  runApp(BaliCalendarApp(
    baliCalendarService: baliCalendarService,
    holyDayService: holyDayService,
    wetonService: wetonService,
    settingsRepository: settingsRepository,
  ));
}

class BaliCalendarApp extends StatelessWidget {
  final BaliCalendarService baliCalendarService;
  final HolyDayService holyDayService;
  final WetonService wetonService;
  final SettingsRepository settingsRepository;
  
  const BaliCalendarApp({
    super.key,
    required this.baliCalendarService,
    required this.holyDayService,
    required this.wetonService,
    required this.settingsRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CalendarProvider(baliCalendarService),
        ),
        ChangeNotifierProvider(
          create: (_) => HolyDaysProvider(holyDayService),
        ),
        ChangeNotifierProvider(
          create: (_) => WetonProvider(wetonService, settingsRepository),
        ),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        
        // Theme Configuration
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        
        // Home Screen
        home: const HomeScreen(),
      ),
    );
  }
}
