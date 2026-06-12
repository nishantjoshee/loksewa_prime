sealed class Result<T> {
  const Result();

  R fold<R>({
    required R Function(T value) onOk,
    required R Function(Object error, StackTrace? stack) onErr,
  }) {
    return switch (this) {
      Ok(:final value) => onOk(value),
      Err(:final error, :final stack) => onErr(error, stack),
    };
  }

  T? get okOrNull => switch (this) {
    Ok(:final value) => value,
    _ => null,
  };

  Object? get errOrNull => switch (this) {
    Err(:final error) => error,
    _ => null,
  };

  bool get isOk => this is Ok<T>;
  bool get isErr => this is Err<T>;
}

final class Ok<T> extends Result<T> {
  final T value;
  const Ok(this.value);
}

final class Err<T> extends Result<T> {
  final Object error;
  final StackTrace? stack;
  const Err(this.error, [this.stack]);
}
