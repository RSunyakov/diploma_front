class AppCommentsModel {
  int id;
  String? avatarPath;
  String name;
  String? answerer;
  String content;
  String date;
  List<AppCommentsModel>? replies;

  AppCommentsModel({
    required this.id,
    this.avatarPath,
    required this.name,
    this.answerer,
    required this.content,
    required this.date,
    this.replies,
  });
}
