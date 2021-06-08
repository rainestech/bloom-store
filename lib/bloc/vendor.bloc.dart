import 'package:bloom/data/entity/personnel.entity.dart';
import 'package:bloom/data/entity/vendor.entity.dart';
import 'package:bloom/data/http/vendor.provider.dart';
import 'package:bloom/data/repository/vendor.repository.dart';
import 'package:rxdart/rxdart.dart';

class VendorBloc {
  final VendorRepository _vendorRepository = VendorRepository();
  final ProductRepository _productRepository = ProductRepository();
  final CategoryRepository _categoryRepository = CategoryRepository();
  final AddressRepository _addressRepository = AddressRepository();
  final CartRepository _cartRepository = CartRepository();
  final OrderRepository _orderRepository = OrderRepository();
  final AdsRepository _adsRepository = AdsRepository();

  final BehaviorSubject<ProductsResponse> _productSubject =
      BehaviorSubject<ProductsResponse>();

  final BehaviorSubject<OrderListResponse> _orderListSubject =
      BehaviorSubject<OrderListResponse>();

  final BehaviorSubject<AddressResponse> _addressSubject =
      BehaviorSubject<AddressResponse>();

  final BehaviorSubject<AddressListResponse> _addressListSubject =
      BehaviorSubject<AddressListResponse>();

  final BehaviorSubject<AdsResponse> _adsSubject =
      BehaviorSubject<AdsResponse>();

  final BehaviorSubject<AdsListResponse> _adsListSubject =
      BehaviorSubject<AdsListResponse>();

  final BehaviorSubject<OrderResponse> _orderSubject =
      BehaviorSubject<OrderResponse>();

  final BehaviorSubject<CartListResponse> _cartListSubject =
      BehaviorSubject<CartListResponse>();

  final BehaviorSubject<CartResponse> _cartSubject =
      BehaviorSubject<CartResponse>();

  final BehaviorSubject<ProductListResponse> _productListSubject =
      BehaviorSubject<ProductListResponse>();

  final BehaviorSubject<CategoryResponse> _categorySubject =
      BehaviorSubject<CategoryResponse>();

  final BehaviorSubject<CategoryListResponse> _categoryListSubject =
      BehaviorSubject<CategoryListResponse>();

  final BehaviorSubject<VendorResponse> _vendorSubject =
      BehaviorSubject<VendorResponse>();

  final BehaviorSubject<CountryListResponse> _countriesSubject =
      BehaviorSubject<CountryListResponse>();

  final BehaviorSubject<VendorListResponse> _vendorListSubject =
      BehaviorSubject<VendorListResponse>();

  Future<VendorResponse> saveVendor(Vendor vendor) async {
    VendorResponse response = await _vendorRepository.save(vendor);
    _vendorSubject.sink.add(response);

    return response;
  }

  Future<VendorResponse> myShop() async {
    VendorResponse response = await _vendorRepository.me();
    _vendorSubject.sink.add(response);

    return response;
  }

  Future<CountryListResponse> getCountries() async {
    CountryListResponse response = await _addressRepository.getCountries();
    _countriesSubject.sink.add(response);

    return response;
  }

  Future<VendorResponse> editVendor(Vendor vendor) async {
    VendorResponse response = await _vendorRepository.edit(vendor);
    _vendorSubject.sink.add(response);

    return response;
  }

  Future<VendorResponse> approveVendor(Vendor vendor) async {
    VendorResponse response = await _vendorRepository.approve(vendor);
    _vendorSubject.sink.add(response);

    return response;
  }

  Future<VendorResponse> revokeVendor(Vendor vendor) async {
    VendorResponse response = await _vendorRepository.revoke(vendor);
    _vendorSubject.sink.add(response);

    return response;
  }

  Future<VendorResponse> deleteVendor(Vendor vendor) async {
    VendorResponse response = await _vendorRepository.delete(vendor);
    _vendorSubject.drain(null);

    if (_vendorListSubject.hasValue) {
      List<Vendor> vendors = _vendorListSubject.value.data;
      if (vendors != null) {
        _vendorListSubject.sink.add(new VendorListResponse(vendors.where((e) => e.id != vendor.id).toList(), "", ""));
      }
    }

    return response;
  }

  Future<VendorListResponse> getVendors() async {
    VendorListResponse response = await _vendorRepository.getVendors();
    _vendorListSubject.sink.add(response);

    return response;
  }

  Future<CategoryResponse> saveCategory(Category cat) async {
    CategoryResponse response = await _categoryRepository.save(cat);
    _categorySubject.sink.add(response);

    return response;
  }

  Future<CategoryResponse> editCategory(Category cat) async {
    CategoryResponse response = await _categoryRepository.edit(cat);
    _categorySubject.sink.add(response);

    return response;
  }

