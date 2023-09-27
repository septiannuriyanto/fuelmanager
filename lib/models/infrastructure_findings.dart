class InfrastructureFindings {
  String key;
  int id;
  String unit;
  String description;
  String cause;
  String action;
  String duedate;
  String pic;
  String status;
  String findingEvidence;
  String? closingEvidence;
  String? openDate;
  String? closedDate;

  InfrastructureFindings({
    required this.key,
    required this.id,
    required this.unit,
    required this.description,
    required this.cause,
    required this.action,
    required this.duedate,
    required this.pic,
    required this.status,
    required this.findingEvidence,
    this.closingEvidence,
    this.openDate,
    this.closedDate,
  });

  factory InfrastructureFindings.fromJson(List<dynamic> json) {
    return InfrastructureFindings(
      key: json[0],
      id: int.parse(json[1]),
      unit: json[2],
      description: json[3],
      cause: json[4],
      action: json[5],
      duedate: json[6],
      pic: json[7],
      status: json[8],
      openDate: json[9],
      findingEvidence: json[10],
    );
  }
}
