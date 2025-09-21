import 'package:flutter/material.dart';

class SpacingUtils {
  // Material 3 spacing tokens
  static const double space0 = 0.0;
  static const double space1 = 4.0;
  static const double space2 = 8.0;
  static const double space3 = 12.0;
  static const double space4 = 16.0;
  static const double space5 = 20.0;
  static const double space6 = 24.0;
  static const double space7 = 28.0;
  static const double space8 = 32.0;
  static const double space9 = 36.0;
  static const double space10 = 40.0;
  static const double space11 = 44.0;
  static const double space12 = 48.0;
  static const double space14 = 56.0;
  static const double space16 = 64.0;
  static const double space20 = 80.0;
  static const double space24 = 96.0;
  static const double space28 = 112.0;
  static const double space32 = 128.0;

  // Semantic spacing
  static const double xs = space1;      // 4px
  static const double sm = space2;      // 8px
  static const double md = space4;      // 16px
  static const double lg = space6;      // 24px
  static const double xl = space8;      // 32px
  static const double xxl = space12;    // 48px
  static const double xxxl = space16;   // 64px

  // Component-specific spacing
  static const double cardPadding = md;
  static const double cardMargin = sm;
  static const double cardRadius = space3;
  
  static const double buttonPadding = space3;
  static const double buttonMargin = sm;
  static const double buttonRadius = space2;
  
  static const double inputPadding = space3;
  static const double inputMargin = sm;
  static const double inputRadius = space3;
  
  static const double listItemPadding = md;
  static const double listItemMargin = xs;
  static const double listItemRadius = space2;
  
  static const double dialogPadding = lg;
  static const double dialogMargin = md;
  static const double dialogRadius = space4;
  
  static const double appBarHeight = space14;
  static const double bottomNavHeight = space12;
  static const double drawerWidth = 280.0;
  
  static const double iconSize = space5;
  static const double iconSizeSmall = space4;
  static const double iconSizeLarge = space6;
  static const double iconSizeXLarge = space8;

  // Layout spacing
  static const double screenPadding = md;
  static const double sectionSpacing = lg;
  static const double componentSpacing = md;
  static const double elementSpacing = sm;

  // Grid spacing
  static const double gridGutter = md;
  static const double gridMargin = lg;

  // Border radius
  static const double radiusXs = 2.0;
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radiusXxl = 20.0;
  static const double radiusXxxl = 24.0;
  static const double radiusRound = 50.0;

  // Elevation
  static const double elevation0 = 0.0;
  static const double elevation1 = 1.0;
  static const double elevation2 = 2.0;
  static const double elevation3 = 3.0;
  static const double elevation4 = 4.0;
  static const double elevation5 = 5.0;
  static const double elevation6 = 6.0;
  static const double elevation8 = 8.0;
  static const double elevation12 = 12.0;
  static const double elevation16 = 16.0;
  static const double elevation24 = 24.0;

  // Utility methods for EdgeInsets
  static EdgeInsets all(double value) => EdgeInsets.all(value);
  static EdgeInsets symmetric({double? horizontal, double? vertical}) => 
      EdgeInsets.symmetric(horizontal: horizontal ?? 0, vertical: vertical ?? 0);
  static EdgeInsets only({double? left, double? top, double? right, double? bottom}) => 
      EdgeInsets.only(left: left ?? 0, top: top ?? 0, right: right ?? 0, bottom: bottom ?? 0);
  static EdgeInsets fromLTRB(double left, double top, double right, double bottom) => 
      EdgeInsets.fromLTRB(left, top, right, bottom);

  // Common padding combinations
  static EdgeInsets get cardPaddingAll => all(cardPadding);
  static EdgeInsets get cardPaddingHorizontal => symmetric(horizontal: cardPadding);
  static EdgeInsets get cardPaddingVertical => symmetric(vertical: cardPadding);
  
