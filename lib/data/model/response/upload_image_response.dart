class UploadImageResponse {
  String? _uploadUrl;
  String? _publicUrl;

  UploadImageResponse({String? uploadUrl, String? publicUrl}) {
    if (uploadUrl != null) {
      this._uploadUrl = uploadUrl;
    }
    if (publicUrl != null) {
      this._publicUrl = publicUrl;
    }
  }

  String? get uploadUrl => _uploadUrl;
  set uploadUrl(String? uploadUrl) => _uploadUrl = uploadUrl;
  String? get publicUrl => _publicUrl;
  set publicUrl(String? publicUrl) => _publicUrl = publicUrl;

  UploadImageResponse.fromJson(Map<String, dynamic> json) {
    _uploadUrl = json['upload_url'];
    _publicUrl = json['public_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['upload_url'] = this._uploadUrl;
    data['public_url'] = this._publicUrl;
    return data;
  }
}