  Future<CategoryResponse> deleteCategory(Category category) async {
    CategoryResponse response = await _categoryRepository.delete(category);
    _categorySubject.drain(null);

    if (_categoryListSubject.hasValue) {
      List<Category> categories = _categoryListSubject.value.data;
      if (categories != null) {
        _categoryListSubject.sink.add(new CategoryListResponse(categories.where((e) => e.id != category.id).toList(), "", ""));
      }
    }

    return response;
  }

  Future<CategoryListResponse> getCategories() async {
    CategoryListResponse response = await _categoryRepository.getCategories();
    _categoryListSubject.sink.add(response);

    return response;
  }

  Future<AdsResponse> saveAds(Ads ads) async {
    AdsResponse response = await _adsRepository.save(ads);
    _adsSubject.sink.add(response);

    return response;
  }

  Future<AdsResponse> editAds(Ads ads) async {
    AdsResponse response = await _adsRepository.edit(ads);
    _adsSubject.sink.add(response);

    return response;
  }

  Future<AdsResponse> deleteAd(Ads ad) async {
    AdsResponse response = await _adsRepository.delete(ad);
    _adsSubject.drain(null);

    if (_adsListSubject.hasValue) {
      List<Ads> ads = _adsListSubject.value.data;
      if (ads != null) {
        _adsListSubject.sink.add(new AdsListResponse(ads.where((e) => e.id != ad.id).toList(), "", ""));
      }
    }

    return response;
  }

  Future<AdsListResponse> getAds() async {
    AdsListResponse response = await _adsRepository.getAds();
    _adsListSubject.sink.add(response);

    return response;
  }

  Future<AdsListResponse> myAds() async {
    AdsListResponse response = await _adsRepository.myAds();
    _adsListSubject.sink.add(response);

    return response;
  }

  Future<AdsListResponse> vendorAds(Vendor vendor) async {
    AdsListResponse response = await _adsRepository.vendorAds(vendor);
    _adsListSubject.sink.add(response);

    return response;
  }

  Future<ProductsResponse> saveProduct(Products product) async {
    ProductsResponse response = await _productRepository.save(product);
    _productSubject.sink.add(response);

    return response;
  }

  Future<ProductsResponse> editProduct(Products product) async {
    ProductsResponse response = await _productRepository.edit(product);
    _productSubject.sink.add(response);

    return response;
  }

  Future<ProductsResponse> delistProduct(Products product) async {
    ProductsResponse response = await _productRepository.delist(product);
    _productSubject.sink.add(response);

    return response;
  }

  Future<ProductsResponse> approveProduct(Products product) async {
    ProductsResponse response = await _productRepository.approve(product);
    _productSubject.sink.add(response);

    return response;
  }

  Future<ProductsResponse> deleteProduct(Products product) async {
    ProductsResponse response = await _productRepository.delete(product);
    _productSubject.drain(null);

    if (_productListSubject.hasValue) {
      List<Products> products = _productListSubject.value.data;
      if (products != null) {
        _productListSubject.sink.add(new ProductListResponse(products.where((e) => e.id != product.id).toList(), "", ""));
      }
    }

    return response;
  }

  Future<ProductListResponse> getProducts() async {
    ProductListResponse response = await _productRepository.getProducts();
    _productListSubject.sink.add(response);

    return response;
  }

  Future<ProductListResponse> getMyProducts() async {
    ProductListResponse response = await _productRepository.me();
    _productListSubject.sink.add(response);

    return response;
  }

  Future<ProductListResponse> getShopProducts(Vendor vendor) async {
    ProductListResponse response = await _productRepository.getShopProducts(vendor);
    _productListSubject.sink.add(response);

    return response;
  }

  Future<ProductListResponse> getShopProductsAdmin(Vendor vendor) async {
    ProductListResponse response = await _productRepository.getShopProductsAdmin(vendor);
    _productListSubject.sink.add(response);

    return response;
  }

  Future<ProductListResponse> getCategoryProducts(Category category) async {
    ProductListResponse response = await _productRepository.getCategoryProducts(category);
    _productListSubject.sink.add(response);

    return response;
  }

  Future<ProductListResponse> getDeals() async {
    ProductListResponse response = await _productRepository.getDeals();
    _productListSubject.sink.add(response);

    return response;
  }

  Future<ProductListResponse> search(String query) async {
    ProductListResponse response = await _productRepository.search(query);
    return response;
  }

  Future<AddressResponse> saveAddress(Address address) async {
    AddressResponse response = await _addressRepository.save(address);
    !_isDisposed ? _addressSubject.sink.add(response) : null;

    return response;
  }

  Future<AddressResponse> editAddress(Address address) async {
    AddressResponse response = await _addressRepository.edit(address);
    !_isDisposed ? _addressSubject.sink.add(response) : null;

    return response;
  }

