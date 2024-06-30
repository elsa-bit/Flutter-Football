import 'package:flutter_football/domain/models/fmi/match_action.dart';
import 'package:flutter_football/domain/models/match_details.dart';

enum FmiStatus { initial, loading, success, error }

class FmiState {
  final FmiStatus status;
  final String error;
  final MatchDetails? match;
  final List<MatchAction>? actions;

  FmiState({
    this.status = FmiStatus.initial,
    this.error = '',
    this.match = null,
    this.actions = null,
  });

  FmiState copyWith({
    FmiStatus? status,
    String? error,
    MatchDetails? match,
    List<MatchAction>? actions,
    MatchAction? action,
  }) {
    return FmiState(
      status: status ?? this.status,
      error: error ?? this.error,
      match: match ?? this.match,
      actions: actions ?? ((action != null) ? ((this.actions != null) ? (List.from(this.actions!)..add(action!)) : [action!]) : this.actions),
    );
  }
}
