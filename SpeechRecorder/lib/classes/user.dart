final String tableUsers = 'users';
final String columnId = 'id';
final String columnName = 'name';

class User {
  int? id;
  String? name;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{columnName: name};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  User();

  User.fromMap(Map<dynamic, dynamic> map) {
    id = map[columnId];
    name = map[columnName];
  }

  @override
  String toString() {
    return "User{id:$id,name:$name}";
  }
}
