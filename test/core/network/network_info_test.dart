import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/network/network_info.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([InternetConnection])
void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockInternetConnection mockInternetConnection;

  setUp(() {
    mockInternetConnection = MockInternetConnection();
    networkInfoImpl =
        NetworkInfoImpl(internetConnection: mockInternetConnection);
  });

  group('isConnected', () {
    test('should forward call to InternetConnectionChecker.hasConnection',
        () async {
      Future<bool> tHasConnection = Future.value(true);
      // arrange
      when(mockInternetConnection.hasInternetAccess)
          .thenAnswer((_) => tHasConnection);
      // act
      final result = networkInfoImpl.isConnected;
      // assert
      verify(mockInternetConnection.hasInternetAccess);
      expect(result, tHasConnection);
    });
  });
}
