import 'package:flutter_football/domain/models/match.dart';

enum FmiStatus { initial, loading, success, error }

class FmiState {
  final FmiStatus status;
  final String error;

  FmiState({
    this.status = FmiStatus.initial,
    this.error = '',
  });

  FmiState copyWith({
    FmiStatus? status,
    String? error,
  }) {
    return FmiState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
