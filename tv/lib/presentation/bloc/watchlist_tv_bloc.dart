import 'package:bloc/bloc.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/domain/usecases/get_watchlist_status_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';

part 'event/watchlist_tv_event.dart';
part 'state/watchlist_tv_state.dart';

class WatchlistTvBloc extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  final GetWatchListStatusTv _getWatchListStatus;
  final SaveWatchlistTv _saveWatchlist;
  final RemoveWatchlistTv _removeWatchlist;

  WatchlistTvBloc(
      this._getWatchListStatus, this._saveWatchlist, this._removeWatchlist)
      : super(WatchlistTvInitial());

  @override
  Stream<WatchlistTvState> mapEventToState(
    WatchlistTvEvent event,
  ) async* {
    if (event is AddToWatchList) {
      final result = await _saveWatchlist.execute(event.tv);
      yield* result.fold(
        (failure) async* {
          yield WatchlistTvError(failure.message);
        },
        (data) async* {
          yield WatchlistTvStatus(true);
        },
      );
    } else if (event is RemoveWatchList) {
      final result = await _removeWatchlist.execute(event.tv);
      yield* result.fold(
        (failure) async* {
          yield WatchlistTvError(failure.message);
        },
        (data) async* {
          yield WatchlistTvStatus(false);
        },
      );
    } else if (event is LoadWatchListStatus) {
      final result = await _getWatchListStatus.execute(event.id);
      yield WatchlistTvStatus(result);
    }
  }
}
