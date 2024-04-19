const client = require("prom-client");
const pushGateway = new client.Pushgateway("http://localhost:9091");

// 创建四种不同类型的指标
const counter = new client.Counter({
  name: "metric_counter",
  help: "metric_help_counter",
});
const gauge = new client.Gauge({
  name: "metric_gauge",
  help: "metric_help_gauge",
});
const histogram = new client.Histogram({
  name: "metric_histogram",
  help: "metric_help_histogram",
  buckets: [0.1, 5, 15, 50, 100, 500],
});
const summary = new client.Summary({
  name: "metric_summary",
  help: "metric_help_summary",
  percentiles: [0.01, 0.1, 0.9, 0.99],
});

// 每10秒推送一次数据
setInterval(() => {
  // 设置指标的值
  counter.inc(10); // 每次增加10
  gauge.inc(Math.random() * 10 - 5); // 每次增加或减少0到5
  histogram.observe(Math.random() * 500); // 观察0到500之间的随机值
  summary.observe(Math.random() * 100); // 观察0到100之间的随机值

  // 将指标推送到 Pushgateway
  pushGateway.pushAdd(
    { jobName: "nodejs_push", groupings: { key: "value" } },
    function (err, resp, body) {
      if (err) {
        console.error(`Error pushing to Pushgateway: ${err}`);
      }
    }
  );
}, 10000);
