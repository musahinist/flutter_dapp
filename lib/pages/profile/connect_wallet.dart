import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cubit/wallet_cubit.dart';
import 'profile.dart';

class ConnectWalletPage extends StatelessWidget {
  const ConnectWalletPage({Key? key}) : super(key: key);
  static const String routeName = '/ConnectWallet';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, state) {
        return state.session != null
            ? ProfilePage()
            : Scaffold(
                appBar: AppBar(
                  title: const Text(
                    'Connect Wallet',
                    style: TextStyle(color: Colors.black),
                  ),
                  backgroundColor: Colors.white,
                  centerTitle: true,
                ),
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CachedNetworkImage(
                            height: 120,
                            imageUrl:
                                'https://images.cointelegraph.com/images/1200_aHR0cHM6Ly9zMy5jb2ludGVsZWdyYXBoLmNvbS9zdG9yYWdlL3VwbG9hZHMvdmlldy8yN2M1Nzk5MGMyNjY1MTM1MjcwYzM3MzNhYjUzMWE4My5wbmc=.jpg'),
                        Text(
                          'Install a wallet',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Connect to any WalletConnect suported wallet to securely store your digital goods and cryptocurrencies.",
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  context
                                      .read<WalletCubit>()
                                      .loginUsingMetamask();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 18,
                                        child: CircleAvatar(
                                          radius: 16,
                                          backgroundColor: Colors.white,
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                                  'https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/MetaMask_Fox.svg/1200px-MetaMask_Fox.svg.png'),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        "Metamask",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Divider(),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 18,
                                      child: CircleAvatar(
                                        radius: 16,
                                        backgroundColor: Colors.white,
                                        backgroundImage: CachedNetworkImageProvider(
                                            'https://trustwallet.com/assets/images/media/assets/TWT.png'),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      "Trust Wallet",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 18,
                                      child: CircleAvatar(
                                        radius: 16,
                                        backgroundColor: Colors.white,
                                        backgroundImage: CachedNetworkImageProvider(
                                            'https://play-lh.googleusercontent.com/VaiAQjaHW6PbSDxwk1fgFhfl9FKikVslaLoO4aPeS8gdzdp_F23Rmov2_ad_AOayCXc'),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      "Rainbow",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                            onPressed: () {}, child: Text('Other options')),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have a wallet yet?"),
                            TextButton(
                                onPressed: () {}, child: Text('Learn more')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}
