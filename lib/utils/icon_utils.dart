import 'package:flutter/material.dart';

class IconUtils {
  // Icon sizes
  static const double iconSizeXs = 12.0;
  static const double iconSizeSm = 16.0;
  static const double iconSizeMd = 20.0;
  static const double iconSizeLg = 24.0;
  static const double iconSizeXl = 32.0;
  static const double iconSizeXxl = 40.0;
  static const double iconSizeXxxl = 48.0;

  // Default icon size
  static const double defaultIconSize = iconSizeLg;

  // Icon categories
  static const Map<String, IconData> navigationIcons = {
    'home': Icons.home,
    'dashboard': Icons.dashboard,
    'menu': Icons.menu,
    'back': Icons.arrow_back,
    'forward': Icons.arrow_forward,
    'up': Icons.keyboard_arrow_up,
    'down': Icons.keyboard_arrow_down,
    'left': Icons.keyboard_arrow_left,
    'right': Icons.keyboard_arrow_right,
    'close': Icons.close,
    'more': Icons.more_vert,
    'more_horizontal': Icons.more_horiz,
    'refresh': Icons.refresh,
    'search': Icons.search,
    'filter': Icons.filter_list,
    'sort': Icons.sort,
  };

  static const Map<String, IconData> actionIcons = {
    'add': Icons.add,
    'remove': Icons.remove,
    'edit': Icons.edit,
    'delete': Icons.delete,
    'save': Icons.save,
    'cancel': Icons.cancel,
    'confirm': Icons.check,
    'submit': Icons.send,
    'upload': Icons.upload,
    'download': Icons.download,
    'share': Icons.share,
    'copy': Icons.copy,
    'paste': Icons.paste,
    'cut': Icons.content_cut,
    'undo': Icons.undo,
    'redo': Icons.redo,
    'print': Icons.print,
    'email': Icons.email,
    'phone': Icons.phone,
    'message': Icons.message,
    'call': Icons.call,
    'video_call': Icons.videocam,
    'audio_call': Icons.phone,
  };

  static const Map<String, IconData> statusIcons = {
    'success': Icons.check_circle,
    'error': Icons.error,
    'warning': Icons.warning,
    'info': Icons.info,
    'loading': Icons.hourglass_empty,
    'pending': Icons.schedule,
    'completed': Icons.check_circle_outline,
    'failed': Icons.cancel,
    'active': Icons.radio_button_checked,
    'inactive': Icons.radio_button_unchecked,
    'enabled': Icons.check_box,
    'disabled': Icons.check_box_outline_blank,
    'online': Icons.circle,
    'offline': Icons.circle_outlined,
  };

  static const Map<String, IconData> userIcons = {
    'profile': Icons.person,
    'account': Icons.account_circle,
    'settings': Icons.settings,
    'logout': Icons.logout,
    'login': Icons.login,
    'register': Icons.person_add,
    'avatar': Icons.account_circle,
    'group': Icons.group,
    'team': Icons.groups,
    'admin': Icons.admin_panel_settings,
    'moderator': Icons.security,
    'user': Icons.person_outline,
    'guest': Icons.person_off,
  };

  static const Map<String, IconData> educationIcons = {
    'school': Icons.school,
    'university': Icons.account_balance,
    'book': Icons.book,
    'library': Icons.library_books,
    'course': Icons.menu_book,
    'assignment': Icons.assignment,
    'quiz': Icons.quiz,
    'exam': Icons.quiz,
    'grade': Icons.grade,
    'gpa': Icons.trending_up,
    'attendance': Icons.present_to_all,
    'schedule': Icons.schedule,
    'calendar': Icons.calendar_today,
    'event': Icons.event,
    'deadline': Icons.schedule,
    'project': Icons.work,
    'research': Icons.science,
    'thesis': Icons.description,
    'paper': Icons.description,
    'presentation': Icons.present_to_all,
    'lab': Icons.science,
    'classroom': Icons.class_,
    'lecture': Icons.record_voice_over,
    'tutorial': Icons.school,
    'workshop': Icons.build,
    'seminar': Icons.people,
    'conference': Icons.people_outline,
  };

