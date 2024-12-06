/// Module: my_coin
module yhfysun_game::yhfy_fcoin;
use std::option::{some};
use sui::coin::create_currency;
use sui::transfer::{public_freeze_object, public_transfer, public_share_object};
use sui::tx_context::TxContext;
use sui::url;
use sui::url::Url;

public struct YHFY_FCOIN has drop{}

fun init(yhfy_fcoin: YHFY_FCOIN, ctx: &mut TxContext) {
    let url = url::new_unsafe_from_bytes(b"https://img1.baidu.com/it/u=3921589634,1084294548&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500");
    let yes = some<Url>(url);

    let (treasury, coin_metadata) = create_currency(yhfy_fcoin, 6, b"YHFY_FCOIN", b"YHFY_FCOIN", b"this is yhfy's coin", yes, ctx);

    public_freeze_object(coin_metadata);

    // 发放代币命令
    /*
        sui client call --package 0x2 --module coin --function mint_and_transfer --type-args 0x41e2406031411967a24ba4da58c40f72648cb8099c59baf41a81fdacb9bb7774::yhfy_fcoin::YHFY_FCOIN --args 0xbc5dd4b15f43cc93d51c68a842b82056966ecf51c7d68e06915ab2270f239ae4 100000000 0x01a50ebc7aa68bb429809ac3d1cac43135c2120035732245939120f07589cfdb
        sui client call --package 0x2 --module coin --function mint_and_transfer --type-args packageId::YHFY_FCOIN::YHFY_FCOIN --args 权限id 金额 钱包地址

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
    // public_transfer(treasury, ctx.sender());
    // 水龙头
    public_share_object(treasury);

}
