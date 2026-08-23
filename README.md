# 企業 AI 產品中心

提供客戶瀏覽企業 AI 產品介紹的純靜態網站。網站不需要套件安裝或建置流程，可直接開啟，也能部署至任意靜態主機。

## 網站結構

```text
.
├── index.html
├── assets/
│   ├── favicon.svg
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

兩份產品頁以原始檔案直接複製，內容與互動不在本專案內修改。

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
