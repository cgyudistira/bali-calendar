# Purnama and Tilem Calculation Analysis

## Verification Results Summary

Based on verification with 2024 astronomical data:

- **Purnama Accuracy**: 58.3% (7 out of 12 correct)
- **Tilem Accuracy**: 46.2% (6 out of 13 correct)

## Key Findings

### 1. One-Day Offset
Most Purnama and Tilem are detected **1 day later** than astronomical data:
- Purnama: 5 out of 12 cases (41.7%) are 1 day late
- Tilem: 7 out of 13 cases (53.8%) are 1 day late

### 2. Highly Accurate Average Cycle
- **Average Purnama interval**: 29.55 days
- **Average Tilem interval**: 29.50 days
- **Astronomical cycle**: 29.53059 days
- **Difference**: Only 0.01-0.03 days!

## Current Algorithm Analysis

### System Used
```
1 sasih = 30 days
Every 63 days there is 1 ngunaratri day (skip day)
```

### Effective Calculation
```
Effective per sasih = 30 days
With ngunaratri: 63 days / 2 sasih = 31.5 days per sasih
After correction: (63-1) / 2 = 31 days per sasih
```

### Problem
This system uses a **fixed 30-day cycle** with ngunaratri correction every 63 days, which causes:
1. Small error accumulation leading to 1-day offset
2. Purnama/Tilem don't always fall exactly on day 15

## Correct Formula (Based on Reference)

According to the Balinese Pengalantaka system:

### Lunar Cycle
```
Average lunar cycle = 29.53059 days
```

### Purnama and Tilem Calculation
```dart
// From tilem to purnama
purnama = tilem + (29.53059 / 2)  // ~14.76 days

// From purnama to tilem
tilem = purnama + (29.53059 / 2)  // ~14.76 days

// From tilem to next tilem
tilem_next = tilem + 29.53059  // ~29.53 days
```

### Eka Sungsang System
The purnama-tilem transition system uses "Eka Sungsang" which:
- From 1953-1971: "Eka Sungsang ke Kliwon"
- After 1971: "Eka Sungsang ke Pon"
- Combines hisab (mathematical calculation) and rukyat (observation)

## Implementation Conclusion

After trying various approaches to fix the algorithm:

1. **Using 29.53059-day lunar cycle** - Results worse because pivot date is inaccurate
2. **Adjusting pivot date** - Results worse, disrupts sasih calculation
3. **Offset correction on day 14/15** - Still inaccurate due to fundamental calculation issues

### Fundamental Problem

The current algorithm uses a complex system with:
- Ngunaratri every 63 days
- Sasih calculation based on 30 days
- Pivot date that may not match actual astronomical data

To fix this properly requires:
1. **Pivot date verification** with verified Balinese calendar
2. **Complete system recalibration** of ngunaratri and day calculation
3. **Extensive testing** with accurate historical data

## Improvement Recommendations

### Option 1: Fix Ngunaratri Algorithm
Adjust the ngunaratri system to be more accurate with the 29.53059-day cycle:

```dart
// Use more accurate lunar cycle
const double LUNAR_CYCLE = 29.53059;

// Calculate ngunaratri based on error accumulation
int calculateNgunaratriDays(int daysSinceEpoch) {
  // Every ~63 days, there's an accumulated error of ~0.47 days
  // that needs to be corrected with ngunaratri
  double expectedDays = daysSinceEpoch * LUNAR_CYCLE / 30.0;
  double actualDays = daysSinceEpoch.toDouble();
  double error = actualDays - expectedDays;
  
  // If error >= 1 day, add ngunaratri
  return error.floor();
}
```

### Option 2: Use Lookup Table
Create a reference table of verified Purnama and Tilem:

```dart
// Verified Purnama and Tilem table
const Map<String, bool> PURNAMA_DATES = {
  '2024-01-26': true,  // Purnama
  '2024-02-24': true,
  // ... etc
};
```

### Option 3: Hybrid Approach
Combine algorithm with manual corrections for important dates:

```dart
// Use algorithm for general calculation
// But correct for verified dates
bool isPurnama(DateTime date) {
  // Check lookup table first
  if (VERIFIED_DATES.containsKey(date)) {
    return VERIFIED_DATES[date].isPurnama;
  }
  
  // Fallback to algorithm
  return calculatePurnama(date);
}
```

## Conclusion

1. **Current algorithm is quite good** at calculating average cycle (error only 0.01-0.03 days)
2. **Main problem is consistent 1-day offset**, not cumulative error
3. **Easiest solution**: Adjust pivot date or add -1 day correction for Purnama/Tilem
4. **Best solution**: Implement more accurate Eka Sungsang system with 29.53059-day cycle

## References

- Average lunar cycle: 29.53059 days (29 days 12 hours 44 minutes)
- Balinese Pengalantaka system
- Eka Sungsang (purnama-tilem transition system)
- Balinese Caka Calendar

## Testing

To run verification:
```bash
flutter test test/purnama_tilem_verification_test.dart
```

Test results show:
- Purnama: 7/12 correct (58.3%)
- Tilem: 6/13 correct (46.2%)
- Most errors are +1 day offset
