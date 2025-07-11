class ProductRequestModel {
  int? userId;
  String? name;
  String? description;
  int? inventory;
  int? price;
  int? costPrice;

  ProductRequestModel({this.userId, this.name, this.description, this.inventory, this.price, this.costPrice});

  factory ProductRequestModel.fromJson(Map<String, dynamic> json) => ProductRequestModel(
    userId: json["user_id"],
    name: json["name"],
    description: json["description"],
    inventory: json["inventory"],
    price: json["price"],
    costPrice: json["cost_price"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId, 
    "name": name, 
    "description": description, 
    "inventory": inventory,
    "price": price,
    "cost_price": costPrice,
  };

    bool isValid() {
    return userId != null &&
           name != null && name!.isNotEmpty &&
           description != null && description!.isNotEmpty &&
           inventory != null && inventory! > 0 &&
           price != null && price! > 0 &&
           costPrice != null && costPrice! > 0;
  }

  // Add method to get validation errors
  List<String> getValidationErrors() {
    List<String> errors = [];
    
    if (userId == null) errors.add("User ID is required");
    if (name == null || name!.isEmpty) errors.add("Product name is required");
    if (description == null || description!.isEmpty) errors.add("Description is required");
    if (inventory == null || inventory! <= 0) errors.add("Inventory must be greater than 0");
    if (price == null || price! <= 0) errors.add("Price must be greater than 0");
    if (costPrice == null || costPrice! <= 0) errors.add("Cost price must be greater than 0");
    
    return errors;
  }
}
