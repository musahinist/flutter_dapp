// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'wallet_cubit.dart';

class WalletState extends Equatable {
  final SessionStatus? session;
  final String? signature;
  WalletState(this.session, this.signature);
  @override
  List<Object?> get props => [session, signature];

  WalletState copyWith({
    dynamic session,
    String? signature,
  }) {
    return WalletState(
      session ?? this.session,
      signature ?? this.signature,
    );
  }
}
