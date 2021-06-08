import 'dart:convert';

import 'package:bloom/data/entity/personnel.entity.dart';
import 'package:bloom/data/entity/vendor.entity.dart';
import 'package:bloom/data/http/http.client.dart';
import 'package:dio/dio.dart';
import 'endpoints.dart';

class VendorResponse {
  final Vendor data;
  final String error;
  final String eTitle;

  VendorResponse(this.data, this.error, this.eTitle);

  VendorResponse.fromJson(resp)
      : data = new Vendor.fromJson(resp),
        error = "",
        eTitle = "";

  VendorResponse.withError(String msg, title)
      : data = null,
        error = msg,
        eTitle = title;
}

class OrderResponse {
  final Orders data;
  final String error;
  final String eTitle;

  OrderResponse(this.data, this.error, this.eTitle);

  OrderResponse.fromJson(resp)
      : data = new Orders.fromJson(resp),
        error = null,
        eTitle = null;

  OrderResponse.withError(String msg, title)
      : data = null,
        error = msg,
        eTitle = title;
}

class OrderListResponse {
  final List<Orders> data;
  final String error;
  final String eTitle;

  OrderListResponse(this.data, this.error, this.eTitle);

  OrderListResponse.fromJson(resp)
      : data = (resp as List).map((i) => new Orders.fromJson(i)).toList(),
        error = null,
        eTitle = null;

  OrderListResponse.withError(String msg, title)
      : data = null,
        error = msg,
        eTitle = title;
}

class WishListsResponse {
  final List<WishList> data;
  final String error;
  final String eTitle;

  WishListsResponse(this.data, this.error, this.eTitle);

  WishListsResponse.fromJson(resp)
      : data = (resp as List).map((i) => new WishList.fromJson(i)).toList(),
        error = null,
        eTitle = null;

  WishListsResponse.withError(String msg, title)
      : data = null,
        error = msg,
        eTitle = title;
}

class CartResponse {
  final Cart data;
  final String error;
  final String eTitle;

  CartResponse(this.data, this.error, this.eTitle);

  CartResponse.fromJson(resp)
      : data = new Cart.fromJson(resp),
        error = null,
        eTitle = null;

  CartResponse.withError(String msg, title)
      : data = null,
        error = msg,
        eTitle = title;
}

class CartListResponse {
  final List<Cart> data;
  final String error;
  final String eTitle;

  CartListResponse(this.data, this.error, this.eTitle);

  CartListResponse.fromJson(resp)
      : data = (resp as List).map((i) => new Cart.fromJson(i)).toList(),
        error = null,
        eTitle = null;

  CartListResponse.withError(String msg, title)
      : data = null,
        error = msg,
        eTitle = title;
}

class VendorListResponse {
  final List<Vendor> data;
  final String error;
  final String eTitle;

  VendorListResponse(this.data, this.error, this.eTitle);

  VendorListResponse.fromJson(resp)
      : data = (resp as List).map((i) => new Vendor.fromJson(i)).toList(),
        error = "",
        eTitle = "";

  VendorListResponse.withError(String msg, title)
      : data = null,
        error = msg,
        eTitle = title;
}

class CountryListResponse {
  final List<Country> data;
  final String error;
  final String eTitle;

  CountryListResponse(this.data, this.error, this.eTitle);

  CountryListResponse.fromJson(resp)
      : data = (resp as List).map((i) => new Country.fromJson(i)).toList(),
        error = "",
        eTitle = "";

  CountryListResponse.withError(String msg, title)
      : data = null,
        error = msg,
        eTitle = title;
}

class AddressListResponse {
  final List<Address> data;
  final String error;
  final String eTitle;

  AddressListResponse(this.data, this.error, this.eTitle);

  AddressListResponse.fromJson(resp)
      : data = (resp as List).map((i) => new Address.fromJson(i)).toList(),
        error = null,
        eTitle = null;

  AddressListResponse.withError(String msg, title)
      : data = null,
        error = msg,
        eTitle = title;
}

class AddressResponse {
  final Address data;
  final String error;
  final String eTitle;

  AddressResponse(this.data, this.error, this.eTitle);

  AddressResponse.fromJson(resp)
      : data = new Address.fromJson(resp),
        error = null,
        eTitle = null;

  AddressResponse.withError(String msg, title)
      : data = null,
        error = msg,
        eTitle = title;
}

