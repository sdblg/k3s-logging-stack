# K3s Logging Stack (Loki + Alloy + Grafana)

Энэхүү репозитор нь K3s кластер дээрх подуудын логийг төвлөрүүлэн цуглуулж, Grafana дээр харуулах зориулалттай.

### Дизайн:
1. **Loki**: Лог хадгалах төв бааз. `local-path` storage class ашиглан 10GB диск дээр лог хадгална.
2. **Grafana**: Лог харах UI. Loki-той gRPC-ээр холбогдоно.
3. **Grafana Alloy**: Лог цуглуулагч (Agent). `DaemonSet` байдлаар ажиллаж, Node бүрийн `/var/log/pods`-оос логийг уншиж Loki руу илгээнэ.
4. **Relabeling**: Alloy нь лог бүрт `container`, `pod`, `namespace` шошго (labels) нааж өгдөг тул хайлт хийхэд хялбар.