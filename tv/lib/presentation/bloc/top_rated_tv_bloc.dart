import 'package:bloc/bloc.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:equatable/equatable.dart';

part 'event/top_rated_tv_event.dart';
part 'state/top_rated_tv_state.dart';

class TopRatedTvBloc extends Bloc<TopRatedTvEvent, TopRatedTvState> {
  final GetTopRatedTvs getTopRatedTv;
  TopRatedTvBloc(this.getTopRatedTv) : super(TopRatedTvInitial());

  @override
  Stream<TopRatedTvState> mapEventToState(
    TopRatedTvEvent event,
  ) async* {
    if (event is TopRatedTvEvent) {
      yield TopRatedTvLoading();
      final result = await getTopRatedTv.execute();

      yield* result.fold((failure) async* {
        yield TopRatedTvError(failure.message);
      }, (tv) async* {
        yield TopRatedTvLoaded(tv);
      });
    }
  }
}
