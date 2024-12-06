/// Module: my_coin
module yhfysun_game::yhfy_coin;
use std::option::{some};
use sui::coin::create_currency;
use sui::transfer::{public_freeze_object, public_transfer, public_share_object};
use sui::tx_context::TxContext;
use sui::url;
use sui::url::Url;

public struct YHFY_COIN has drop{}

fun init(yhfy_coin: YHFY_COIN, ctx: &mut TxContext) {
    let url = url::new_unsafe_from_bytes(b"https://img1.baidu.com/it/u=3921589634,1084294548&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500");
    let yes = some<Url>(url);

    let (treasury, coin_metadata) = create_currency(yhfy_coin, 6, b"YHFY_COIN", b"YHFY_COIN", b"this is yhfy's coin", yes, ctx);

    public_freeze_object(coin_metadata);

    // 发放代币命令
    /*
        sui client call --package 0x2 --module coin --function mint_and_transfer --type-args 0x3662b8de16ee58d470c9e46f620ae02309c12236c6461cb49b48e27db856be5d::yhfy_coin::YHFY_COIN --args 0x2f5f3e6325852c87d2b4e0e89521fbfbded0bb7a07fed0bea2f3f8482e88d7c0 100000000 0x01a50ebc7aa68bb429809ac3d1cac43135c2120035732245939120f07589cfdb
        sui client call --package 0x2 --module coin --function mint_and_transfer --type-args packageId::yhfy_coin::YHFY_COIN --args 权限id 金额ls 钱包地址

        testnet
            share
                hash: 3UEim8N7an63WV3K9cvMgtqnPkLJ7rcjohV5HraXWo8M
                packageId: 0xc8db51ff80ebcb3e9efdc0fe8449a86126fea9ebbe8deb43948a80cf0d889dbc
            独有
                hash: FwQmhb8o4RWRGjUTFaf61jQe57YxzdoB8sgCXc1ejDov
                packageId: 0x3662b8de16ee58d470c9e46f620ae02309c12236c6461cb49b48e27db856be5d

        mainnet
            share
                hash: 2BagkEgfLSBRyzwLwvGsi7Bh7cLQ6xL2d1C3mKeSD2rR
                packapeId: 0xff4d258471e23754770d1486edbc24376ae44bf2f4c7a773309401b50149e2e1
            独有
                hash: 3hFfHvaBTyjngqp8TZCYZ6WtBZFL8xGi8YrswQi1c8Yg
                packageId: 0xf0e5b634561fad5b4fa23550cd7ef06685271a0b457e15f30fff96b681b92807

    */

    // 独有
    public_transfer(treasury, ctx.sender());
    // 水龙头
    // public_share_object(treasury);

}
