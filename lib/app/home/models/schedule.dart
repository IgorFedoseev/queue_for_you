
class Schedule {
  Schedule({
    required this.id,
    required this.start,
    required this.end,
    this.comment,
  });

  String? id;
  DateTime start;
  DateTime end;
  String? comment;

  factory Schedule.fromMap(Map<dynamic, dynamic> value, String id) {
    final int startMilliseconds = value['start'];
    final int endMilliseconds = value['end'];
    return Schedule(
      id: id,
      start: DateTime.fromMillisecondsSinceEpoch(startMilliseconds),
      end: DateTime.fromMillisecondsSinceEpoch(endMilliseconds),
      comment: value['comment'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
      'comment': comment,
    };
  }
}