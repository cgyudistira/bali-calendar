# Implementation Plan

- [x] 1. Implement data models with complete wewaran





  - [x] 1.1 Create Saka date model



    - SakaDate class with year, sasih, day, and dayInfo fields
    - Sasih class with all 12 normal sasih and nampih variations
    - SasihDayInfo enum (penanggal, purnama, pangelong, tilem)
    - _Requirements: 1.1, 1.4, 1.5_



  - [x] 1.2 Create Pawukon date model with complete wewaran



    - PawukonDate class with wuku, dayInCycle, and all 10 wewaran fields

    - All wewaran classes (EkaWara through DasaWara) with id, name, and urip

    - _Requirements: 2.1, 2.2, 2.6, 2.7_
  - [x] 1.3 Create Weton model

    - Weton class with pawukonDate, birthDate, classification, neptu fields
    - WetonCharacteristics class for personality traits
    - _Requirements: 5.1, 5.2_





  - [x] 1.4 Create combined BaliCalendarDate model


    - BaliCalendarDate class combining gregorianDate, sakaDate, pawukonDate
    - Helper methods for special day checks (isKajengKliwon, isPurnama, etc.)
    - _Requirements: 1.1, 2.1, 3.6_

- [x] 2. Build Saka calendar calculation engine







  - [x] 2.1 Implement Saka service with complete calculations





    - SakaService with gregorianToSaka() using pivot dates and ngunaratri cycle
    - Lunar month calculation with nampih sasih handling
    - Saka Kala period support (1993-2003)
    - getCurrentSakaDate() method
    - _Requirements: 1.1, 1.2, 1.3, 1.4_

- [x] 3. Build Pawukon calendar calculation engine



  - [x] 3.1 Implement Pawukon service with all wewaran


    - PawukonService with gregorianToPawukon() using 210-day cycle
    - All 10 wewaran calculations with special rules (Jaya Tiga, Kala Tiga, Dangu Pat)
    - getCurrentPawukonDate() method
    - _Requirements: 2.1, 2.2, 2.3, 2.6, 2.7_
  - [x] 3.2 Implement Pawukon utilities


    - isKajengKliwon() method
    - getKajengKliwonDates() for date range
    - daysUntilNextOtonan() and getNextOtonan() methods
    - getFutureOtonans() method
    - _Requirements: 2.2, 2.5_

- [x] 4. Build weton calculator service



  - [x] 4.1 Implement WetonService


    - calculateWeton() method with neptu calculation
    - getNextOtonan() and getFutureOtonans() methods
    - getCharacteristics() method with personality traits
    - _Requirements: 5.1, 5.2, 5.3, 5.5_

- [x] 5. Create main calendar service






  - [x] 5.1 Implement BaliCalendarService

    - getCalendarForDate() combining Saka and Pawukon
    - getCurrentCalendar() method
    - getCalendarForMonth() method
    - getPurnamaDates(), getTilemDates(), getKajengKliwonDates() methods
    - getAnggaraKasihDates() and getBudaCemengDates() methods
    - getSpecialDayFlags() helper method
    - _Requirements: 1.1, 2.1, 3.6_

- [x] 6. Initialize Flutter project structure





  - Create pubspec.yaml with required dependencies (flutter, provider, shared_preferences, flutter_local_notifications, intl, google_fonts)
  - Set up folder structure: /presentation, /core, /assets
  - Create main.dart entry point with MaterialApp
  - Create constants files for colors, strings, and theme configuration
  - Configure assets in pubspec.yaml
  - _Requirements: 7.1, 7.2, 8.1_

- [x] 7. Create HolyDay model and JSON database



  - [x] 7.1 Create HolyDay model with JSON serialization


    - Write HolyDay class with id, name, description, category, dates, culturalSignificance fields
    - Add HolyDayCategory enum (purnama, tilem, kajengKliwon, tumpek, major, other)
    - Implement toJson() and fromJson() methods
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 3.6_
  - [x] 7.2 Create holy days JSON database


    - Create assets/holy_days.json
    - Add Purnama and Tilem dates for 2025-2035
    - Add Kajeng Kliwon dates for 2025-2035
    - Add major holidays: Galungan, Kuningan, Nyepi, Saraswati, Pagerwesi, Siwaratri
    - Add all six Tumpek dates: Landep, Wariga, Kandang, Wayang, Krulut, Uduh
    - Add Anggara Kasih and Buda Cemeng dates
    - Include name, description, category, and culturalSignificance for each
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 3.7, 10.3_
  - [x] 7.3 Implement HolyDayService


    - Create HolyDayService class with loadHolyDays() method
    - Implement getHolyDaysForDate() to retrieve holy days for specific date
    - Implement getHolyDaysInRange() for date range queries
    - Implement getUpcomingHolyDays() for next N days
    - Implement isHolyDay() boolean check
    - Implement getHolyDaysByCategory() filter method
    - Add error handling for JSON loading failures
    - _Requirements: 3.6, 3.7, 10.4_

