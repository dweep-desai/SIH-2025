# Responsive Layout Fix for Faculty Student Search

## Problem
The Faculty → Student Search screen showed Flutter's red overflow indicator between the Branch and Domain dropdowns on narrow screens (360px, 393px, 412px). The issue was caused by a Row with fixed-width children that exceeded available screen space.

## Solution
Replaced the complex LayoutBuilder-based responsive logic with a robust `Wrap` + `Flexible` + `ConstrainedBox` approach:

### Key Changes:
1. **Search field**: Takes full width at the top
2. **Filter dropdowns**: Use `Wrap` widget with `Flexible` + `ConstrainedBox` constraints
   - Minimum width: 100px (ensures readability on narrow screens)
   - Maximum width: 180px (prevents excessive stretching)
   - Spacing: 8px between elements (reduced for better fit)
   - Run spacing: 8px between wrapped rows
   - `isDense: true` for compact dropdowns
   - Shortened text labels (CS, IT, AI/ML, etc.) to fit better
   - `TextOverflow.ellipsis` for text that might still overflow

### Code Comment:
```dart
// Responsive filters - use Wrap to prevent overflow on any screen size
```

## Benefits:
- ✅ No overflow at any screen width (360px, 393px, 412px, 768px+)
- ✅ Controls remain visible and tappable
- ✅ Automatic wrapping when space is limited
- ✅ Consistent spacing and sizing
- ✅ Simpler, more maintainable code

## Test Coverage:
- Unit tests verify layout works at 360px, 412px, and 768px widths
- Tests confirm Wrap widget and ConstrainedBox usage
- No overflow errors at very narrow widths (320px)

## Files Modified:
- `lib/pages/faculty_student_search_page.dart` - Main implementation
- `test/responsive_layout_test.dart` - Test coverage
