class Post {
  int id;
  String header;
  String text;


  Post({this.id, this.header, this.text});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(id: json["id"], header: json["header"], text: json["text"]);
  }

  Map<String, dynamic> toJson(){
    return {
      "id" : id,
      "text" : text,
      "header" : header
    };
  }
}