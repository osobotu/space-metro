import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:space_metro/src/core/services/realtime_db_service.dart';
import 'package:space_metro/src/leaderboard/domain/score.dart';

class MetroLeaderboardPage extends StatelessWidget {
  const MetroLeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metro Leaderboard'),
      ),
      body: StreamBuilder(
          stream: RealTimeDBService.getScoresRef().onValue,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              // if (snapshot.data?.snapshot.children != null) {
              //   for (final child in snapshot.data!.snapshot.children) {
              //     print(child.value);
              //     return Text('there is data');
              //   }
              // }
              final children = snapshot.data?.snapshot.children ?? [];
              final scores = children
                  .map((e) => Score.fromJson(jsonEncode(e.value)))
                  .toList();

              final DataTableSource dataSource = MyDataSource(scores: scores);
              // print(children);
              // return ListView.builder(
              //   itemCount: children.length,
              //   itemBuilder: (context, index) {
              //     final item = children.toList()[index].value;
              //     final score = Score.fromJson(jsonEncode(item));
              //     return Text(score.toString());
              //   },
              // );
              return DataTableExample(
                dataSource: dataSource,
              );
            } else {
              return const Text('Loading...');
            }
          }),
    );
  }
}

class MyDataSource extends DataTableSource {
  final List<Score> scores;

  MyDataSource({required this.scores});
  @override
  int get rowCount => scores.length;

  @override
  DataRow? getRow(int index) {
    // scores.reversed.toList();

    final score = scores[index];
    final winPercent = ((score.wins / score.totalPlays) * 100);
    return DataRow(
      cells: <DataCell>[
        DataCell(Text(score.name)),
        DataCell(Text(score.wins.toString())),
        DataCell(Text(score.totalPlays.toString())),
        DataCell(Text(winPercent.toStringAsFixed(2))),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}

class DataTableExample extends StatelessWidget {
  const DataTableExample({super.key, required this.dataSource});

  final DataTableSource dataSource;

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      sortColumnIndex: 3,
      sortAscending: false,
      columns: const <DataColumn>[
        DataColumn(
          label: Text('Name'),
        ),
        DataColumn(
          label: Text('Wins'),
        ),
        DataColumn(
          label: Text('Total Plays'),
        ),
        DataColumn(
          label: Text('Win %'),
        ),
      ],
      source: dataSource,
    );
  }
}
