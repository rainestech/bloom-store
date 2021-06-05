import 'package:bloom/data/entity/admin.entity.dart';
import 'package:bloom/data/entity/personnel.entity.dart';

class Vendor {
  int id;
  List<Person> person;
  String name;
  String slug;
  String description;
  Address address;
  Passport logo;
  String facebook;
  String twitter;
  String instagram;

  Vendor(
      {this.id,
        this.person,
        this.name,
        this.slug,
        this.description,
        this.logo,
        this.facebook,
        this.instagram,
        this.twitter,
        this.address});

  Vendor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    facebook = json['facebook'];
    instagram = json['instagram'];
    twitter = json['twitter'];
    description = json['description'];
    if (json['person'] != null) {
      person = <Person>[];
      json['person'].forEach((v) {
        person.add(new Person.fromJson(v));
      });
    }
    if (json['logo'] != null) {
        logo = Passport.fromJson(json['logo']);
    }
    if (json['address'] != null) {
        address = Address.fromJson(json['address']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['slug'] = this.slug;
    data['name'] = this.name;
    data['facebook'] = this.facebook;
    data['twitter'] = this.twitter;
    data['instagram'] = this.instagram;
    data['description'] = this.description;
    if (this.person != null) {
      data['person'] = this.person.map((v) => v.toJson()).toList();
    }
    if (this.logo != null) {
      data['logo'] = this.logo.toJson();
    }
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    return data;
  }

  bool operator ==(dynamic other) =>
      other != null && other is Vendor && this.id == other.id;

  @override
  int get hashCode => super.hashCode;
}

class Category {
  int id;
  List<Products> products;
  String name;
  String alias;
  int catOrder;
  bool catActive;
  Passport icon;

  Category(
      {this.id,
        this.products,
        this.name,
        this.alias,
        this.catActive,
        this.catOrder,
        this.icon});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    alias = json['alias'];
    catOrder = json['catOrder'];
    catActive = json['catActive'];
    icon = json['icon'] != null ? new Passport.fromJson(json['icon']) : null;
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['alias'] = this.alias;
    data['name'] = this.name;
    data['catActive'] = this.catActive;
    data['catOrder'] = this.catOrder;
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    data['icon'] = this.icon != null ? icon.toJson() : null;
    return data;
  }

  bool operator ==(dynamic other) =>
      other != null && other is Category && this.id == other.id;

  @override
  int get hashCode => super.hashCode;
}
class Ads {
  int id;
  Products product;
  Category category;
  Passport image;
  Vendor vendor;

  Ads(
      {this.id,
        this.product,
        this.category,
        this.image});

  Ads.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'] != null ? new Passport.fromJson(json['image']) : null;
    category = json['category'] != null ? new Category.fromJson(json['category']) : null;
    product = json['activeProduct'] != null ? new Products.fromJson(json['activeProduct']) : json['product'] != null ? new Products.fromJson(json['product']) : null;
    vendor = json['vendor'] != null ? new Vendor.fromJson(json['vendor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product'] = this.product != null ? product.toJson() : null;
    data['product_id'] = this.product != null ? product.id : null;
    data['image'] = this.image != null ? image.toJson() : null;
    data['category'] = this.category != null ? category.toJson() : null;
    data['category_id'] = this.category != null ? category.id : null;
    data['vendor'] = this.vendor != null ? vendor.toJson() : null;
    data['vendor_id'] = this.vendor != null ? vendor.id : null;
    return data;
  }

  bool operator == (dynamic other) =>
      other != null && other is Ads && this.id == other.id;

  @override
  int get hashCode => super.hashCode;
}

class Cart {
  int id;
  Products product;
  String category;
  String status;
  int quantity;
  double price;
  double shipping;

  Cart(
      {this.id,
        this.product,
        this.category,
        this.status,
        this.quantity,
        this.price});

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['product_type'];
    status = json['status'];
    quantity = json['quantity'];
    shipping = double.parse(json['shipping'].toString());
    price = double.parse(json['price'].toString());
    product = json['product'] != null ? new Products.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_type'] = this.category;
    data['status'] = this.status;
    data['price'] = this.price;
    data['shipping'] = this.price;
    data['quantity'] = this.quantity;
    data['product'] = this.product != null ? product.toJson() : null;
    return data;
  }

  bool operator ==(dynamic other) =>
      other != null && other is Cart && this.id == other.id;

  @override
  int get hashCode => super.hashCode;
}

class OrderItems {
  int id;
  Products product;
  String name;
  int orderId;
  String category;
  String status;
  int quantity;
  double price;

  OrderItems(
      {this.id,
        this.product,
        this.name,
        this.category,
        this.status,
        this.quantity,
        this.price});

  OrderItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['product_type'];
    name = json['name'];
    status = json['status'];
    quantity = int.parse(json['quantity'].toString());
    orderId = int.parse(json['order_id'].toString());
    price = double.parse(json['price'].toString());
    product = json['product'] != null ? new Products.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_type'] = this.category;
    data['name'] = this.name;
    data['order_id'] = this.orderId;
    data['status'] = this.status;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['product'] = this.product != null ? product.toJson() : null;
    return data;
  }

  bool operator ==(dynamic other) =>
      other != null && other is OrderItems && this.id == other.id;

  @override
  int get hashCode => super.hashCode;
}

