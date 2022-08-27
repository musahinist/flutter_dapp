import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:walletconnect_secure_storage/walletconnect_secure_storage.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit() : super(WalletState(null, null));
  late final WalletConnect connector;
  final sessionStorage = WalletConnectSecureStorage();
  var _session, _uri, _signature;
  void initWalletConnect() async {
    final localSession = await sessionStorage.getSession();
    if (localSession != null) {
      connector = WalletConnect(
          bridge: 'https://bridge.walletconnect.org',
          sessionStorage: sessionStorage,
          session: localSession,
          clientMeta: const PeerMeta(
              name: 'Intangible',
              description: 'NFT Marketplace',
              url: 'https://intangible.org',
              icons: [
                'https://files.gitbook.com/v0/b/gitbook-legacy-files/o/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
              ]));

      emit(state.copyWith(
          session: SessionStatus(
              chainId: localSession.chainId, accounts: localSession.accounts)));
    }

    connector.on('connect', (SessionStatus session) {
      print('CONNECT $session');
      _session = session;

      emit(state.copyWith(session: _session as SessionStatus));
    });
    connector.on('session_update', (WCSessionUpdateResponse payload) {
      _session = payload;

      emit(state.copyWith(
          session: SessionStatus(
              chainId: payload.chainId, accounts: payload.accounts)));
    });
    connector.on('disconnect', (payload) {
      _session = null;
      emit(state.copyWith(session: _session as SessionStatus));
    });
  }

  loginUsingMetamask() async {
    connector = WalletConnect(
        bridge: 'https://bridge.walletconnect.org',
        sessionStorage: sessionStorage,
        clientMeta: const PeerMeta(
            name: 'Intangible',
            description: 'NFT Marketplace',
            url: 'https://intangible.org',
            icons: [
              'https://files.gitbook.com/v0/b/gitbook-legacy-files/o/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
            ]));
    if (!connector.connected) {
      try {
        var session = await connector.createSession(onDisplayUri: (uri) async {
          _uri = uri;

          await launchUrlString(uri, mode: LaunchMode.externalApplication);
        });

        _session = session;
        emit(state.copyWith(session: _session));
      } catch (exp) {
        print(exp);
      }
    }
  }

  signMessageWithMetamask(String message) async {
    if (connector.connected) {
      try {
        EthereumWalletConnectProvider provider =
            EthereumWalletConnectProvider(connector);
        launchUrlString(_uri, mode: LaunchMode.externalApplication);
        var signature = await provider.personalSign(
            message: message, address: _session.accounts[0], password: "");

        _signature = signature;
        emit(state.copyWith(signature: _signature));
      } catch (exp) {
        print("Error while signing transaction");
        print(exp);
      }
    }
  }
}
