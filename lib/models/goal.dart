class Goal {
  final int id;
  final int clientId;
  final String name;

  const Goal({  required this.id, required this.clientId, required this.name, });

  factory Goal.fromSqfliteDatabase(Map<String,dynamic> map) => Goal(
    id: map['id']?.toInt() ?? 0,
    clientId: map['clientId']?? 0,
    name: map['name'] ?? 'no name'
  );
}