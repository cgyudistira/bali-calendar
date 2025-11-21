import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/strings.dart';
import 'core/utils/error_handler.dart';
import 'domain/services/saka_service.dart';
import 'domain/services/pawukon_service.dart';
import 'domain/services/holy_day_service.dart';
import 'domain/services/bali_calendar_service.dart';
import 'domain/services/weton_service.dart';
import 'domain/services/ai_recommender_service.dart';
import 'domain/services/notification_service.dart';
import 'data/repositories/settings_repository.dart';
import 'presentation/providers/calendar_provider.dart';
import 'presentation/providers/holy_days_provider.dart';
import 'presentation/providers/weton_provider.dart';
import 'presentation/providers/ai_recommender_provider.dart';
import 'presentation/providers/settings_provider.dart';
import 'presentation/providers/navigation_provider.dart';
import 'presentation/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🚀 Bali Calendar App Starting...');
  
  // Initialize services in dependency order
  print('📦 Initializing services...');
  final settingsRepository = SettingsRepository();
  final sakaService = SakaService();
  final pawukonService = PawukonService();
  final holyDayService = HolyDayService();
  final wetonService = WetonService(pawukonService);
  final baliCalendarService = BaliCalendarService(sakaService, pawukonService);
  final aiRecommenderService = AIRecommenderService(baliCalendarService);
  final notificationService = NotificationService(
    settingsRepository: settingsRepository,
    holyDayService: holyDayService,
    wetonService: wetonService,
  );
  print('✅ Services initialized');
  
  // Load holy days data with error handling
  print('📚 Loading holy days data...');
  String? holyDayLoadError;
  try {
    await holyDayService.loadHolyDays();
    // Set holy day service in calendar service
    baliCalendarService.setHolyDayService(holyDayService);
    print('✅ Holy days data loaded successfully');
  } on HolyDayLoadException catch (e) {
    ErrorHandler.logError('main', e);
    holyDayLoadError = e.getUserMessage();
    print('⚠️  Holy days data loading failed: ${e.message}');
    // Continue with minimal functionality - calendar calculations will still work
  } catch (e) {
    ErrorHandler.logError('main', e);
    holyDayLoadError = 'Failed to load holy days data. Some features may be limited.';
    print('⚠️  Holy days data loading failed: $e');
  }
  
  // Initialize notification service with error handling
  print('🔔 Initializing notification service...');
  try {
    final initialized = await notificationService.initialize();
    if (initialized) {
      print('✅ Notification service initialized');
    } else {
      print('⚠️  Notification service initialization returned false');
    }
  } catch (e) {
    ErrorHandler.logError('main', 'Failed to initialize notifications: $e');
    print('⚠️  Notification service initialization failed: $e');
    // Continue without notifications
  }
  
  print('🎉 App initialization complete!');
  
  runApp(BaliCalendarApp(
    baliCalendarService: baliCalendarService,
    holyDayService: holyDayService,
    wetonService: wetonService,
    aiRecommenderService: aiRecommenderService,
    notificationService: notificationService,
    settingsRepository: settingsRepository,
    holyDayLoadError: holyDayLoadError,
  ));
}

class BaliCalendarApp extends StatelessWidget {
  final BaliCalendarService baliCalendarService;
  final HolyDayService holyDayService;
  final WetonService wetonService;
  final AIRecommenderService aiRecommenderService;
  final NotificationService notificationService;
  final SettingsRepository settingsRepository;
  final String? holyDayLoadError;
  
  const BaliCalendarApp({
    super.key,
    required this.baliCalendarService,
    required this.holyDayService,
    required this.wetonService,
    required this.aiRecommenderService,
    required this.notificationService,
    required this.settingsRepository,
    this.holyDayLoadError,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NavigationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CalendarProvider(baliCalendarService),
        ),
        ChangeNotifierProvider(
          create: (_) => HolyDaysProvider(holyDayService),
        ),
        ChangeNotifierProvider(
          create: (_) => WetonProvider(wetonService, settingsRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => AIRecommenderProvider(aiRecommenderService),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(settingsRepository, notificationService),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return MaterialApp(
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,
            
            // Theme Configuration
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsProvider.themeMode,
            
            // Main Screen with Bottom Navigation
            home: _AppInitializer(
              holyDayLoadError: holyDayLoadError,
              child: const MainScreen(),
            ),
          );
        },
      ),
    );
  }
}

/// Widget to show initialization errors
class _AppInitializer extends StatefulWidget {
  final String? holyDayLoadError;
  final Widget child;
  
  const _AppInitializer({
    this.holyDayLoadError,
    required this.child,
  });
  
  @override
  State<_AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<_AppInitializer> {
  @override
  void initState() {
    super.initState();
    // Show error dialog after first frame if there was a loading error
    if (widget.holyDayLoadError != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showLoadErrorDialog();
      });
    }
  }
  
  void _showLoadErrorDialog() {
    if (!mounted) return;
    
    ErrorHandler.showErrorDialog(
      context,
      title: 'Data Loading Warning',
      message: widget.holyDayLoadError!,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
