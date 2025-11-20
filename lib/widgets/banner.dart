import 'package:carousel_slider/carousel_slider.dart';
import '../provider/banner_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/banner_model.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});


  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

BannerProvider provider = BannerProvider();

List<Banner1> listBanner = [];

class _BannerWidgetState extends State<BannerWidget> {
  @override
  void initState() {
    super.initState();
    // Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BannerProvider>(context, listen: false).fetchBanners();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bannerProvider = Provider.of<BannerProvider>(context);
    final listBanner = bannerProvider.banners;
    if (bannerProvider.isLoading && listBanner.isEmpty) {
      return const SizedBox(height: 180, child: Center(child: CircularProgressIndicator()));
    }
    if (listBanner.isEmpty) {
      return const SizedBox(height: 180);
    }
    return CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 16 / 9,
        autoPlay: true,
        autoPlayCurve: Curves.fastOutSlowIn,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        enlargeCenterPage: true,
        viewportFraction: 0.8,
        enableInfiniteScroll: true,
        height: 180.0,
        initialPage: 0,
      ),
      items: listBanner.map((banner) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              margin: const EdgeInsets.all(6.0),
              width: MediaQuery.of(context).size.width,
              height: 180,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image(image: AssetImage(banner.imgURL), fit: BoxFit.fill),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}