class CategoryResponse {
  final Category data;
  final String error;
  final String eTitle;

  CategoryResponse(this.data, this.error, this.eTitle);

  CategoryResponse.fromJson(resp)
      : data = new Category.fromJson(resp),
        error = "",
        eTitle = "";

  CategoryResponse.withError(String msg, title)
      : data = null,
        error = msg,
        eTitle = title;
}

class AdsResponse {
  final Ads data;
  final String error;
  final String eTitle;

  AdsResponse(this.data, this.error, this.eTitle);

  AdsResponse.fromJson(resp)
      : data = new Ads.fromJson(resp),
        error = "",
        eTitle = "";

  AdsResponse.withError(String msg, title)
      : data = null,
        error = msg,
        eTitle = title;
}

class CategoryListResponse {
  final List<Category> data;
  final String error;
  final String eTitle;

  CategoryListResponse(this.data, this.error, this.eTitle);

  CategoryListResponse.fromJson(resp)
      : data = (resp as List).map((i) => new Category.fromJson(i)).toList(),
        error = null,
        eTitle = null;

  CategoryListResponse.withError(String msg, title)
      : data = null,
        error = msg,
        eTitle = title;
}

class AdsListResponse {
  final List<Ads> data;
  final String error;
  final String eTitle;

  AdsListResponse(this.data, this.error, this.eTitle);

  AdsListResponse.fromJson(resp)
      : data = (resp as List).map((i) => new Ads.fromJson(i)).toList(),
        error = null,
        eTitle = null;

  AdsListResponse.withError(String msg, title)
      : data = null,
        error = msg,
        eTitle = title;
}

class ProductsResponse {
  final Products data;
  final String error;
  final String eTitle;

  ProductsResponse(this.data, this.error, this.eTitle);

  ProductsResponse.fromJson(resp)
      : data = new Products.fromJson(resp),
        error = "",
        eTitle = "";

  ProductsResponse.withError(String msg, title)
      : data = null,
        error = msg,
        eTitle = title;
}

class ProductListResponse {
  final List<Products> data;
  final String error;
  final String eTitle;

  ProductListResponse(this.data, this.error, this.eTitle);

  ProductListResponse.fromJson(resp)
      : data = (resp as List).map((i) => new Products.fromJson(i)).toList(),
        error = "",
        eTitle = "";

  ProductListResponse.withError(String msg, title)
      : data = null,
        error = msg,
        eTitle = title;
}

class VendorApiProvider {
  Future<VendorResponse> me() async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(vendorEndpoint + '/me');

      VendorResponse resp = VendorResponse.fromJson(response.data);

      return resp;
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return VendorResponse.withError(error['message'], error['error']);
      }
      return VendorResponse.withError(e.message, "Network Error");
    }
  }

  Future<VendorListResponse> getVendors() async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(vendorEndpoint);

      VendorListResponse resp = VendorListResponse.fromJson(response.data);

      return resp;
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return VendorListResponse.withError(error['message'], error['error']);
      }
      return VendorListResponse.withError(e.message, "Network Error");
    }
  }

  Future<VendorResponse> saveVendor(Vendor vendor) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.post(vendorEndpoint,
          data: vendor.toJson());

      return VendorResponse.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return VendorResponse.withError(error['message'], error['error']);
      }
      return VendorResponse.withError(e.message, "Network Error");
    }
  }

  Future<VendorResponse> editVendor(Vendor vendor) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.put(vendorEndpoint, data: vendor.toJson());

      return VendorResponse.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return VendorResponse.withError(error['message'], error['error']);
      }
      return VendorResponse.withError(e.message, "Network Error");
    }
  }

  Future<VendorResponse> approveVendor(Vendor vendor) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(vendorEndpoint + '/a/' + vendor.id.toString());

      return VendorResponse.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return VendorResponse.withError(error['message'], error['error']);
      }
      return VendorResponse.withError(e.message, "Network Error");
    }
  }

  Future<VendorResponse> revokeVendor(Vendor vendor) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(vendorEndpoint + '/r/' + vendor.id.toString());

      return VendorResponse.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return VendorResponse.withError(error['message'], error['error']);
      }
      return VendorResponse.withError(e.message, "Network Error");
    }
  }

  Future<VendorResponse> deleteVendor(Vendor vendor) async {
    final Dio _dio = await HttpClient.http();
    try {
      await _dio.delete(vendorEndpoint + '/remove/${vendor.id}');

      return VendorResponse(vendor, "", "");
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return VendorResponse.withError(error['message'], error['error']);
      }
      return VendorResponse.withError(e.message, "Network Error");
    }
  }
}

