import 'package:bloc/bloc.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';
import 'package:equatable/equatable.dart';

part 'event/popular_tv_event.dart';
part 'state/popular_tv_state.dart';

class PopularTvBloc extends Bloc<PopularTvEvent, PopularTvState> {
  final GetPopularTvs getPopularTv;

  PopularTvBloc(this.getPopularTv) : super(PopularTvInitial());

  @override
  Stream<PopularTvState> mapEventToState(
    PopularTvEvent event,
  ) async* {
    if (event is PopularTvEvent) {
      yield PopularTvLoading();
      final result = await getPopularTv.execute();

      yield* result.fold((failure) async* {
        yield PopularTvError(failure.message);
      }, (tv) async* {
        yield PopularTvLoaded(tv);
      });
    }
  }
}
