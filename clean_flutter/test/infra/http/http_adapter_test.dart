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
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json'
    };
    await client.post(Uri.parse(url), headers: headers);
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  late HttpAdapter sut;
  late ClientSpy client;
  late Uri url;

  setUp(() {
    client = ClientSpy();
    url = Uri.parse(faker.internet.httpUrl());
    sut = HttpAdapter(client);

    when(() => client.post(
          url,
          headers: any(
            named: 'headers',
          ),
        )).thenAnswer((_) async => Response('{}', 200));
  });
  
  group('When call post', () {
    test('should be called correct values', () async {
      await sut.request(url: url.toString(), method: 'post');

      verify(() => client.post(
            url,
            headers: {
              'content-type': 'application/json',
              'accept': 'app  lication/json'
            },
          ));
    });
  });
}