class Orders {
  int id;
  String channel;
  String address;
  String notes;
  String status;
  List<OrderItems> items;
  double amount;
  double amountProducts;
  double amountShipping;
  User user;

  Orders(
      {this.id,
        this.notes,
        this.channel,
        this.address,
        this.status,
        this.amount,
        this.amountProducts,
        this.amountShipping,
        this.items});

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    notes = json['notes'];
    status = json['status'];
    amount = double.parse(json['amount'].toString());
    print(json['amount_shipping']);
    amountShipping = double.parse(json['amount_shipping'].toString());
    amountProducts = double.parse(json['amount_products'].toString());
    channel = json['channel'];
    address = json['address'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['items'] != null) {
      items = <OrderItems>[];
      json['items'].forEach((v) {
        items.add(new OrderItems.fromJson(v));
      });
    }
  }

  Orders.cartToOrder(List<Cart> cart, Address addr) {
    notes = 'Order Note';
    status = 'pending';
    channel = 'Mobile Stripe';
    address = addr.toJson().toString();
    amountProducts = cart.fold(0.0, (sum, i) => sum + i.price);
    amountShipping = cart.fold(0.0, (sum, i) => sum + i.shipping);
    amount = amountShipping + amountProducts;

    items = [];
    cart.forEach((e) {
      var item = new OrderItems();
      item.id = e.product.id;
      item.status = 'pending';
      item.name = e.product.name;
      item.product = e.product;
      item.category = e.category;
      item.price = e.price;
      item.quantity = e.quantity;

      items.add(item);
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['notes'] = this.notes;
    data['amount'] = this.amount;
    data['channel'] = this.channel;
    data['status'] = this.status;
    data['address'] = this.address;
    data['amount_shipping'] = this.amountShipping;
    data['amount_products'] = this.amountProducts;
    data['user'] = this.user == null ? null : user.toJson();
    this.items != null ? data['items'] = this.items.map((v) => v.toJson()).toList() : null;

    return data;
  }

  bool operator ==(dynamic other) =>
      other != null && other is Orders && this.id == other.id;

  @override
  int get hashCode => super.hashCode;
}

class Products {
  int id;
  Vendor vendor;
  String name;
  String slug;
  String sku;
  double price;
  double lsFee;
  double isFee;
  String excerpt;
  String description;
  String state;
  String extTitle;
  int unitsSold;
  String lastSaleAt;
  int stock;
  Category category;
  List<Passport> images;
  int quantity;
  double salePrice;
  String saleEnds;
  int approved;

  Products(
      {this.id,
        this.vendor,
        this.name,
        this.slug,
        this.extTitle,
        this.lastSaleAt,
        this.stock,
        this.state,
        this.unitsSold,
        this.sku,
        this.price,
        this.description,
        this.category,
        this.images,
        this.lsFee,
        this.isFee,
        this.approved,
        this.excerpt});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    description = json['description'];
    excerpt = json['excerpt'];
    salePrice = json['sale_price'];
    saleEnds = json['sale_ends'];
    if (json['vendor'] != null) {
      vendor = new Vendor.fromJson(json['vendor']);
    }

    if (json['images'] != null) {
      images = <Passport>[];
      json['images'].forEach((v) {
        images.add(new Passport.fromJson(v));
      });
    }
    extTitle = json['ext_title'];
    lastSaleAt = json['last_sale_at'];
    state = json['state'];
    stock = json['stock'];
    unitsSold = json['units_sold'];
    approved = json['approved'];
    sku = json['sku'];
    quantity = json['quantity'];
    price = double.parse(json['price'].toString());
    lsFee = double.parse(json['lsFee'].toString());
    isFee = double.parse(json['isFee'].toString());
    category = json['category'] != null ? new Category.fromJson(json['category']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['slug'] = this.slug;
    data['name'] = this.name;
    data['description'] = this.description;
    data['approved'] = this.approved;
    data['excerpt'] = this.excerpt;
    data['sku'] = this.sku;
    data['lsFee'] = this.lsFee;
    data['isFee'] = this.isFee;
    data['price'] = this.price;
    data['state'] = this.state;
    this.images != null ? data['images'] = this.images.map((v) => v.toJson()).toList() : null;
    data['ext_title'] = this.extTitle;
    data['last_sale_at'] = this.lastSaleAt;
    data['units_sold'] = this.unitsSold;
    data['stock'] = this.stock;
    data['sale_price'] = this.salePrice;
    data['sale_ends'] = this.saleEnds;
    data['quantity'] = this.quantity;
    data['vendor'] = this.vendor != null ? this.vendor.toJson() : null;
    data['category'] = this.category != null ? this.category.toJson() : null;

    return data;
  }

  bool operator ==(dynamic other) =>
      other != null && other is Products && this.id == other.id;

  @override
  int get hashCode => super.hashCode;
}





