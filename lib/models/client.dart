class Client {
  final String name;
  final int id;
  final String description;
  final int birthday;

  const Client({  required this.id, required this.name, this.description = "", required this.birthday});

  factory Client.fromSqfliteDatabase(Map<String,dynamic> map) => Client(
    id: map['id']?.toInt() ?? 0,
    name: map['name'] ?? 'no name',
    description: map['description'] ?? "",
    birthday: map['birthday'] ?? 0
  );
}