import 'package:flutter_test/flutter_test.dart';
import 'package:loksewa_prime/core/result.dart';

void main() {
  group('Result', () {
    group('Ok', () {
      test('isOk returns true', () {
        const result = Ok(42);
        expect(result.isOk, isTrue);
        expect(result.isErr, isFalse);
      });

      test('okOrNull returns value', () {
        const result = Ok('hello');
        expect(result.okOrNull, 'hello');
      });

      test('errOrNull returns null', () {
        const result = Ok(true);
        expect(result.errOrNull, isNull);
      });

      test('fold calls onOk', () {
        const result = Ok(10);
        final folded = result.fold(onOk: (v) => v * 2, onErr: (e, s) => 0);
        expect(folded, 20);
      });
    });

    group('Err', () {
      test('isErr returns true', () {
        const result = Err<int>('error');
        expect(result.isErr, isTrue);
        expect(result.isOk, isFalse);
      });

      test('okOrNull returns null', () {
        const result = Err<String>('fail');
        expect(result.okOrNull, isNull);
      });

      test('errOrNull returns error', () {
        const result = Err<double>('bad');
        expect(result.errOrNull, 'bad');
      });

      test('fold calls onErr', () {
        const result = Err<int>('oops');
        final folded = result.fold(
          onOk: (v) => v,
          onErr: (error, _) => 'error: $error',
        );
        expect(folded, 'error: oops');
      });

      test('stores stack trace', () {
        final stack = StackTrace.current;
        final result = Err<int>('boom', stack);
        expect(result.stack, stack);
      });
    });
  });
}
