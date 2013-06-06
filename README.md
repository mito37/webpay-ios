# WebPay iOS

WebPay iOSでは、あなたのアプリ内でWebPayの[トークン](https://webpay.jp/docs/api#tokens)を発行することが可能です。通常クレジットでの支払いを必要とするアプリケーションを開発する際、クレジット情報をサーバーに送らないために、このようなトークンなどに紐付ける必要があります。

## インストールについて

WebPay iOSを導入する手段は２つあります。
WebPayは[Stripe](https://stripe.com/)のライブラリに依存しているので、Stripeも同時にインストールする必要があります。

### CocoaPodsを仕様する

[CocoaPods](http://cocoapods.org/) はiOSのライブラリを管理するためのツールです。 下記のように `Podfile` を編集し `pod install`するだけです。:

    pod 'Stripe', :git => 'https://github.com/stripe/stripe-ios.git'
    pod 'WebPay', :git => 'https://github.com/mmakoto37/webpay-ios.git'

### プロジェクトに直接インポートする

1. WebPayをクローンする。 (git clone --recursive)
1. メニューバーのFileをクリックして 'Add files to "Project"...' をする。
1. クローンしたリポジトリから 'WebPay' と 'Stripe' の両方のディレクトリにあるファイルを選択する。
1. "Copy items into destination group's folder (if needed)" にチェックをいれる。"
1. 最後に "Add" を選択し追加を完了する。


## API

このAPIでは主に3つの主要なクラスがあります。
`STPCard` はクレジットカードのモデルを扱うクラスです。ユーザが入力したクレジットのデータはこのクラスに格納されます。
`STPToken` はクレジットカードに紐付いたトークンを扱うクラスです。このトークンは下記のコードのように、クレジットカードの情報から生成されます。
`WebPay` は、WebPayのAPIとやり取りをするための静的クラスです。`Stripe`を継承しているクラスです。

### Creating a token

    STPCard *card = [[STPCard alloc] init];
    card.number = @"4242424242424242";
    card.expMonth = 12;
    card.expYear = 2020;
    card.name = @"Makoto"

    STPCompletionBlock completionHandler = ^(STPToken *token, NSError *error)
    {
        if (error) {
            NSLog(@"Error trying to create token %@", [error
            localizedDescription]);
        } else {
            NSLog(@"Token created with ID: %@", token.tokenId)
        }
    }

    [WebPay createTokenWithCard:card
                 publishableKey:@"my_publishable_key"
                     completion:completionHandler];


## 具体的な使い方について
### Step1
まず初めに、WebPayのインターフェースでは、`QuartzCore.framework`が必要なので、予めインポートする。
そして、`UIViewController`を継承した、クラス（ここでは`WebPaymentViewController`）のヘッダに`STPView.h`をインポートする（下記参照）。

    #import <UIKit/UIKit.h>
    #import "STPView.h"
    @interface PaymentViewController : UIViewController <STPViewDelegate>
    @property STPView* stripeView;
    @end

`STPView`クラス型の`stripeView`を宣言し、Delegateに関しても`STPViewDelegate`を設定する。
そして、`STPView`をインスタンス化し、`addSubView`する。

    - (void)viewDidLoad
    {
        [super viewDidLoad];
        self.stripeView = [[STPView alloc] initWithFrame:CGRectMake(15,20,290,55)
                                                  andKey:@"pk_test_XvGi9N1YMvybyo6BTDoIKeHn"];
        self.stripeView.delegate = self;
        [self.view addSubview:self.stripeView];
        self.signature = self.textField.text.
    }

この状態で、カードの番号や、セキュリティコードおよび期限日などを取り扱うことができる。
これに追加で、カードの使用者の名前を入力するフォームも作成する。

また、ここで[WebPayのダッシュボード](https://webpay.jp/settings)から取得したテスト環境用公開鍵に`WEBPAY_PUBLISHABLE_KEY`を置き換えます。

すべての入力項目に誤りがない場合、下記の`stripeView:withCard:isValid:`デリゲートが返ってくるので、Saveボタンを押すことが可能となります。

    - (void)stripeView:(STPView *)view withCard:(PKCard *)card isValid:(BOOL)valid
    {
        // Toggle navigation, for example
        // self.saveButton.enabled = valid;
    }
    
すべてのコードは[サンプルコード]()に記載しています。

### Step2