  static const Map<String, IconData> achievementIcons = {
    'trophy': Icons.emoji_events,
    'medal': Icons.emoji_events,
    'award': Icons.military_tech,
    'badge': Icons.workspace_premium,
    'certificate': Icons.verified,
    'diploma': Icons.school,
    'degree': Icons.school,
    'honor': Icons.star,
    'excellence': Icons.star_border,
    'recognition': Icons.thumb_up,
    'appreciation': Icons.favorite,
    'congratulations': Icons.celebration,
    'milestone': Icons.flag,
    'goal': Icons.flag_circle,
    'target': Icons.gps_fixed,
    'achievement': Icons.emoji_events,
    'success': Icons.check_circle,
    'victory': Icons.emoji_events,
    'win': Icons.emoji_events,
    'champion': Icons.emoji_events,
  };

  static const Map<String, IconData> analyticsIcons = {
    'chart': Icons.bar_chart,
    'graph': Icons.show_chart,
    'trending': Icons.trending_up,
    'analytics': Icons.analytics,
    'statistics': Icons.analytics,
    'data': Icons.data_usage,
    'metrics': Icons.analytics,
    'performance': Icons.speed,
    'progress': Icons.trending_up,
    'growth': Icons.trending_up,
    'decline': Icons.trending_down,
    'stable': Icons.trending_flat,
    'comparison': Icons.compare,
    'report': Icons.assessment,
    'dashboard': Icons.dashboard,
    'overview': Icons.visibility,
    'summary': Icons.summarize,
    'insights': Icons.lightbulb,
    'recommendations': Icons.recommend,
  };

  static const Map<String, IconData> communicationIcons = {
    'message': Icons.message,
    'chat': Icons.chat,
    'comment': Icons.comment,
    'reply': Icons.reply,
    'forward': Icons.forward,
    'broadcast': Icons.broadcast_on_home,
    'announcement': Icons.campaign,
    'notification': Icons.notifications,
    'alert': Icons.notifications_active,
    'reminder': Icons.alarm,
    'invitation': Icons.mail,
    'request': Icons.request_page,
    'approval': Icons.approval,
    'rejection': Icons.cancel,
    'feedback': Icons.feedback,
    'review': Icons.rate_review,
    'rating': Icons.star_rate,
    'poll': Icons.poll,
    'survey': Icons.quiz,
    'questionnaire': Icons.quiz,
  };

  static const Map<String, IconData> fileIcons = {
    'file': Icons.insert_drive_file,
    'folder': Icons.folder,
    'document': Icons.description,
    'pdf': Icons.picture_as_pdf,
    'image': Icons.image,
    'video': Icons.video_file,
    'audio': Icons.audio_file,
    'archive': Icons.archive,
    'zip': Icons.archive,
    'text': Icons.text_snippet,
    'code': Icons.code,
    'spreadsheet': Icons.table_chart,
    'presentation': Icons.slideshow,
    'database': Icons.storage,
    'cloud': Icons.cloud,
    'sync': Icons.sync,
    'backup': Icons.backup,
    'restore': Icons.restore,
    'import': Icons.input,
    'export': Icons.output,
  };

  static const Map<String, IconData> deviceIcons = {
    'mobile': Icons.phone_android,
    'tablet': Icons.tablet,
    'desktop': Icons.desktop_windows,
    'laptop': Icons.laptop,
    'monitor': Icons.monitor,
    'keyboard': Icons.keyboard,
    'mouse': Icons.mouse,
    'headphones': Icons.headphones,
    'speaker': Icons.speaker,
    'camera': Icons.camera_alt,
    'microphone': Icons.mic,
    'wifi': Icons.wifi,
    'bluetooth': Icons.bluetooth,
    'usb': Icons.usb,
    'battery': Icons.battery_std,
    'power': Icons.power,
    'charging': Icons.battery_charging_full,
    'signal': Icons.signal_cellular_alt,
    'location': Icons.location_on,
    'gps': Icons.gps_fixed,
  };

