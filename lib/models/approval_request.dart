class ApprovalRequest {
  String title;
  String description;
  String category;
  String? pdfPath;
  String? link;
  String status; // 'pending', 'accepted', 'rejected'
  String? rejectionReason;
  int? points; // Points awarded by faculty (0-50)
  DateTime submittedAt;

  ApprovalRequest({
    required this.title,
    required this.description,
    required this.category,
    this.pdfPath,
    this.link,
    this.status = 'pending',
    this.rejectionReason,
    this.points,
    DateTime? submittedAt,
  }) : submittedAt = submittedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'pdfPath': pdfPath,
      'link': link,
      'status': status,
      'rejectionReason': rejectionReason,
      'points': points,
      'submittedAt': submittedAt.toIso8601String(),
    };
  }

  factory ApprovalRequest.fromMap(Map<String, dynamic> map) {
    return ApprovalRequest(
      title: map['title'],
      description: map['description'],
      category: map['category'],
      pdfPath: map['pdfPath'],
      link: map['link'],
      status: map['status'],
      rejectionReason: map['rejectionReason'],
      points: map['points'],
      submittedAt: DateTime.parse(map['submittedAt']),
    );
  }
}
