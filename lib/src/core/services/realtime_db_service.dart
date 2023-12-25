import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:space_metro/src/leaderboard/domain/score.dart';

const String scoresJSON = kDebugMode ? 'dev_scores' : 'prod_scores';

typedef Scores = ({int wins, int totalPlays});

class RealTimeDBService {
  static FirebaseDatabase database = FirebaseDatabase.instance;

  static Future<void> writeToScoresJSON(
      {required String userId,
      required int wins,
      required int total,
      required String name}) async {
    final ref = database.ref(scoresJSON);

    ref.child(userId).set({
      'name': name,
      'wins': wins,
      'total_plays': total,
      'last_updated': DateTime.now().toIso8601String(),
    });
  }

  static DatabaseReference getScoresRef() {
    final ref = database.ref(scoresJSON);
    return ref;
  }

  static Future<Score> getScores(String userId) async {
    final ref = database.ref(scoresJSON);
    final snapshot = await ref.child(userId).get();
    if (snapshot.exists) {
      return Score.fromJson(jsonEncode(snapshot.value));
    } else {
      return Score.empty();
    }
  }
}
