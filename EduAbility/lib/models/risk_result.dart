/// Risk evaluation result from the backend.
class RiskResult {
  final String userId;
  final String riskZone; // 'green', 'yellow', 'red'
  final double riskScore; // 0-100
  final List<String> keyFactors;
  final String recommendedAction;

  RiskResult({
    required this.userId,
    required this.riskZone,
    required this.riskScore,
    required this.keyFactors,
    required this.recommendedAction,
  });

  factory RiskResult.fromJson(Map<String, dynamic> json) {
    return RiskResult(
      userId: json['user_id'] ?? '',
      riskZone: (json['risk_zone'] ?? 'green').toString().toLowerCase(),
      riskScore: (json['risk_score'] ?? 0.0).toDouble(),
      keyFactors:
          (json['key_factors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      recommendedAction: json['recommended_action'] ?? '',
    );
  }

  bool get isRed => riskZone == 'red';
  bool get isYellow => riskZone == 'yellow';
  bool get isGreen => riskZone == 'green';
}
