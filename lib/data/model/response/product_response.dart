class DataProductResponseModel {
  ProductResponseModel? data;

  DataProductResponseModel({this.data});

  DataProductResponseModel.fromJson(Map<String, dynamic> json) {
    data =
        json['data'] != null
            ? new ProductResponseModel.fromJson(json['data'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ProductResponseModel {
  GetAllProducts? getAllProducts;

  ProductResponseModel({this.getAllProducts});

  ProductResponseModel.fromJson(Map<String, dynamic> json) {
    getAllProducts =
        json['getAllProducts'] != null
            ? new GetAllProducts.fromJson(json['getAllProducts'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.getAllProducts != null) {
      data['getAllProducts'] = this.getAllProducts!.toJson();
    }
    return data;
  }
}

class GetAllProducts {
  List<Products>? products;

  GetAllProducts({this.products});

  GetAllProducts.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  int? id;
  String? name;
  String? description;
  int? userId;
  int? price;
  int? costPrice;
  int? inventory;
  String? createdAt;
  String? updatedAt;

  Products({
    this.id,
    this.name,
    this.description,
    this.userId,
    this.price,
    this.costPrice,
    this.inventory,
    this.createdAt,
    this.updatedAt,
  });

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    userId = json['user_id'];
    price = json['price'];
    costPrice = json['cost_price'];
    inventory = json['inventory'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['user_id'] = this.userId;
    data['price'] = this.price;
    data['cost_price'] = this.costPrice;
    data['inventory'] = this.inventory;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