  Future<AddressResponse> getShippingAddress() async {
    AddressResponse response = await _addressRepository.shippingAddress();
    !_isDisposed ? _addressSubject.sink.add(response) : null;

    return response;
  }

  Future<CartListResponse> myCart() async {
    CartListResponse response = await _cartRepository.myCart();
    !_isDisposed ? _cartListSubject.sink.add(response) : null;

    return response;
  }

  Future<CartResponse> saveCart(Cart cart) async {
    CartResponse response = await _cartRepository.save(cart);
    !_isDisposed ? _cartSubject.sink.add(response) : null;

    return response;
  }

  Future<CartResponse> editCart(Cart cart) async {
    CartResponse response = await _cartRepository.edit(cart);
    !_isDisposed ? _cartSubject.sink.add(response) : null;

    return response;
  }

  Future<CartResponse> deleteCart(Cart cart) async {
    CartResponse response = await _cartRepository.delete(cart);
    !_isDisposed ? _cartSubject.sink.add(null) : null;

    return response;
  }

  Future<OrderListResponse> myOrders() async {
    OrderListResponse response = await _orderRepository.myOrders();
    !_isDisposed ? _orderListSubject.sink.add(response) : null;

    return response;
  }

  Future<OrderResponse> saveOrder(Orders order) async {
    OrderResponse response = await _orderRepository.save(order);
    !_isDisposed ? _orderSubject.sink.add(response) : null;

    return response;
  }

  Future<OrderResponse> payOrder(Orders order) async {
    OrderResponse response = await _orderRepository.pay(order);
    !_isDisposed ? _orderSubject.sink.add(response) : null;

    return response;
  }

  Future<OrderResponse> cancelOrder(Orders order) async {
    OrderResponse response = await _orderRepository.cancel(order);
    !_isDisposed ? _orderSubject.sink.add(response) : null;

    return response;
  }

  bool _isDisposed = false;

  dispose() {
    _vendorSubject.close();
    _vendorListSubject.close();
    _categorySubject.close();
    _categoryListSubject.close();
    _productListSubject.close();
    _productSubject.close();
    _cartListSubject.close();
    _cartSubject.close();
    _orderListSubject.close();
    _orderSubject.close();
    _addressListSubject.close();
    _addressSubject.close();
    _adsListSubject.close();
    _adsSubject.close();
    _countriesSubject.close();
    _isDisposed = true;
  }

  void drainStream() {
    _vendorSubject.isClosed ? null : _vendorSubject.drain(null);
    _vendorListSubject.isClosed ? null : _vendorListSubject.drain(null);
    _categorySubject.isClosed ? null : _categorySubject.drain(null);
    _categoryListSubject.isClosed ? null : _categoryListSubject.drain(null);
    _productListSubject.isClosed ? null : _productListSubject.drain(null);
    _productSubject.isClosed ? null : _productSubject.drain(null);
    _cartListSubject.isClosed ? null : _cartListSubject.drain(null);
    _cartSubject.isClosed ? null : _cartSubject.drain(null);
    _orderListSubject.isClosed ? null : _orderListSubject.drain(null);
    _orderSubject.isClosed ? null : _orderSubject.drain(null);
    _addressListSubject.isClosed ? null : _addressListSubject.drain(null);
    _addressSubject.isClosed ? null : _addressSubject.drain(null);
    _adsListSubject.isClosed ? null : _adsListSubject.drain(null);
    _adsSubject.isClosed ? null : _adsSubject.drain(null);
    _countriesSubject.isClosed ? null : _countriesSubject.drain(null);
  }

  BehaviorSubject<VendorResponse> get vendorSubject => _vendorSubject;
  BehaviorSubject<VendorListResponse> get vendorListSubject => _vendorListSubject;
  BehaviorSubject<ProductsResponse> get productSubject => _productSubject;
  BehaviorSubject<ProductListResponse> get productListSubject => _productListSubject;
  BehaviorSubject<CartResponse> get cartSubject => _cartSubject;
  BehaviorSubject<CartListResponse> get cartListSubject => _cartListSubject;
  BehaviorSubject<OrderResponse> get orderSubject => _orderSubject;
  BehaviorSubject<OrderListResponse> get orderListSubject => _orderListSubject;
  BehaviorSubject<CategoryResponse> get categorySubject => _categorySubject;
  BehaviorSubject<CategoryListResponse> get categoryListSubject => _categoryListSubject;
  BehaviorSubject<AddressResponse> get addressSubject => _addressSubject;
  BehaviorSubject<AddressListResponse> get addressListSubject => _addressListSubject;
  BehaviorSubject<AdsResponse> get adsSubject => _adsSubject;
  BehaviorSubject<AdsListResponse> get adsListSubject => _adsListSubject;
  BehaviorSubject<CountryListResponse> get countriesSubject => _countriesSubject;

}

final vendorBloc = VendorBloc();
