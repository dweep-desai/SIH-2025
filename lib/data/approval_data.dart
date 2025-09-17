import 'package:flutter/foundation.dart';
import '../models/approval_request.dart';

List<ApprovalRequest> approvalRequests = [
  // Dummy data for testing
  ApprovalRequest(
    title: 'Mobile App Development',
    description: 'A Flutter-based mobile application for campus management.',
    category: 'Projects',
    link: 'https://example.com',
    status: 'accepted',
    points: 45,
  ),
  ApprovalRequest(
    title: 'AI in Education Research',
    description: 'A comprehensive study on adaptive learning systems.',
    category: 'Research papers',
    pdfPath: '/path/to/pdf',
    status: 'accepted',
    points: 48,
  ),
  ApprovalRequest(
    title: 'Web Development Project',
    description: 'E-commerce platform using React and Node.js.',
    category: 'Projects',
    status: 'accepted',
    points: 42,
  ),
  ApprovalRequest(
    title: 'Machine Learning Study',
    description: 'Research on neural networks for image recognition.',
    category: 'Research papers',
    status: 'accepted',
    points: 50,
  ),
  ApprovalRequest(
    title: 'Tech Corp Internship',
    description: 'Software development internship at Tech Corp.',
    category: 'Experience',
    status: 'accepted',
  ),
  ApprovalRequest(
    title: 'Rejected Project',
    description: 'Incomplete project submission.',
    category: 'Projects',
    status: 'rejected',
    rejectionReason: 'Incomplete documentation.',
  ),
];

void addApprovalRequest(ApprovalRequest request) {
  approvalRequests.add(request);
}

void updateApprovalStatus(int index, String status, {String? reason}) {
  approvalRequests[index].status = status;
  if (reason != null) {
    approvalRequests[index].rejectionReason = reason;
  }
}

// ---------------- FACULTY APPROVAL HISTORY ----------------
class FacultyApprovalAction {
  final String studentName;
  final String action; // approved|rejected
  final String title;
  final String? reason; // for rejected
  final DateTime at;

  FacultyApprovalAction({
    required this.studentName,
    required this.action,
    required this.title,
    this.reason,
    DateTime? at,
  }) : at = at ?? DateTime.now();
}

final List<FacultyApprovalAction> facultyApprovalHistory = [];

void logFacultyApproval({
  required String studentName,
  required String action,
  required String title,
  String? reason,
}) {
  facultyApprovalHistory.insert(0, FacultyApprovalAction(
    studentName: studentName,
    action: action,
    title: title,
    reason: reason,
  ));
}

// ---------------- SHARED APPROVAL STATS ----------------
class ApprovalStats extends ChangeNotifier {
  int _approvedCount = 0;
  int _rejectedCount = 0;
  int _pendingCount = 0;

  int get approvedCount => _approvedCount;
  int get rejectedCount => _rejectedCount;
  int get pendingCount => _pendingCount;

  void setPending(int count) {
    _pendingCount = count < 0 ? 0 : count;
    notifyListeners();
  }

  void decrementPending() {
    if (_pendingCount > 0) {
      _pendingCount -= 1;
      notifyListeners();
    }
  }

  void incrementApproved({int by = 1}) {
    if (by <= 0) return;
    _approvedCount += by;
    notifyListeners();
  }

  void incrementRejected({int by = 1}) {
    if (by <= 0) return;
    _rejectedCount += by;
    notifyListeners();
  }

  double get approvalRatePercent {
    final totalDecided = _approvedCount + _rejectedCount;
    if (totalDecided == 0) return 0.0;
    return (_approvedCount / totalDecided) * 100.0;
  }
}

final ApprovalStats approvalStats = ApprovalStats();

double computeAveragePointsAwarded() {
  final acceptedWithPoints = approvalRequests.where((r) => r.status == 'accepted' && r.points != null).toList();
  if (acceptedWithPoints.isEmpty) return 0.0;
  final total = acceptedWithPoints.fold<int>(0, (sum, r) => sum + (r.points ?? 0));
  return total / acceptedWithPoints.length;
}