class CategoryApiProvider {
  Future<CategoryListResponse> getCategories() async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(categoryEndpoint);

      CategoryListResponse resp = CategoryListResponse.fromJson(response.data);

      return resp;
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return CategoryListResponse.withError(error['message'], error['error']);
      }
      return CategoryListResponse.withError(e.message, "Network Error");
    }
  }

  Future<CategoryResponse> saveCategory(Category category) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.post(categoryEndpoint,
          data: category.toJson());

      return CategoryResponse.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return CategoryResponse.withError(error['message'], error['error']);
      }
      return CategoryResponse.withError(e.message, "Network Error");
    }
  }

  Future<CategoryResponse> editCategory(Category category) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.put(categoryEndpoint, data: category.toJson());

      return CategoryResponse.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return CategoryResponse.withError(error['message'], error['error']);
      }
      return CategoryResponse.withError(e.message, "Network Error");
    }
  }

  Future<CategoryResponse> deleteCategory(Category category) async {
    final Dio _dio = await HttpClient.http();
    try {
      await _dio.delete(categoryEndpoint + '/remove/${category.id}');

      return CategoryResponse(category, "", "");
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return CategoryResponse.withError(error['message'], error['error']);
      }
      return CategoryResponse.withError(e.message, "Network Error");
    }
  }
}

class WishListApiProvider {
  Future<WishListsResponse> myWishList() async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(wishListEndpoint);

      WishListsResponse resp = WishListsResponse.fromJson(response.data);

      return resp;
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return WishListsResponse.withError(error['message'], error['error']);
      }
      return WishListsResponse.withError(e.message, "Network Error");
    }
  }

  Future<bool> addToWishList(Products product) async {
    try {
      final Dio _dio = await HttpClient.http();
      await _dio.get(wishListEndpoint + '/a/' + product.id.toString());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeWishList(Products product) async {
    try {
      final Dio _dio = await HttpClient.http();
      await _dio.get(wishListEndpoint + '/r/' + product.id.toString());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> queryWishList(Products product) async {
    try {
      final Dio _dio = await HttpClient.http();
      await _dio.get(wishListEndpoint + '/q/' + product.id.toString());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<CategoryResponse> editCategory(Category category) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.put(categoryEndpoint, data: category.toJson());

      return CategoryResponse.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return CategoryResponse.withError(error['message'], error['error']);
      }
      return CategoryResponse.withError(e.message, "Network Error");
    }
  }

  Future<CategoryResponse> deleteCategory(Category category) async {
    final Dio _dio = await HttpClient.http();
    try {
      await _dio.delete(categoryEndpoint + '/remove/${category.id}');

      return CategoryResponse(category, "", "");
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return CategoryResponse.withError(error['message'], error['error']);
      }
      return CategoryResponse.withError(e.message, "Network Error");
    }
  }
}

class AdsApiProvider {
  Future<AdsListResponse> index() async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(adsEndpoint);

      AdsListResponse resp = AdsListResponse.fromJson(response.data);

      return resp;
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return AdsListResponse.withError(error['message'], error['error']);
      }
      return AdsListResponse.withError(e.message, "Network Error");
    }
  }

  Future<AdsListResponse> myAds() async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(adsEndpoint + '/my');

      AdsListResponse resp = AdsListResponse.fromJson(response.data);

      return resp;
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return AdsListResponse.withError(error['message'], error['error']);
      }
      return AdsListResponse.withError(e.message, "Network Error");
    }
  }

  Future<AdsListResponse> vendorAds(Vendor vendor) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(adsEndpoint + '/vendor/' + vendor.id.toString());

      AdsListResponse resp = AdsListResponse.fromJson(response.data);

      return resp;
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return AdsListResponse.withError(error['message'], error['error']);
      }
      return AdsListResponse.withError(e.message, "Network Error");
    }
  }

  Future<AdsResponse> saveAds(Ads ads) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.post(adsEndpoint,
          data: ads.toJson());

      return AdsResponse.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return AdsResponse.withError(error['message'], error['error']);
      }
      return AdsResponse.withError(e.message, "Network Error");
    }
  }

  Future<AdsResponse> editAds(Ads ads) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.put(adsEndpoint, data: ads.toJson());

      return AdsResponse.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return AdsResponse.withError(error['message'], error['error']);
      }
      return AdsResponse.withError(e.message, "Network Error");
    }
  }

  Future<AdsResponse> deleteAd(Ads ads) async {
    final Dio _dio = await HttpClient.http();
    try {
      await _dio.delete(adsEndpoint + '/remove/${ads.id}');

      return AdsResponse(ads, "", "");
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return AdsResponse.withError(error['message'], error['error']);
      }
      return AdsResponse.withError(e.message, "Network Error");
    }
  }
}

