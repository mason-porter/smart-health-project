const String tableUsers = 'users';
const String userId = 'id';
const String userUname = 'uname';
const String userPass = 'password';
const String userName = 'name';
const String userAdmin = 'admin';

class User {
  int? id;
  String? uname;
  String? password;
  String? name;
  bool? admin;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map[userId] = id;
    map[userUname] = uname;
    map[userPass] = password;
    map[userName] = name;
    map[userAdmin] = (admin == true) ? 1 : 0;
    return map;
  }

  User();

  User.fromMap(Map<dynamic, dynamic> map) {
    id = map[userId];
    uname = map[userUname];
    password = map[userPass];
    name = map[userName];
    admin = (map[userAdmin] == 1) ? true : false;
  }

  @override
  String toString() {
    if (admin == true) {
      return "User[ADMIN]{id:$id,name:$name,uname:$uname,password:$password}";
    }
    return "User{id:$id,name:$name,uname:$uname,password:$password}";
  }
}