  static final Map<String, IconData> timeIcons = {
    'time': Icons.access_time,
    'clock': Icons.schedule,
    'calendar': Icons.calendar_today,
    'date': Icons.date_range,
    'today': Icons.today,
    'yesterday': Icons.arrow_back,
    'tomorrow': Icons.arrow_forward,
    'week': Icons.view_week,
    'month': Icons.view_module,
    'year': Icons.calendar_view_month,
    'hour': Icons.hourglass_empty,
    'minute': Icons.timer,
    'second': Icons.timer_3,
    'duration': Icons.timer_10,
    'deadline': Icons.schedule,
    'reminder': Icons.alarm,
    'notification': Icons.notifications,
    'event': Icons.event,
    'meeting': Icons.event_available,
    'appointment': Icons.event_available,
  };

  // Icon utility methods
  static IconData getIcon(String category, String name) {
    switch (category.toLowerCase()) {
      case 'navigation':
        return navigationIcons[name] ?? Icons.help_outline;
      case 'action':
        return actionIcons[name] ?? Icons.help_outline;
      case 'status':
        return statusIcons[name] ?? Icons.help_outline;
      case 'user':
        return userIcons[name] ?? Icons.help_outline;
      case 'education':
        return educationIcons[name] ?? Icons.help_outline;
      case 'achievement':
        return achievementIcons[name] ?? Icons.help_outline;
      case 'analytics':
        return analyticsIcons[name] ?? Icons.help_outline;
      case 'communication':
        return communicationIcons[name] ?? Icons.help_outline;
      case 'file':
        return fileIcons[name] ?? Icons.help_outline;
      case 'device':
        return deviceIcons[name] ?? Icons.help_outline;
      case 'time':
        return timeIcons[name] ?? Icons.help_outline;
      default:
        return Icons.help_outline;
    }
  }

  static IconData getIconByName(String name) {
    // Search through all categories
    final allIcons = {
      ...navigationIcons,
      ...actionIcons,
      ...statusIcons,
      ...userIcons,
      ...educationIcons,
      ...achievementIcons,
      ...analyticsIcons,
      ...communicationIcons,
      ...fileIcons,
      ...deviceIcons,
      ...timeIcons,
    };
    return allIcons[name] ?? Icons.help_outline;
  }

  // Icon size utilities
  static double getIconSize(String size) {
    switch (size.toLowerCase()) {
      case 'xs':
        return iconSizeXs;
      case 'sm':
        return iconSizeSm;
      case 'md':
        return iconSizeMd;
      case 'lg':
        return iconSizeLg;
      case 'xl':
        return iconSizeXl;
      case 'xxl':
        return iconSizeXxl;
      case 'xxxl':
        return iconSizeXxxl;
      default:
        return defaultIconSize;
    }
  }

  static double getResponsiveIconSize(BuildContext context, String size) {
    final baseSize = getIconSize(size);
    final mediaQuery = MediaQuery.of(context);
    final textScaleFactor = mediaQuery.textScaleFactor;
    return baseSize * textScaleFactor;
  }