  static EdgeInsets get buttonPaddingAll => all(buttonPadding);
  static EdgeInsets get buttonPaddingHorizontal => symmetric(horizontal: buttonPadding);
  static EdgeInsets get buttonPaddingVertical => symmetric(vertical: buttonPadding);
  
  static EdgeInsets get inputPaddingAll => all(inputPadding);
  static EdgeInsets get inputPaddingHorizontal => symmetric(horizontal: inputPadding);
  static EdgeInsets get inputPaddingVertical => symmetric(vertical: inputPadding);
  
  static EdgeInsets get listItemPaddingAll => all(listItemPadding);
  static EdgeInsets get listItemPaddingHorizontal => symmetric(horizontal: listItemPadding);
  static EdgeInsets get listItemPaddingVertical => symmetric(vertical: listItemPadding);
  
  static EdgeInsets get dialogPaddingAll => all(dialogPadding);
  static EdgeInsets get dialogPaddingHorizontal => symmetric(horizontal: dialogPadding);
  static EdgeInsets get dialogPaddingVertical => symmetric(vertical: dialogPadding);
  
  static EdgeInsets get screenPaddingAll => all(screenPadding);
  static EdgeInsets get screenPaddingHorizontal => symmetric(horizontal: screenPadding);
  static EdgeInsets get screenPaddingVertical => symmetric(vertical: screenPadding);

  // Common margin combinations
  static EdgeInsets get cardMarginAll => all(cardMargin);
  static EdgeInsets get cardMarginHorizontal => symmetric(horizontal: cardMargin);
  static EdgeInsets get cardMarginVertical => symmetric(vertical: cardMargin);
  
  static EdgeInsets get buttonMarginAll => all(buttonMargin);
  static EdgeInsets get buttonMarginHorizontal => symmetric(horizontal: buttonMargin);
  static EdgeInsets get buttonMarginVertical => symmetric(vertical: buttonMargin);
  
  static EdgeInsets get inputMarginAll => all(inputMargin);
  static EdgeInsets get inputMarginHorizontal => symmetric(horizontal: inputMargin);
  static EdgeInsets get inputMarginVertical => symmetric(vertical: inputMargin);
  
  static EdgeInsets get listItemMarginAll => all(listItemMargin);
  static EdgeInsets get listItemMarginHorizontal => symmetric(horizontal: listItemMargin);
  static EdgeInsets get listItemMarginVertical => symmetric(vertical: listItemMargin);
  
  static EdgeInsets get dialogMarginAll => all(dialogMargin);
  static EdgeInsets get dialogMarginHorizontal => symmetric(horizontal: dialogMargin);
  static EdgeInsets get dialogMarginVertical => symmetric(vertical: dialogMargin);

