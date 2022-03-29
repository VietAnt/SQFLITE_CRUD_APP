//*->Khởi_tạo_DB_Service
import 'package:sqlite_app/database/db_helper.dart';
import 'package:sqlite_app/models/product_model.dart';

class DBService {
  //*->GetProduct(Lây_Sản_Phẩm)
  Future<List<ProductModel>> getProducts() async {
    await DBHelper.init();

    List<Map<String, dynamic>> products =
        await DBHelper.query(ProductModel.table);

    return products.map((item) => ProductModel.fromMap(item)).toList();
  }

  //*->addProduct(Thêm_Sản_Phẩm)
  Future<bool> addProduct(ProductModel model) async {
    await DBHelper.init();

    int ret = await DBHelper.insert(ProductModel.table, model);

    return ret > 0 ? true : false;
  }

  //*->update(Cập_nhật_sản_phẩm)
  Future<bool> updateProduct(ProductModel model) async {
    await DBHelper.init();

    int ret = await DBHelper.update(ProductModel.table, model);

    return ret > 0 ? true : false;
  }

  //*->delete(Xóa_sản_phẩm)
  Future<bool> deleteProduct(ProductModel model) async {
    await DBHelper.init();

    int ret = await DBHelper.delete(ProductModel.table, model);

    return ret > 0 ? true : false;
  }
}
