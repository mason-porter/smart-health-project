const String tableTests = 'tests';
const String testName = 'name';
const String testDate = 'date';
const String testScore = 'score';
const String testId = 'id';
const String ownerId = 'oId';

class Test {
  int? id;
  int? oId;
  String? name;
  int? date;
  int? score;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map[testId] = id;
    map[ownerId] = oId;
    map[testName] = name;
    map[testDate] = date;
    map[testScore] = score;
    return map;
  }

  Test();

  Test.fromMap(Map<dynamic, dynamic> map) {
    id = map[testId];
    oId = map[ownerId];
    name = map[testName];
    date = map[testDate];
    score = map[testScore];
  }

  @override
  String toString() {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch((date ?? 0) * 1000);
    String dstring = dateTime.toString();
    return "Test{id:$id,name:$name,score:$score,owner:$oId,date:$dstring}";
  }
}
