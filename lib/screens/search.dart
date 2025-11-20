
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:furniture_app_project/models/filter_model.dart';
import 'package:furniture_app_project/models/history_search_model.dart';
import 'package:furniture_app_project/provider/category_provider.dart';
import 'package:furniture_app_project/provider/filter_provider.dart';
import 'package:furniture_app_project/screens/product_detail.dart';
import '../models/category_model.dart';
import '../provider/product_provider.dart';
import '../services/DatabaseHandler.dart';
import '../widgets/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import '../models/favorite_model.dart';
import '../models/product_model.dart';
import 'cart.dart';
import 'favorite.dart';
import 'package:badges/badges.dart' as badges;

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

ProductProvider productProvider = ProductProvider();
CategoryProvider categoryProvider = CategoryProvider();
FilterProvider filterProvider = FilterProvider();

final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

class _SearchState extends State<Search> {
  final TextEditingController searchQuery = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String searchString = "";

  Map<String,String> listColor = {};
  List<String> listMaterial = [];
  List<String> listFeature = [];
  List<String> listSortBy = [];
  List<String> listPrice = [];
  List<String> listSeries = [];


  String priceSort = 'No selected';
  String categorySort = 'No selected';
  String categoryItemSort = 'No selected';
  String listCategory = "";

  RangeValues _currentRangeValues = const RangeValues(0,1000);
  List<double> valuesPrice = [0, 1000];


  late DatabaseHandler handle;
  List<Product> searchedProducts = [];
  List<HistorySearch> listHis = [];
  List<FilterModel> filterList = [];
  List<String> autoCompleteText = [];

  late double height, width;
  late List<Favorite> listFavorite;
  late List<Cart> listCart;
  late Favorite favorite;

  int page = 1;
  bool entering = true;
  bool searching = false;

  @override
  void initState() {
    super.initState();
    handle = DatabaseHandler();
  }


  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of<ProductProvider>(context);
    categoryProvider = Provider.of<CategoryProvider>(context);
    filterProvider = Provider.of<FilterProvider>(context);
    filterProvider.getListFilter();
    filterList = filterProvider.getFilter;


    listCart = handle.getListCart;
    listFavorite = handle.getListFavorite;
    listHis = handle.getListHistorySearch;
    autoCompleteText = getAutoCompleteInput(
        productProvider.getListProduct, categoryProvider.getListCategory);

