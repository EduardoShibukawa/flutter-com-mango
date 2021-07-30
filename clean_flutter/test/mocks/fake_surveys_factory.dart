import 'dart:math';

import 'package:clean_flutter/domain/entities/entities.dart';
import 'package:faker/faker.dart';

class FakeSurveysFactory {
  static List<Map> makeApiJson() => List.filled(
        new Random().nextInt(10),
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(50),
          'didAnswer': faker.randomGenerator.boolean(),
          'date': faker.date.dateTime().toIso8601String()
        },
      );

  static List<Map> makeInvalidApiJson() => [
        {'invalid_data': 'invalid_key'}
      ];

  static List<Map<String, String>> makeCacheJson() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': '2020-07-20T00:00:00Z',
          'didAnswer': 'false'
        },
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': '2019-02-02T00:00:00Z',
          'didAnswer': 'true'
        }
      ];

  static List<Map<String, String>> makeInvalidCacheJson() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': 'invalid_date',
          'didAnswer': 'false'
        }
      ];

  static List<Map<String, String>> makeIncompleteCacheJson() => [
        {'id': faker.guid.guid()}
      ];
  static List<SurveyEntity> makeEntities() => [
        SurveyEntity(
          id: faker.guid.guid(),
          question: faker.randomGenerator.string(10),
          dateTime: DateTime.utc(2020, 2, 2),
          didAnswer: true,
        ),
        SurveyEntity(
          id: faker.guid.guid(),
          question: faker.randomGenerator.string(10),
          dateTime: DateTime.utc(2018, 12, 20),
          didAnswer: false,
        ),
      ];
}
