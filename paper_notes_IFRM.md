# Paper Notes: AI-enabled IFRMs in Agriculture
> Systematic review, 218 articles, 2012–2025

---

## Key Terms
- **IFRM** = Intelligent Robotic Farm Machinery
- **ISOBUS** = 农业机械通用通信协议（ISO 11783）
- **PRISMA** = 系统综述标准流程
- **Bibliometric analysis** = 文献计量分析
- **Variable rate application** = 变量施肥/施药
- **Edge computing** = 边缘计算（在机器本地处理数据，不依赖云端）
- **Digital twin** = 数字孪生（实时虚拟模型）
- **Survivorship bias** = 幸存者偏差

---

## 论文结构（从后往前读）

### 结论 Section 4

**重点句：**
- "The current design of IFRMs currently relies heavily on static classifiers, limiting the adaptability to dynamic field conditions."
  - 👉 **核心矛盾**：农业环境高度动态，但AI模型用静态历史数据训练——像开车看后视镜

- "Future research should explore AI models that integrate real-time data from field and operational dynamics."
  - 👉 Real-time status 的解法：Edge computing / Digital twin / Reinforcement learning / 多传感器融合

- "Achieving the full potential of AI in agriculture will require strong collaboration among technology developers, policymakers, and the farming community."
  - 👉 **有疑问**：这个逻辑预设了问题在农民身上，解决方案是"说服他们"——但问题可能在产品本身

---

### 3.10.5 Limitations

- 研究主要依赖 Web of Science 和 Scopus，**只收录英文文献**
  - 👉 可能排除了大量非英语国家（亚洲、南美、非洲）的农业研究——这些地区的农业条件和资源限制往往更有代表性

---

### 3.10.4 Technology Readiness

- TRL（Technology Readiness Level）指标显示大多数AI方法仍在 **pilot/research** 阶段
  - 👉 延伸：从实验室到田间的"死亡之谷"问题

---

## 我的论点（待写评论）

### 论点1：「农民保守」是叙事，不是事实

**目标句**：论文第四段关于"三方合作"推动农民接受AI的部分

**论点**：
- 农民拒绝的不是"新"，而是**风险大于收益的新**
- "农民保守"这个说法在老师、论文、公司参观中反复出现——这本身是一种预设，而不是实证结论
- 学术上的依据：Technology Adoption Resistance 研究 / Survivorship bias（研究只采样了愿意配合的农民）
- 反问：**有没有可能推出人们无法拒绝的产品？**（Frictionless adoption）
- 类比：iPhone 出来时没有人说"消费者太保守不愿意放弃实体键盘"

**关键词**：frictionless adoption, technology acceptance model (TAM), rational resistance

---

### 论点2：Static classifiers 的根本局限

**目标句**："relies heavily on static classifiers, limiting adaptability to dynamic field conditions"

**论点**：
- 静态模型 vs 动态农业环境的根本矛盾
- Real-time 的工程解法：edge computing 最现实（农村网络差）
- 延伸：和 Majeed 灌溉研究相关——风灾下系统失效也是因为缺乏实时响应能力

---

## 延伸知识

| 概念 | 说明 |
|------|------|
| Technology Adoption Resistance | 农民拒绝新技术的理性原因：经济风险、信息不对称、不兼容、无售后 |
| Frictionless adoption | 好产品嵌入用户已有行为，不需要改变习惯 |
| Edge computing | 本地处理数据，低延迟，不依赖网络——农村场景最现实 |
| Reinforcement Learning | 不需要标注数据，在真实环境中边做边学 |
| MCDM（多标准决策） | 论文提到的未来研究方向，综合多个指标做设计决策 |
| Survivorship bias | 只研究愿意配合的农民，把不配合的归咎于"态度保守" |

---

## 待读页面
- [ ] Section 3（主体部分）
- [ ] Section 2（方法论）
- [ ] Section 1（引言）- 已部分注释

