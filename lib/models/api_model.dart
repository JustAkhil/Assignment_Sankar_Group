class ApiModel {
  String? author;
  String? authorSlug;
  String? content;
  String? dateAdded;
  String? dateModified;
  int? length;
  List<dynamic>? tags;
  String? id;

  ApiModel({
    this.author,
    this.authorSlug,
    this.content,
    this.dateAdded,
    this.dateModified,
    this.length,
    this.tags,
    this.id,
  });
  factory ApiModel.fromJson(Map<String, dynamic> json) => ApiModel(
    author: json["author"],
    authorSlug: json["authorSlug"],
    content: json["content"],
    dateAdded: json["dateAdded"],
    dateModified: json["dateModified"],
    length: json["length"],
    tags: json["tags"],
    id: json["_id"],
  );
}
