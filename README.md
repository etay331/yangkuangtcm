# 陽光中醫線上掛號原型

開啟 `index.html` 即可使用手機瀏覽器操作的原型。院所和時段為示範資料；掛號紀錄只存在瀏覽器，不會完成實際掛號。中醫就診問卷會送到 Supabase。若要在手機上開啟，請將檔案放到可供手機存取的網頁伺服器，或傳送檔案到手機後以瀏覽器開啟。

正式上線前需取得院所、醫師、門診資料及掛號系統介接方式，並處理個人資料保護與預約確認。

另保留 Flutter 原型於 `lib/main.dart`。

## 問卷資料

「我的 → 中醫就診問卷」已連接 Supabase 專案 yangkuang 's Project（lwxfgeprbpwkvnizlczp）。答案存放在 public.survey_responses，包含 id、created_at、visited（yes/no）、categories（科別陣列）、visit_purpose（就診目的）、visit_frequency（就診頻率）、preferred_time（偏好時段）。可從 Supabase Table Editor 查看。

前台使用 publishable key，僅允許新增 visited、categories、visit_purpose、visit_frequency、preferred_time，不能查詢、修改或刪除答案。資料庫啟用 RLS，並檢查科別及答案一致性。瀏覽器只保留上次成功送出的答案以便回填；本機儲存被封鎖不影響雲端送出。既有本機問卷不會自動上傳，需按「送出問卷」。

更新線上網站時，請部署修改後的 index.html。Flutter 原型未接入問卷。

問卷共 5 題：就診經驗、曾看過的科別（未曾就診者免填）、就診目的、過去一年就診頻率、偏好時段。原有答案保留；舊紀錄的新增三欄為空值，新送出的問卷必須包含三欄。
