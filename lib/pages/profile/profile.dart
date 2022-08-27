import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clipboard/clipboard.dart';

import '../../bloc/cubit/wallet_cubit.dart';
import '../../util/web3_helper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  static const String routeName = '/Profile';

  @override
  State<ProfilePage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<ProfilePage> {
  static const _kBasePadding = 12.0;
  static const kExpandedHeight = 240.0;
  final double radius = 36.0;
  String publicKey = '0x0000...0000';

  final ValueNotifier<double> _titlePaddingNotifier =
      ValueNotifier(_kBasePadding);

  final _scrollController = ScrollController();

  double get _horizontalTitlePadding {
    double kCollapsedPadding =
        (MediaQuery.of(context).size.width - kToolbarHeight - 32) / 2;

    if (_scrollController.hasClients) {
      return min(
          _kBasePadding + kCollapsedPadding,
          _kBasePadding +
              (kCollapsedPadding * _scrollController.offset) /
                  (kExpandedHeight - kToolbarHeight));
    }

    return _kBasePadding;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      _titlePaddingNotifier.value = _horizontalTitlePadding;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: ((context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: kExpandedHeight,
                backgroundColor: Colors.white,
                elevation: 0,
                floating: false,
                pinned: true,
                // leading: Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: FloatingActionButton(
                //     heroTag: 'back',
                //     elevation: 0,
                //     backgroundColor: Colors.white,
                //     onPressed: () {
                //       Navigator.pop(context);
                //     },
                //     child: const Icon(
                //       Icons.arrow_back,
                //       size: 20,
                //       color: Colors.grey,
                //     ),
                //   ),
                // ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: FloatingActionButton(
                      heroTag: 'share',
                      elevation: 0,
                      backgroundColor: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.share,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
                flexibleSpace: ValueListenableBuilder<double>(
                    valueListenable: _titlePaddingNotifier,
                    builder: (context, value, child) {
                      return FlexibleSpaceBar(
                        centerTitle: false,
                        titlePadding:
                            EdgeInsets.only(top: 8, bottom: 8, left: value),
                        collapseMode: CollapseMode.pin,
                        background: ShaderMask(
                          blendMode: BlendMode.srcATop,
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              stops: [.3, .85],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Theme.of(context).scaffoldBackgroundColor
                              ],
                            ).createShader(bounds);
                          },
                          child: CachedNetworkImage(
                            imageUrl: 'https://picsum.photos/id/${72}/200/300',
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        title: SafeArea(
                          child: CircleAvatar(
                            radius: radius,
                            backgroundImage: CachedNetworkImageProvider(
                              'https://picsum.photos/id/${35}/200/300',
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                toolbarHeight: 0,
                collapsedHeight: 64,
                automaticallyImplyLeading: false,
                pinned: false,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ProfilePage',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      BlocBuilder<WalletCubit, WalletState>(
                        builder: (context, state) {
                          publicKey = state.session!.accounts[0];
                          return InkWell(
                            onTap: () {
                              FlutterClipboard.copy(publicKey).then(
                                (value) =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('$publicKey Copied to Clipboard'),
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  truncateString(publicKey, 6, 4),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(Icons.copy, size: 16, color: Colors.grey),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                toolbarHeight: 48,
                automaticallyImplyLeading: false,
                pinned: true,
                flexibleSpace: TabBar(
                  labelColor: Colors.black,
                  isScrollable: true,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  indicatorWeight: 4,
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.grid_on_outlined),
                          const Text("Collected"),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.format_paint_outlined),
                          const Text("Created"),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.favorite_border_outlined),
                          const Text("Favorited"),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.history_outlined),
                          const Text("Activity"),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.call_made_outlined),
                          const Text("Offers made"),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.call_received_outlined),
                          const Text("Offfers received"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ];
          }),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TabBarView(
              children: [
                Center(
                  child: Text("Collected"),
                ),
                Center(
                  child: Text("Created"),
                ),
                Center(
                  child: Text("Favorited"),
                ),
                Center(
                  child: Text("Activity"),
                ),
                Center(
                  child: Text("Offers made"),
                ),
                Center(
                  child: Text("Offers received"),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          label: Text('Filter'),
          icon: Icon(Icons.filter_list),
        ),
      ),
    );
  }
}
