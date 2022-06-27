import 'either.dart';

abstract class Option<A> {
  const Option();

  B fold<B>(B Function() ifNone, B Function(A a) ifSome);

  Option<A> orElse(Option<A> Function() other) => fold(other, (_) => this);
  A getOrElse(A Function() dflt) => fold(dflt, (a) => a);
  Either<B, A> toEither<B>(B Function() ifNone) =>
      fold(() => left(ifNone()), (a) => right(a));
  Either<dynamic, A> operator %(ifNone) => toEither(() => ifNone);
  A operator |(A dflt) => getOrElse(() => dflt);

  Option<B> map<B>(B Function(A a) f) => fold(none, (A a) => some(f(a)));
  Option<B> andThen<B>(Option<B> next) => fold(none, (_) => next);

  bool isSome() => fold(() => false, (_) => true);

  bool isNone() => !isSome();

  @override
  String toString() => fold(() => 'None', (a) => 'Some($a)');

  void forEach(void Function(A a) sideEffect) => fold(() => Null, sideEffect);
}

class Some<A> extends Option<A> {
  final A _a;
  const Some(this._a);
  A get value => _a;
  @override
  B fold<B>(B Function() ifNone, B Function(A a) ifSome) => ifSome(_a);
  @override
  bool operator ==(other) => other is Some && other._a == _a;
  @override
  int get hashCode => _a.hashCode;
}

class None<A> extends Option<A> {
  const None();
  @override
  B fold<B>(B Function() ifNone, B Function(A a) ifSome) => ifNone();
  @override
  bool operator ==(other) => other is None;
  @override
  int get hashCode => 0;
}

Option<A> none<A>() => const None();
Option<A> some<A>(A a) => Some(a);
Option<A> option<A>(bool test, A value) => test ? some(value) : none();
Option<A> optionOf<A>(A value) => value != null ? some(value) : none();
