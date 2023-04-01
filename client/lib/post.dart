import 'package:freezed_annotation/freezed_annotation.dart';
part 'post.freezed.dart';
part 'post.g.dart';
@freezed
class Post with _$Post {
  const factory Post({
    String? theme,
    String? content,
    required int? id
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}
//напиши модель базы данных для таблицы Post с полями Тема и Контент
