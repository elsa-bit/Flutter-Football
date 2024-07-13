import 'package:flutter_football/domain/models/user.dart';

enum CoachStatus { initial, loading, success, error }

class CoachState {
  final CoachStatus status;
  final Coach? detailsCoach;
  final String error;

  CoachState({
    this.status = CoachStatus.initial,
    this.detailsCoach = null,
    this.error = '',
  });

  CoachState copyWith({
    CoachStatus? status,
    Coach? detailsCoach,
    String? error,
  }) {
    return CoachState(
        status: status ?? this.status,
        detailsCoach: detailsCoach ?? this.detailsCoach,
        error: error ?? this.error);
  }
}
