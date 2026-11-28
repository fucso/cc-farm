# 🐑 cc-farm

- collie 🐕（牧羊犬）が sheep 🐑（羊）の群れを管理する牧場、という世界観の Claude Code プラグイン集。
- GitHub Issue でタスクを管理し、マネージャーとワーカーで開発を回すための marketplace。
- タスクは GitHub Issue に置き、ワーカー（sheep 🐑）が1頭につき1件の Issue をプルリクエストに変える。
- 全体設計は [issue #1](https://github.com/fucso/cc-farm/issues/1) にある。

## インストール

```
/plugin marketplace add fucso/cc-farm
/plugin marketplace add michael-denyer/pstack-claude
/plugin install sheep@cc-farm
```

- sheep 🐑 は commons（共有規約）と pstack（poteto-mode）に依存している。plugin.json の dependencies で宣言しているため、sheep のインストール時に両方が自動でインストールされる。
- 自動インストールには、依存先の marketplace を先に追加しておくことと、cc-farm 側の marketplace.json で allowCrossMarketplaceDependenciesOn に pstack-claude を許可していることが必要。

## 使い方

```
/sheep:graze <issue番号>
```

- Issue を読み、poteto-mode で実装し、interrogate で自己レビューし、ドラフトのプルリクエストを作成し、CI を見て、レビュー待ち（farm:in-review）にする。
- 規約は commons 🌾 の common-sense スキルが定義している。
- マージはしない。それは shepherd 🧑‍🌾（羊飼い）の仕事である。