- [x] 8. Integrate holy days into calendar service



  - [x] 8.1 Update BaliCalendarDate model to include holy days


    - Add holyDays field (List<HolyDay>) to BaliCalendarDate model
    - Update constructor and toString() method
    - _Requirements: 3.6_
  - [x] 8.2 Update BaliCalendarService to integrate holy days


    - Inject HolyDayService into BaliCalendarService
    - Update getCalendarForDate() to include holy days
    - Update getCalendarForMonth() to include holy days
    - Implement caching for frequently accessed dates
    - _Requirements: 1.1, 2.1, 3.6_

- [x] 9. Implement settings repository



  - [x] 9.1 Create SettingsRepository


    - Create SettingsRepository using SharedPreferences
    - Add methods to save/load user birth date
    - Add methods to save/load notification preferences
    - Add methods to save/load theme preference (light/dark)
    - Implement error handling for storage failures
    - _Requirements: 5.4, 6.3_

- [x] 10. Implement notification service



  - [x] 10.1 Create NotificationPreferences model


    - Create NotificationPreferences class with category flags and settings
    - Add fields: enablePurnama, enableTilem, enableKajengKliwon, enableTumpek, enableMajorHolidays, enableOtonan
    - Add advanceDays and notificationTime fields
    - _Requirements: 6.3_
  - [x] 10.2 Set up notification infrastructure


    - Create NotificationService class
    - Initialize flutter_local_notifications plugin
    - Configure Android notification channels
    - Configure iOS notification settings
    - Implement permission request flow
    - _Requirements: 6.5_
  - [x] 10.3 Implement notification scheduling


    - Add scheduleHolyDayNotifications() method
    - Schedule notifications for all upcoming holy days
    - Implement advance notification logic (3 days before)
    - Add scheduleOtonanReminder() for user otonan
    - _Requirements: 6.1, 6.2_
  - [x] 10.4 Implement notification preferences management


    - Add updatePreferences() method
    - Implement category-based filtering (Purnama, Tilem, Kajeng Kliwon, Tumpek, major)
    - Add cancelAllNotifications() method
    - _Requirements: 6.3, 6.4_