    if (page == 1) {
      return Scaffold(
        key: key,
        backgroundColor: const Color(0xfff2f9fe),
        appBar: page == 1
            ? AppBar(
                automaticallyImplyLeading: true,
                centerTitle: true,
                iconTheme: const IconThemeData(
                  color: Colors.black,
                ),
                title: const AutoSizeText(
                  'Search',
                  maxFontSize: 17,
                  minFontSize: 12,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                actions: [
                  badges.Badge(
                    showBadge: listFavorite.isNotEmpty,
                    position: badges.BadgePosition.topEnd(top: 10, end: 5),
                    badgeContent: Text(
                      listFavorite.length.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    child: IconButton(
                        icon: const Icon(
                          Icons.favorite_border_outlined,
                          color: Color(0xff80221e),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const FavoritePage()));
                        }),
                  ),
                  badges.Badge(
                    position: badges.BadgePosition.topEnd(top: 10, end: 5),
                    showBadge: listCart.isNotEmpty,
                    badgeContent: Text(
                      listCart.length.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    child: IconButton(
                        icon: const Icon(
                          Icons.shopping_bag_outlined,
                          color: Color(0xff80221e),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CartPage()));
                        }),
                  ),
                ],
              )
            : null,
        body: getSearchResult(),
        bottomNavigationBar: getFooter(1, context),
      );
    } else if (page == 2) {
      return Scaffold(
        body: getFilter(),
        bottomNavigationBar: getFooterSearch(),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          title: const AutoSizeText(
            'Search',
            maxFontSize: 17,
            minFontSize: 12,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: [
            badges.Badge(
              showBadge: listFavorite.isNotEmpty,
              position: badges.BadgePosition.topEnd(top: 10, end: 5),
              badgeContent: Text(
                listFavorite.length.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              child: IconButton(
                  icon: const Icon(
                    Icons.favorite_border_outlined,
                    color: Color(0xff80221e),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FavoritePage()));
                  }),
            ),
            badges.Badge(
              position: badges.BadgePosition.topEnd(top: 10, end: 5),
              showBadge: listCart.isNotEmpty,
              badgeContent: Text(
                listCart.length.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              child: IconButton(
                  icon: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Color(0xff80221e),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CartPage()));
                  }),
            ),
          ],
        ),
        body: getProductPage(),
        bottomNavigationBar: getFooter(1, context),
      );
    }
  }

  Widget getSearchResult() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Show Search bar
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    width: MediaQuery.of(context).size.width - 80,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                            //color: Color.fromRGBO(179, 213, 242, 0.2),
                            color: Color(0xffe3eaef),
                            spreadRadius: 0.06,
                            blurRadius: 24,
                            offset: Offset(12, 12)),
                        BoxShadow(
                            //color: Color.fromRGBO(179, 213, 242, 0.2),
                            color: Color(0xffffffff),
                            spreadRadius: 0.06,
                            blurRadius: 24,
                            offset: Offset(-12, -12)),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.search_rounded,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: MediaQuery.of(context).size.width / 2,
                          child: getRawAutocompleteTextField(),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                  onTap: () {
                    setState(() {
                      page = 2;
                      //print(2);
                    });
                  },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xff81221e),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            //color: Color.fromRGBO(179, 213, 242, 0.2),
                              color: const Color(0xff81221e).withOpacity(0.3),
                              spreadRadius: 0.06,
                              blurRadius: 24,
                              offset: const Offset(12, 12)),
                          const BoxShadow(
                            //color: Color.fromRGBO(179, 213, 242, 0.2),
                              color: Color(0xffffffff),
                              spreadRadius: 0.06,
                              blurRadius: 24,
                              offset: Offset(-12, -12)),
                        ],
                      ),
                      child: const Icon(Icons.tune),
                    ),
                  ),
                ],
              ),
              // Show History Search
              Visibility(
                visible: entering && listHis.isNotEmpty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "Recent Searches",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 30 * 3,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemExtent: 30,
                          itemCount: 3,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  searchString = listHis[index].name;
                                });
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.schedule,
                                    color: Colors.grey,
                                    size: 25,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    listHis[index].name,
                                    style: const TextStyle(fontSize: 17),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
              // Show Popular Search
              Visibility(
                visible: entering && filterList.isNotEmpty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "Popular searches",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: filterList.isNotEmpty
                          ? Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              runAlignment: WrapAlignment.spaceAround,
                              spacing: 10,
                              runSpacing: 10,
                              direction: Axis.horizontal,
                              children: filterList[0].popularSearch.map((e) {
                                return TextButton(
                                  onPressed: () {
                                    setState(() {
                                      searchString = e;
                                      page = 3;
                                      searchQuery.text = e;
                                      searchedProducts = getProductByFilter(productProvider.getListProduct, setFilter(), searchString);
                                    });
                                  },
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.only(
                                            top: 10,
                                            right: 15,
                                            left: 15,
                                            bottom: 10)),
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xffe07464)),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        //side: const BorderSide(width: 0, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    e,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      color: Color(0xff81221e),
                                    ),
                                  ),
                                );
                              }).toList(),
                            )
                          : const Center(),
                    ),
                  ],
                ),
              ),
              // Show Category list
              Visibility(
                visible: entering,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "Category's",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Wrap(
                        alignment: WrapAlignment.spaceAround,
                        runAlignment: WrapAlignment.spaceAround,
                        spacing: 5,
                        runSpacing: 20,
                        direction: Axis.horizontal,
                        children: categoryProvider.getListCategoryItem.map((e) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                page = 3;
                                listCategory = e.name;
                                searchedProducts = getProductByFilter(productProvider.getListProduct, setFilter(), searchString);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    //color: Color.fromRGBO(179, 213, 242, 0.2),
                                      color: Color(0xffe3eaef),
                                      spreadRadius: 0.06,
                                      blurRadius: 12,
                                      offset: Offset(6, 6)),
                                  BoxShadow(
                                    //color: Color.fromRGBO(179, 213, 242, 0.2),
                                      color: Color(0xffffffff),
                                      spreadRadius: 0.06,
                                      blurRadius: 12,
                                      offset: Offset(-6, -6)),
                                ],
                              ),
                              width: 100,
                              height: 120,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Image(
                                    image: AssetImage(e.img),
                                    width: 70,
                                    height: 70,
                                  ),
                                  Flexible(
                                    child: Text(
                                      e.name,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getFilter() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      page = 1;
                    });
                    //searchedProducts = getProductByFilter(productProvider.getListProduct, setFilter(), searchString);
                  },
                  icon: const Icon(Icons.close , color: Color(0xff81221e),)),
              const SizedBox(height: 20,),

              // Filter price
              const Text(
                "Price",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 20,),
              SliderTheme(
                data: const SliderThemeData(
                  valueIndicatorColor: Color(0xff680108),
                  showValueIndicator: ShowValueIndicator.always,
                ),
                child: RangeSlider(
                inactiveColor: const Color(0xff680108).withOpacity(0.5),
                activeColor: const Color(0xff680108),
                values: _currentRangeValues,
                min: double.parse(filterList[0].priceRange.values.elementAt(1).toString()),
                max: double.parse(filterList[0].priceRange.values.elementAt(0).toString()),
                labels: RangeLabels(
                  "\$ ${_currentRangeValues.start.round()}",
                  "\$ ${_currentRangeValues.end.round()}",
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    _currentRangeValues = values;
                    valuesPrice = [values.start , values.end];
                  });
                },
              ),),

              // Filter material
              const Text(
                "Material",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 20,),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                runAlignment: WrapAlignment.spaceBetween,
                spacing: 5,
                children: filterList[0].material.map((e) {
                  return FilterChip(
                    backgroundColor: const Color(0xff81221e).withOpacity(0.2),
                    labelPadding: const EdgeInsets.all(5),
                    selected: checkMaterialInList(listMaterial, e),
                    selectedColor: const Color(0xff680108),
                    showCheckmark: false,
                    label: Text(e , style: TextStyle(
                      color: checkMaterialInList(listMaterial, e) ? Colors.white :  const Color(0xff81221e),
                      fontSize: 18
                    ),),
                    onSelected: (bool value) {
                      setState(() {
                        if(checkMaterialInList(listMaterial, e)) {
                          listMaterial.remove(e);
                        }
                        else {
                          listMaterial.add(e);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20,),

              // Filter Feature
              const Text(
                "Feature",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 20,),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                runAlignment: WrapAlignment.spaceBetween,
                spacing: 5,
                children: filterList[0].feature.map((e) {
                  return FilterChip(
                    backgroundColor: const Color(0xff81221e).withOpacity(0.2),
                    labelPadding: const EdgeInsets.all(5),
                    selected: checkMaterialInList(listFeature, e),
                    selectedColor: const Color(0xff680108),
                    showCheckmark: false,
                    label: Text(e , style: TextStyle(
                        color: checkMaterialInList(listFeature, e) ? Colors.white :  const Color(0xff81221e),
                        fontSize: 18
                    ),),
                    onSelected: (bool value) {
                      setState(() {
                        if(checkMaterialInList(listFeature, e)) {
                          listFeature.remove(e);
                        }
                        else {
                          listFeature.add(e);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20,),

              // Filter Color
              const Text(
                "Color",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 20,),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                runAlignment: WrapAlignment.spaceBetween,
                spacing: 10,
                runSpacing: 10,
                children: filterList[0].color.entries.map((e) {
                  return Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      color: HexColor.fromHex(e.value),
                    ),
                    child: FilterChip(
                      elevation: 0,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
                     backgroundColor: HexColor.fromHex(e.value),
                      selected: listColor.containsKey(e.key) ,
                      selectedColor: HexColor.fromHex(e.value),
                      checkmarkColor: Colors.white,
                      showCheckmark: true,
                      padding: const EdgeInsets.all(0),
                      label: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(25)),
                          color: HexColor.fromHex(e.value),
                        ),
                        child: const Text(''),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onSelected: (bool value) {
                        setState(() {
                          if(listColor.containsKey(e.key)) {
                            listColor.remove(e.key);
                          }
                          else {
                            listColor[e.key] = e.value;
                          }
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Filter Sort by
              const Text(
                "Sort by",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 20,),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                runAlignment: WrapAlignment.spaceBetween,
                spacing: 5,
                children: filterList[0].sortBy.map((e) {
                  return InputChip(
                    backgroundColor: const Color(0xff81221e).withOpacity(0.2),
                    labelPadding: const EdgeInsets.all(5),
                    selected: checkMaterialInList(listSortBy, e),
                    selectedColor: const Color(0xff680108),
                    showCheckmark: false,
                    label: Text(e , style: TextStyle(
                        color: checkMaterialInList(listSortBy, e) ? Colors.white :  const Color(0xff81221e),
                        fontSize: 18
                    ),),
                    onSelected: (bool value) {
                      setState(() {
                        if(checkMaterialInList(listSortBy, e)) {
                          listSortBy.remove(e);
                        }
                        else {
                          listSortBy.clear();
                          listSortBy.add(e);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20,),

              // Filter series by
              const Text(
                "Series",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 20,),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                runAlignment: WrapAlignment.spaceBetween,
                spacing: 5,
                children: filterList[0].series.map((e) {
                  return InputChip(
                    backgroundColor: const Color(0xff81221e).withOpacity(0.2),
                    labelPadding: const EdgeInsets.all(5),
                    selected: checkMaterialInList(listSeries, e),
                    selectedColor: const Color(0xff680108),
                    showCheckmark: false,
                    label: Text(e , style: TextStyle(
                        color: checkMaterialInList(listSeries, e) ? Colors.white :  const Color(0xff81221e),
                        fontSize: 18
                    ),),
                    onSelected: (bool value) {
                      setState(() {
                        if(checkMaterialInList(listSeries, e)) {
                          listSeries.remove(e);
                        }
                        else {
                          listSeries.clear();
                          listSeries.add(e);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20,),

              // Filter Price Sort
              const Text(
                "Price sort",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 20,),
              getDropDownButton(),

              // Filter Category
              const Text(
                "Category's",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 20,),
              getDropDownButtonCategory(),
              const SizedBox(height: 100,),
            ],
          ),
        ),
      ),
    );
  }

  Widget getRawAutocompleteTextField() {
    //print(getAutoCompleteInput(productProvider.getListProduct, categoryProvider.getListCategory).length);
    return RawAutocomplete(
      textEditingController: searchQuery,
      focusNode: _focusNode,
      onSelected: (String selectedOption) {
        setState(() {
          searchString = selectedOption;
        });
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return TextField(
          autofocus: false,
          focusNode: focusNode,
          controller: textEditingController,
          onChanged: (value) {
            //onFieldSubmitted();
          },
          onSubmitted: (String value) {
            setState(() {
              searchString = value;
              searchQuery.text = value;
              page = 3;
              searchedProducts = getProductByFilter(
                  productProvider.getListProduct, setFilter(), searchString);
            });
          },
          style: const TextStyle(
              // letterSpacing: 1,
              decoration: TextDecoration.none,
              decorationThickness: 0,
              fontSize: 15,
              color: Color(0xff81221e),
              fontWeight: FontWeight.bold),
          cursorColor: const Color(0xff410000),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
            hintText: "Search ...",
          ),
        );
      },
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return autoCompleteText.where((String option) {
          return option.trim().toLowerCase().contains(textEditingValue.text.trim().toLowerCase());
        });
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
        return Container(
          alignment: Alignment.topLeft,
          margin: const EdgeInsets.only(top: 20),
          child: Material(
            elevation: 4.0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              width: MediaQuery.of(context).size.width / 1.5,
              height: 200.0,
              child: ListView.builder(
                padding: const EdgeInsets.all(5.0),
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        searchString = option;
                        page = 3;
                        searchedProducts = getProductByFilter(
                            productProvider.getListProduct, setFilter(), searchString);
                      });
                    },
                    child: ListTile(
                      title: Text(option),
                      leading: const Icon(Icons.search_outlined),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getFilterChipForResult() {
    return Container(
        margin: const EdgeInsets.only(left: 0,right: 0 , top: 20),
        height: 120,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: 5,
            direction: Axis.vertical,
            children: filterChipList(setFilter()).values.map((e) {
              return Wrap(
                spacing: 5,
                children: e.map((ele) {
                  return InputChip(
                    backgroundColor: const Color(0xff7eca8f),
                    padding: const EdgeInsets.only(top: 10,bottom: 10),
                    label: Text(ele , style: const TextStyle(
                        fontSize: 18,
                      color: Color(0xff10431c),
                    ),),
                    deleteIcon: const Icon(Icons.delete),
                    onPressed: () {
                    },
                  );
                }).toList(),
              );
            }).toList(),
          ),
        )
    );
  }

  Widget getProductPage() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Show Search bar
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    width: MediaQuery.of(context).size.width - 80,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          //color: Color.fromRGBO(179, 213, 242, 0.2),
                            color: Color(0xffe3eaef),
                            spreadRadius: 0.06,
                            blurRadius: 24,
                            offset: Offset(12, 12)),
                        BoxShadow(
                          //color: Color.fromRGBO(179, 213, 242, 0.2),
                            color: Color(0xffffffff),
                            spreadRadius: 0.06,
                            blurRadius: 24,
                            offset: Offset(-12, -12)),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.search_rounded,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: MediaQuery.of(context).size.width / 2,
                          child: getRawAutocompleteTextField(),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        page = 2;
                      });
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xff81221e),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            //color: Color.fromRGBO(179, 213, 242, 0.2),
                              color: const Color(0xff81221e).withOpacity(0.3),
                              spreadRadius: 0.06,
                              blurRadius: 24,
                              offset: const Offset(12, 12)),
                          const BoxShadow(
                            //color: Color.fromRGBO(179, 213, 242, 0.2),
                              color: Color(0xffffffff),
                              spreadRadius: 0.06,
                              blurRadius: 24,
                              offset: Offset(-12, -12)),
                        ],
                      ),
                      child: const Icon(Icons.tune),
                    ),
                  ),
                ],
              ),
              // Show Filter Chip
              getFilterChipForResult(),
              getProductList(),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget getProductList() {
    if(searchedProducts.isNotEmpty) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: searchedProducts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 0.6,
        ),
        itemBuilder: (BuildContext context, int index) => getProductCard(searchedProducts[index]),
      );
    }
    else {
      return Center(
        child: Column(
          children: [
            const Image(image: AssetImage("assets/icons/empty.png")),
            Text('No search result for $searchString' , style: const TextStyle(
              fontSize: 20,
            ),),
          ],
        ),
      );
    }
  }

  Widget getFooterSearch() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 4,
        ),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        color: Colors.white.withOpacity(0.5),
      ),
      child: Row(
        children: [
          Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 10, left: 30),
                width: 200,
                height: 50,
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      listSeries = [];
                      listCategory = "";
                      listSortBy = [];
                      listFeature = [];
                      listColor = {};
                      listPrice = [];
                      listMaterial = [];
                      priceSort = 'No selected';
                      categorySort = "No selected";
                      _currentRangeValues = const RangeValues(0,1000);
                      valuesPrice = [0,1000];
                    });
                  },
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      color: Color(0xff81221e),
                      fontSize: 22,
                    ),
                  ),
                ),
              )),
          Expanded(
              child: Container(
                width: 200,
                height: 50,
                margin: const EdgeInsets.only(bottom: 10, right: 30),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  color: Color(0xffe5665a),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(179, 213, 242, 1),
                      spreadRadius: 0.3,
                      offset: Offset(5, 5),
                      blurRadius: 10,
                    ),
                    BoxShadow(
                      color: Color(0xffffffff),
                      spreadRadius: 0.3,
                      offset: Offset(-5, -5),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        page = 3;
                        searchedProducts = getProductByFilter(productProvider.getListProduct, setFilter(), searchString);
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        SizedBox(
                          width: 0,
                        ),
                        Text(
                          "Add Filter",
                          style: TextStyle(
                            color: Color(0xffffffff),
                            fontSize: 22,
                          ),
                        ),
                        SizedBox(
                          width: 0,
                        ),
                      ],
                    )),
              )),
        ],
      ),
    );
  }

  Widget getDropDownButton() {
    if (filterList[0].price.isNotEmpty) {
      List<String> newLIst = ["No selected"];
      newLIst.addAll(filterList[0].price);

      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  alignment: Alignment.center,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: Colors.transparent,
                    border: Border.all(width: 1, color: Colors.grey),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      menuMaxHeight: MediaQuery.of(context).size.height / 2,
                      isExpanded: true,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      dropdownColor: const Color(0xfff2f9fe),
                      value: priceSort,
                      items: newLIst.map((e) {
                        return DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          if(value != newLIst[0]) {
                            listPrice.clear();
                            listPrice.add(value!);
                            priceSort = value;
                          }
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget getDropDownButtonCategory() {
    if (categoryProvider.getListCategory.isNotEmpty) {
      List<String> newLIst = ["No selected"];

      for (var element in categoryProvider.getListCategory) {
        newLIst.add(element.name);
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  alignment: Alignment.center,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: Colors.transparent,
                    border: Border.all(width: 1, color: Colors.grey),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      menuMaxHeight: MediaQuery.of(context).size.height / 2,
                      isExpanded: true,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      dropdownColor: const Color(0xfff2f9fe),
                      value: categorySort,
                      items: newLIst.map((e) {
                        return DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          categorySort = value!;
                          //print(value);
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          getExpandItem(categorySort, newLIst),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget getExpandItem(String text , List<String> newLIst) {
    if(text != 'No selected') {
      int index = newLIst.indexOf(text);
      List<String> cateList = ['No selected'];
      for (var element in categoryProvider.getListCategory[index-1].itemList) {
        cateList.add(element.name);
      }
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              alignment: Alignment.center,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: Colors.transparent,
                border: Border.all(width: 1, color: Colors.grey),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  menuMaxHeight: MediaQuery.of(context).size.height / 2,
                  isExpanded: true,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  dropdownColor: const Color(0xfff2f9fe),
                  value: categoryItemSort,
                  items: cateList.map((e) {
                    return DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      if(value!= cateList[0]) {
                        listCategory = value!;
                        categoryItemSort = value;
                      }
                      //print(listCategory);
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    }
    return Container();
  }

  Widget getProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                ProductDetailPage(productID: product,)));
      },
      child: Stack(
        children: [
          // img
          Container(
            width: 200,
            height: 170,
            padding: const EdgeInsets.all(10),
            child: Hero(
              tag: product.id,
              child: FadeInImage(
                image: AssetImage(product.img),
                fadeInDuration: const Duration(milliseconds: 2000),
                fit: BoxFit.contain,
                placeholder: const AssetImage("assets/icons/spinner170.gif"),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration (
              color: Colors.white,
            ),
            margin: const EdgeInsets.only(top: 170),
            padding: const EdgeInsets.all(5),
            height: 280,
            alignment: Alignment.bottomCenter,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // name product
                        AutoSizeText(
                          product.name,
                          maxFontSize: 18,
                          minFontSize: 12,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        // title product
                        Text(
                          product.title,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: "Roboto",
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                              overflow: TextOverflow.ellipsis
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),

                        // Rate
                        RatingBar.builder(
                          ignoreGestures: true,
                          initialRating: product.review,
                          itemSize: 15,
                          minRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          unratedColor: Colors.grey,
                          itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            //print(rating);
                          },
                        ),

                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            AutoSizeText(
                              "(Sold ${product.sellest.toStringAsFixed(0)})",
                              maxFontSize: 12,
                              minFontSize: 12,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {

                          Cart cart = Cart(
                              imgProduct: product.img,
                              nameProduct: product.name,
                              color: product.productItemList[0].color.keys.elementAt(0),
                              quantity: 1,
                              idProduct: product.productItemList[0].id,
                              price: product.currentPrice
                          );

                          handle.insertCart(cart);
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1,color: const Color(0xff81220e)),
                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                        ),

                        child: const Icon(Icons.shopping_cart , color: Color(0xff81220e),size: 25,),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    getPriceDecor(product),
                  ],
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 250),
            height: 15,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: product.productItemList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: HexColor.fromHex(product.productItemList[index].color.values.elementAt(0)),
                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                      const SizedBox(width: 5,)
                    ],
                  );
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  getProductTagNew(product),
                  getProductTagDiscount(product),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: getIconFavorite(
                        product.id, listFavorite, product),
                    onPressed: () {
                      setState(() {
                        var favorite = Favorite(
                          imgProduct: product.img,
                          nameProduct: product.name,
                          idProduct: product.id,
                          price: product.currentPrice,
                        );

                        handle.insertFavorite(favorite);
                      });
                    },
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget getPriceDecor(Product product) {
    if(product.currentPrice != product.rootPrice) {
      return Column(
        children: [
          AutoSizeText(
            getDecorPrice(product.rootPrice),
            maxFontSize: 12,
            minFontSize: 12,
            textAlign: TextAlign.start,
            style: const TextStyle(
              decoration: TextDecoration.lineThrough,
              color: Colors.grey,
              fontFamily: "Roboto",
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5,),
          AutoSizeText(
            getDecorPrice(product.currentPrice),
            maxFontSize: 15,
            minFontSize: 12,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: Color(0xff80221e),
              fontFamily: "Roboto",
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }
    else {
      return AutoSizeText(
        getDecorPrice(product.currentPrice),
        maxFontSize: 15,
        minFontSize: 12,
        textAlign: TextAlign.start,
        style: const TextStyle(
          color: Color(0xff80221e),
          fontFamily: "Roboto",
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  Widget getProductTagNew(Product product) {
    if(checkProductNew(product.timestamp) <= 90) {
      return Container(
        margin: const EdgeInsets.only(left: 5),
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: const Image(image: AssetImage("assets/icons/new.png"),fit: BoxFit.fill,),
      );
    }
    else {
      return Container();
    }
  }


  Widget getProductTagDiscount(Product product) {
    if(product.currentPrice != product.rootPrice) {
      return Container(
        padding: const EdgeInsets.all(10),
        child: Transform.rotate(angle: 380,
          child: SizedBox(
            height: 30,
            width: 60,
            child: CustomPaint(
              painter: PriceTagPaint(),
              child: Center(
                child: Transform.rotate(
                  angle: 380, child: Text(
                  returnDiscountPrice(product.rootPrice,
                      product.currentPrice),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),),
              ),
            ),
          ),
        ),
      );
    }
    else {
      return Container();
    }
  }

  Widget getIconFavorite(
      String idProduct, List<Favorite> favorite, Product product) {
    bool check = false;
    for (var element in favorite) {
      if (element.idProduct == idProduct) {
        check = true;
      }
    }

    if (check == false) {
      return const Icon(
        Icons.favorite_border_outlined,
        color: Colors.red,
      );
    } else {
      return const Icon(
        Icons.favorite,
        color: Colors.red,
      );
    }
  }

  FilterModel setFilter() {

    FilterModel filter = FilterModel(
        price: listPrice,
        color: listColor,
        material: listMaterial,
        feature: listFeature,
        idFilter: 'F',
        popularSearch: const [],
        priceRange: {'0' : valuesPrice[0] , '1': valuesPrice[1]},
        series: listSeries,
        sortBy: listSortBy,
        category: listCategory
    );

    return filter;
  }
}

Map<String, List<String>> filterChipList(FilterModel filterModel) {
  Map<String, List<String>> newMap = {};

  if (filterModel.category.isNotEmpty) {
    newMap['category'] = [filterModel.category];
  }
  if (filterModel.sortBy.isNotEmpty) {
    newMap['sortBy'] = [filterModel.sortBy[0]];
  }
  if (filterModel.series.isNotEmpty) {
    newMap['series'] = [filterModel.series[0]];
  }
  if (filterModel.priceRange.isNotEmpty) {
    newMap['priceRange'] = [
      "\$${double.parse(filterModel.priceRange.values.elementAt(0).toString()).toStringAsFixed(0)} - \$${double.parse(filterModel.priceRange.values.elementAt(1).toString()).toStringAsFixed(0)}"
    ];
  }
  if (filterModel.price.isNotEmpty) {
    newMap['price'] = [filterModel.price[0]];
  }
  if (filterModel.material.isNotEmpty) {
    newMap['material'] = filterModel.material;
  }
  if (filterModel.feature.isNotEmpty) {
    newMap['feature'] = [filterModel.feature[0]];
  }
  if (filterModel.color.isNotEmpty) {
    newMap['color'] = filterModel.color.keys.toList();
  }
  return newMap;
}

FilterModel setFilterNew(String text, FilterModel filter) {
  FilterModel newFilter = FilterModel(
      price: filter.price,
      color: filter.color,
      material: filter.material,
      feature: filter.feature,
      idFilter: filter.idFilter,
      popularSearch: filter.popularSearch,
      priceRange: filter.priceRange,
      series: filter.series,
      sortBy: filter.sortBy,
      category: filter.category);
  if (text == "category") {
    newFilter = FilterModel(
        price: filter.price,
        color: filter.color,
        material: filter.material,
        feature: filter.feature,
        idFilter: filter.idFilter,
        popularSearch: filter.popularSearch,
        priceRange: filter.priceRange,
        series: filter.series,
        sortBy: filter.sortBy,
        category: '');
  } else if (text == "price") {
    newFilter = FilterModel(
        price: const [],
        color: filter.color,
        material: filter.material,
        feature: filter.feature,
        idFilter: filter.idFilter,
        popularSearch: filter.popularSearch,
        priceRange: filter.priceRange,
        series: filter.series,
        sortBy: filter.sortBy,
        category: filter.category);
  } else if (text == "color") {
    newFilter = FilterModel(
        price: filter.price,
        color: const {},
        material: filter.material,
        feature: filter.feature,
        idFilter: filter.idFilter,
        popularSearch: filter.popularSearch,
        priceRange: filter.priceRange,
        series: filter.series,
        sortBy: filter.sortBy,
        category: filter.category);
  } else if (text == "material") {
    newFilter = FilterModel(
        price: filter.price,
        color: filter.color,
        material: const [],
        feature: filter.feature,
        idFilter: filter.idFilter,
        popularSearch: filter.popularSearch,
        priceRange: filter.priceRange,
        series: filter.series,
        sortBy: filter.sortBy,
        category: filter.category);
  } else if (text == "feature") {
    newFilter = FilterModel(
        price: filter.price,
        color: filter.color,
        material: filter.material,
        feature: const [],
        idFilter: filter.idFilter,
        popularSearch: filter.popularSearch,
        priceRange: filter.priceRange,
        series: filter.series,
        sortBy: filter.sortBy,
        category: filter.category);
  } else if (text == "priceRange") {
    newFilter = FilterModel(
        price: filter.price,
        color: filter.color,
        material: filter.material,
        feature: filter.feature,
        idFilter: filter.idFilter,
        popularSearch: filter.popularSearch,
        priceRange: const {},
        series: filter.series,
        sortBy: filter.sortBy,
        category: filter.category);
  } else if (text == "series") {
    newFilter = FilterModel(
        price: filter.price,
        color: filter.color,
        material: filter.material,
        feature: filter.feature,
        idFilter: filter.idFilter,
        popularSearch: filter.popularSearch,
        priceRange: filter.priceRange,
        series: const [],
        sortBy: filter.sortBy,
        category: filter.category);
  } else if (text == "sortBy") {
    newFilter = FilterModel(
        price: filter.price,
        color: filter.color,
        material: filter.material,
        feature: filter.feature,
        idFilter: filter.idFilter,
        popularSearch: filter.popularSearch,
        priceRange: filter.priceRange,
        series: filter.series,
        sortBy: const [],
        category: filter.category);
  }

  return newFilter;
}

bool checkColorInMap(Map<String, String> colorList, String colorKey) {
  bool check = false;
  if (colorList.containsKey(colorKey)) {
    check = true;
  }
  return check;
}

bool checkMaterialInList(List<String> materialList, String text) {
  bool check = false;
  if (materialList.contains(text)) {
    check = true;
  }
  return check;
}

List<Product> getProductBySearch(List<Product> listProduct , String query) {
  List<Product> finalList = [];

  if(listProduct.isNotEmpty) {
    for (var product in listProduct) {
      if(product.name.toLowerCase().contains(query.toLowerCase().trim())) {
        finalList.add(product);
      }
      else if(product.title.toLowerCase().contains(query.toLowerCase().trim())) {
        finalList.add(product);
      }
      else if(checkMaterial(product.material, query)) {
        finalList.add(product);
      }
    }
  }
  return finalList;
}

bool checkMaterial(Map<String, String> material , String query ) {
  bool check = false;
  material.forEach((key, value) {
    if(value.toLowerCase().contains(query.toLowerCase().trim())) {
      check = true;
    }
  });
  return check;
}
bool checkColor(Map<String, String> color ,  List<ProductItem> productItemList ) {
  bool check = false;
  color.forEach((key, value) {
    for (var element in productItemList) {
      if(element.color.keys.elementAt(0).toLowerCase().contains(key.toLowerCase())) {
        check = true;
      }
    }
  });
  return check;
}

List<Product> getProductByFilter(List<Product> productList, FilterModel filter, String query) {
  List<Product> finalList = [];
  List<Product> newList = [];

  //print(productList.length);

  if(query.isNotEmpty) {
    newList = getProductBySearch(productList, query);
  }
  else {
    newList = productList;
  }

  // Follow price - Low to high - High to Low
  if(filter.price.isNotEmpty) {
    if(filter.price[0].toLowerCase() == 'Low to high'.toLowerCase()) {
      newList.sort((a,b) => a.currentPrice.compareTo(b.currentPrice));
    }
    else {
      newList.sort((b,a) => a.currentPrice.compareTo(b.currentPrice));
    }
  }

  // Follow color
  if(filter.color.isNotEmpty) {
    newList = newList.where((element) => checkColor(filter.color, element.productItemList)).toList();
  }

  // Follow filter
  if(filter.feature.isNotEmpty) {
    for (var fe in filter.feature) {
      newList = newList.where((element) => element.title.toLowerCase().contains(fe.toLowerCase())).toList();
    }
  }

  // Follwow material
  if(filter.material.isNotEmpty) {
    for (var mat in filter.material) {
      newList = newList.where((element) => checkMaterial(element.material, mat)).toList();
    }
  }

  // Follow price range
  if(filter.priceRange.isNotEmpty) {
    newList = newList.where((element) => element.currentPrice >= filter.priceRange.values.elementAt(0) && element.currentPrice <= filter.priceRange.values.elementAt(1)).toList();
  }

  // Follow series
  if(filter.series.isNotEmpty) {
    newList = newList.where((element) => element.name.toLowerCase().contains(filter.series[0].toLowerCase())).toList();
  }

  // Follow sort by
  if(filter.sortBy.isNotEmpty) {
    if(filter.sortBy[0].toLowerCase() == "New Product".toLowerCase()) {
      newList.sort((b,a) => a.timestamp.compareTo(b.timestamp));
      newList = newList.where((element) => checkProductNew(element.timestamp) <= 90).toList();
    }
    else if(filter.sortBy[0].toLowerCase() == "Top Sellest".toLowerCase()) {
      newList.sort((b,a) => a.sellest.compareTo(b.sellest));
    }
    else if(filter.sortBy[0].toLowerCase() == "Best Review".toLowerCase()) {
      newList.sort((b,a) => a.review.compareTo(b.review));
    }
    else{
      newList = newList.where((element) => element.currentPrice != element.rootPrice).toList();
    }
  }

  if(filter.category.isNotEmpty) {
    String id = "";
    for(var data in categoryProvider.getListCategory) {
      for(var item in data.itemList) {
        if(item.name.toLowerCase().trim() == filter.category.toLowerCase().trim()) {
          id = item.id;
          //print(id);
        }
      }
    }
    newList = newList.where((element) => element.categoryItemId == id).toList();
  }

  finalList = newList;
  return finalList;
}

String returnDiscountPrice(double priceRoot, double priceCurrent) {

  double discount = ((priceRoot - priceCurrent) / priceRoot) * 100;
  return "${discount.toStringAsFixed(0)} % ";
}

List<String> getAutoCompleteInput(List<Product> listProduct , List<Category> listCategory) {
  List<String> finalList = [];
  for(var pro in listProduct) {
    finalList.add(pro.name.toLowerCase());
    finalList.add(pro.title.toLowerCase());
  }

  for(var cat in listCategory) {
    for (var element in cat.itemList) {
      finalList.add(element.name.toLowerCase());
    }
  }
  return finalList;
}

int checkProductNew(DateTime dateProduct) {
  DateTime now = DateTime.now();
  return now.difference(dateProduct).inDays;
}

class PriceTagPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.amber
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    Path path = Path();

    path
      ..moveTo(0, size.height * .5)
      ..lineTo(size.width * .13, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width * .13, size.height)
      ..lineTo(0, size.height * .5)
      ..close();
    canvas.drawPath(path, paint);

    //* Circle
    canvas.drawCircle(
      Offset(size.width * .13, size.height * .5),
      size.height * .15,
      paint..color = Colors.redAccent,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}