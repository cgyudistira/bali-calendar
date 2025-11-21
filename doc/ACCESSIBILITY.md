# Accessibility Features

## Overview

The Bali Calendar App is designed to be accessible to all users, including those with disabilities. This document outlines the accessibility features implemented in the app.

## WCAG 2.1 Compliance

The app aims to meet WCAG 2.1 Level AA standards.

### Color Contrast

All text and interactive elements meet WCAG AA contrast ratio requirements:

- **Normal Text**: Minimum 4.5:1 contrast ratio
- **Large Text**: Minimum 3:1 contrast ratio
- **Interactive Elements**: Minimum 3:1 contrast ratio

#### Color Combinations Tested

| Foreground | Background | Contrast Ratio | Status |
|------------|------------|----------------|--------|
| Primary | White | ≥4.5:1 | ✅ Pass |
| Secondary | White | ≥4.5:1 | ✅ Pass |
| White | Primary | ≥4.5:1 | ✅ Pass |
| Success | White | ≥4.5:1 | ✅ Pass |
| Error | White | ≥4.5:1 | ✅ Pass |
| Warning | White | ≥4.5:1 | ✅ Pass |
| Info | White | ≥4.5:1 | ✅ Pass |

### Touch Targets

All interactive elements meet minimum touch target size requirements:

- **Minimum Size**: 48x48 dp (Material Design guidelines)
- **Buttons**: All buttons are at least 48dp in height
- **Calendar Dates**: Calendar date cells are sized appropriately
- **Icons**: Icon buttons have adequate padding

### Semantic Labels

All interactive elements have semantic labels for screen readers:

#### Calendar
- Date cells announce: "Friday, March 15, 2024. Holy days: Galungan, Purnama"
- Navigation buttons announce: "Previous month" and "Next month"
- Today indicator is clearly announced

#### Holy Days Screen
- Holy day cards announce: "Holy day: Galungan. March 15, 2024"
- Category filters announce their state
- Search field has proper label

#### Weton Checker
- Date picker announces: "Select birth date"
- Calculate button announces: "Calculate weton"
- Results announce weton details clearly

#### AI Recommender
- Activity chips announce selection state
- Score indicators announce: "Score: 85 out of 100"
- Recommendation cards provide full context

#### Settings
- Switches announce: "Dark Mode: enabled" or "Dark Mode: disabled"
- All settings have descriptive labels

## Screen Reader Support

### Tested With
- **Android**: TalkBack
- **iOS**: VoiceOver

### Features
- All interactive elements are focusable
- Focus order follows logical reading order
- Semantic labels provide context
- State changes are announced
- Error messages are announced

## Keyboard Navigation

While primarily a mobile app, keyboard navigation is supported where applicable:

- Tab order follows visual order
- Enter/Space activates buttons
- Arrow keys navigate lists
- Escape closes dialogs

## Text Scaling

The app supports system text scaling:

- Text scales up to 200% without loss of functionality
- Layouts adapt to larger text sizes
- No text truncation at larger sizes
- Scrolling enabled where needed

## Dark Mode

Dark mode provides:

- Reduced eye strain in low light
- Maintained contrast ratios
- Consistent color semantics
- User preference persistence

## Motion and Animation

Animations respect system preferences:

- Reduced motion setting is honored
- Animations can be disabled
- No flashing content
- Smooth transitions (60fps)

## Error Handling

Errors are communicated accessibly:

- Visual error indicators
- Text error messages
- Screen reader announcements
- Clear recovery instructions

## Testing Checklist

### Manual Testing

- [ ] Test with TalkBack/VoiceOver enabled
- [ ] Verify all interactive elements are announced
- [ ] Check focus order is logical
- [ ] Test with large text sizes (200%)
- [ ] Verify color contrast in both themes
- [ ] Test with reduced motion enabled
- [ ] Verify touch targets are adequate
- [ ] Test error message announcements

### Automated Testing

Run accessibility tests:

```bash
flutter test test/accessibility_test.dart
```

## Accessibility Utilities

The app includes `AccessibilityUtils` class with helpers:

```dart
// Check contrast ratio
final ratio = AccessibilityUtils.getContrastRatio(color1, color2);

// Ensure minimum touch target
final widget = AccessibilityUtils.ensureMinTouchTarget(
  child: myWidget,
);

// Get semantic label
final label = AccessibilityUtils.getDateSemanticLabel(date);

// Announce to screen reader
AccessibilityUtils.announce(context, 'Action completed');
```

## Known Limitations

1. **Calendar Grid**: Complex calendar layouts may require additional navigation hints
2. **Custom Widgets**: Some custom widgets may need additional semantic markup
3. **Animations**: Some decorative animations don't provide functional value

## Future Improvements

- [ ] Add haptic feedback for important actions
- [ ] Implement voice commands
- [ ] Add more granular focus management
- [ ] Improve calendar navigation for screen readers
- [ ] Add audio cues for holy days

## Resources

- [Flutter Accessibility](https://docs.flutter.dev/development/accessibility-and-localization/accessibility)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Material Design Accessibility](https://material.io/design/usability/accessibility.html)

## Feedback

We welcome feedback on accessibility. Please report issues or suggestions through:
- GitHub Issues
- Email: [accessibility@example.com]

## Compliance Statement

The Bali Calendar App strives to meet WCAG 2.1 Level AA standards. We are committed to making our app accessible to all users and continuously improving accessibility features.

Last Updated: November 2024
