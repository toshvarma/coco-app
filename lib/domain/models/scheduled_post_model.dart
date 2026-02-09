class ScheduledPost {
  final String id;
  final String platform;
  final String topic;
  final String? note;
  final bool isDraft;
  final DateTime date;
  final String? time;

  ScheduledPost({
    required this.id,
    required this.platform,
    required this.topic,
    this.note,
    this.isDraft = false,
    required this.date,
    this.time,
  });


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'platform': platform,
      'topic': topic,
      'note': note,
      'isDraft': isDraft,
      'date': date.toIso8601String(),
      'time': time,
    };
  }


  factory ScheduledPost.fromJson(Map<String, dynamic> json) {
    return ScheduledPost(
      id: json['id'],
      platform: json['platform'],
      topic: json['topic'],
      note: json['note'],
      isDraft: json['isDraft'] ?? false,
      date: DateTime.parse(json['date']),
      time: json['time'],
    );
  }


  ScheduledPost copyWith({
    String? id,
    String? platform,
    String? topic,
    String? note,
    bool? isDraft,
    DateTime? date,
    String? time,
  }) {
    return ScheduledPost(
      id: id ?? this.id,
      platform: platform ?? this.platform,
      topic: topic ?? this.topic,
      note: note ?? this.note,
      isDraft: isDraft ?? this.isDraft,
      date: date ?? this.date,
      time: time ?? this.time,
    );
  }
}