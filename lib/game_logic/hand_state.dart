class HandState {
  final bool canPoon;
  final bool canChi;
  final bool canRon;
  final bool canKhan;

  final bool hasYaku;

  final bool canRiichi;
  final bool isReady;

  HandState({
    required this.canPoon,
    required this.canChi,
    required this.canRon,
    required this.canKhan,
    required this.hasYaku,
    required this.canRiichi,
    required this.isReady,
  });
}
