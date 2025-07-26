class AddProductResponse {
  Data? _data;

  AddProductResponse({Data? data}) {
    if (data != null) {
      this._data = data;
    }
  }

  Data? get data => _data;
  set data(Data? data) => _data = data;

  AddProductResponse.fromJson(Map<String, dynamic> json) {
    _data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._data != null) {
      data['data'] = this._data!.toJson();
    }
    return data;
  }
}

class Data {
  CreateProduct? _createProduct;

  Data({CreateProduct? createProduct}) {
    if (createProduct != null) {
      this._createProduct = createProduct;
    }
  }

  CreateProduct? get createProduct => _createProduct;
  set createProduct(CreateProduct? createProduct) =>
      _createProduct = createProduct;

  Data.fromJson(Map<String, dynamic> json) {
    _createProduct =
        json['createProduct'] != null
            ? new CreateProduct.fromJson(json['createProduct'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._createProduct != null) {
      data['createProduct'] = this._createProduct!.toJson();
    }
    return data;
  }
}

class CreateProduct {
  Product? _product;

  CreateProduct({Product? product}) {
    if (product != null) {
      this._product = product;
    }
  }

  Product? get product => _product;
  set product(Product? product) => _product = product;

  CreateProduct.fromJson(Map<String, dynamic> json) {
    _product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._product != null) {
      data['product'] = this._product!.toJson();
    }
    return data;
  }
}

class Product {
  String? _name;
  int? _costPrice;
  String? _description;
  int? _inventory;
  int? _price;
  int? _userId;
  String? _imageUrl;

  Product({
    String? name,
    int? costPrice,
    String? description,
    int? inventory,
    int? price,
    int? userId,
    String? imageUrl,
  }) {
    if (name != null) {
      this._name = name;
    }
    if (costPrice != null) {
      this._costPrice = costPrice;
    }
    if (description != null) {
      this._description = description;
    }
    if (inventory != null) {
      this._inventory = inventory;
    }
    if (price != null) {
      this._price = price;
    }
    if (userId != null) {
      this._userId = userId;
    }
    if (imageUrl != null) {
      this._imageUrl = imageUrl;
    }
  }

  String? get name => _name;
  set name(String? name) => _name = name;
  int? get costPrice => _costPrice;
  set costPrice(int? costPrice) => _costPrice = costPrice;
  String? get description => _description;
  set description(String? description) => _description = description;
  int? get inventory => _inventory;
  set inventory(int? inventory) => _inventory = inventory;
  int? get price => _price;
  set price(int? price) => _price = price;
  int? get userId => _userId;
  set userId(int? userId) => _userId = userId;
  String? get imageUrl => _imageUrl;
  set imageUrl(String? imageUrl) => _imageUrl = imageUrl;

  Product.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _costPrice = json['cost_price'];
    _description = json['description'];
    _inventory = json['inventory'];
    _price = json['price'];
    _userId = json['user_id'];
    _imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['cost_price'] = this._costPrice;
    data['description'] = this._description;
    data['inventory'] = this._inventory;
    data['price'] = this._price;
    data['user_id'] = this._userId;
    data['image_url'] = this._imageUrl;
    return data;
  }
}
