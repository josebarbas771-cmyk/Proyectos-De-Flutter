class Post {
  final int id;
  final String titulo;
  final String cuerpo; 
  final int usuarioId;

  const Post({
    required this.id,
    required this.titulo,
    required this.cuerpo,
    required this.usuarioId,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      titulo: json['title'] as String,
      cuerpo: json['body'] as String,
      usuarioId: json['userId'] as int,
    );
  }
}