class AddressApiProvider {
  Future<CountryListResponse> getCountries() async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(addressEndpoint);

      return CountryListResponse.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return CountryListResponse.withError(error['message'], error['error']);
      }
      return CountryListResponse.withError(e.message, "Network Error");
    }
  }

  Future<AddressResponse> getAddress(String type) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(addressEndpoint + '/type/$type}');

      return AddressResponse.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return AddressResponse.withError(error['message'], error['error']);
      }
      return AddressResponse.withError(e.message, "Network Error");
    }
  }

  Future<AddressResponse> saveAddresses(Address address) async {
    if (address.id != null) {
      return editAddresses(address);
    }

    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.post(addressEndpoint, data: address.toJson());

      return AddressResponse.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return AddressResponse.withError(error['message'], error['error']);
      }
      return AddressResponse.withError(e.message, "Network Error");
    }
  }

  Future<AddressResponse> editAddresses(Address address) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.put(addressEndpoint, data: address.toJson());

      return AddressResponse.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return AddressResponse.withError(error['message'], error['error']);
      }
      return AddressResponse.withError(e.message, "Network Error");
    }
  }
}

class ProductsApiProvider {
  Future<ProductListResponse> myShopProducts() async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(productsEndpoint + '/me');

      ProductListResponse resp = ProductListResponse.fromJson(response.data);

      return resp;
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return ProductListResponse.withError(error['message'], error['error']);
      }
      return ProductListResponse.withError(e.message, "Network Error");
    }
  }

  Future<ProductListResponse> getProducts() async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(productsEndpoint);

      ProductListResponse resp = ProductListResponse.fromJson(response.data);

      return resp;
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return ProductListResponse.withError(error['message'], error['error']);
      }
      return ProductListResponse.withError(e.message, "Network Error");
    }
  }

  Future<ProductListResponse> shopProducts(Vendor vendor) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(productsEndpoint + '/shop/' + vendor.id.toString());

      ProductListResponse resp = ProductListResponse.fromJson(response.data);

      return resp;
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return ProductListResponse.withError(error['message'], error['error']);
      }
      return ProductListResponse.withError(e.message, "Network Error");
    }
  }

  Future<ProductListResponse> shopProductsAdmin(Vendor vendor) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(productsEndpoint + '/admin/' + vendor.id.toString());

      ProductListResponse resp = ProductListResponse.fromJson(response.data);

      return resp;
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return ProductListResponse.withError(error['message'], error['error']);
      }
      return ProductListResponse.withError(e.message, "Network Error");
    }
  }

  Future<ProductListResponse> categoryProducts(Category category) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(productsEndpoint + '/cat/' + category.id.toString());

      ProductListResponse resp = ProductListResponse.fromJson(response.data);
      return resp;
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return ProductListResponse.withError(error['message'], error['error']);
      }
      return ProductListResponse.withError(e.message, "Network Error");
    }
  }

  Future<ProductListResponse> deals() async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(productsEndpoint + '/deals');

      ProductListResponse resp = ProductListResponse.fromJson(response.data);
      return resp;
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return ProductListResponse.withError(error['message'], error['error']);
      }
      return ProductListResponse.withError(e.message, "Network Error");
    }
  }

  Future<ProductListResponse> search(String query) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.post(productsEndpoint + '/search', data: {"query": query});

      ProductListResponse resp = ProductListResponse.fromJson(response.data);
      return resp;
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return ProductListResponse.withError(error['message'], error['error']);
      }
      return ProductListResponse.withError(e.message, "Network Error");
    }
  }

  Future<ProductsResponse> getProduct(Products product) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(productsEndpoint + '/show/' + product.id.toString());

      ProductsResponse resp = ProductsResponse.fromJson(response.data);

      return resp;
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return ProductsResponse.withError(error['message'], error['error']);
      }
      return ProductsResponse.withError(e.message, "Network Error");
    }
  }

  Future<ProductsResponse> saveProduct(Products products) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.post(productsEndpoint,
          data: products.toJson());

      return ProductsResponse.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return ProductsResponse.withError(error['message'], error['error']);
      }
      return ProductsResponse.withError(e.message, "Network Error");
    }
  }

  Future<ProductsResponse> editProduct(Products product) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.put(productsEndpoint, data: product.toJson());

      return ProductsResponse.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return ProductsResponse.withError(error['message'], error['error']);
      }
      return ProductsResponse.withError(e.message, "Network Error");
    }
  }

  Future<ProductsResponse> approveProduct(Products product) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(productsEndpoint + '/a/' + product.id.toString());

      return ProductsResponse.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return ProductsResponse.withError(error['message'], error['error']);
      }
      return ProductsResponse.withError(e.message, "Network Error");
    }
  }

  Future<ProductsResponse> delistProduct(Products product) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(productsEndpoint + '/r/' + product.id.toString());

      return ProductsResponse.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return ProductsResponse.withError(error['message'], error['error']);
      }
      return ProductsResponse.withError(e.message, "Network Error");
    }
  }

  Future<ProductsResponse> deleteProduct(Products product) async {
    final Dio _dio = await HttpClient.http();
    try {
      await _dio.delete(productsEndpoint + '/remove/${product.id}');

      return ProductsResponse(product, "", "");
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return ProductsResponse.withError(error['message'], error['error']);
      }
      return ProductsResponse.withError(e.message, "Network Error");
    }
  }

}

