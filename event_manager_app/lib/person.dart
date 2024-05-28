class Person {
  String name;
  String lastName;
  DateTime birth;

  Person({
    required this.name,
    required this.lastName,
    required this.birth
  });

  Map<String, Object?> toMap() {
    return {
      'name': name,
      'last_name': lastName,
      'birth': birth.toString(),
    };
  }

  @override
  String toString() {
    return 'Person{name: $name, last_name: $lastName, birth: $birth}';
  }
}