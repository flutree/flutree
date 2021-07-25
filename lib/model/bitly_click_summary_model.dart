class BitlyClickSummaryModel {
  String unitReference;
  int totalClicks;
  int units;
  String unit;

  BitlyClickSummaryModel(
      {this.unitReference, this.totalClicks, this.units, this.unit});

  BitlyClickSummaryModel.fromJson(Map<String, dynamic> json) {
    unitReference = json["unit_reference"];
    totalClicks = json["total_clicks"];
    units = json["units"];
    unit = json["unit"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["unit_reference"] = unitReference;
    data["total_clicks"] = totalClicks;
    data["units"] = units;
    data["unit"] = unit;
    return data;
  }
}