  // Spacing for different screen sizes
  static EdgeInsets getResponsivePadding(BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) {
      return all(desktop ?? lg);
    } else if (width >= 600) {
      return all(tablet ?? md);
    } else {
      return all(mobile ?? sm);
    }
  }

  static EdgeInsets getResponsiveMargin(BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) {
      return all(desktop ?? md);
    } else if (width >= 600) {
      return all(tablet ?? sm);
    } else {
      return all(mobile ?? xs);
    }
  }

  static double getResponsiveSpacing(BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) {
      return desktop ?? lg;
    } else if (width >= 600) {
      return tablet ?? md;
    } else {
      return mobile ?? sm;
    }
  }

  // Border radius utilities
  static BorderRadius getRadius(double radius) => BorderRadius.circular(radius);
  static BorderRadius getRadiusAll(double radius) => BorderRadius.all(Radius.circular(radius));
  static BorderRadius getRadiusOnly({
    double? topLeft,
    double? topRight,
    double? bottomLeft,
    double? bottomRight,
  }) => BorderRadius.only(
    topLeft: Radius.circular(topLeft ?? 0),
    topRight: Radius.circular(topRight ?? 0),
    bottomLeft: Radius.circular(bottomLeft ?? 0),
    bottomRight: Radius.circular(bottomRight ?? 0),
  );

  // Common border radius combinations
  static BorderRadius get cardRadiusAll => getRadiusAll(cardRadius);
  static BorderRadius get buttonRadiusAll => getRadiusAll(buttonRadius);
  static BorderRadius get inputRadiusAll => getRadiusAll(inputRadius);
  static BorderRadius get listItemRadiusAll => getRadiusAll(listItemRadius);
  static BorderRadius get dialogRadiusAll => getRadiusAll(dialogRadius);

  // Spacing for specific components
  static EdgeInsets get appBarPadding => symmetric(horizontal: md, vertical: sm);
  static EdgeInsets get bottomNavPadding => symmetric(horizontal: md, vertical: sm);
  static EdgeInsets get drawerPadding => all(md);
  static EdgeInsets get fabMargin => all(md);
  static EdgeInsets get snackbarMargin => all(md);

  // Grid spacing
  static EdgeInsets get gridPadding => all(gridMargin);
  static EdgeInsets get gridItemPadding => all(gridGutter);

  // Form spacing
  static EdgeInsets get formPadding => all(md);
  static EdgeInsets get formFieldPadding => all(sm);
  static EdgeInsets get formFieldMargin => symmetric(vertical: xs);

  // List spacing
  static EdgeInsets get listPadding => all(md);
  static EdgeInsets get listItemContentPadding => all(sm);
  static EdgeInsets get listItemContentMargin => symmetric(vertical: xs);

  // Card spacing
  static EdgeInsets get cardContentPadding => all(md);
  static EdgeInsets get cardHeaderPadding => all(md);
  static EdgeInsets get cardFooterPadding => all(md);

  // Dialog spacing
  static EdgeInsets get dialogContentPadding => all(lg);
  static EdgeInsets get dialogHeaderPadding => all(lg);
  static EdgeInsets get dialogFooterPadding => all(lg);

  // Tab spacing
  static EdgeInsets get tabPadding => symmetric(horizontal: md, vertical: sm);
  static EdgeInsets get tabBarPadding => all(sm);

  // Chip spacing
  static EdgeInsets get chipPadding => symmetric(horizontal: sm, vertical: xs);
  static EdgeInsets get chipMargin => all(xs);

  // Badge spacing
  static EdgeInsets get badgePadding => all(xs);
  static EdgeInsets get badgeMargin => all(xs);

  // Tooltip spacing
  static EdgeInsets get tooltipPadding => all(sm);
  static EdgeInsets get tooltipMargin => all(xs);

  // Progress indicator spacing
  static EdgeInsets get progressPadding => all(md);
  static EdgeInsets get progressMargin => all(sm);

  // Divider spacing
  static EdgeInsets get dividerPadding => symmetric(vertical: sm);
  static EdgeInsets get dividerMargin => symmetric(vertical: xs);

  // Spacing for different content types
  static EdgeInsets get textPadding => all(sm);
  static EdgeInsets get imagePadding => all(md);
  static EdgeInsets get videoPadding => all(md);
  static EdgeInsets get audioPadding => all(md);

  // Spacing for different states
  static EdgeInsets get loadingPadding => all(lg);
  static EdgeInsets get errorPadding => all(md);
  static EdgeInsets get successPadding => all(md);
  static EdgeInsets get warningPadding => all(md);
  static EdgeInsets get infoPadding => all(md);

  // Spacing for different layouts
  static EdgeInsets get columnPadding => all(md);
  static EdgeInsets get rowPadding => all(md);
  static EdgeInsets get stackPadding => all(md);
  static EdgeInsets get flexPadding => all(md);

  // Spacing for different screen orientations
  static EdgeInsets get landscapePadding => symmetric(horizontal: lg, vertical: md);
  static EdgeInsets get portraitPadding => symmetric(horizontal: md, vertical: lg);

  // Spacing for different device types
  static EdgeInsets get mobilePadding => all(sm);
  static EdgeInsets get tabletPadding => all(md);
  static EdgeInsets get desktopPadding => all(lg);

  // Spacing for different content densities
  static EdgeInsets get compactPadding => all(xs);
  static EdgeInsets get comfortablePadding => all(md);
  static EdgeInsets get spaciousPadding => all(lg);

  // Spacing for different interaction states
  static EdgeInsets get hoverPadding => all(sm);
  static EdgeInsets get focusPadding => all(sm);
  static EdgeInsets get pressedPadding => all(xs);
  static EdgeInsets get disabledPadding => all(sm);

  // Spacing for different accessibility needs
  static EdgeInsets get highContrastPadding => all(md);
  static EdgeInsets get largeTextPadding => all(lg);
  static EdgeInsets get reducedMotionPadding => all(sm);

  // Spacing for different themes
  static EdgeInsets get lightThemePadding => all(md);
  static EdgeInsets get darkThemePadding => all(md);
  static EdgeInsets get highContrastThemePadding => all(lg);

  // Spacing for different languages
  static EdgeInsets get ltrLanguagePadding => all(md);
  static EdgeInsets get rtlLanguagePadding => all(md);
  static EdgeInsets get verticalTextLanguagePadding => all(md);

  // Spacing for different user preferences
  static EdgeInsets get compactDensityUserPadding => all(xs);
  static EdgeInsets get normalDensityUserPadding => all(md);
  static EdgeInsets get expandedDensityUserPadding => all(lg);

  // Spacing for different content types
  static EdgeInsets get textContentTypePadding => all(sm);
  static EdgeInsets get mediaContentTypePadding => all(md);
  static EdgeInsets get interactiveContentTypePadding => all(sm);
  static EdgeInsets get staticContentTypePadding => all(md);

  // Spacing for different content states
  static EdgeInsets get emptyStateContentPadding => all(lg);
  static EdgeInsets get loadingStateContentPadding => all(lg);
  static EdgeInsets get errorStateContentPadding => all(md);
  static EdgeInsets get successStateContentPadding => all(md);

  // Spacing for different content sizes
  static EdgeInsets get smallContentSizePadding => all(xs);
  static EdgeInsets get mediumContentSizePadding => all(md);
  static EdgeInsets get largeContentSizePadding => all(lg);
  static EdgeInsets get extraLargeContentSizePadding => all(xl);

  // Spacing for different content positions
  static EdgeInsets get topContentPositionPadding => only(top: md);
  static EdgeInsets get bottomContentPositionPadding => only(bottom: md);
  static EdgeInsets get leftContentPositionPadding => only(left: md);
  static EdgeInsets get rightContentPositionPadding => only(right: md);
  static EdgeInsets get centerContentPositionPadding => all(md);

  // Spacing for different content alignments
  static EdgeInsets get startContentAlignmentPadding => only(left: md);
  static EdgeInsets get endContentAlignmentPadding => only(right: md);
  static EdgeInsets get centerContentAlignmentPadding => all(md);
  static EdgeInsets get stretchContentAlignmentPadding => all(md);

  // Spacing for different content distributions
  static EdgeInsets get spaceAroundDistributionPadding => all(md);
  static EdgeInsets get spaceBetweenDistributionPadding => all(md);
  static EdgeInsets get spaceEvenlyDistributionPadding => all(md);
  static EdgeInsets get flexStartDistributionPadding => all(md);
  static EdgeInsets get flexEndDistributionPadding => all(md);
  static EdgeInsets get centerDistributionPadding => all(md);

  // Spacing for different content wraps
  static EdgeInsets get wrapContentPadding => all(md);
  static EdgeInsets get noWrapContentPadding => all(md);
  static EdgeInsets get wrapReversePadding => all(md);

  // Spacing for different content directions
  static EdgeInsets get rowDirectionPadding => all(md);
  static EdgeInsets get columnDirectionPadding => all(md);
  static EdgeInsets get rowReversePadding => all(md);
  static EdgeInsets get columnReversePadding => all(md);
}
