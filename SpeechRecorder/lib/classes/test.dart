const String tableTests = 'tests';
const String testName = 'name';
const String testDate = 'date';
const String testScoreL = 'score_left';
const String testScoreR = 'score_right';
const String testScoreS = 'score_single';
const String testScoreB = 'score_both';
const String testScoreFinal = 'score_final';
const String testId = 'id';
const String ownerId = 'oId';

class Test {
  int? id;
  int? oId;
  String? name;
  int? date;
  int? scoreL;
  int? scoreR;
  int? scoreS;
  int? scoreB;
  int? scoreFinal;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map[testId] = id;
    map[ownerId] = oId;
    map[testName] = name;
    map[testDate] = date;
    map[testScoreL] = scoreL;
    map[testScoreR] = scoreR;
    map[testScoreS] = scoreS;
    map[testScoreB] = scoreB;
    map[testScoreFinal] = scoreFinal;
    return map;
  }

  Test();

  Test.fromMap(Map<dynamic, dynamic> map) {
    id = map[testId];
    oId = map[ownerId];
    name = map[testName];
    date = map[testDate];
    scoreL = map[testScoreL];
    scoreR = map[testScoreR];
    scoreS = map[testScoreS];
    scoreB = map[testScoreB];
    scoreFinal = map[testScoreFinal];
  }

  @override
  String toString() {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch((date ?? 0) * 1000);
    String dstring = dateTime.toString();
    return "Test{id:$id,name:$name,score:$scoreFinal(L:$scoreL,R:$scoreR,S:$scoreS,B:$scoreB),owner:$oId,date:$dstring}";
  }
}
