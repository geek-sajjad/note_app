class Note{
  int id;
  String title;
  String body;

  Map<String, dynamic> toMap() {
    return {
      'id' : this.id,
       'title' : this.title, 'body' : this.body};
  }

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    body: json['body'],
    id: json['id'],
    title: json['title'],
  );
  Note({this.body, this.title, this.id});
}