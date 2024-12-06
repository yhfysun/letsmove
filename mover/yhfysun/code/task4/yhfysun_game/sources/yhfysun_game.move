/// Module: yhfysun_game
module yhfysun_game::yhfysun_game;

use sui::coin::{Self, Coin};
use sui::balance::{Self, Balance};
use sui::random::{Self, Random};
use yhfysun_game::yhfy_fcoin::YHFY_FCOIN;

const EUserInsufficientBalance: u64 = 1000;
const EGameInsufficientBalance: u64 = 1001;

public struct Game has key {
    id: UID,
    balance: Balance<YHFY_FCOIN>,
}

public struct Admin has key {
    id: UID,
}

fun init(ctx: &mut TxContext) {
    let game = Game {
        id: object::new(ctx),
        balance: balance::zero(),
    };
    transfer::share_object(game);

    let admin = Admin {id: object::new(ctx)};
    transfer::transfer(admin, ctx.sender());
}

public entry fun Deposit(
    game: &mut Game,
    coin: &mut Coin<YHFY_FCOIN>,
    amount: u64,
) {
    assert!(
        coin::value(coin) >= amount,
        EUserInsufficientBalance
    );
    let split_balance = balance::split(coin::balance_mut(coin), amount);
    balance::join(&mut game.balance, split_balance);
}

public entry fun Withdraw(
    game: &mut Game,
    _: &Admin,
    amount: u64,
    ctx: &mut TxContext
) {
    assert!(
        game.balance.value() >= amount,
        EGameInsufficientBalance
    );
    let cash = coin::take(&mut game.balance, amount, ctx);
    transfer::public_transfer(cash, ctx.sender());
}

public entry fun Play(
    game: &mut Game,
    rnd: &Random,
    guess: bool,
    coin: &mut Coin<YHFY_FCOIN>,
    amount: u64,
    ctx: &mut TxContext
) {
    // 检查合约余额是否充足，确保用户获胜时有足够金额奖励
    assert!(
        game.balance.value() >= amount,
        EGameInsufficientBalance
    );
    // 检查用户的余额是否充足
    assert!(
        coin::value(coin) >= amount,
        EUserInsufficientBalance
    );

    // 生成随机数
    let mut gen = random::new_generator(rnd, ctx);
    let flag = random::generate_bool(&mut gen);

    // 如果获胜
    if (flag == guess) {
        // 投入的代币不变，另外奖励等额的代币
        let reward = coin::take(&mut game.balance, amount, ctx);
        coin::join(coin, reward);
    }
        // 猜错了就损失投入的代币
    else {
        Self::Deposit(game, coin, amount)
    }
}

// Transaction Digest: H7348yP8xE6ssoT4PPbuZxkSCGk4b4DYPQtFwRKHvoGp

// testnet
// play
// sui client call --package 0x41e2406031411967a24ba4da58c40f72648cb8099c59baf41a81fdacb9bb7774 --module yhfysun_game --function Play --args 0x2d27376e5027708993d8ce083da94d0a06f961286a58fc2d9d8d5db2018519c4 0x8 true 0x408e9612ca0d125281f0c8e6dfc2ed47822918b50d5a4cd2a9d91038f0f1b364 10000000 --gas-budget 10000000


// testnet
// random objectid 0x8
// admin address: 0x0fa9d9616f097057358f714f1a80078a1360fd1a954cc86426c62ea2a751eafc
// package id: 0x414fb59c145073d9bc6abd8f950a9cc98617d090379f8a87244e22c69b4a4d56
// game id: 0xc57e19f1a87743960d491540a774c6ab6dc5f7bf16fab0ad050ccdabdc6aeda9
// get faucet: sui client call --package 0x0414a27f58e752e8659c5e86d3b563f39b9e9cd40e15df8eb2e4c8512b86f3ec --module YHFY_FCOIN --function mint_in_my_module --args 0x72444a11f047f344a12770c1b65cf6ff7592b79a9d45e6b077b1180a6f118575 100000000 0x0fa9d9616f097057358f714f1a80078a1360fd1a954cc86426c62ea2a751eafc
// player1 address: 0x0fa9d9616f097057358f714f1a80078a1360fd1a954cc86426c62ea2a751eafc
// player1 alexwaker faucet id: 0x516476e617c1ae719204dd113fb640a4ab67ffaadbd347ffe06462d15eac9060 amount 100000000
// player2 address: 0x8ec99ae020e195d772b65296ad99d6d2f6743a091ee9acbbb56361e189e6b282
// player2 alexwaker faucet id: 0xa6b2cd86142002b7af5b7ab72c4d20b2259bf23ff9a81802873be27c4e5df9a9 amount 100000000
// deposit: sui client call --package <packageid> --module alexwaker_coin_game --function deposit --args <gameid> <player address> true/false <coinid>
// withdraw: sui client call --package <packageid> --module alexwaker_coin_game --function withdraw --args <gameid> amount(u64)
// play: sui client call --package <packageid> --module alexwaker_coin_game --function play --args <gameid> 0x8
// withdraw hash: GrCM2Hk5snnUuiGwHqp8APNvamB5sX9UKPKoey9jtjtB

// mainnet
// random objectid 0x8
// admin address: 0x0fa9d9616f097057358f714f1a80078a1360fd1a954cc86426c62ea2a751eafc
// package id: 0xd58b8295f6bcebbcb3b565cd2506fe547d663e71460fc35c8f77518b03d18172
// game id: 0xae7e2e98a3b2dc70adbf4e2c94bf92038ffc65f81846e75ac2adc5d93df54c13
// get faucet: sui client call --package 0x2adc11d7339def7528121fb6302719cc37e588e4ea2672851efa8180c29037e5 --module YHFY_FCOIN --function mint_in_my_module --args 0xe0c3f2fe67dfb2e47be028a8b3f4e9999c5aaac30adbc2523048d93f3f322622 100000000 0x0fa9d9616f097057358f714f1a80078a1360fd1a954cc86426c62ea2a751eafc
// player1 address: 0x0fa9d9616f097057358f714f1a80078a1360fd1a954cc86426c62ea2a751eafc
// player1 alexwaker faucet id: 0xcd0bac5add8f180a73820766cc2d2555f99ff730bef409975a2ad273981aecc1 amount 100000000
// player2 address: 0x8ec99ae020e195d772b65296ad99d6d2f6743a091ee9acbbb56361e189e6b282
// player2 alexwaker faucet id: 0xa13ff725c5684e3ac0cba12bb3e5f35f7d8144fb59d595a8663c0d6b3e896eaa amount 100000000
// palyer1 deposit hash: 3GaUrZiFRhb4pfp4W1HiaSKntPxvCdJk4w27SLfy6aEA
// palyer2 deposit hash: DqgzugvZvKzCtDgSNwQUFMR3Y4Bvv6uP5SUX3AkEXrNv
// withdraw hash: 5Kkc4ckL244b1UiqrpNgp36EfCpgkeoA62rtx148eVrC
// play hash: Efd8wLmV3QNkF74Cao7jtDu1UXk8r9vTwgzSt6hnKhxn


