class User {
  String? id;
  String displayName;
  String email;
  String? photoUrl;
  String uid;
  String? games;
  String? birthday;
  String? user;
  String? nationality;
  List<String>? friends;
  List<String>? friendRequests;

  User(
      this.id,
      this.email,
      this.photoUrl,
      this.displayName,
      this.user,
      this.uid,
      this.birthday,
      this.games,
      this.nationality,
      this.friends,
      this.friendRequests);
}
