enum ReportType {
  sales(1, "sale"),
  expenses(2, "expense");

  final int id;
  final String name;

  const ReportType(this.id, this.name);
}
