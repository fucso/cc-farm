# cc-farm

- collie（牧羊犬）が sheep（羊）の群れを管理する牧場、という世界観の Claude Code プラグイン集。
- GitHub Issue でタスクを管理し、マネージャーとワーカーで開発を回すための marketplace。
- タスクは GitHub Issue に置き、ワーカー（sheep）が1頭につき1件の Issue をプルリクエストに変える。
- 全体設計は [issue #1](https://github.com/fucso/cc-farm/issues/1) にある。

## インストール

```
/plugin marketplace add fucso/cc-farm
/plugin install sheep@cc-farm
```

- sheep プラグインは実装の進め方を pstack（poteto-mode）に委譲するので、そちらもインストールする:

```
/plugin marketplace add michael-denyer/pstack-claude
/plugin install pstack@pstack-claude
```

## 使い方

```
/sheep:graze <issue番号>
```

- Issue を読み、poteto-mode で実装し、interrogate で自己レビューし、プルリクエストを作成し、CI を見て、Issue に報告する。
- マージはしない。それは shepherd（羊飼い）の仕事である。
