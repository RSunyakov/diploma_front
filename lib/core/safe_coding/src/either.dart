import 'function.dart';
import 'id.dart';
import 'option.dart';

abstract class Either<L, R> {
  const Either();

  B fold<B>(B Function(L l) ifLeft, B Function(R r) ifRight);

  Either<L, R> orElse(Either<L, R> Function() other) =>
      fold((_) => other(), (_) => this);
  R getOrElse(R Function() dflt) => fold((_) => dflt(), id);
  R operator |(R dflt) => getOrElse(() => dflt);
  Either<L2, R> leftMap<L2>(L2 Function(L l) f) =>
      fold((L l) => left(f(l)), right);
  Option<R> toOption() => fold((_) => none(), some);
  bool isLeft() => fold((_) => true, (_) => false);
  bool isRight() => fold((_) => false, (_) => true);
  Either<R, L> swap() => fold(right, left);

  Either<L, R2> map<R2>(R2 Function(R r) f) => fold(left, (R r) => right(f(r)));
  Either<L, R2> bind<R2>(Function1<R, Either<L, R2>> f) => fold(left, f);
  Either<L, R2> flatMap<R2>(Function1<R, Either<L, R2>> f) => fold(left, f);
  Either<L, R2> andThen<R2>(Either<L, R2> next) => fold(left, (_) => next);

  @override
  String toString() => fold((l) => 'Left($l)', (r) => 'Right($r)');

  void forEach(void Function(R r) sideEffect) => fold((_) => Null, sideEffect);
}

class Left<L, R> extends Either<L, R> {
  final L _l;
  const Left(this._l);
  L get value => _l;
  @override
  B fold<B>(B Function(L l) ifLeft, B Function(R r) ifRight) => ifLeft(_l);
  @override
  bool operator ==(other) => other is Left && other._l == _l;
  @override
  int get hashCode => _l.hashCode;
}

class Right<L, R> extends Either<L, R> {
  final R _r;
  const Right(this._r);
  R get value => _r;
  @override
  B fold<B>(B Function(L l) ifLeft, B Function(R r) ifRight) => ifRight(_r);
  @override
  bool operator ==(other) => other is Right && other._r == _r;
  @override
  int get hashCode => _r.hashCode;
}

Either<L, R> left<L, R>(L l) => Left(l);
Either<L, R> right<L, R>(R r) => Right(r);
Either<dynamic, A> catching<A>(Function0<A> thunk) {
  try {
    return right(thunk());
  } catch (e) {
    return left(e);
  }
}
