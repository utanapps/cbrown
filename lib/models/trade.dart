class Trade {
  final String? userId;
  final String? mt4Id;
  final DateTime? closetime;
  final double? lots;
  final double? totalComm;
  final String? instrument;

  Trade({
    required this.userId,
    required this.mt4Id,
    required this.closetime,
    required this.lots,
    required this.totalComm,
    required this.instrument,
  });

  // データベースからのデータをこのモデルに変換するためのファクトリコンストラクタ
  factory Trade.fromMap(Map<String, dynamic> data) {
    return Trade(
      userId: data['user_id'],
      mt4Id: data['mt4_id'],
      closetime: DateTime.parse(data['closetime']),
      lots: data['lots'],
      totalComm: data['payment_amount'],
      instrument: data['instrument'],

    );
  }
}
