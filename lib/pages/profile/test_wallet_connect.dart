import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../bloc/cubit/wallet_cubit.dart';
import '../../config/constants/web3_const.dart';
import '../../util/web3_helper.dart';

class TestConnectWallet extends StatefulWidget {
  const TestConnectWallet({Key? key}) : super(key: key);

  @override
  State<TestConnectWallet> createState() => _TestConnectWalletState();
}

class _TestConnectWalletState extends State<TestConnectWallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: BlocBuilder<WalletCubit, WalletState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (state.session != null)
                    ? Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Account',
                            ),
                            Text(
                              '${state.session!.accounts[0]}',
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Text(
                                  'Chain: ',
                                ),
                                Text(
                                  getNetworkName(state.session!.chainId),
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                            (state.session!.chainId != 42)
                                ? Row(
                                    children: const [
                                      Icon(Icons.warning,
                                          color: Colors.redAccent, size: 15),
                                      Text('Network not supported. Switch to '),
                                      Text(
                                        'Kovan Testnet',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )
                                : (state.signature == null)
                                    ? Container(
                                        alignment: Alignment.center,
                                        child: ElevatedButton(
                                            onPressed: () => context
                                                .read<WalletCubit>()
                                                .signMessageWithMetamask(
                                                    generateSessionMessage(state
                                                        .session!.accounts[0])),
                                            child: const Text('Sign Message')),
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Signature: ",
                                              ),
                                              Text(
                                                truncateString(
                                                    state.signature.toString(),
                                                    4,
                                                    2),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                        ],
                                      )
                          ],
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () =>
                            context.read<WalletCubit>().loginUsingMetamask(),
                        child: const Text("Connect with Metamask"))
              ],
            ),
          );
        },
      ),
    );
  }
}