class CartApiProvider {
  Future<CartListResponse> myCart() async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(cartEndpoint);
      // print(response.data.toString());

      CartListResponse resp = CartListResponse.fromJson(response.data);
      return resp;
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return CartListResponse.withError(error['message'], error['error']);
      }
      return CartListResponse.withError(e.message, "Network Error");
    }
  }

  Future<CartResponse> saveCart(Cart cart) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.post(cartEndpoint,
          data: cart.toJson());

      return CartResponse.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return CartResponse.withError(error['message'], error['error']);
      }
      return CartResponse.withError(e.message, "Network Error");
    }
  }

  Future<CartResponse> editCart(Cart cart) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.put(cartEndpoint, data: cart.toJson());

      return CartResponse.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return CartResponse.withError(error['message'], error['error']);
      }
      return CartResponse.withError(e.message, "Network Error");
    }
  }

  Future<CartResponse> deleteCart(Cart cart) async {
    final Dio _dio = await HttpClient.http();
    try {
      await _dio.delete(cartEndpoint + '/remove/${cart.id}');

      return CartResponse(cart, "", "");
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return CartResponse.withError(error['message'], error['error']);
      }
      return CartResponse.withError(e.message, "Network Error");
    }
  }

}

class OrderApiProvider {
  Future<OrderListResponse> myOrders() async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(orderEndpoint);

      OrderListResponse resp = OrderListResponse.fromJson(response.data);

      return resp;
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return OrderListResponse.withError(error['message'], error['error']);
      }
      return OrderListResponse.withError(e.message, "Network Error");
    }
  }

  Future<OrderResponse> payOrder(Orders orders) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(payOrderEndpoint + orders.id.toString());

       return OrderResponse.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return OrderResponse.withError(error['message'], error['error']);
      }
      return OrderResponse.withError(e.message, "Network Error");
    }
  }

  Future<OrderResponse> cancelOrder(Orders orders) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(cancelOrderEndpoint + orders.id.toString());

       return OrderResponse.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return OrderResponse.withError(error['message'], error['error']);
      }
      return OrderResponse.withError(e.message, "Network Error");
    }
  }

  Future<OrderResponse> saveOrder(Orders order) async {
    // try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.post(orderEndpoint,
          data: order.toJson());

      return OrderResponse.fromJson(response.data);
    // } catch (e) {
    //   if (e.response != null) {
    //     Map<String, dynamic> error = json.decode(e.response.toString());
    //     return OrderResponse.withError(error['message'], error['error']);
    //   }
    //   return OrderResponse.withError(e.message, "Network Error");
    // }
  }


}
