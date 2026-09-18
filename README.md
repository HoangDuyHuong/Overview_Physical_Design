# ASIC Physical Design Flow - Cadence Innovus

Quy trình tự động hóa thiết kế vật lý (RTL-to-GDS / Netlist-to-GDS) cho thiết kế chip **croc_chip** (Croc SoC)[cite: 2, 3] sử dụng bộ công cụ **Cadence Innovus Implementation System**.

---

## Tổng quan quy trình (Flow Stages)

| Stage | Script / Tên quy trình | Nhiệm vụ chính |
| :--- | :--- | :--- |
| **00** | `00_init_design_v1.tcl` | Khởi tạo design, load LEF/MMMC, Floorplan, đặt Hard Macro SRAM, Endcap, Well Tap. |
| **PG** | `create_pg.tcl` | Thiết lập mạng lưới phân phối nguồn (Power Grid), Power Rings, SRoute, Add Stripes (Met3-TopMet2) & Power Vias. |
| **02** | `02_place_opt_v1.tcl` | Đặt vị trí Standard Cells (`place_opt_design`), thêm Tie-Hi/Tie-Lo, kiểm tra Pre-CTS Timing. |
| **03** | `03_cts.tcl` | Dựng cây xung nhịp (Clock Tree Synthesis), cân bằng Clock Skew, tối ưu và kiểm tra Post-CTS Timing. |
| **05** | `05_route.tcl` | Cấu hình NanoRoute, gán lớp định tuyến (Routing Layers), chạy `routeDesign` chi tiết và kiểm tra vi phạm DRC. |
| **06** | `06_route_opt.tcl` | Tối ưu hóa Timing hậu định tuyến (Post-Route Setup/Hold), chèn Filler Cells, xuất file DEF, Netlist và LEF. |
---

## Cấu trúc thư mục khuyến nghị

```text
├── data/
│   └── scripts/
│       ├── common/
│       │   ├── common_settings.tcl
│       │   ├── user_settings.tcl
│       │   └── config.tcl
│       ├── PG/
│       │   └── create_pg.tcl
│       ├── utility/
│       │   └── report_timing_format.tcl
│       ├── 00_init_design.tcl
│       ├── 02_place_opt.tcl
│       ├── 05_route.tcl
│       └── 06_route_opt.tcl
├── input_data/
│   ├── netlist/
│   │   └── croc_chip_yosys.v
│   ├── croc_mmmc.view
│   └── all_lef.tcl
├── rpt/                    # Thư mục lưu báo cáo Timing, DRC, Library usage
├── SAVED/                  # Checkpoint database (.invs) qua từng giai đoạn
└── output/                 # Kết quả xuất DEF, LEF, Netlist hoàn thiện