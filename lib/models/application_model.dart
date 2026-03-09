class ApplicationModel {
  final String id;
  final String gigId;
  final String gigTitle;
  final String studentId;
  final String studentName;
  final String? studentPhotoUrl;
  final String managerId;
  final String status; // 'applied', 'shortlisted', 'accepted', 'rejected'
  final String? coverNote;
  final DateTime appliedAt;
  final DateTime updatedAt;

  const ApplicationModel({
    required this.id,
    required this.gigId,
    required this.gigTitle,
    required this.studentId,
    required this.studentName,
    this.studentPhotoUrl,
    required this.managerId,
    this.status = 'applied',
    this.coverNote,
    required this.appliedAt,
    required this.updatedAt,
  });

  bool get isApplied => status == 'applied';
  bool get isShortlisted => status == 'shortlisted';
  bool get isAccepted => status == 'accepted';
  bool get isRejected => status == 'rejected';

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id'] as String,
      gigId: json['gigId'] as String,
      gigTitle: json['gigTitle'] as String,
      studentId: json['studentId'] as String,
      studentName: json['studentName'] as String,
      studentPhotoUrl: json['studentPhotoUrl'] as String?,
      managerId: json['managerId'] as String,
      status: json['status'] as String? ?? 'applied',
      coverNote: json['coverNote'] as String?,
      appliedAt: DateTime.parse(json['appliedAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gigId': gigId,
      'gigTitle': gigTitle,
      'studentId': studentId,
      'studentName': studentName,
      'studentPhotoUrl': studentPhotoUrl,
      'managerId': managerId,
      'status': status,
      'coverNote': coverNote,
      'appliedAt': appliedAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  ApplicationModel copyWith({
    String? id,
    String? gigId,
    String? gigTitle,
    String? studentId,
    String? studentName,
    String? studentPhotoUrl,
    String? managerId,
    String? status,
    String? coverNote,
    DateTime? appliedAt,
    DateTime? updatedAt,
  }) {
    return ApplicationModel(
      id: id ?? this.id,
      gigId: gigId ?? this.gigId,
      gigTitle: gigTitle ?? this.gigTitle,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      studentPhotoUrl: studentPhotoUrl ?? this.studentPhotoUrl,
      managerId: managerId ?? this.managerId,
      status: status ?? this.status,
      coverNote: coverNote ?? this.coverNote,
      appliedAt: appliedAt ?? this.appliedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
