import 'dart:convert';

class Score {
  final int wins;
  final int totalPlays;
  final DateTime lastUpdated;
  final String name;
  Score({
    required this.wins,
    required this.totalPlays,
    required this.lastUpdated,
    required this.name,
  });

  Score copyWith({
    int? wins,
    int? totalPlays,
    DateTime? lastUpdated,
    String? name,
  }) {
    return Score(
      wins: wins ?? this.wins,
      totalPlays: totalPlays ?? this.totalPlays,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'wins': wins,
      'total_plays': totalPlays,
      'last_updated': lastUpdated.millisecondsSinceEpoch,
      'name': name,
    };
  }

  factory Score.fromMap(Map<String, dynamic> map) {
    return Score(
      wins: map['wins'] as int,
      totalPlays: map['total_plays'] as int,
      lastUpdated: DateTime.parse(map['last_updated']),
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Score.fromJson(String source) =>
      Score.fromMap(json.decode(source) as Map<String, dynamic>);

  factory Score.empty() => Score(
        wins: 0,
        totalPlays: 0,
        lastUpdated: DateTime.now(),
        name: 'Null User',
      );

  @override
  String toString() {
    return 'Score(wins: $wins, total_plays: $totalPlays, last_updated: $lastUpdated, name: $name)';
  }

  @override
  bool operator ==(covariant Score other) {
    if (identical(this, other)) return true;

    return other.wins == wins &&
        other.totalPlays == totalPlays &&
        other.lastUpdated == lastUpdated &&
        other.name == name;
  }

  @override
  int get hashCode {
    return wins.hashCode ^
        totalPlays.hashCode ^
        lastUpdated.hashCode ^
        name.hashCode;
  }
}
