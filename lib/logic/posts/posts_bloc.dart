import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:sphere/logic/repository/repository.dart';

import '../../core/safe_coding/src/either.dart';
import '../../domain/core/extended_errors.dart';
import '../../domain/post/post.dart';

part 'posts_bloc.freezed.dart';

@prod
@lazySingleton
class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc({Repository? repo})
      : _repo = repo ?? GetIt.I.get(),
        super(const PostState.initial()) {
    on<_GetPostEvent>(_getCommonPosts);
  }

  final Repository _repo;

  Future _getCommonPosts(_GetPostEvent event, Emitter<PostState> emit) async {
    emit(
      const PostState.gotPost(
        PostStateData.loading(),
      ),
    );
    try {
      final rez = await _repo.getFollowsPosts();
      emit(PostState.gotPost(PostStateData.result(rez)));
    } on Exception catch (e) {
      emit(PostState.gotPost(
          PostStateData.result(left(ExtendedErrors.simple(e.toString())))));
    }
  }
}

@freezed
class PostEvent with _$PostEvent {
  const factory PostEvent.getPost() = _GetPostEvent;
}

@freezed
class PostState with _$PostState {
  const factory PostState.initial() = _Initial;

  const factory PostState.gotPost(
      PostStateData<Either<ExtendedErrors, List<Post>>> data) = _GotPost;
}

@freezed
class PostStateData<T> with _$PostStateData<T> {
  const factory PostStateData.initial() = _InitialData<T>;

  const factory PostStateData.loading() = _LoadingData<T>;

  const factory PostStateData.result(T data) = _ResultData<T>;
}