- [ ] 11. Create Material 3 theme and styling
  - [ ] 11.1 Implement app theme configuration
    - Create AppTheme class in lib/core/theme/app_theme.dart
    - Define light theme with gold primary (#FFD700), sunset orange secondary
    - Define dark theme with same gold primary, adjusted background colors
    - Configure Material 3 design tokens
    - _Requirements: 8.1, 8.2_
  - [ ] 11.2 Create color constants
    - Define event colors: holyDayColor (gold), purnamaColor (blue), kajengKliwonColor (red)
    - Define gradient colors for sunrise/sunset effects
    - Create color scheme for light and dark modes
    - _Requirements: 4.3, 4.4, 4.5, 8.3_
  - [ ] 11.3 Configure typography
    - Set up Google Fonts (Poppins for headlines, Inter for body)
    - Define text styles: headline1, headline2, body1, body2, caption
    - _Requirements: 8.1_
  - [ ] 11.4 Create Balinese pattern widget
    - Create BaliPattern widget for subtle background patterns
    - Implement at 10% opacity
    - Make it reusable across screens
    - _Requirements: 8.4_

- [ ] 12. Build home screen with calendar widget
  - [ ] 12.1 Create calendar widget
    - Create CalendarWidget displaying monthly grid
    - Implement month navigation (swipe left/right)
    - Display Gregorian dates as primary
    - Add current date highlighting with gold accent
    - _Requirements: 4.1, 8.6_
  - [ ] 12.2 Add event indicators to calendar
    - Create DateIndicator widget for colored dots
    - Display gold dots for holy days
    - Display blue dots for Purnama/Tilem
    - Display red dots for Kajeng Kliwon
    - Support multiple indicators per date
    - _Requirements: 4.2, 4.3, 4.4, 4.5_
  - [ ] 12.3 Implement home screen layout
    - Create HomeScreen with app bar showing current Saka date
    - Integrate CalendarWidget
    - Add settings icon to app bar
    - Apply Balinese pattern background
    - _Requirements: 4.1, 8.4_
  - [ ] 12.4 Add calendar state management
    - Create CalendarProvider using Provider package
    - Manage selected date state
    - Manage current month state
    - Load calendar data for visible month
    - _Requirements: 4.1_

- [ ] 13. Build detail day bottom sheet
  - [ ] 13.1 Create bottom sheet UI
    - Create DetailDaySheet widget with rounded top corners (24px)
    - Add drag handle at top
    - Implement gradient header with sunrise colors
    - Create sections for Gregorian, Saka, Pawukon, Holy Days
    - _Requirements: 4.6, 8.1, 8.5_
  - [ ] 13.2 Create Saka display widget
    - Create SakaDisplay widget showing year, sasih, day, phase
    - Format as "Year 1946, Sasih Kasa, Penanggal 5"
    - Add calendar icon
    - _Requirements: 1.1, 1.4_
  - [ ] 13.3 Create Pawukon display widget
    - Create PawukonDisplay widget showing wuku, saptawara, pancawara, triwara
    - Format as multi-line display
    - Add cycle icon
    - _Requirements: 2.1, 2.2, 2.5_
  - [ ] 13.4 Implement holy days section
    - Display list of holy days for selected date
    - Show name and description for each
    - Use EventChip widget for visual consistency
    - Handle case when no holy days exist
    - _Requirements: 3.6_
  - [ ] 13.5 Wire bottom sheet to calendar taps
    - Add onTap handler to calendar dates
    - Show bottom sheet with animation
    - Pass selected date to bottom sheet
    - Load complete calendar data for date
    - _Requirements: 4.6_

- [ ] 14. Build holy days list screen
  - [ ] 14.1 Create holy days screen layout
    - Create HolyDaysScreen with app bar
    - Add search bar at top
    - Create categorized list with expandable sections
    - _Requirements: 3.6_
  - [ ] 14.2 Implement category filtering
    - Add filter chips for categories (Purnama, Tilem, Kajeng Kliwon, Tumpek, Major)
    - Implement filter logic to show/hide categories
    - Update list when filters change
    - _Requirements: 3.6_
  - [ ] 14.3 Create holy day list items
    - Create HolyDayCard widget
    - Display holy day name, date, and brief description
    - Add "View Details" button
    - Use category colors for visual distinction
    - _Requirements: 3.6_
  - [ ] 14.4 Implement search functionality
    - Add search text field
    - Filter holy days by name as user types
    - Show "no results" message when appropriate
    - _Requirements: 3.6_

- [ ] 15. Build weton checker screen
  - [ ] 15.1 Create weton checker layout
    - Create WetonCheckerScreen with app bar
    - Add date picker for birth date selection
    - Add "Calculate" button
    - Create results card section
    - _Requirements: 5.1_
  - [ ] 15.2 Implement weton calculation flow
    - Wire date picker to state
    - Call WetonService.calculateWeton() on button press
    - Display loading indicator during calculation
    - Show results in formatted card
    - _Requirements: 5.1, 5.2_
  - [ ] 15.3 Display weton results
    - Show wuku name with star icon
    - Show saptawara, pancawara, triwara
    - Display characteristics (personality, strengths, guidance)
    - Format in visually appealing card layout
    - _Requirements: 5.2, 5.5_
  - [ ] 15.4 Add otonan countdown
    - Calculate and display next otonan date
    - Show countdown in days
    - Add "Set Reminder" button
    - _Requirements: 5.3_
  - [ ] 15.5 Implement save weton functionality
    - Add "Save My Weton" button
    - Store birth date in SettingsRepository
    - Show confirmation message
    - _Requirements: 5.4_

- [ ] 16. Implement AI recommender service
  - [ ] 16.1 Create recommendation algorithm
    - Create AIRecommenderService class
    - Implement scoring system (0-100) based on Dewasa Ayu principles
    - Score Saka phase (penanggal higher than panglong)
    - Score Pawukon combinations (certain wuku + day combinations)
    - Score weton compatibility if user weton provided
    - Filter out major holy days
    - _Requirements: 9.1, 9.2, 9.3, 9.4, 9.5_
  - [ ] 16.2 Implement date analysis
    - Add analyzeDate() method for specific date evaluation
    - Generate explanation of auspiciousness
    - List positive factors and considerations
    - _Requirements: 9.1_
  - [ ] 16.3 Implement recommendation generation
    - Add recommendDays() method
    - Search through date range (default 90 days)
    - Rank dates by score
    - Return top 3 recommendations with reasoning
    - _Requirements: 9.6, 9.7_

- [ ] 17. Build AI recommender screen
  - [ ] 17.1 Create recommender screen layout
    - Create AIRecommenderScreen with app bar
    - Add activity type selector (dropdown or chips)
    - Add optional user weton input section
    - Add search period selector (30/60/90 days)
    - Add "Generate Recommendations" button
    - _Requirements: 9.1_
  - [ ] 17.2 Implement recommendation flow
    - Collect user inputs (activity type, weton, period)
    - Call AIRecommenderService.recommendDays()
    - Show loading indicator during processing
    - Display results list
    - _Requirements: 9.6_
  - [ ] 17.3 Create recommendation cards
    - Create DayRecommendationCard widget
    - Display score with visual indicator (stars or progress bar)
    - Show date with Saka and Pawukon info
    - Display "Why this day" section with bullet points
    - Add "Add to Calendar" button
    - _Requirements: 9.6_
  - [ ] 17.4 Handle edge cases
    - Show message when no suitable dates found
    - Suggest extending search period
    - Handle missing user weton gracefully
    - _Requirements: 9.7_

- [ ] 18. Build settings screen
  - [ ] 18.1 Create settings screen layout
    - Create SettingsScreen with app bar
    - Create sections: Appearance, Notifications, About
    - Use ListTile widgets for settings items
    - _Requirements: 6.3_
  - [ ] 18.2 Implement theme toggle
    - Add dark mode switch
    - Wire to ThemeProvider
    - Persist preference in SettingsRepository
    - Apply theme change immediately
    - _Requirements: 8.2_
  - [ ] 18.3 Implement notification settings
    - Add switches for each holy day category
    - Add advance notification days selector (0, 1, 3, 7)
    - Add notification time picker
    - Wire to NotificationService.updatePreferences()
    - _Requirements: 6.3_
  - [ ] 18.4 Add about section
    - Display app version
    - Add cultural acknowledgment text
    - Add links to sources or credits
    - _Requirements: 10.5_

- [ ] 19. Implement bottom navigation
  - [ ] 19.1 Create main app structure with navigation
    - Update main.dart with MaterialApp and theme
    - Implement BottomNavigationBar with 4 tabs
    - Add navigation items: Home, Holy Days, Weton, AI Recommender
    - Wire navigation to screen switching
    - _Requirements: 4.1_
  - [ ] 19.2 Add navigation state management
    - Create NavigationProvider for current tab state
    - Preserve screen state when switching tabs
    - Add smooth transitions between screens
    - _Requirements: 8.6_

- [ ] 20. Add animations and transitions
  - [ ] 20.1 Implement screen transitions
    - Add fade transitions between screens (200-400ms)
    - Add slide transition for bottom sheet
    - Add scale animation for button presses
    - _Requirements: 8.6_
  - [ ] 20.2 Add calendar animations
    - Animate month transitions with slide effect
    - Add ripple effect on date taps
    - Animate event indicator appearance
    - _Requirements: 4.6, 8.6_
  - [ ] 20.3 Optimize animation performance
    - Ensure 60fps frame rate
    - Use const constructors where possible
    - Implement RepaintBoundary for complex widgets
    - _Requirements: 4.7_

- [ ] 21. Implement error handling and validation
  - [ ] 21.1 Add JSON loading error handling
    - Wrap JSON loading in try-catch blocks
    - Show user-friendly error dialogs
    - Implement fallback to minimal functionality
    - Log errors for debugging
    - _Requirements: 10.5_
  - [ ] 21.2 Add calculation error handling
    - Validate date ranges (1900-2100)
    - Return null for invalid calculations
    - Show error messages for out-of-range dates
    - _Requirements: 1.2, 2.3_
  - [ ] 21.3 Add notification error handling
    - Handle permission denied gracefully
    - Show permission request dialog
    - Handle scheduling failures
    - _Requirements: 6.5_
  - [ ] 21.4 Add input validation
    - Validate birth date input in weton checker
    - Validate activity type in AI recommender
    - Show validation error messages
    - _Requirements: 5.1, 9.1_

- [ ] 22. Integrate all components and final polish
  - [ ] 22.1 Wire all services together
    - Initialize all services in main.dart
    - Set up Provider hierarchy
    - Load JSON data on app startup
    - Initialize notification service
    - _Requirements: 7.1, 7.2, 7.3_
  - [ ] 22.2 Test offline functionality
    - Verify app works without internet connection
    - Test all calculations work offline
    - Verify notifications work offline
    - _Requirements: 7.3, 7.4, 7.5_
  - [ ] 22.3 Implement data validation on load
    - Validate JSON structure on app startup
    - Check for required fields
    - Display error for malformed data
    - _Requirements: 10.5_
  - [ ] 22.4 Add accessibility features
    - Add semantic labels to all interactive elements
    - Ensure color contrast meets WCAG AA standards
    - Set minimum touch target sizes (48x48dp)
    - Test with screen reader
    - _Requirements: 8.1_
  - [ ] 22.5 Performance optimization
    - Profile app performance with DevTools
    - Optimize calendar rendering for 60fps
    - Reduce JSON parsing time
    - Minimize widget rebuilds
    - _Requirements: 4.7_
  - [ ] 22.6 Create app README documentation
    - Document project structure
    - Explain calendar calculation algorithms
    - Provide setup instructions
    - Include cultural context and sources
    - _Requirements: 10.3, 10.4_
