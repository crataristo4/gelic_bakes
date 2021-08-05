class NotificationInfo {
  int? id;
  String? title;
  DateTime? notifDateTime;
  bool? isPending;

  NotificationInfo({this.id, this.title, this.notifDateTime, this.isPending});

  factory NotificationInfo.fromMap(Map<String, dynamic> json) =>
      NotificationInfo(
        id: json["id"],
        title: json["title"],
        notifDateTime: DateTime.parse(json["notifDateTime"]),
        isPending: json["isPending"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "notifDateTime": notifDateTime!.toIso8601String(),
        "isPending": isPending
      };
}
