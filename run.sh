#!/bin/bash

# export PYTHONUNBUFFERED=1
# 可选：实时把 Python 输出刷到终端/日志

# 激活 conda 环境
source ./miniconda3/bin/activate
conda activate ultralytics     # 改成你的环境名

# ===== 大目录（其中每个一级子文件夹都会被处理）=====
ROOT="./test"                      # 例如：/data/batch
SCRIPT="./detect_tags.py"
WEIGHTS="your_model.pt"
PROMPT='请只输出标签上的编号，前面的字母是RIL，后面两位或者三位都是数字。如果标签无法直接获取，可以将照片逆时针旋转90度，进行读取。'
# ================================================

# 遍历一级子文件夹
for IN in "$ROOT"/*/; do
  [ -d "$IN" ] || continue
  base="$(basename "$IN")"
  OUT="${IN%/}_renamed_out"   # 输出目录：{文件夹名}_renamed_out，与输入同层

  echo ""
  echo "====== START: $base ======"
  echo "[INFO] 输入: $IN"
  echo "[INFO] 输出: $OUT"

  # 运行主程序
  python -u "$SCRIPT" \
    -i "$IN" \
    -w "$WEIGHTS" \
    -o "$OUT" \
    --prompt "$PROMPT" \
    --duplicates True \
    --device cuda:0 \
    --clean-out
  # 如需递归：在上面命令末尾加 --recursive
  # 如需演练：加 --dry-run
  # 如需同时落盘日志：加 --log-file rename_run_$(date +%Y%m%d_%H%M%S).log

  ret=$?
  echo "====== DONE: $base (ret=$ret) ======"
done