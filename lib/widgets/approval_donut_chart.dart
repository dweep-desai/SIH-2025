import 'package:flutter/material.dart';

class ApprovalDonutChart extends StatelessWidget {
  final int approved;
  final int rejected;
  final int pending;
  final bool includePending; // when false, chart uses only approved+rejected
  final bool showLegend; // when true, shows legend with percentages
  final double thicknessMultiplier; // 1.0 = default, 1.5 = thicker

  const ApprovalDonutChart({
    super.key,
    required this.approved,
    required this.rejected,
    required this.pending,
    this.includePending = true,
    this.showLegend = false,
    this.thicknessMultiplier = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final int total = includePending ? (approved + rejected + pending) : (approved + rejected);
    if (total == 0) {
      return Center(
        child: Text(
          'No data',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }
    final double approvedFrac = approved / total;
    final double rejectedFrac = rejected / total;
    final double pendingFrac = includePending ? (pending / total) : 0.0;
    final Widget chart = CustomPaint(
      painter: _DonutPainter(
        approvedFrac: approvedFrac,
        rejectedFrac: rejectedFrac,
        pendingFrac: pendingFrac,
        thicknessMultiplier: thicknessMultiplier,
      ),
    );

    if (!showLegend) {
      return chart;
    }

    final TextStyle? legendStyle = Theme.of(context).textTheme.bodySmall;
    final String approvePct = (approvedFrac * 100).toStringAsFixed(1);
    final String rejectPct = (rejectedFrac * 100).toStringAsFixed(1);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AspectRatio(aspectRatio: 1.0, child: chart),
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _legendItem(color: Colors.green, label: 'Approval', value: '$approvePct% ', style: legendStyle),
            const SizedBox(width: 16.0),
            _legendItem(color: Colors.red, label: 'Rejection', value: '$rejectPct% ', style: legendStyle),
          ],
        ),
      ],
    );
  }

  Widget _legendItem({required Color color, required String label, required String value, TextStyle? style}) {
    return Row(
      children: [
        Container(width: 10.0, height: 10.0, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6.0),
        Text('$label: ', style: style),
        Text(value, style: style?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  final double approvedFrac;
  final double rejectedFrac;
  final double pendingFrac;
  final double thicknessMultiplier;

  _DonutPainter({
    required this.approvedFrac,
    required this.rejectedFrac,
    required this.pendingFrac,
    this.thicknessMultiplier = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double shortest = size.shortestSide;
    final double stroke = shortest * 0.18 * thicknessMultiplier;
    final Rect rect = Offset.zero & size;
    final double startAngle = -90 * 3.1415926535 / 180.0;

    final Paint approvedPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt
      ..color = Colors.green;
    final Paint rejectedPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt
      ..color = Colors.red;
    final Paint pendingPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt
      ..color = const Color(0xFF9E9E9E);

    final double approvedSweep = approvedFrac * 2 * 3.1415926535;
    final double rejectedSweep = rejectedFrac * 2 * 3.1415926535;
    final double pendingSweep = pendingFrac * 2 * 3.1415926535;

    final Rect arcRect = Rect.fromLTWH(
      stroke / 2,
      stroke / 2,
      size.width - stroke,
      size.height - stroke,
    );

    double currentAngle = startAngle;
    if (approvedSweep > 0) {
      canvas.drawArc(arcRect, currentAngle, approvedSweep, false, approvedPaint);
      currentAngle += approvedSweep;
    }
    if (rejectedSweep > 0) {
      canvas.drawArc(arcRect, currentAngle, rejectedSweep, false, rejectedPaint);
      currentAngle += rejectedSweep;
    }
    if (pendingSweep > 0) {
      canvas.drawArc(arcRect, currentAngle, pendingSweep, false, pendingPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return approvedFrac != oldDelegate.approvedFrac ||
        rejectedFrac != oldDelegate.rejectedFrac ||
        pendingFrac != oldDelegate.pendingFrac;
  }
}


