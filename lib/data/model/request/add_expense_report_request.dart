class AddExpenseReportRequest {
  int? userId;
  int? amount;
  String? title;
  String? description;
  String? expenseDate;

  AddExpenseReportRequest({
    this.userId,
    this.amount,
    this.title,
    this.description,
    this.expenseDate,
  });

  AddExpenseReportRequest.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    amount = json['amount'];
    title = json['title'];
    description = json['description'];
    expenseDate = json['expense_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['amount'] = amount;
    data['title'] = title;
    data['description'] = description;
    data['expense_date'] = expenseDate;
    return data;
  }
}
