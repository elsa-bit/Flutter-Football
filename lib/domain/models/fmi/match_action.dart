import 'package:flutter/material.dart' hide Card;
import 'package:flutter_football/domain/models/fmi/card.dart';
import 'package:flutter_football/domain/models/fmi/goal.dart';
import 'package:flutter_football/domain/models/fmi/replacement.dart';
import 'package:flutter_football/presentation/screens/coach/match/fmi/actions/card_action_detail.dart';
import 'package:flutter_football/presentation/screens/coach/match/fmi/actions/card_action_history.dart';
import 'package:flutter_football/presentation/screens/coach/match/fmi/actions/goal_action_detail.dart';
import 'package:flutter_football/presentation/screens/coach/match/fmi/actions/goal_action_history.dart';
import 'package:flutter_football/presentation/screens/coach/match/fmi/actions/replacement_action_detail.dart';
import 'package:flutter_football/presentation/screens/coach/match/fmi/actions/replacement_action_history.dart';

abstract class MatchAction {
  final String id;
  final DateTime createdAt;
  final String matchTime;
  final String assetName;
  final Color? assetTint;

  MatchAction({
    required this.id,
    required this.createdAt,
    required this.matchTime,
    required this.assetName,
    this.assetTint,
  });

  Widget? getActionDetailWidget();

  Widget? getActionHistoryWidget();
}

class CardAction extends MatchAction {
  final Card card;

  CardAction({
    required super.id,
    required super.createdAt,
    required super.matchTime,
    required super.assetName,
    super.assetTint,
    required this.card,
  });

  @override
  Widget? getActionDetailWidget() {
    return CardActionDetail(action: this);
  }

  @override
  Widget? getActionHistoryWidget() {
    return CardActionHistory(action: this);
  }
}

class GoalAction extends MatchAction {
  final Goal goal;

  GoalAction({
    required super.id,
    required super.createdAt,
    required super.matchTime,
    required super.assetName,
    super.assetTint,
    required this.goal,
  });

  @override
  Widget? getActionDetailWidget() {
    return GoalActionDetail(action: this);
  }
  @override
  Widget? getActionHistoryWidget() {
    return GoalActionHistory(action: this);
  }
}

class ReplacementAction extends MatchAction {
  final Replacement replacement;

  ReplacementAction({
    required super.id,
    required super.createdAt,
    required super.matchTime,
    required super.assetName,
    super.assetTint,
    required this.replacement,
  });

  @override
  Widget? getActionDetailWidget() {
    return ReplacementActionDetail(action: this);
  }
  @override
  Widget? getActionHistoryWidget() {
    return ReplacementActionHistory(action: this);
  }
}
