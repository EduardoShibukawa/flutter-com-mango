import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter/data/http/http.dart';
import 'package:clean_flutter/infra/http/http.dart';

class ClientSpy extends Mock implements Client {}

void main() {
  late HttpAdapter sut;
  late ClientSpy client;
  late Uri url;

  setUp(() {
    client = ClientSpy();
    url = Uri.parse(faker.internet.httpUrl());
    sut = HttpAdapter(client);
  });

  group('shared', () {
    test('Should throw ServerError if invalid method is provided', () {
      final future = sut.request(url: url.toString(), method: 'invalid_method');

      expect(future, throwsA(HttpError.serverError));
    });
  });

  group('When call post', () {
    When mockRequest() => when(() => client.post(url,
        headers: any(
          named: 'headers',
        ),
        body: any(named: 'body')));

    void mockResponse(int statusCode,
        {String body = '{"any_key":"any_value"}'}) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    void mockError() {
      mockRequest().thenThrow(Exception());
    }

    setUp(() {
      mockResponse(200);
    });

    test('should be called correct values', () async {
      await sut.request(
        url: url.toString(),
        method: 'post',
        body: {'any_key': 'any_value'},
      );

      verify(() => client.post(url,
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json'
          },
          body: '{"any_key":"any_value"}'));
    });

    test('should be called without body', () async {
      await sut.request(url: url.toString(), method: 'post');

      verify(() => client.post(
            url,
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json'
            },
          ));
    });

    test('should return data if post returns 200', () async {
      await sut.request(url: url.toString(), method: 'post');

      verify(() => client.post(
            url,
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json'
            },
          ));
    });
    test('should return empty map if post returns 200 with no data', () async {
      mockResponse(200, body: '');

      final response = await sut.request(url: url.toString(), method: 'post');

      expect(response, {});
    });

    test('should return empty map if post returns 204', () async {
      mockResponse(204, body: '');

      final response = await sut.request(url: url.toString(), method: 'post');

      expect(response, {});
    });

    test('should return empty map if post returns 204 with data', () async {
      mockResponse(204);

      final response = await sut.request(url: url.toString(), method: 'post');

      expect(response, {});
    });

    test('should return BadRequestError if post returns 400 without body',
        () async {
      mockResponse(400, body: '');

      final future = sut.request(url: url.toString(), method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('should return BadRequestError if post returns 400', () async {
      mockResponse(400);

      final future = sut.request(url: url.toString(), method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('should return Unauthorized if post returns 401', () async {
      mockResponse(401);

      final future = sut.request(url: url.toString(), method: 'post');

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('should return Unauthorized if post returns 403', () async {
      mockResponse(403);

      final future = sut.request(url: url.toString(), method: 'post');

      expect(future, throwsA(HttpError.forbidden));
    });

    test('should return Unauthorized if post returns 404', () async {
      mockResponse(404);

      final future = sut.request(url: url.toString(), method: 'post');

      expect(future, throwsA(HttpError.notFound));
    });

    test('should return ServerErrpr if post returns 500', () async {
      mockResponse(400);

      final future = sut.request(url: url.toString(), method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('should return ServerError if post throws', () async {
      mockError();

      final future = sut.request(url: url.toString(), method: 'post');

      expect(future, throwsA(HttpError.serverError));
    });
  });

  group('When call get', () {
    When mockRequest() => when(() => client.get(url,
        headers: any(
          named: 'headers',
        )));

    void mockResponse(int statusCode,
        {String body = '{"any_key":"any_value"}'}) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    void mockError() {
      mockRequest().thenThrow(Exception());
    }

    setUp(() {
      mockResponse(200);
    });

    test('should be called correct values', () async {
      await sut.request(
        url: url.toString(),
        method: 'get',
      );

      verify(() => client.get(
            url,
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json'
            },
          ));
    });

    test('should return data if post returns 200', () async {
      await sut.request(url: url.toString(), method: 'get');

      verify(() => client.get(
            url,
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json'
            },
          ));
    });

    test('should return empty map if post returns 200 with no data', () async {
      mockResponse(200, body: '');

      final response = await sut.request(url: url.toString(), method: 'get');

      expect(response, {});
    });

    test('should return empty map if post returns 204', () async {
      mockResponse(204, body: '');

      final response = await sut.request(url: url.toString(), method: 'get');

      expect(response, {});
    });

    test('should return empty map if post returns 204 with data', () async {
      mockResponse(204);

      final response = await sut.request(url: url.toString(), method: 'get');

      expect(response, {});
    });

    test('should return BadRequestError if post returns 400 without body',
        () async {
      mockResponse(400, body: '');

      final future = sut.request(url: url.toString(), method: 'get');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('should return BadRequestError if post returns 400', () async {
      mockResponse(400);

      final future = sut.request(url: url.toString(), method: 'get');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('should return Unauthorized if post returns 401', () async {
      mockResponse(401);

      final future = sut.request(url: url.toString(), method: 'get');

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('should return Unauthorized if post returns 401', () async {
      mockResponse(401);

      final future = sut.request(url: url.toString(), method: 'get');

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('should return Unauthorized if post returns 403', () async {
      mockResponse(403);

      final future = sut.request(url: url.toString(), method: 'get');

      expect(future, throwsA(HttpError.forbidden));
    });

    test('should return Unauthorized if post returns 404', () async {
      mockResponse(404);

      final future = sut.request(url: url.toString(), method: 'get');

      expect(future, throwsA(HttpError.notFound));
    });

    test('should return ServerErrpr if post returns 500', () async {
      mockResponse(400);

      final future = sut.request(url: url.toString(), method: 'get');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('should return ServerError if post throws', () async {
      mockError();

      final future = sut.request(url: url.toString(), method: 'post');

      expect(future, throwsA(HttpError.serverError));
    });
  });
}
