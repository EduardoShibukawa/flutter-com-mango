import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);

  Future<void> request({
    required String url,
    required String method,
  }) async {
    await client.post(Uri.parse(url));
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  group('post', () {
    test('Should call post with correct values', () async {
      final client = ClientSpy();
      final url = Uri.parse(faker.internet.httpUrl());
      final sut = HttpAdapter(client);

      when(() => client.post(url)).thenAnswer((_) async => Response('{}', 200));

      await sut.request(url: url.toString(), method: 'post');

      verify(() => client.post(url));
    });
  });
}
