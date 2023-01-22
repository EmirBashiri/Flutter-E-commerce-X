import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/duplicate_controller.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/profile_controller.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Constant/const.dart';
import 'package:flutter_application_ecommerce/Model/Widget/widget.dart';
import 'package:flutter_application_ecommerce/View/ProfileScreen/FavoriteScreen/bloc/favorite_bloc.dart';
import 'package:flutter_application_ecommerce/ViewModel/Profile/profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  FavoriteBloc? favoriteBloc;
  @override
  void dispose() {
    favoriteBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final duplicateController = Get.find<DuplicateController>();
    final profileController = Get.find<ProfileController>();
    final ProfileFunctions profileFunctions =
        profileController.profileFunctions;
    final textStyle = duplicateController.textStyle;
    final colors = duplicateController.colors;
    return BlocProvider(
      create: (context) {
        final bloc = FavoriteBloc();
        bloc.add(FavoriteStart());
        favoriteBloc = bloc;
        return bloc;
      },
      child: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteSuccess) {
            return DuplicateTemplate(
              title: "Favorite Screen",
              colors: colors,
              textStyle: textStyle,
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 40),
                physics: duplicateController.uiDuplicate.defaultScroll,
                itemCount: state.productList.length,
                itemBuilder: (context, index) {
                  final product = state.productList[index];
                  return HorizontalProductView(
                      colors: colors,
                      product: product,
                      textStyle: textStyle,
                      widget: CupertinoButton(
                        child: Icon(
                          Icons.delete,
                          color: colors.whiteColor,
                        ),
                        onPressed: () async {
                          bool isDeleted = await profileFunctions
                              .removeFavorite(productEntity: product);
                          if (isDeleted) {
                            favoriteBloc!.add(FavoriteStart());
                          }
                        },
                      ),
                      margin: const EdgeInsets.only(
                          top: 15, right: 8, left: 8, bottom: 15));
                },
              ),
            );
          } else if (state is FavoriteEmpty) {
            return EmptyScreen(
                colors: colors,
                textStyle: textStyle,
                title: "Favorite Screen",
                content: "you're favorite list is empty",
                lottieName: emptyListLottie);
          }
          return Container();
        },
      ),
    );
  }
}
