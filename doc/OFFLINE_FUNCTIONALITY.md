# Offline Functionality

## Overview

The Bali Calendar App is designed to work completely offline. All features are available without an internet connection.

## Offline Features

### ✅ Calendar Calculations
- **Saka Calendar**: All lunar calendar calculations are performed locally using mathematical algorithms
- **Pawukon Calendar**: 210-day cycle calculations are done entirely on-device
- **Date Range**: Supports dates from 1900 to 2100 without any network dependency

### ✅ Holy Days
- **Data Storage**: Holy days are stored in local JSON assets (`assets/data/holy_days.json`)
- **Loading**: Data is loaded from assets on app startup
- **Calculated Holy Days**: Purnama, Tilem, Kajeng Kliwon, etc. are calculated dynamically

### ✅ Weton Checker
- **Calculation**: All weton calculations are performed locally
- **Storage**: Birth dates are stored in local SharedPreferences
- **Otonan**: Next otonan dates are calculated on-device

### ✅ AI Recommender
- **Algorithm**: Recommendation algorithm runs entirely on-device
- **No API Calls**: No external AI services are used
- **Fast**: Recommendations are generated in milliseconds

### ✅ Notifications
- **Local Scheduling**: All notifications are scheduled using local notification plugin
- **No Push Notifications**: No server-side push notifications required
- **Persistence**: Scheduled notifications persist across app restarts

### ✅ Settings
- **Local Storage**: All settings are stored in SharedPreferences
- **Theme**: Theme preferences are saved locally
- **Notification Preferences**: All notification settings are stored locally

## Testing Offline Functionality

### Manual Testing Steps

1. **Enable Airplane Mode**
   - Turn on airplane mode on your device
   - Disable WiFi and mobile data

2. **Test Calendar**
   - Open the app
   - Navigate through different months
   - Verify calendar displays correctly
   - Check that holy days are shown

3. **Test Weton Checker**
   - Enter a birth date
   - Calculate weton
   - Verify results are displayed
   - Check otonan countdown

4. **Test AI Recommender**
   - Select an activity type
   - Generate recommendations
   - Verify recommendations are displayed

5. **Test Notifications**
   - Enable notification categories
   - Verify notifications are scheduled
   - Check that notifications fire at scheduled times

6. **Test Settings**
   - Toggle dark mode
   - Change notification preferences
   - Verify settings are saved and applied

### Automated Testing

Run the offline functionality test:

```bash
flutter test test/offline_functionality_test.dart
```

## Architecture for Offline Support

### No Network Dependencies
- No HTTP clients or network packages
- No API endpoints
- No cloud services

### Local Data Storage
- **Assets**: JSON files bundled with the app
- **SharedPreferences**: Key-value storage for settings
- **In-Memory Cache**: Calendar date cache for performance

### Calculation Services
All services perform calculations locally:
- `SakaService`: Lunar calendar math
- `PawukonService`: 210-day cycle math
- `BaliCalendarService`: Combined calendar logic
- `WetonService`: Weton and otonan calculations
- `AIRecommenderService`: Recommendation algorithm
- `HolyDayService`: Holy day lookup and calculation

## Performance Benefits

Working offline provides several benefits:

1. **Fast**: No network latency
2. **Reliable**: No connection failures
3. **Private**: No data sent to servers
4. **Battery Efficient**: No network radio usage
5. **Works Anywhere**: No coverage required

## Data Updates

Since the app works offline, holy days data is bundled with the app:

- **Updates**: New holy days require app update
- **Calculated Days**: Purnama, Tilem, etc. are always current
- **No Sync**: No synchronization needed

## Conclusion

The Bali Calendar App is a fully offline application that provides all features without requiring an internet connection. This design ensures reliability, privacy, and performance for all users.
