class InspectionRecord {
  const InspectionRecord({
    required this.id,
    required this.createdAt,
    required this.originalImagePath,
    required this.filteredImagePath,
    this.memo = '',
  });

  final String id;
  final DateTime createdAt;
  final String originalImagePath;
  final String filteredImagePath;
  final String memo;

  factory InspectionRecord.fromJson(Map<String, dynamic> json) {
    return InspectionRecord(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      originalImagePath: json['originalImagePath'] as String,
      filteredImagePath: json['filteredImagePath'] as String,
      memo: json['memo'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'originalImagePath': originalImagePath,
      'filteredImagePath': filteredImagePath,
      'memo': memo,
    };
  }
}
