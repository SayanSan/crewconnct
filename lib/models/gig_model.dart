class GigModel {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime date;
  final String duration;
  final double pay;
  final List<String> requiredSkills;
  final String managerId;
  final String? organizationId;
  final String? organizationName;
  final String status; // 'draft', 'published', 'closed'
  final int applicantCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const GigModel({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.duration,
    required this.pay,
    required this.requiredSkills,
    required this.managerId,
    this.organizationId,
    this.organizationName,
    this.status = 'draft',
    this.applicantCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isDraft => status == 'draft';
  bool get isPublished => status == 'published';
  bool get isClosed => status == 'closed';

  factory GigModel.fromJson(Map<String, dynamic> json) {
    return GigModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      date: DateTime.parse(json['date'] as String),
      duration: json['duration'] as String,
      pay: (json['pay'] as num).toDouble(),
      requiredSkills: (json['requiredSkills'] as List<dynamic>).cast<String>(),
      managerId: json['managerId'] as String,
      organizationId: json['organizationId'] as String?,
      organizationName: json['organizationName'] as String?,
      status: json['status'] as String? ?? 'draft',
      applicantCount: json['applicantCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'date': date.toIso8601String(),
      'duration': duration,
      'pay': pay,
      'requiredSkills': requiredSkills,
      'managerId': managerId,
      'organizationId': organizationId,
      'organizationName': organizationName,
      'status': status,
      'applicantCount': applicantCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  GigModel copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    DateTime? date,
    String? duration,
    double? pay,
    List<String>? requiredSkills,
    String? managerId,
    String? organizationId,
    String? organizationName,
    String? status,
    int? applicantCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GigModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      date: date ?? this.date,
      duration: duration ?? this.duration,
      pay: pay ?? this.pay,
      requiredSkills: requiredSkills ?? this.requiredSkills,
      managerId: managerId ?? this.managerId,
      organizationId: organizationId ?? this.organizationId,
      organizationName: organizationName ?? this.organizationName,
      status: status ?? this.status,
      applicantCount: applicantCount ?? this.applicantCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
