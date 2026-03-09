class OrganizationModel {
  final String id;
  final String name;
  final String? description;
  final String? logoUrl;
  final String managerId;
  final DateTime createdAt;

  const OrganizationModel({
    required this.id,
    required this.name,
    this.description,
    this.logoUrl,
    required this.managerId,
    required this.createdAt,
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      logoUrl: json['logoUrl'] as String?,
      managerId: json['managerId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logoUrl': logoUrl,
      'managerId': managerId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  OrganizationModel copyWith({
    String? id,
    String? name,
    String? description,
    String? logoUrl,
    String? managerId,
    DateTime? createdAt,
  }) {
    return OrganizationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      managerId: managerId ?? this.managerId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
