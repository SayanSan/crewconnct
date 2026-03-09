class UserModel {
  final String id;
  final String email;
  final String? phone;
  final String name;
  final String? photoUrl;
  final String userType; // 'student' or 'manager'
  final bool onboardingComplete;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Student-specific fields
  final List<String>? skills;
  final String? resumeUrl;
  final Map<String, dynamic>? availability;
  final String? bio;
  final String? university;

  // Manager-specific fields
  final String? organizationId;
  final String? designation;

  const UserModel({
    required this.id,
    required this.email,
    this.phone,
    required this.name,
    this.photoUrl,
    required this.userType,
    this.onboardingComplete = false,
    required this.createdAt,
    required this.updatedAt,
    this.skills,
    this.resumeUrl,
    this.availability,
    this.bio,
    this.university,
    this.organizationId,
    this.designation,
  });

  bool get isStudent => userType == 'student';
  bool get isManager => userType == 'manager';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String?,
      userType: json['userType'] as String,
      onboardingComplete: json['onboardingComplete'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      skills: (json['skills'] as List<dynamic>?)?.cast<String>(),
      resumeUrl: json['resumeUrl'] as String?,
      availability: json['availability'] as Map<String, dynamic>?,
      bio: json['bio'] as String?,
      university: json['university'] as String?,
      organizationId: json['organizationId'] as String?,
      designation: json['designation'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'name': name,
      'photoUrl': photoUrl,
      'userType': userType,
      'onboardingComplete': onboardingComplete,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      if (skills != null) 'skills': skills,
      if (resumeUrl != null) 'resumeUrl': resumeUrl,
      if (availability != null) 'availability': availability,
      if (bio != null) 'bio': bio,
      if (university != null) 'university': university,
      if (organizationId != null) 'organizationId': organizationId,
      if (designation != null) 'designation': designation,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? phone,
    String? name,
    String? photoUrl,
    String? userType,
    bool? onboardingComplete,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? skills,
    String? resumeUrl,
    Map<String, dynamic>? availability,
    String? bio,
    String? university,
    String? organizationId,
    String? designation,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      userType: userType ?? this.userType,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      skills: skills ?? this.skills,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      availability: availability ?? this.availability,
      bio: bio ?? this.bio,
      university: university ?? this.university,
      organizationId: organizationId ?? this.organizationId,
      designation: designation ?? this.designation,
    );
  }
}
