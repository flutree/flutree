
class BitlyClickSummaryModel {
    String unitReference;
    int totalClicks;
    int units;
    String unit;

    BitlyClickSummaryModel({this.unitReference, this.totalClicks, this.units, this.unit});

    BitlyClickSummaryModel.fromJson(Map<String, dynamic> json) {
        this.unitReference = json["unit_reference"];
        this.totalClicks = json["total_clicks"];
        this.units = json["units"];
        this.unit = json["unit"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data["unit_reference"] = this.unitReference;
        data["total_clicks"] = this.totalClicks;
        data["units"] = this.units;
        data["unit"] = this.unit;
        return data;
    }
}