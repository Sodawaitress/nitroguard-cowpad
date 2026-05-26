# CowPad — Project Workflow & Demo Guide
ENGN676 · Lincoln University · 2026

---

## 项目全貌

### 文件结构

```
AgricultureEngineering/
├── index.html                  ← 首页（浅色专业工程图纸主题）
├── cowpad_configurator.html    ← 3D互动配置器（Three.js）
├── cowpad_modules.html         ← 4种模块图纸（SVG）
├── cowpad_gis.html             ← Canterbury风险地图（Leaflet + 热力图）
├── cowpad_ops.html             ← 农场运营仪表板（Leaflet）
├── nitroguard-bmc.html         ← 商业模式画布（9块）
├── nitroguard-compare.html     ← 竞争分析
│
└── engn676/
    ├── REPORT_DRAFT.md              ← 报告正文（221行，5节，完整）
    ├── CowPad_Report_DRAFT.docx     ← Word版（需重新生成，见下）
    ├── PRESENTATION_BULLETS.md      ← 演讲 bullet points（5–7分钟）✅ 今天用
    ├── PRESENTATION_SCRIPT.md       ← 完整演讲稿草稿（参考用）
    ├── PRODUCT.md                   ← 技术完整规格（设计参考）
    │
    ├── diagrams/                    ← 5张设计版本示意图（浅色主题）
    │   ├── v1_dispersal.png
    │   ├── v2_monitoring.png
    │   ├── v3_capture.png
    │   ├── v4_ejection_abandoned.png
    │   └── v5_final.png
    │
    ├── 3d_print/
    │   ├── cowpad_tile_arc.scad      ← Arc tile：IR=75, OR=145, 45°, 5× V-groove
    │   ├── cowpad_cartridge.scad     ← Biochar cartridge：CART_H=6mm, pull tab
    │   ├── cowpad_tile_sensor.scad   ← EC sensor tile：probe holes + wire channel
    │   ├── cowpad_assembly.scad      ← 完整组装预览
    │   └── stl/                      ← 可直接切片的STL
    │
    └── arduino/
        └── cowpad_sensor/
            └── cowpad_sensor.ino     ← Arduino Nano EC传感器（含3层雨水过滤）
```

---

## 网站部署 — 不需要 PythonAnywhere

**网站是纯静态 HTML/CSS/JS。没有任何 Python 后端。**

PythonAnywhere 是给 Flask/Django 用的 — 静态网站用它部署可以但麻烦，需要额外 wsgi 配置。不推荐。

### 方案 A — 本地演示（今天 presentation 首选）✅

```bash
open "/Users/sodawaitress/Desktop/学校/林肯大学/AgricultureEngineering/index.html"
```
- 零部署风险
- 完全离线（除地图瓦片需要网络）
- 最稳定

### 方案 B — Netlify Drop（免费，30秒上线）✅ 推荐

1. 打开 `app.netlify.com/drop`
2. 把整个 `AgricultureEngineering` 文件夹拖进去
3. 自动生成 URL（如 `nitroguard-cowpad.netlify.app`）

特点：免费、自动HTTPS、全球CDN、可分享给 Majeed

### 方案 C — GitHub Pages

```bash
cd AgricultureEngineering
git init && git add . && git commit -m "CowPad ENGN676 2026"
# 推到 GitHub → Settings → Pages → Deploy from main branch
```

---

## 演示路线（5–7分钟 presentation）

| 顺序 | 页面 | 说什么 |
|------|------|--------|
| 1 | `index.html` | 开场，展示系统三层架构 |
| 2 | `cowpad_gis.html` | Canterbury数据，Selwyn 7.13 mg/L，问题严重性 |
| 3 | `diagrams/v1–v5 PNG` | 设计迭代（直接打开图片文件夹，逐张翻） |
| 4 | `cowpad_configurator.html` | 3D模型，展示真实设计 |
| 5 | `nitroguard-bmc.html` | 商业模式 |

可选补充：
- `cowpad_modules.html` — 展示工程细节（4种模块）
- `cowpad_ops.html` — IoT监控仪表板

---

## 报告现状 — 完整，可以交

| 章节 | 状态 |
|------|------|
| 1. Introduction（问题+ML数据+CowPad定义） | ✅ |
| 2. Design Process（V1→V5 + 传感器 + 结构分析） | ✅ |
| 3. Similar Products（竞品 + ML模型表现表） | ✅ |
| 4. Business Model（BMC九块 + 收入流） | ✅ |
| 5. Limitations & Future Work | ✅ |
| References（11条，含DOI） | ✅ |

**重新生成 Word 版：**

```bash
cd /Users/sodawaitress/Desktop/学校/林肯大学/AgricultureEngineering/engn676
pandoc REPORT_DRAFT.md -o CowPad_Report_DRAFT.docx --from markdown-yaml_metadata_block
```

---

## 接下来可以做

- [ ] 把 diagrams/ 的5张图插入 Word 报告对应章节
- [ ] 网站：CowPad 工作原理 SVG 动画（urine → biochar → LED → 更换cartridge）
- [ ] 网站：首页设计迭代翻牌动画
- [ ] Netlify 部署（分享链接给 Majeed）
- [ ] 报告最终格式检查，提交

---

## 设计关键参数快查

| 部件 | 参数 |
|------|------|
| Arc tile | IR=75mm, OR=145mm, 45°, BASE_H=6mm, FILL_H=8mm, RIB_H=6mm |
| V-groove | N=5, W=3.5mm, D=3.0mm, 60°自清洁 |
| Cartridge | CART_H=6mm, CART_WALL=1.5mm, pull tab 14×4mm |
| Snap connector | SN_W=10mm, SN_L=2.5mm, clearance 0.4mm |
| EC sensor | Arduino Nano, D4雨水传感器, 绿/黄/红 LED, 220Ω |
| Replacement interval | 15–20天（80头牛，1100L水槽） |
| N reduction | 82%（dispersal，0.37→2.0m²） |
| Load FoS | >8×（600kg牛蹄，N_RIB=7） |
