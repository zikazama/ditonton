import 'package:bloc/bloc.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_on_the_air_tv.dart';
import 'package:equatable/equatable.dart';

part 'event/on_air_tv_event.dart';
part 'state/on_air_tv_state.dart';

class OnAirTvBloc extends Bloc<OnAirTvEvent, OnAirTvState> {
  OnAirTvBloc(this.getOnAirTv) : super(OnAirTvInitial());
  final GetOnTheAirTvs getOnAirTv;

  @override
  Stream<OnAirTvState> mapEventToState(
    OnAirTvEvent event,
  ) async* {
    if (event is OnAirTvEvent) {
      yield OnAirTvLoading();
      final nowPlayingresult = await getOnAirTv.execute();

      yield* nowPlayingresult.fold((failure) async* {
        yield OnAirTvError(failure.message);
      }, (movie) async* {
        yield OnAirTvLoaded(movie);
      });
    }
  }
}
