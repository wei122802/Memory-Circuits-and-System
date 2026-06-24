import numpy as np
import matplotlib.pyplot as plt
from scipy.interpolate import interp1d
from scipy.optimize import minimize_scalar, fsolve

# ==========================================
# 1. 貼上你的 HSPICE .print 輸出的資料
# ==========================================
# 你可以把 hspice 跑出來的數據直接取代下面的 raw_data
raw_data = """
 volt         voltage   
              q1         
     0.        399.9999m 
    10.00000m  399.9999m 
    20.00000m  399.9999m 
    30.00000m  399.9998m 
    40.00000m  399.9998m 
    50.00000m  399.9997m 
    60.00000m  399.9995m 
    70.00000m  399.9992m 
    80.00000m  399.9986m 
    90.00000m  399.9975m 
   100.00000m  399.9955m 
   110.00000m  399.9915m 
   120.00000m  399.9834m 
   130.00000m  399.9670m 
   140.00000m  399.9330m 
   150.00000m  399.8621m 
   160.00000m  399.7126m 
   170.00000m  399.3939m 
   180.00000m  398.7055m 
   190.00000m  397.1803m 
   200.00000m  393.6070m 
   210.00000m  383.8054m 
   220.00000m  313.9090m 
   230.00000m   38.4919m 
   240.00000m   11.9733m 
   250.00000m    4.9459m 
   260.00000m    2.1950m 
   270.00000m    1.0021m 
   280.00000m  463.6788u 
   290.00000m  216.3045u 
   300.00000m  101.5849u 
   310.00000m   48.0590u 
   320.00000m   22.9472u 
   330.00000m   11.0907u 
   340.00000m    5.4461u 
   350.00000m    2.7291u 
   360.00000m    1.4023u 
   370.00000m  742.3107n 
   380.00000m  406.7116n 
   390.00000m  231.6396n 
   400.00000m  137.7105n 
"""

# ==========================================
# 2. 資料解析與轉換 (處理 HSPICE 的 m, u, n 後綴)
# ==========================================
def to_float(s):
    """將 HSPICE 的單位轉為 Python float"""
    s = s.replace('m', 'e-3').replace('u', 'e-6').replace('n', 'e-9')
    if s.endswith('.'): s = s[:-1]
    if s == '': return 0.0
    return float(s)

vin_list = []
vout_list = []

for line in raw_data.split('\n'):
    line = line.strip()
    # 忽略表頭或無關的文字
    if not line or line in ('x', 'y') or '*' in line or 'volt' in line or 'q1' in line or 'parameter' in line or 'exercise' in line:
        continue
    parts = line.split()
    if len(parts) == 2:
        try:
            vin_list.append(to_float(parts[0]))
            vout_list.append(to_float(parts[1]))
        except ValueError:
            pass

vin = np.array(vin_list)
vout = np.array(vout_list)

# 自動偵測 VDD (四捨五入到小數點第一位，例如 0.399 -> 0.4)
vdd = round(np.max(vout) * 10) / 10.0

# 清除超出 VDD 範圍的雜訊點
valid_idx = vin <= vdd
vin = vin[valid_idx]
vout = vout[valid_idx]

# ==========================================
# 3. 尋找最大內切正方形 (計算 SNM)
# ==========================================
# 建立 Vout 關於 Vin 的內插函數，方便連續取值
f = interp1d(vin, vout, kind='linear', bounds_error=False, fill_value=(vout[0], vout[-1]))

# 找出 Trip Point (Vin = Vout 的點)
trip_point = fsolve(lambda x: f(x) - x, vdd / 2)[0]

S_max = 0
best_y = 0

# 在左半部眼眶中掃描不同的 y 基準點，尋找能塞入的最大正方形
y_vals = np.linspace(trip_point, vdd, 500)
for y in y_vals:
    x = f(y)  # 找到對應在 VTC 上的 x 座標
    
    # 定義成本函數：找出正方形對角頂點是否剛好碰到另一條曲線
    def cost(S):
        if x + S > vdd: return 1e6
        return (f(x + S) - y - S)**2
    
    # 最佳化搜尋邊長 S
    res = minimize_scalar(cost, bounds=(0, vdd - x), method='bounded')
    if res.fun < 1e-4:
        S = res.x
        if S > S_max:
            S_max = S
            best_y = y

snm_mv = S_max * 1000
print(f"計算完成！ VDD = {vdd} V, SNM = {snm_mv:.2f} mV")

# ==========================================
# 4. 畫圖 (Butterfly Curve)
# ==========================================
plt.figure(figsize=(8, 8))

# 畫出兩條對稱的 VTC
plt.plot(vin, vout, 'b-', linewidth=2, label='Curve 1 ($V_{out}$ vs $V_{in}$)')
plt.plot(vout, vin, 'r-', linewidth=2, label='Curve 2 ($V_{in}$ vs $V_{out}$)')

# 畫出 Trip Point
plt.plot([trip_point], [trip_point], 'ko', markersize=6, label='Trip Point')

# 畫出左右兩眼的最大內切正方形
best_x = f(best_y)
rect_left = plt.Rectangle((best_x, best_y), S_max, S_max, fill=False, edgecolor='g', linewidth=2.5, zorder=5)
rect_right = plt.Rectangle((best_y, best_x), S_max, S_max, fill=False, edgecolor='g', linewidth=2.5, zorder=5)
plt.gca().add_patch(rect_left)
plt.gca().add_patch(rect_right)

# 圖片標題與美化
plt.title(f'SRAM Butterfly Curve (VDD = {vdd}V)\nSNM = {snm_mv:.2f} mV', fontsize=14, fontweight='bold')
plt.xlabel('$V_{in}$ / $V_{out}$ (V)', fontsize=12)
plt.ylabel('$V_{out}$ / $V_{in}$ (V)', fontsize=12)
plt.xlim(0, vdd)
plt.ylim(0, vdd)
plt.grid(True, linestyle='--', alpha=0.7)
plt.legend(fontsize=10)
plt.tight_layout()

# 顯示圖片並存檔
plt.savefig('SNM_Butterfly_Curve.png', dpi=300)
plt.show()