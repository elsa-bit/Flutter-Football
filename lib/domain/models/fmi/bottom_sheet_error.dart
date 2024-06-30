abstract class BottomSheetError {
  final String message;

  BottomSheetError({required this.message});
}

class NoCardSelectedError extends BottomSheetError {
  NoCardSelectedError({required super.message});
}

class NoPlayerSelectedError extends BottomSheetError {
  NoPlayerSelectedError({required super.message});
}