  // Icon color utilities
  static Color getIconColor(BuildContext context, String status) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    switch (status.toLowerCase()) {
      case 'success':
      case 'completed':
      case 'approved':
        return Colors.green;
      case 'warning':
      case 'pending':
      case 'in_progress':
        return Colors.orange;
      case 'error':
      case 'failed':
      case 'rejected':
        return colorScheme.error;
      case 'info':
      case 'draft':
      case 'new':
        return colorScheme.primary;
      case 'disabled':
      case 'inactive':
        return colorScheme.onSurfaceVariant;
      default:
        return colorScheme.onSurface;
    }
  }

  // Icon widget builders
  static Widget buildIcon({
    required String name,
    String? category,
    String size = 'md',
    Color? color,
    String? status,
    required BuildContext context,
  }) {
    final iconData = category != null ? getIcon(category, name) : getIconByName(name);
    final iconSize = getResponsiveIconSize(context, size);
    final iconColor = color ?? (status != null ? getIconColor(context, status) : null);
    
    return Icon(
      iconData,
      size: iconSize,
      color: iconColor,
    );
  }

  static Widget buildStatusIcon({
    required String status,
    String size = 'md',
    required BuildContext context,
  }) {
    return buildIcon(
      name: status,
      category: 'status',
      size: size,
      status: status,
      context: context,
    );
  }

  static Widget buildActionIcon({
    required String action,
    String size = 'md',
    Color? color,
    required BuildContext context,
  }) {
    return buildIcon(
      name: action,
      category: 'action',
      size: size,
      color: color,
      context: context,
    );
  }

  static Widget buildNavigationIcon({
    required String direction,
    String size = 'md',
    Color? color,
    required BuildContext context,
  }) {
    return buildIcon(
      name: direction,
      category: 'navigation',
      size: size,
      color: color,
      context: context,
    );
  }

  static Widget buildEducationIcon({
    required String type,
    String size = 'md',
    Color? color,
    required BuildContext context,
  }) {
    return buildIcon(
      name: type,
      category: 'education',
      size: size,
      color: color,
      context: context,
    );
  }

  static Widget buildAchievementIcon({
    required String type,
    String size = 'md',
    Color? color,
    required BuildContext context,
  }) {
    return buildIcon(
      name: type,
      category: 'achievement',
      size: size,
      color: color,
      context: context,
    );
  }

  static Widget buildAnalyticsIcon({
    required String type,
    String size = 'md',
    Color? color,
    required BuildContext context,
  }) {
    return buildIcon(
      name: type,
      category: 'analytics',
      size: size,
      color: color,
      context: context,
    );
  }

  static Widget buildCommunicationIcon({
    required String type,
    String size = 'md',
    Color? color,
    required BuildContext context,
  }) {
    return buildIcon(
      name: type,
      category: 'communication',
      size: size,
      color: color,
      context: context,
    );
  }

  static Widget buildFileIcon({
    required String type,
    String size = 'md',
    Color? color,
    required BuildContext context,
  }) {
    return buildIcon(
      name: type,
      category: 'file',
      size: size,
      color: color,
      context: context,
    );
  }

  static Widget buildDeviceIcon({
    required String type,
    String size = 'md',
    Color? color,
    required BuildContext context,
  }) {
    return buildIcon(
      name: type,
      category: 'device',
      size: size,
      color: color,
      context: context,
    );
  }

  static Widget buildTimeIcon({
    required String type,
    String size = 'md',
    Color? color,
    required BuildContext context,
  }) {
    return buildIcon(
      name: type,
      category: 'time',
      size: size,
      color: color,
      context: context,
    );
  }

  // Icon with badge
  static Widget buildIconWithBadge({
    required IconData icon,
    required String badgeText,
    String size = 'md',
    Color? color,
    Color? badgeColor,
    required BuildContext context,
  }) {
    final iconSize = getResponsiveIconSize(context, size);
    
    return Stack(
      children: [
        Icon(
          icon,
          size: iconSize,
          color: color,
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: badgeColor ?? Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              badgeText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  // Icon with tooltip
  static Widget buildIconWithTooltip({
    required IconData icon,
    required String tooltip,
    String size = 'md',
    Color? color,
    required BuildContext context,
  }) {
    final iconSize = getResponsiveIconSize(context, size);
    
    return Tooltip(
      message: tooltip,
      child: Icon(
        icon,
        size: iconSize,
        color: color,
      ),
    );
  }

  // Icon with animation
  static Widget buildAnimatedIcon({
    required IconData icon,
    String size = 'md',
    Color? color,
    Duration duration = const Duration(milliseconds: 300),
    required BuildContext context,
  }) {
    final iconSize = getResponsiveIconSize(context, size);
    
    return AnimatedContainer(
      duration: duration,
      child: Icon(
        icon,
        size: iconSize,
        color: color,
      ),
    );
  }

  // Icon with gradient
  static Widget buildGradientIcon({
    required IconData icon,
    required List<Color> colors,
    String size = 'md',
    required BuildContext context,
  }) {
    final iconSize = getResponsiveIconSize(context, size);
    
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Icon(
        icon,
        size: iconSize,
        color: Colors.white,
      ),
    );
  }

  // Icon with shadow
  static Widget buildIconWithShadow({
    required IconData icon,
    String size = 'md',
    Color? color,
    Color? shadowColor,
    double shadowBlur = 4.0,
    Offset shadowOffset = const Offset(2, 2),
    required BuildContext context,
  }) {
    final iconSize = getResponsiveIconSize(context, size);
    
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: shadowColor ?? Colors.black26,
            blurRadius: shadowBlur,
            offset: shadowOffset,
          ),
        ],
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: color,
      ),
    );
  }
}
