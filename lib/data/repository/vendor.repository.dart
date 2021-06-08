import 'package:bloom/data/entity/personnel.entity.dart';
import 'package:bloom/data/entity/vendor.entity.dart';
import 'package:bloom/data/http/vendor.provider.dart';

class CategoryRepository {
  CategoryApiProvider _apiProvider = CategoryApiProvider();

  Future<CategoryListResponse> getCategories() async {
    CategoryListResponse response = await _apiProvider.getCategories();

    return response;
  }

  Future<CategoryResponse> save(Category category) async {
    CategoryResponse response = await _apiProvider.saveCategory(category);

    return response;
  }

  Future<CategoryResponse> edit(Category category) async {
    CategoryResponse response = await _apiProvider.editCategory(category);

    return response;
  }

  Future<CategoryResponse> delete(Category category) async {
    CategoryResponse response = await _apiProvider.deleteCategory(category);

    return response;
  }

}
class AdsRepository {
  AdsApiProvider _apiProvider = AdsApiProvider();

  Future<AdsListResponse> getAds() async {
    AdsListResponse response = await _apiProvider.index();

    return response;
  }

  Future<AdsListResponse> myAds() async {
    AdsListResponse response = await _apiProvider.myAds();

    return response;
  }

  Future<AdsListResponse> vendorAds(Vendor vendor) async {
    AdsListResponse response = await _apiProvider.vendorAds(vendor);

    return response;
  }

  Future<AdsResponse> save(Ads ads) async {
    AdsResponse response = await _apiProvider.saveAds(ads);

    return response;
  }

  Future<AdsResponse> edit(Ads ads) async {
    AdsResponse response = await _apiProvider.editAds(ads);

    return response;
  }

  Future<AdsResponse> delete(Ads ads) async {
    AdsResponse response = await _apiProvider.deleteAd(ads);

    return response;
  }

}

class AddressRepository {
  AddressApiProvider _apiProvider = AddressApiProvider();

  Future<CountryListResponse> getCountries() async {
    CountryListResponse response = await _apiProvider.getCountries();

    return response;
  }

  Future<AddressResponse> shippingAddress() async {
    AddressResponse response = await _apiProvider.getAddress('shipping');

    return response;
  }

  Future<AddressResponse> save(Address address) async {
    AddressResponse response = await _apiProvider.saveAddresses(address);

    return response;
  }

  Future<AddressResponse> edit(Address address) async {
    AddressResponse response = await _apiProvider.editAddresses(address);

    return response;
  }
}

class CartRepository {
  CartApiProvider _apiProvider = CartApiProvider();

  Future<CartListResponse> myCart() async {
    CartListResponse response = await _apiProvider.myCart();

    return response;
  }

  Future<CartResponse> save(Cart cart) async {
    CartResponse response = await _apiProvider.saveCart(cart);

    return response;
  }

  Future<CartResponse> edit(Cart cart) async {
    CartResponse response = await _apiProvider.editCart(cart);

    return response;
  }

  Future<CartResponse> delete(Cart cart) async {
    CartResponse response = await _apiProvider.deleteCart(cart);

    return response;
  }
}

class OrderRepository {
  OrderApiProvider _apiProvider = OrderApiProvider();

  Future<OrderListResponse> myOrders() async {
    OrderListResponse response = await _apiProvider.myOrders();

    return response;
  }

  Future<OrderResponse> save(Orders order) async {
    OrderResponse response = await _apiProvider.saveOrder(order);

    return response;
  }

  Future<OrderResponse> pay(Orders order) async {
    OrderResponse response = await _apiProvider.payOrder(order);

    return response;
  }

  Future<OrderResponse> cancel(Orders order) async {
    OrderResponse response = await _apiProvider.cancelOrder(order);

    return response;
  }
}

class WishListRepository {
  WishListApiProvider _apiProvider = WishListApiProvider();

  Future<WishListsResponse> myList() async {
    WishListsResponse response = await _apiProvider.myWishList();

    return response;
  }

  Future<bool> add(Products product) async {
    var response = await _apiProvider.addToWishList(product);

    return response;
  }

  Future<bool> remove(Products product) async {
    var response = await _apiProvider.removeWishList(product);

    return response;
  }

  Future<bool> query(Products products) async {
    var response = await _apiProvider.queryWishList(products);

    return response;
  }
}


class VendorRepository {
  VendorApiProvider _apiProvider = VendorApiProvider();

  Future<VendorListResponse> getVendors() async {
    VendorListResponse response = await _apiProvider.getVendors();

    return response;
  }

  Future<VendorResponse> me() async {
    VendorResponse response = await _apiProvider.me();

    return response;
  }

  Future<VendorResponse> save(Vendor vendor) async {
    VendorResponse response = await _apiProvider.saveVendor(vendor);

    return response;
  }

  Future<VendorResponse> edit(Vendor vendor) async {
    VendorResponse response = await _apiProvider.editVendor(vendor);

    return response;
  }

  Future<VendorResponse> approve(Vendor vendor) async {
    VendorResponse response = await _apiProvider.approveVendor(vendor);

    return response;
  }

  Future<VendorResponse> revoke(Vendor vendor) async {
    VendorResponse response = await _apiProvider.revokeVendor(vendor);

    return response;
  }

  Future<VendorResponse> delete(Vendor vendor) async {
    VendorResponse response = await _apiProvider.deleteVendor(vendor);

    return response;
  }

}

class ProductRepository {
  ProductsApiProvider _apiProvider = ProductsApiProvider();

  Future<ProductListResponse> getProducts() async {
    ProductListResponse response = await _apiProvider.getProducts();

    return response;
  }
  
  Future<ProductListResponse> getShopProducts(Vendor vendor) async {
    ProductListResponse response = await _apiProvider.shopProducts(vendor);

    return response;
  }

  Future<ProductListResponse> getShopProductsAdmin(Vendor vendor) async {
    ProductListResponse response = await _apiProvider.shopProductsAdmin(vendor);

    return response;
  }

  Future<ProductListResponse> getCategoryProducts(Category category) async {
    ProductListResponse response = await _apiProvider.categoryProducts(category);

    return response;
  }

  Future<ProductListResponse> getDeals() async {
    ProductListResponse response = await _apiProvider.deals();

    return response;
  }

  Future<ProductListResponse> search(String query) async {
    ProductListResponse response = await _apiProvider.search(query);

    return response;
  }

  Future<ProductsResponse> show(Products product) async {
    ProductsResponse response = await _apiProvider.getProduct(product);

    return response;
  }

  Future<ProductListResponse> me() async {
    ProductListResponse response = await _apiProvider.myShopProducts();

    return response;
  }

  Future<ProductsResponse> save(Products products) async {
    ProductsResponse response = await _apiProvider.saveProduct(products);

    return response;
  }

  Future<ProductsResponse> edit(Products products) async {
    ProductsResponse response = await _apiProvider.editProduct(products);

    return response;
  }

  Future<ProductsResponse> approve(Products products) async {
    ProductsResponse response = await _apiProvider.approveProduct(products);

    return response;
  }

  Future<ProductsResponse> delist(Products products) async {
    ProductsResponse response = await _apiProvider.delistProduct(products);

    return response;
  }

  Future<ProductsResponse> delete(Products products) async {
    ProductsResponse response = await _apiProvider.deleteProduct(products);

    return response;
  }

}
