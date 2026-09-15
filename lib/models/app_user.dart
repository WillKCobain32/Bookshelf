class AppUser {
  final String id;
  final String nome;
  final String username;
  final String email;
  final String bio;


  const AppUser({
    required this.id,
    required this.nome,
    required this.username,
    required this.email,
    this.bio = '',
  });

  AppUser copyWith ({String? name, String? username, String? bio}){
    return AppUser(id: id, nome: nome ?? this.nome, username: username ?? this.username, email: email, bio: bio ?? this.bio);


  }
}