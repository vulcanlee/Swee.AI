# 企業 AI 產品中心

提供客戶瀏覽企業 AI 產品介紹的純靜態網站。網站不需要套件安裝或建置流程，可直接開啟，也能部署至任意靜態主機。

## 網站結構

```text
.
├── index.html
├── robots.txt
├── assets/
│   ├── docinsight-mark.svg
│   ├── favicon.svg
│   ├── knowledge-extraction-mark.svg
│   ├── network-background.png
│   └── site.css
├── products/
│   ├── docinsight.html
│   └── knowledge-extraction.html
└── tests/
    └── Test-Site.ps1
```

## 產品頁來源

| 網站檔案 | 唯讀來源 |
| --- | --- |
| `products/docinsight.html` | `D:\Vulcan\GitHub\DocInsight.AI\docs\marketing\產品介紹簡報.html` |
| `products/knowledge-extraction.html` | `D:\Vulcan\GitHub\KnowledgeExtraction.AI\docs\marketing\商業簡報-對外銷售版.html` |

兩份產品頁以原始檔案直接複製。要改內容時先改唯讀來源，再複製回本專案，驗證會比對兩邊的 SHA-256。

## SEO 與聯絡方式

首頁 `index.html` 的 `<head>` 帶有 meta description、`robots` 指示、Open Graph 與 Twitter Card，並在 `</head>` 前放一段 JSON-LD 結構化資料，描述 Organization、WebSite、WebPage 與產品 ItemList。分享預覽圖沿用 `assets/network-background.png`。

維護時要注意三件事：

- 改動首頁 `<title>` 或 meta description 時，JSON-LD 內對應的 `name` 與 `description` 要一起改。
- 聯絡信箱出現在首頁頁尾、兩份產品頁最後一張投影片，以及 JSON-LD 的 `email` 與 `contactPoint`。要換信箱時，這些位置加上兩份唯讀來源檔都要同步更新。
- 正式網域確定後，再補 `<link rel="canonical">`、`og:url`、`sitemap.xml`，並在 `robots.txt` 加上 `Sitemap:` 那一行。目前刻意不寫絕對網址。

## 產品品牌圖示

兩個產品的品牌圖示用在首頁產品卡片、產品頁 favicon，以及 JSON-LD 兩個 SoftwareApplication 的 `image`。

| 圖示 | 正本 | 另外兩份副本 |
| --- | --- | --- |
| `docinsight-mark.svg` | `DocInsight.AI\src\DocInsight\DocInsight.Web\wwwroot\brand-mark.svg` | `DocInsight.AI\docs\assets\`、本專案 `assets/` |
| `knowledge-extraction-mark.svg` | `KnowledgeExtraction.AI\src\...\wwwroot\images\app-logo.svg` | `KnowledgeExtraction.AI\docs\assets\`、本專案 `assets/` |

換圖時三份都要一起換，驗證會比對三方的 SHA-256。

產品頁的 favicon 一律寫 `../assets/<檔名>.svg`。這個相對路徑在本專案指向 `assets/`，在來源 repo 指向 `docs/assets/`，所以同一份簡報在網站上與在來源 repo 裡都抓得到圖示，同時維持兩邊逐位元組相同。

## 本機預覽

可直接以瀏覽器開啟 `index.html`。若要模擬靜態主機環境，可在專案根目錄執行：

```powershell
python -m http.server 8000
```

接著開啟 `http://localhost:8000/`。

## 驗證

```powershell
.\tests\Test-Site.ps1
```

驗證內容包含必要檔案、首頁文案、連結、響應式規則、favicon，以及兩份產品頁與來源檔案的 SHA-256 是否一致。

## 新增產品

1. 將自包含的產品介紹 HTML 複製到 `products/`，檔名使用小寫英文與連字號。
2. 在 `index.html` 的 `.product-grid` 新增產品卡片，使用相對路徑連到產品頁。
3. 視需要在 `assets/site.css` 增加產品識別色，並維持鍵盤焦點與響應式行為。
4. 更新本文件的產品來源對照，並執行網站驗證。
