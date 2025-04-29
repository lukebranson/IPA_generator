class Session {
  final int id;
  final int clientId;
  final int createDate;

  const Session({  required this.id, required this.clientId, required this.createDate});

  factory Session.fromSqfliteDatabase(Map<String,dynamic> map) => Session(
    id: map['id']?.toInt() ?? 0,
    clientId: map['clientId'] ?? 0,
    createDate: map['createDate'] ?? 0
  );
}