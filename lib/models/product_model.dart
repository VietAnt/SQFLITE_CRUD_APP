//*->Mô_hình_lớp_sản_phẩm
import 'package:sqlite_app/models/model.dart';

class ProductModel extends Model {
  static String table = "products";

  //*->gia_tri
  int? id;
  int categoryId;
  String productName;
  String? productDesc;
  double? price;
  String? productPic;

  //*->Contructor
  ProductModel({
    this.id,
    required this.categoryId,
    required this.productName,
    this.productDesc,
    this.price,
    this.productPic,
  });

  //*->Tao_Map
  static ProductModel fromMap(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      productName: json['productName'].toString(),
      categoryId: json['categoryId'],
      productDesc: json['productDesc'].toString(),
      price: json['price'],
      productPic: json['productPic'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'id': id,
      'productName': productName,
      'categoryId': categoryId,
      'productDesc': productDesc,
      'price': price,
      'productPic': productPic
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
