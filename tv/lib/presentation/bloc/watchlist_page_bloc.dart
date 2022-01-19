import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_watchlist_tvs.dart';

part 'event/watchlist_page_event.dart';
part 'state/watchlist_page_state.dart';

class TvWatchlistPageBloc extends Bloc<FetchWatchlistTv, WatchlistPageState> {
  final GetWatchlistTvs getWatchlistTv;

  TvWatchlistPageBloc(this.getWatchlistTv) : super(WatchlistPageInitial());

  @override
  Stream<WatchlistPageState> mapEventToState(
    FetchWatchlistTv event,
  ) async* {
    if (event is FetchWatchlistTv) {
      yield WatchlistPageLoading();
      final result = await getWatchlistTv.execute();
      yield* result.fold(
        (failure) async* {
          yield WatchlistPageError(failure.message);
        },
        (data) async* {
          yield WatchlistPageLoaded(data);
        },
      );
    }
  }
}
