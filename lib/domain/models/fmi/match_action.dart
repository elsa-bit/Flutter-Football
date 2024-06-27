import 'dart:ui';

import 'package:flutter_football/domain/models/fmi/card.dart';

abstract class MatchAction {
  final String id;
  final DateTime createdAt;
  final String assetName;
  final Color? assetTint;

  MatchAction({
    required this.id,
    required this.createdAt,
    required this.assetName,
    this.assetTint,
  });
}

class CardAction extends MatchAction {
  final Card card;

  CardAction({
    required super.id,
    required super.createdAt,
    required super.assetName,
    super.assetTint,
    required this.card,
  });
}

class GoalAction extends MatchAction {
  // TODO : add complement fields with all info for details
  GoalAction({
    required super.id,
    required super.createdAt,
    required super.assetName,
    super.assetTint,
  });
}

class ReplacementAction extends MatchAction {
  // TODO : add complement fields with all info for details
  ReplacementAction({
    required super.id,
    required super.createdAt,
    required super.assetName,
    super.assetTint,
  });
}
