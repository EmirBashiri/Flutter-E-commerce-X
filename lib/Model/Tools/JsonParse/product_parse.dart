import 'package:hive/hive.dart';

part 'product_parse.g.dart';

@HiveType(typeId: 0)
class ProductEntity {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String price;
  @HiveField(3)
  final String imageUrl;
  @HiveField(4)
  final String productType;
  @HiveField(5)
  final String description;

  ProductEntity(this.id, this.name, this.price, this.imageUrl, this.productType,
      this.description);

  ProductEntity.fromJson(Map<String, dynamic> json)
      : id = json['id']??0,
        name = json['name']??"",
        price = json['price']??"",
        imageUrl = json['image_link']??"",
        productType = json['product_type']??"",
        description = json['description']??"";
}
