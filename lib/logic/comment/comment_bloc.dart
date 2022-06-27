import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:sphere/core/safe_coding/src/either.dart';
import 'package:sphere/data/dto/posts/comment.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/post/comment.dart';
import 'package:sphere/logic/repository/repository.dart';

part 'comment_bloc.freezed.dart';

@prod
@lazySingleton
class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentBloc({Repository? repo})
      : _repo = repo ?? GetIt.I.get(),
        super(const CommentState.initial()) {
    on<_StoreCommentEvent>(_storeComment);
  }

  final Repository _repo;

  Future _storeComment(
      _StoreCommentEvent event, Emitter<CommentState> emit) async {
    emit(const CommentState.storeComment(CommentStateData.loading()));
    final res = await _repo.storeComment(event.value);
    emit(CommentState.storeComment(CommentStateData.result(res)));
  }
}

@freezed
class CommentEvent with _$CommentEvent {
  const factory CommentEvent.storeComment(CommentBody value) =
      _StoreCommentEvent;
}

@freezed
class CommentState with _$CommentState {
  const factory CommentState.initial() = _Initial;

  const factory CommentState.storeComment(
          CommentStateData<Either<ExtendedErrors, Comment>> data) =
      _StoreAchievement;
}

@freezed
class CommentStateData<T> with _$CommentStateData<T> {
  const factory CommentStateData.initial() = _InitialData<T>;

  const factory CommentStateData.loading() = _LoadingData<T>;

  const factory CommentStateData.result(T data) = _ResultData<T>;
}
